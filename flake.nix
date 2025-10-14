{
  description = "CTF addon for home-manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-stable";
  };

  outputs =
    { ... }:
    {
      # Export a Home Manager module
      homeManagerModules.ctf =
        { pkgs, ... }:
        {
          home.packages = with pkgs; [
            burpsuite
            ghidra
            wordlists
            wine
            gobuster
            hydra
            nikto
            wireshark-qt
            sqlmap
            payloadsallthethings
            ffuf
            fuzzdb
            cyberchef
            hashcat
            enum4linux-ng
            smbclient-ng
            smbmap
            smbscan
            dig
            steghide
            stegseek
            stegsolve
            binwalk
            exiftool
            ltrace
            foremost
            zsteg
            nmap
            tcpflow
            tcpdump
            whois
            ipcalc
            checksec
            ropgadget
            ropr
            gdb
            apktool

            # Create an FHS environment using the command `fhs`, enabling the execution of non-NixOS packages in NixOS!
            (
              let
                base = pkgs.appimageTools.defaultFhsEnvArgs;
              in
              pkgs.buildFHSEnv (
                base
                // {
                  name = "fhs";
                  targetPkgs =
                    pkgs:
                    # pkgs.buildFHSEnv provides only a minimal FHS environment,
                    # lacking many basic packages needed by most software.
                    # Therefore, we need to add them manually.
                    #
                    # pkgs.appimageTools provides basic packages required by most software.
                    (base.targetPkgs pkgs)
                    ++ (with pkgs; [
                      pkg-config
                      ncurses
                      # Feel free to add more packages here if needed.
                    ]);
                  profile = "export FHS=1";
                  runScript = "bash";
                  extraOutputsToInstall = [ "dev" ];
                }
              )
            )
          ];

          home.sessionVariables = {
            CTF_MODE = "1";
          };
        };
    };
}
