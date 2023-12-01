{ config, lib, pkgs, ... }:
{
# Add/Make Changes to systemPackages
  environment.systemPackages = with pkgs; [
    gnomeExtensions.gsconnect  # option for kdeconnect service, check services.nix
    cfs-zen-tweaks # zen tweaks
    wireguard-tools
    unstable.pipewire # latest audio
    unstable.sof-firmware
    unstable.wireplumber
  ];
}
