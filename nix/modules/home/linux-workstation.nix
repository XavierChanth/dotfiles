# Linux workstation counterpart: intentionally excludes Darwin application options.
{ ... }: {
  imports = [
    ../shared/claude.nix
    ../shared/cliproxy.nix
    ../shared/ghostty.nix
    ../shared/packages.nix
  ];
}
