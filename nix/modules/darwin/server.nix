{lib, ...}: {
  imports = [
    ./common.nix
    ./homebrew.nix
  ];

  # Headless servers must remain reachable. Let displays power down, but never
  # allow macOS system sleep, standby, or automatic power-off sleep.
  system.activationScripts.noSleep.text = lib.mkAfter ''
    echo >&2 "Disabling automatic system sleep..."
    /usr/bin/pmset -a sleep 0 standby 0 autopoweroff 0 powernap 0
  '';
}
