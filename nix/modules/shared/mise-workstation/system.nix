{ lib, username, ... }: {
  # Mise installs upstream Linux binaries, which need the conventional dynamic
  # linker path that NixOS deliberately does not expose by default.
  programs.nix-ld.enable = true;

  # A cold toolchain install includes several cargo builds. Keep that work
  # inside activation, but do not let Home Manager's five-minute default kill a
  # healthy install and trigger a system rollback.
  systemd.services."home-manager-${username}".serviceConfig.TimeoutStartSec = lib.mkForce "1h";
}
