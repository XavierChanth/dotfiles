{config, lib, pkgs, ...}: {
  imports = [
    ./darwin-applications.nix
    ../shared/claude.nix
    ../shared/cliproxy.nix
    ../shared/ghostty.nix
    ../shared/packages.nix
  ];

  # Stow owns the global config and lockfile, so installation must run after
  # stowDotfiles. Trust only this repository-managed global configuration.
  home.activation.installMiseTools = lib.hm.dag.entryAfter ["stowDotfiles"] ''
    export HOME=${lib.escapeShellArg config.home.homeDirectory}
    export MISE_GLOBAL_CONFIG_FILE="$HOME/.config/mise/config.toml"
    export MISE_YES=1
    ${pkgs.mise}/bin/mise trust "$MISE_GLOBAL_CONFIG_FILE"
    ${pkgs.mise}/bin/mise install
  '';
}
