-- | An identifier is a type used to uniquely identify a resource, target...
--
-- One can think of an identifier as something similar to a file path. An
-- identifier is a path as well, with the different elements in the path
-- separated by @/@ characters. Examples of identifiers are:
--
-- * @posts/foo.markdown@
--
-- * @index@
--
-- * @error/404@
--
-- The most important difference between an 'Identifier' and a file path is that
-- the identifier for an item is not necesserily the file path.
--
-- For example, we could have an @index@ identifier, generated by Hakyll. The
-- actual file path would be @index.html@, but we identify it using @index@.
--
-- @posts/foo.markdown@ could be an identifier of an item that is rendered to
-- @posts/foo.html@. In this case, the identifier is the name of the source
-- file of the page.
--
{-# LANGUAGE GeneralizedNewtypeDeriving, DeriveDataTypeable #-}
module Hakyll.Core.Identifier
    ( Identifier (..)
    , parseIdentifier
    , toFilePath
    ) where

import Control.Arrow (second)
import Data.Monoid (Monoid)
import System.FilePath (joinPath)

import Data.Binary (Binary)
import GHC.Exts (IsString, fromString)
import Data.Typeable (Typeable)

-- | An identifier used to uniquely identify a value
--
newtype Identifier = Identifier {unIdentifier :: [String]}
                   deriving (Eq, Ord, Monoid, Binary, Typeable)

instance Show Identifier where
    show = toFilePath

instance IsString Identifier where
    fromString = parseIdentifier

-- | Parse an identifier from a string
--
parseIdentifier :: String -> Identifier
parseIdentifier = Identifier . filter (not . null) . split'
  where
    split' [] = [[]]
    split' str = let (pre, post) = second (drop 1) $ break (== '/') str
                 in pre : split' post

-- | Convert an identifier to a relative 'FilePath'
--
toFilePath :: Identifier -> FilePath
toFilePath = joinPath . unIdentifier
