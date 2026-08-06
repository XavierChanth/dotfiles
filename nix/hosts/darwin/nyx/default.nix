{...}: {
  # Bootstrap Rosetta once before or alongside the first darwin-rebuild switch.
  imports = [
    ../../../modules/darwin/workstation.nix
    ../../../modules/darwin/close-ports.nix
  ];
}
