{
  config,
  hostname,
  lib,
  pkgs,
  username,
  ...
}: {
  imports = [
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
    mkdir -p "${config.home.homeDirectory}/.config/agents"
    mkdir -p "${config.home.homeDirectory}/.config/ghostty"
    mkdir -p "${config.home.homeDirectory}/.config/jj"
    mkdir -p "${config.home.homeDirectory}/.config/kanata"
    mkdir -p "${config.home.homeDirectory}/.config/tmux"
    mkdir -p "${config.home.homeDirectory}/.config/nvim"
    mkdir -p "${config.home.homeDirectory}/.config/zed"
    mkdir -p "${config.home.homeDirectory}/.codex"

    AGENT_SKILLS_DIR="${config.home.homeDirectory}/.config/agents/skills"
    CODEX_SKILLS_DIR="${config.home.homeDirectory}/.codex/skills"

    ${pkgs.stow}/bin/stow \
      --dir="$STOW_DIR" \
      --dotfiles \
      --target="${config.home.homeDirectory}" \
      --restow \
      zsh

    ${pkgs.stow}/bin/stow \
      --dir="$STOW_DIR" \
      --target="${config.home.homeDirectory}/.config/agents" \
      --restow \
      agents

    ${pkgs.stow}/bin/stow \
      --dir="$STOW_DIR" \
      --target="${config.home.homeDirectory}/.config/ghostty" \
      --restow \
      ghostty

    ${pkgs.stow}/bin/stow \
      --dir="$STOW_DIR" \
      --target="${config.home.homeDirectory}/.config/jj" \
      --restow \
      jj

    ${pkgs.stow}/bin/stow \
      --dir="$STOW_DIR" \
      --target="${config.home.homeDirectory}/.config/kanata" \
      --restow \
      kanata

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

    if [ -d "$CODEX_SKILLS_DIR" ] && [ ! -L "$CODEX_SKILLS_DIR" ]; then
      unmanaged_skill="$(${pkgs.findutils}/bin/find "$CODEX_SKILLS_DIR" -mindepth 1 -maxdepth 1 ! -name '.system' -print -quit)"

      if [ -n "$unmanaged_skill" ]; then
        printf 'Refusing to replace %s: found unmanaged Codex skill %s. Move it into %s first.\n' \
          "$CODEX_SKILLS_DIR" \
          "$(basename "$unmanaged_skill")" \
          "$AGENT_SKILLS_DIR" >&2
        exit 1
      fi

      if [ -e "$CODEX_SKILLS_DIR/.system" ] && [ ! -e "$AGENT_SKILLS_DIR/.system" ]; then
        mv "$CODEX_SKILLS_DIR/.system" "$AGENT_SKILLS_DIR/.system"
      fi

      rmdir "$CODEX_SKILLS_DIR"
    fi

    ln -sfn "$AGENT_SKILLS_DIR" "$CODEX_SKILLS_DIR"
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
    EDITOR = "vim";
  };

  services.macos-remap-keys = lib.mkIf pkgs.stdenv.isDarwin {
    enable = true;
    keyboard = {
      Capslock = "Escape";
    };
  };
}
