{config, hostname, pkgs, username, ...}: {
  imports = [ ../../modules/home/stow.nix ];

  home = {
    inherit username;
    homeDirectory = if pkgs.stdenv.hostPlatform.isDarwin then "/Users/${username}" else "/home/${username}";
    stateVersion = "25.05";
    sessionPath = [
      "${config.home.homeDirectory}/.dotfiles/bin/hosts/${hostname}"
      "${config.home.homeDirectory}/.dotfiles/bin/shared"
      "${config.home.homeDirectory}/.local/bin"
      "${config.home.homeDirectory}/.local/share/mise/shims"
    ];
    sessionVariables = {
      EDITOR = "nvim";
      DOTFILES_HOST_BIN = "${config.home.homeDirectory}/.dotfiles/bin/hosts/${hostname}";
    };
    file.".config/spaceship-prompt".source = "${pkgs.spaceship-prompt}/lib/spaceship-prompt";
  };

  programs.home-manager.enable = true;
}
