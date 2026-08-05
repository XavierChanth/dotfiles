{config, hostname, hostProfile, lib, pkgs, username, ...}: let
  isWorkstation = hostProfile.profile == "workstation";
in {
  imports = [
    ../../modules/home/stow.nix
    ../../modules/shared/git.nix
    ../../modules/shared/identities.nix
    ../../modules/shared/shell.nix
    ../../modules/shared/ssh.nix
    ../../modules/shared/tmux.nix
  ] ++ lib.optionals isWorkstation [
    ../../modules/home/workstation.nix
  ] ++ lib.optionals (!isWorkstation) [
    ../../modules/home/server.nix
  ];

  home = {
    inherit username;
    homeDirectory = if pkgs.stdenv.hostPlatform.isDarwin then "/Users/${username}" else "/home/${username}";
    stateVersion = "25.05";
    sessionPath = [
      "${config.home.homeDirectory}/.dotfiles/bin/hosts/${hostname}"
      "${config.home.homeDirectory}/.dotfiles/bin/shared"
      "${config.home.homeDirectory}/.local/bin"
      "${config.home.homeDirectory}/.local/share/mise/shims"
      "${config.home.homeDirectory}/.cargo/bin"
      "${config.home.homeDirectory}/go/bin"
    ];
    sessionVariables.EDITOR = "nvim";
    file.".config/spaceship-prompt".source = "${pkgs.spaceship-prompt}/lib/spaceship-prompt";
  };

  programs.home-manager.enable = true;
}
