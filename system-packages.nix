{ config, lib, pkgs, ... }:
{
# Standalone systemPackages
  environment.systemPackages = with pkgs; [
    cfs-zen-tweaks # zen tweaks
  ];
}
