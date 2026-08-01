{...}: {
  imports = [
    ./darwin-applications.nix
    ./nb.nix
    ../shared/claude.nix
    ../shared/cliproxy.nix
    ../shared/ghostty.nix
    ../shared/packages.nix
  ];
}
