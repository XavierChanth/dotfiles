{config, lib, pkgs, ...}: {
  imports = [
    ./darwin-applications.nix
    ../shared/claude.nix
    ../shared/cliproxy.nix
    ../shared/ghostty.nix
    ../shared/packages.nix
  ];

  # Stow owns the global config, so installation must run after stowDotfiles.
  # `mise install` honors settings.lockfile=false and does not change config.
  home.activation.installMiseTools = lib.hm.dag.entryAfter ["stowDotfiles"] ''
    export HOME=${lib.escapeShellArg config.home.homeDirectory}
    export MISE_GLOBAL_CONFIG_FILE="$HOME/.config/mise/config.toml"
    export MISE_YES=1
    ${pkgs.mise}/bin/mise install
  '';
}
