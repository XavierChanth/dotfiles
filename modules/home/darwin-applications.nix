{config, lib, ...}: {
  services.macos-remap-keys = {
    enable = true;
    keyboard.Capslock = "Escape";
  };

  home.activation.linkApplications = lib.hm.dag.entryAfter ["linkGeneration"] ''
    apps_dir="${config.home.homeDirectory}/Applications"
    hm_apps_dir="$apps_dir/Home Manager Apps"
    mkdir -p "$apps_dir"

    for app_name in "Ghostty.app" "Google Chrome.app" "Karabiner-Elements.app" "Karabiner-EventViewer.app"; do
      app_link="$apps_dir/$app_name"
      if [ -L "$app_link" ]; then
        target="$(readlink "$app_link" || true)"
        case "$target" in /nix/store/*) rm -f "$app_link" ;; esac
      fi
    done
    find "$apps_dir" -maxdepth 1 -type l -name '*.app' | while read -r app_link; do
      target="$(readlink "$app_link" || true)"
      case "$target" in "$hm_apps_dir"/*) rm -f "$app_link" ;; esac
    done
    for app_bundle in "$hm_apps_dir"/*.app; do
      [ -e "$app_bundle" ] || continue
      app_name="$(basename "$app_bundle")"
      app_target="$(readlink "$app_bundle" || printf '%s' "$app_bundle")"
      ln -sfn "$app_target" "$apps_dir/$app_name"
    done
  '';
}
