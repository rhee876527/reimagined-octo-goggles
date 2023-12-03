{ config, pkgs, ... }:

{
  # set ZSH as default shell for higashi
  users.users.higashi.shell = pkgs.zsh;

  # Enable zsh
  programs.zsh.enable = true;

  # Enable Oh-my-zsh
  programs.zsh.ohMyZsh = {
    enable = true;
  };
  
  # Switch to my oh-my-zsh custom
  programs.zsh.ohMyZsh.custom = "/home/higashi/.oh-my-zsh/custom";
    
  # Custom plugins/themes
  programs.zsh.shellInit = ''
    # p10k theme
    source $HOME/.oh-my-zsh/custom/themes/powerlevel10k/powerlevel10k.zsh-theme
    source $HOME/.p10k.zsh
    # Plugins
    source $HOME/.oh-my-zsh/custom/plugins/zsh-completions/zsh-completions.plugin.zsh
    source $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    source $HOME/.oh-my-zsh/custom/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
    source $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
  '';    

  # More ZSH customizations
  programs.zsh.setOptions = [
  "HIST_IGNORE_DUPS"
  "SHARE_HISTORY"
  "HIST_FCNTL_LOCK"
  "INC_APPEND_HISTORY_TIME"
  ];
  
  # Shell Aliases, mostly for NixOS admin
  # My aliases live in zshrc for ease
  programs.zsh.shellAliases = {
#    paru = "sudo nix-channel --update; cd /etc/nixos; sudo nix flake update; sudo nixos-rebuild dry-run";
#    switch = "sudo nixos-rebuild switch --upgrade";
#    boot = "sudo nixos-rebuild boot --upgrade";
#    validate = "cd /etc/nixos; nix flake check";
    list-gens = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
    list-packages = "nix-store -q --references /run/current-system/sw | xargs -I {} basename {} | cut -d'-' -f2-";
  };
}
