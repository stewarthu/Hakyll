{
  withHoogle ? false
}:

let
  pinnedPkgs = import ./pkgs-from-json.nix { json = ./nixos-20.03.json; };

  customHaskellPackages = pinnedPkgs.haskellPackages.override (old: {
    overrides = pinnedPkgs.lib.composeExtensions (old.overrides or (_: _: {})) (self: super: {
      myProject = self.callPackage  ./hakyll.nix { };
      #myProject = self.callCabal2nix "myProject" ./shu.cabal { };
      # addditional overrides go here
      #secp256k1-haskell = self.callPackage ./secp256k1-haskell-0.2.1.nix { libsecp256k1 = pinnedPkgs.secp256k1; };
    });
  });

  hoogleAugmentedPackages = import ./toggle-hoogle.nix { withHoogle = withHoogle; input = customHaskellPackages; };

in
  {
    myProject = hoogleAugmentedPackages.myProject;
  }
