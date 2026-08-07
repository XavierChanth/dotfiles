{config, lib, pkgs, ...}: {
  # mise belongs to every coding workstation. Linux also needs the native
  # linker/compiler for cargo-installed tools; avoid shadowing Darwin's toolchain.
  home.packages = [ pkgs.mise ] ++ lib.optionals pkgs.stdenv.isLinux [ pkgs.stdenv.cc ];

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
