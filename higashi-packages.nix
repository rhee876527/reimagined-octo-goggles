{ config, pkgs, ... }:
{
# Define a user account.
  users.users.higashi = {
    isNormalUser = true;
    description = "Mantic Minotaur";
    extraGroups = [ "networkmanager" "wheel" "tss" "docker"];
    packages = with pkgs; [
#      firefox #came default
      gnomeExtensions.gsconnect # normal install doesn't launch in 23.05
      croc
      #noto-fonts-cjk
      #noto-fonts-emoji
      webp-pixbuf-loader #for webp files      
      jq #dzr
      dialog #dzr
      openssl #dzr
      gnome.gnome-tweaks
      evolution-data-server # contacts needs this
      libnotify
      htop
      sbctl
      niv
      flatpak 
      unstable.git # preempt unresolved git issues maybe
      wget
      xorg.xlsclients
      tpm-tools
      restic
      android-tools
      unstable.fastfetch # nice unstable test
      gocryptfs # vault flatpak needs this
      intel-gpu-tools
      nethogs
      playerctl
      unstable.scrcpy #scrcpy too old (2.0), doesn't have --no-video yet
      tealdeer
      libsecret 
      python311Packages.pipx #pipx
    ];
  };

# Call my bins & pipx's
  environment.shellInit = ''
    export PATH=$HOME/.local/bin:$PATH
  '';

# No PASSWORD SUDO !!!
  security.sudo.extraRules = [
  { users = [ "higashi" ];
    commands = [ { command = "ALL"; options = [ "NOPASSWD" ]; } ];
  }
  ];

}
