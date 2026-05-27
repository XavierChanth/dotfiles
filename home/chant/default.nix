{
  config,
  hostname,
  lib,
  pkgs,
  username,
  ...
}: {
  imports = [
    ../../modules/shared/ghostty.nix
    ../../modules/shared/git.nix
    ../../modules/shared/packages.nix
    ../../modules/shared/shell.nix
    ../../modules/shared/ssh.nix
    ../../modules/shared/tmux.nix
  ];

  home.username = username;
  home.homeDirectory = "/Users/${username}";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  home.file.".config/spaceship-prompt".source = "${pkgs.spaceship-prompt}/lib/spaceship-prompt";

  home.sessionPath = [
    "${config.home.homeDirectory}/.dotfiles/bin/shared"
    "${config.home.homeDirectory}/.dotfiles/bin/hosts/${hostname}"
  ];

  home.activation.stowDotfiles = lib.hm.dag.entryAfter ["writeBoundary"] ''
    STOW_DIR="${config.home.homeDirectory}/.dotfiles/stow"

    mkdir -p "${config.home.homeDirectory}/.config"
    mkdir -p "${config.home.homeDirectory}/.agents"
    mkdir -p "${config.home.homeDirectory}/.config/jj"
    ${lib.optionalString (!pkgs.stdenv.isDarwin) ''
    mkdir -p "${config.home.homeDirectory}/.config/kanata"
    ''}
    mkdir -p "${config.home.homeDirectory}/.config/zsh"
    mkdir -p "${config.home.homeDirectory}/.config/tmux"
    mkdir -p "${config.home.homeDirectory}/.config/nvim"
    mkdir -p "${config.home.homeDirectory}/.config/zed"
    mkdir -p "${config.home.homeDirectory}/.cursor"
    mkdir -p "${config.home.homeDirectory}/.cursor/rules"
    mkdir -p "${config.home.homeDirectory}/.codex"
    mkdir -p "${config.home.homeDirectory}/.codex/agents"
    mkdir -p "${config.home.homeDirectory}/.codex/rules"
    mkdir -p "${config.home.homeDirectory}/.pi"

    ${pkgs.stow}/bin/stow \
      --dir="$STOW_DIR" \
      --target="${config.home.homeDirectory}/.agents" \
      --restow \
      agents

    ${pkgs.stow}/bin/stow \
      --dir="$STOW_DIR" \
      --target="${config.home.homeDirectory}/.codex" \
      --restow \
      codex

    ${pkgs.stow}/bin/stow \
      --dir="$STOW_DIR" \
      --target="${config.home.homeDirectory}/.cursor" \
      --restow \
      cursor

    ${pkgs.stow}/bin/stow \
      --dir="$STOW_DIR" \
      --target="${config.home.homeDirectory}/.config/jj" \
      --restow \
      jj

    ${lib.optionalString (!pkgs.stdenv.isDarwin) ''
    ${pkgs.stow}/bin/stow \
      --dir="$STOW_DIR" \
      --target="${config.home.homeDirectory}/.config/kanata" \
      --restow \
      kanata
    ''}
    ${lib.optionalString pkgs.stdenv.isDarwin ''
    if [ -L "${config.home.homeDirectory}/.config/kanata/macos.kbd" ]; then
      target="$(readlink "${config.home.homeDirectory}/.config/kanata/macos.kbd" || true)"
      case "$target" in
        *"/stow/kanata/"*)
          rm -f "${config.home.homeDirectory}/.config/kanata/macos.kbd"
          rmdir "${config.home.homeDirectory}/.config/kanata" 2>/dev/null || true
          ;;
      esac
    fi
    ''}


    ${pkgs.stow}/bin/stow \
      --dir="$STOW_DIR" \
      --target="${config.home.homeDirectory}/.config/zsh" \
      --restow \
      zsh

    ${pkgs.stow}/bin/stow \
      --dir="$STOW_DIR" \
      --target="${config.home.homeDirectory}/.config/tmux" \
      --restow \
      tmux

    ${pkgs.stow}/bin/stow \
      --dir="$STOW_DIR" \
      --target="${config.home.homeDirectory}/.config/nvim" \
      --restow \
      nvim

    ${pkgs.stow}/bin/stow \
      --dir="$STOW_DIR" \
      --target="${config.home.homeDirectory}/.config/zed" \
      --restow \
      zed

    ${pkgs.stow}/bin/stow \
      --dir="$STOW_DIR" \
      --target="${config.home.homeDirectory}/.pi" \
      --restow \
      pi
  '';

  home.activation.linkApplications = lib.hm.dag.entryAfter ["linkGeneration"] ''
    apps_dir="${config.home.homeDirectory}/Applications"
    hm_apps_dir="$apps_dir/Home Manager Apps"

    mkdir -p "$apps_dir"

    for app_name in \
      "Ghostty.app" \
      "Google Chrome.app" \
      "Karabiner-Elements.app" \
      "Karabiner-EventViewer.app"
    do
      app_link="$apps_dir/$app_name"
      if [ -L "$app_link" ]; then
        target="$(readlink "$app_link" || true)"
        case "$target" in
          /nix/store/*)
            rm -f "$app_link"
            ;;
        esac
      fi
    done

    find "$apps_dir" -maxdepth 1 -type l -name '*.app' | while read -r app_link; do
      target="$(readlink "$app_link" || true)"
      case "$target" in
        "$hm_apps_dir"/*)
          rm -f "$app_link"
          ;;
      esac
    done

    for app_bundle in "$hm_apps_dir"/*.app; do
      [ -e "$app_bundle" ] || continue
      app_name="$(basename "$app_bundle")"
      app_target="$(readlink "$app_bundle" || printf '%s' "$app_bundle")"
      ln -sfn "$app_target" "$apps_dir/$app_name"
    done
  '';

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  services.macos-remap-keys = lib.mkIf pkgs.stdenv.isDarwin {
    enable = true;
    keyboard = {
      Capslock = "Escape";
    };
  };
}
