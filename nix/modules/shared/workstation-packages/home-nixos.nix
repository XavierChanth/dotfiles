# Linux workstation counterpart: intentionally excludes Darwin application options.
{ ... }: {
  imports = [
    ../claude.nix
    ../packages.nix
  ];

  # Ghostty is configured but not installed by Home Manager.
  programs.ghostty.systemd.enable = false;
}
