{ pkgs, ... }:
with pkgs;
[
  burpsuite
  gobuster
  ffuf
  nikto
  sqlmap
]
