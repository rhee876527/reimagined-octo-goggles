{ config, pkgs, ... }:
{
# Enable the OpenSSH daemon. #Defaults are not secure-enough
  services.openssh = {
  enable = true;
  # require public key authentication for better security
  settings.PasswordAuthentication = false;
  settings.PermitRootLogin = "no";
  };

# Reduce default timeout
  systemd.extraConfig = ''
    DefaultTimeoutStopSec=10s
  '';

  # OOMD & Slices
  systemd.oomd.enableRootSlice = true;
  systemd.oomd.enableSystemSlice = true;
  systemd.oomd.enableUserServices = true;
  # TO DO!! per-slice settings 
  # https://src.fedoraproject.org/rpms/systemd/blob/rawhide/f/10-oomd-per-slice-defaults.conf

  # NM Conn Check
  networking.networkmanager.extraConfig = ''
    [connectivity]
    enabled=1
    uri=https://connectivitycheck.android.com/generate_204
    response=
  '';

# Disable boltd
  systemd.services.bolt.enable = false;

# Thermald
  services.thermald.enable = true;

# To be added in 23.11
  #services.preload.enable = true; 

# Flatpak
  services.flatpak.enable = true;
  #xdg.portal.enable = true; # don't think this is needed

# Docker
  environment.systemPackages = with pkgs; [ docker ];
  virtualisation.docker.enable = true;

}
