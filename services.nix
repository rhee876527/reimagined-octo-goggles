{ config, pkgs, ... }:
{
# Enable the OpenSSH daemon. 
  services.openssh.enable = true; #Defaults are secure-enough

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
