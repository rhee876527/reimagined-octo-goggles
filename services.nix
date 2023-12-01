{ config, pkgs, ... }:
{
# Enable the OpenSSH daemon. #Defaults are not secure-enough
  services.openssh = {
  enable = true;
  # require public key authentication for better security
  settings.PasswordAuthentication = false;
  settings.PermitRootLogin = "no";
  };

# Disable boltd
  systemd.services.bolt.enable = false;

# Open firewall for kde/gsconnect as specified in programs
# https://github.com/NixOS/nixpkgs/issues/116388
  programs.kdeconnect.enable = true;

# Thermald
  services.thermald.enable = true;

# To be added in 23.11
  #services.preload.enable = true; 

# Flatpak
  services.flatpak.enable = true;
  #xdg.portal.enable = true; # don't think this is needed

# Docker
  environment.systemPackages = with pkgs; [
  docker
  ];
  virtualisation.docker.enable = true;

}
