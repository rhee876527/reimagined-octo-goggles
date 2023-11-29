{ config, lib, pkgs, ... }:
{
# Add/Make Changes to systemPackages
  environment.systemPackages = with pkgs; [
    wireguard-tools
    unstable.pipewire # latest audio
    unstable.sof-firmware
    unstable.wireplumber
  ];
}
