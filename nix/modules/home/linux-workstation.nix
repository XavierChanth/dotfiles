# Linux workstation counterpart: intentionally excludes Darwin application options.
{ ... }: {
  imports = [
    ../shared/claude.nix
    ../shared/ghostty.nix
    ../shared/packages.nix
  ];

  # Ghostty is configured but not installed by Home Manager.
  programs.ghostty.systemd.enable = false;
}
