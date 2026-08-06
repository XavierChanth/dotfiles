{pkgs, ...}: {
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    extra-platforms = [
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    gnupg
    pinentry_mac
    vim
  ];

  programs.zsh.enable = true;
}
