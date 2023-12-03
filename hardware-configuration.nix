# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "usb_storage" "usbhid" "sd_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ "i915" ];
  boot.kernelModules = [ "kvm-intel" "wireguard" ];
  boot.extraModulePackages = [ ];
  
  # Disable HDMI audio, needless and could be causing audio to get confused after suspend
  boot.blacklistedKernelModules = [ "snd_hda_codec_hdmi" ];
  
  # TPM
  security.tpm2.enable = true;
  security.tpm2.pkcs11.enable = true;  # expose /run/current-system/sw/lib/libtpm2_pkcs11.so
  security.tpm2.tctiEnvironment.enable = true;  # TPM2TOOLS_TCTI and TPM2_PKCS11_TCTI env variables  

  # Whichever working kernel is latest and/or optimized  
  #boot.kernelPackages = pkgs.linuxPackages_latest;
  #boot.kernelPackages = pkgs.linuxPackages_6_5; #if we need to downgrade
  boot.kernelPackages = pkgs.unstable.linuxPackages_lqx;  
   
  # My snowflake boot params 
  boot.kernelParams = [ 
"quiet" "splash" "loglevel=3" "udev.log_level=3" "systemd.show_status=false" 
"mce=off" "nowatchdog" 
"cpuidle.governor=teo" # Not activated since most kernels have: CONFIG_CPU_IDLE_GOV_TEO is not set
"resume=UUID=0e841e14-17fb-4d4c-b186-7fd24daba099" "resume_offset=3679488" 
"module.sig_enforce=1" 
"pcie_aspm=force" 
"rootfstype=btrfs" 
"i915.enable_guc=2" 
"rd.lvm=0" "rd.dm=0" "rd.md=0" 
"slab_nomerge" "init_on_alloc=1" "init_on_free=1" "page_alloc.shuffle=1" "randomize_kstack_offset=on" "lockdown=confidentiality" "panic=0" 
];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/0e841e14-17fb-4d4c-b186-7fd24daba099";
      fsType = "btrfs";
      options = [ "subvol=@" "ssd" "autodefrag" "discard=async" "noatime" "compress=zstd:3" ];
    };

  boot.initrd.luks.devices."luks-d07f4d23-fc3b-4e2b-92ad-e4bbff059fb9".device = "/dev/disk/by-uuid/d07f4d23-fc3b-4e2b-92ad-e4bbff059fb9";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/C787-B461";
      fsType = "vfat";
    };
  
  swapDevices = [ { device = "/swap/swapfile"; } ];

  fileSystems."/mnt/sda2" =
    { device = "/dev/disk/by-uuid/47dde051-8fcb-46f9-9aaf-dfd119d630dc";
      fsType = "btrfs";
      options = [ "noatime" "X-fstrim.notrim" "commit=120" "discard=async" "compress=zstd:6" "nosuid" "nossd" "nodev" "nofail" "x-gvfs-show" "autodefrag" ];
    };  

  # Kyber
  services.udev.extraRules = ''
    ACTION=="add|change", KERNEL=="sd[a-z]*|mmcblk[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="kyber"
    ACTION=="add|change", KERNEL=="sd[a-z]*", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="kyber"
  '';

  # BTRFS Scrub
  services.btrfs.autoScrub.enable = true;
  services.btrfs.autoScrub.interval = "weekly";
  
  # Scrcpy/ ADB
  programs.adb.enable = true;
  users.users.higashi.extraGroups = ["adbusers"];

  # Wake-on-WLAN service
  environment.systemPackages = with pkgs; [ iw ];
  systemd.services.wol-wlp2s0 = {
    enable = true;
    description = "Wake-on-WAN for %i";
    requires = [ "network.target" ];
    after = [ "network.target" ];
    unitConfig = {
      Type = "oneshot";
    };
    serviceConfig = {
      ExecStart = "/run/current-system/sw/bin/iw phy0 wowlan enable magic-packet";
    };
    wantedBy = [ "multi-user.target" ];
  };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp1s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp2s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
 
  # VAAPI
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
    ];
  };

  # Switch from performance to schedutil
  powerManagement.cpuFreqGovernor = "schedutil";
}
