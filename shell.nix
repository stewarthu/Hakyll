let 
  pinnedPkgs = import ./pkgs-from-json.nix { json = ./nixos-20.03.json; };
  myPackages = (import ./release.nix { withHoogle = true; } );

  projectDrvEnv = myPackages.myProject.env.overrideAttrs (oldAttrs: rec {
    buildInputs = oldAttrs.buildInputs ++ [ 
      pinnedPkgs.haskellPackages.cabal-install
      ];
    shellHook = ''
      export USERNAME="stewart"
      alias ls="ls --color=auto"
    '';
  });
in 
  projectDrvEnv
