{...}: {
  # Bootstrap Rosetta once before or alongside the first darwin-rebuild switch.
  imports = [
    ../../../modules/darwin/common.nix
    ../../../modules/darwin/close-ports.nix
  ];
}
