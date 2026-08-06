{config, hostProfile, lib, pkgs, ...}: let
  home = config.home.homeDirectory;
  isWorkstation = hostProfile.profile == "workstation";
  commonPackages = [
    {name = "agents"; target = ".agents"; prepare = [".agents"];}
    {name = "codex"; target = ".codex"; prepare = [".codex/rules"];}
    {name = "jj"; target = ".config/jj"; prepare = [".config/jj"];}
    {name = "grok"; target = ".grok"; prepare = [".grok"];}
    {name = "zsh"; target = ".config/zsh"; prepare = [".config/zsh"];}
    {name = "tmux"; target = ".config/tmux"; prepare = [".config/tmux"];}
    {name = "nvim"; target = ".config/nvim"; prepare = [".config/nvim"];}
    {name = "opencode"; target = ".config/opencode"; prepare = [".config/opencode"];}
  ];
  workstationPackages = [
    {name = "cmux"; target = ".config/cmux"; prepare = [".config/cmux"];}
    {name = "mise"; target = ".config/mise"; prepare = [".config/mise"];}
    {name = "zed"; target = ".config/zed"; prepare = [".config/zed"];}
  ];
  packages = commonPackages ++ lib.optionals isWorkstation workstationPackages;
  prepare = lib.unique (lib.concatMap (package: package.prepare) packages);
  mkdirCommands = lib.concatMapStringsSep "\n" (path: ''mkdir -p "${home}/${path}"'') prepare;
  stowCommand = package: ''
    ${pkgs.stow}/bin/stow --dir="$STOW_DIR" --target="${home}/${package.target}" --restow ${lib.escapeShellArg package.name}
  '';
  stowCommands = lib.concatMapStringsSep "\n" stowCommand packages;
in {
  home.activation.stowDotfiles = lib.hm.dag.entryAfter ["writeBoundary"] ''
    STOW_DIR="${home}/.dotfiles/stow"
    ${mkdirCommands}

    # Kanata is no longer managed. Remove only the stale Stow-owned link,
    # preserving any replacement file the user may have created.
    stale_kanata="${home}/.config/kanata/macos.kbd"
    if [ -L "$stale_kanata" ]; then
      case "$(readlink "$stale_kanata" || true)" in
        */stow/kanata/macos.kbd) rm -f "$stale_kanata" ;;
      esac
    fi

    ${lib.optionalString isWorkstation ''
      # Ordered migration: old Home Manager Ghostty theme links must be removed
      # before Stow can own the same paths.
      ghostty_theme_dir="${home}/.config/ghostty/themes"
      mkdir -p "$ghostty_theme_dir"
      for theme in "$ghostty_theme_dir"/*; do
        [ -L "$theme" ] || continue
        target="$(readlink "$theme" || true)"
        case "$target" in
          /nix/store/*-home-manager-files/.config/ghostty/themes/*) rm -f "$theme" ;;
        esac
      done
      ${pkgs.stow}/bin/stow --dir="$STOW_DIR" --target="$ghostty_theme_dir" --restow ghostty-themes
    ''}

    ${lib.optionalString (!isWorkstation) ''
      cleanup_stow_links() {
        package_name="$1"
        target_dir="$2"
        [ -d "$target_dir" ] || return 0

        find "$target_dir" -type l | while read -r link; do
          target="$(readlink "$link" || true)"
          case "$target" in
            "$STOW_DIR/$package_name"/*) rm -f "$link" ;;
          esac
        done
      }

      cleanup_stow_links cmux "${home}/.config/cmux"
      cleanup_stow_links mise "${home}/.config/mise"
      cleanup_stow_links zed "${home}/.config/zed"
      cleanup_stow_links ghostty-themes "${home}/.config/ghostty/themes"
    ''}

    ${stowCommands}
  '';
}
