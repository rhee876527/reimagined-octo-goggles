{ config, pkgs, ... }:
 {
  # Debloat GNOME  
  environment.gnome.excludePackages = (with pkgs; [
  gnome-photos
  gnome-tour
  gnome-connections
  gnome-browser-connector
  gnome-user-docs
  ]) ++ (with pkgs.gnome; [
  gnome-software
  cheese 
  gnome-music
  gedit 
  epiphany 
  geary
  gnome-calendar
  evince 
  gnome-characters
  gnome-calculator
  seahorse
  gnome-initial-setup
  gnome-logs
  eog
  gnome-shell-extensions
  sushi
  #totem #we want thumbnails for video in nautilus
  file-roller
  gnome-contacts   
  gnome-online-miners
  gnome-weather
  gnome-font-viewer
  simple-scan
  gnome-maps
  gnome-clocks
  gnome-online-miners
  ]);
  # Remove xterm
  services.xserver.excludePackages = [ pkgs.xterm ];
}
