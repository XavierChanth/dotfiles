{pkgs, ...}: {
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    gnupg
    pinentry_mac
    vim
  ];

  programs.zsh.enable = true;
}
