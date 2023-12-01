{ config, lib, pkgs, ... }:
{
# Add/Make Changes to systemPackages
  environment.systemPackages = with pkgs; [
#    cfs-zen-tweaks # zen tweaks for use only with stock kernel
    wireguard-tools
    unstable.pipewire # latest audio
    unstable.sof-firmware
    unstable.wireplumber
  ];
}
