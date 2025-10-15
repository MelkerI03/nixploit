{
  description = "Modular home-manager flake for a CTF/pentesting environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  };

  outputs =
    { ... }:
    {
      # Export a Home Manager module
      homeModules.nixploit =
        { pkgs, ... }:
        let
          load = file: import file { inherit pkgs; };
        in
        {
          home.packages = builtins.concatLists [
            (load ./packages/generic.nix)
            (load ./packages/web.nix)
            (load ./packages/binary.nix)
            (load ./packages/network.nix)
            (load ./packages/reverse.nix)
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
