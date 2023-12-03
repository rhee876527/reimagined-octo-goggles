{ config, pkgs, lib, ... }:{
  networking.wireguard.enable = true;
  environment.systemPackages = with pkgs; [ wireguard-tools ] ;
  
  networking.firewall = {
   # if packets are still dropped, they will show up in dmesg
   logReversePathDrops = false; #silence gsconnect logs
   # wireguard won't work without this in 23.05
   extraCommands = ''
     ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN
     ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN
   '';
   extraStopCommands = ''
     ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN || true
     ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN || true
   '';
  };
}
