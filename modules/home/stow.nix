{config, lib, pkgs, ...}: let
  home = config.home.homeDirectory;
  packages = [
    {name = "agents"; target = ".agents"; prepare = [".agents"];}
    {name = "codex"; target = ".codex"; prepare = [".codex/rules"];}
    {name = "cmux"; target = ".config/cmux"; prepare = [".config/cmux"];}
    {name = "jj"; target = ".config/jj"; prepare = [".config/jj"];}
    {name = "grok"; target = ".grok"; prepare = [".grok"];}
    {name = "zsh"; target = ".config/zsh"; prepare = [".config/zsh"];}
    {name = "tmux"; target = ".config/tmux"; prepare = [".config/tmux"];}
    {name = "nvim"; target = ".config/nvim"; prepare = [".config/nvim"];}
    {name = "opencode"; target = ".config/opencode"; prepare = [".config/opencode"];}
    {name = "zed"; target = ".config/zed"; prepare = [".config/zed"];}
  ];
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

    ${stowCommands}
  '';
}
