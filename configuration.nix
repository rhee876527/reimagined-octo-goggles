# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./system-packages.nix
      ./lanzaboote.nix
      ./higashi-packages.nix
      ./debloat.nix
      ./services.nix
      ./harden.nix
      ./firewall.nix
      ./zsh.nix
      ./sysctl.nix
      ./wireguard.nix
    ];

  # Enable Flakes and the new command-line tool
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Auto update every morning
  system.autoUpgrade.operation = "switch"; # boot is broken, doesn't jump me to latest gen!
  system.autoUpgrade.randomizedDelaySec = "12min";
  system.autoUpgrade.dates = "9:37";
  system.autoUpgrade = {
    enable = true;
    flake = "/etc/nixos/#higashi";
    flags = [
      "--update-input"
      "nixpkgs"
      "--commit-lock-file"
    ];
  };
  # Tame hungry updates nix daemon
  nix.daemonCPUSchedPolicy = "idle";
#  nix.daemonIOSchedPriority = 7;

  # OOMD & Slices
  systemd.oomd.enableRootSlice = true;
  systemd.oomd.enableSystemSlice = true;
  systemd.oomd.enableUserServices = true;
  # TO DO!! per-slice settings 
  # https://src.fedoraproject.org/rpms/systemd/blob/rawhide/f/10-oomd-per-slice-defaults.conf
   
  # Limit the number of generations to keep
  boot.loader.systemd-boot.configurationLimit = 10; #seems lanzaboot breaks this or feature is not clear to me
  # boot.loader.grub.configurationLimit = 10;
  
  # Reduce default timeout
  systemd.extraConfig = ''
    DefaultTimeoutStopSec=10s
  '';

  # plymouth & quiet boot
  boot.plymouth.enable = true;
  boot.plymouth.theme="bgrt";
  # https://github.com/NixOS/nixpkgs/issues/26722#issuecomment-1693500074
  boot.initrd.systemd.enable = true; # without this pcr for lanzaboot trips every time
  boot.consoleLogLevel = 0;  
  boot.initrd.verbose = false;


  # Perform garbage collection weekly  
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 1w";
  };

  # Optimize storage
  # You can also manually optimize the store via:
  #    nix-store --optimise
  nix.settings.auto-optimise-store = true;  

  # Bootloader.
  # disable for lanzaboote
  #boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "higashi"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Africa/Nairobi";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # Enable the windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  
  # Configure keymap 
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents. # Was default true
  services.printing.enable = false;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  # Keyring won't allow us to do autologin cleanly!!
  # Enable automatic login for the user.
  #services.xserver.displayManager.autoLogin.enable = true;
  #services.xserver.displayManager.autoLogin.user = "higashi";
  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  #systemd.services."getty@tty1".enable = false;
  #systemd.services."autovt@tty1".enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
