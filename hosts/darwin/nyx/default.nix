{
  username,
  hostname,
  ...
}: {
  # Bootstrap Rosetta once on this Apple Silicon host before or alongside the
  # first darwin-rebuild switch:
  # softwareupdate --install-rosetta --agree-to-license
  imports = [
    ../../../modules/shared/nix.nix
    ../../../modules/darwin/defaults.nix
  ];

  networking.hostName = hostname;
  networking.computerName = "Xavier's MacBook Air";

  users.users.${username}.home = "/Users/${username}";

  system.primaryUser = username;
  system.stateVersion = 6;
}
