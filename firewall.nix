{ config, pkgs, ... }:
{
#   networking.nftables.enable = true; #gave a build error in 23.05

   networking.firewall = {
     enable = true;
     allowedTCPPorts = [ 22 22000 ]; # ssh syncthing
     allowedUDPPorts = [ 9 22000 21027 ]; #WoWLAN syncthing
#     allowedUDPPortRanges = [
#    { from = 1714; to = 1764; } # gsconnect # check services.nix
#  ];
 };
}
