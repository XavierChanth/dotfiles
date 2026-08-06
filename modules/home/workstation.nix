{config, lib, pkgs, ...}: {
  imports = [
    ./darwin-applications.nix
    ../shared/claude.nix
    ../shared/cliproxy.nix
    ../shared/ghostty.nix
    ../shared/packages.nix
  ];

  # Android Studio owns this SDK; unlike developer runtimes it is not managed
  # by mise. This module is imported only by Darwin workstation configurations.
  home.sessionVariables = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    ANDROID_HOME = "${config.home.homeDirectory}/Library/Android/sdk";
  };
  home.sessionPath = lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
    "${config.home.homeDirectory}/Library/Android/sdk/cmdline-tools/latest/bin"
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
