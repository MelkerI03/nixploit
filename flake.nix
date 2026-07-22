{
  description = "Modular home-manager flake for a CTF/pentesting environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  outputs =
    { ... }:
    let
      pinned = import (fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/<commit>.tar.gz";
      }) { };
    in
    {
      nixpkgs.overlays = [
        (final: prev: {
          ghidra = pinned.ghidra;
        })
      ];
      # Export a Home Manager module
      homeModules.nixploit =
        { pkgs, ... }:
        let
          load = file: import file { inherit pkgs; };
          load2 = file: import file { inherit pkgs; };
        in
        {
          home.packages = builtins.concatLists [
            (load ./packages/generic.nix)
            (load ./packages/web.nix)
            (load ./packages/binary.nix)
            (load ./packages/network.nix)
            (load2 ./packages/reverse.nix)
            (load ./packages/windows.nix)
            (load ./packages/passcrack.nix)
            (load ./packages/wordlists.nix)
            (load ./packages/enumeration.nix)
            (load ./packages/steganography.nix)
          ];

          home.sessionVariables = {
            CTF_MODE = "1";
          };
        };
    };
}
