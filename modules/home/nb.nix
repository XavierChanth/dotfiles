{config, lib, pkgs, ...}: {
  home.file.".nbrc".text = ''
    nb_cmux_browser() {
      if [[ -n "''${CMUX_WORKSPACE_ID:-}" ]] && command -v cmux >/dev/null 2>&1; then
        cmux browser open "$1" --focus true
      else
        ${if pkgs.stdenv.isDarwin then "open" else "xdg-open"} "$1"
      fi
    }
    export NB_GUI_BROWSER=nb_cmux_browser
  '';

  home.activation.migrateNbrc = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
    nbrc_path="${config.home.homeDirectory}/.nbrc"
    if [ -f "$nbrc_path" ] && [ ! -L "$nbrc_path" ]; then
      nbrc_backup="$nbrc_path.pre-home-manager"
      if [ -e "$nbrc_backup" ]; then
        echo >&2 "Unable to manage $nbrc_path: $nbrc_backup already exists."
        exit 1
      fi
      mv "$nbrc_path" "$nbrc_backup"
    fi
  '';
}
