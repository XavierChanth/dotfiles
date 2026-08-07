{ hostname, pkgs, username, ... }: {
  networking = { hostName = hostname; networkmanager.enable = true; firewall.enable = true; };
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  nix = { settings.experimental-features = [ "nix-command" "flakes" ]; gc = { automatic = true; dates = "weekly"; options = "--delete-older-than 30d"; }; };
  nixpkgs.config.allowUnfree = true;
  users = { defaultUserShell = pkgs.zsh; users.${username} = { isNormalUser = true; uid = 1000; description = username; extraGroups = [ "networkmanager" "wheel" ]; openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGjNyTPVTrUJcWrox+nheN7oEOYejfIrwcLgTac/qdNy xavierchanth nyx" ]; }; };
  programs.zsh.enable = true;
  environment.systemPackages = with pkgs; [ curl git jq neovim ripgrep vim ];
  security.sudo = { wheelNeedsPassword = true; execWheelOnly = true; };
  system.stateVersion = "26.05";
}
