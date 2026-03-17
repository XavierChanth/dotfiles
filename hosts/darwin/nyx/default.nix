{
  username,
  hostname,
  ...
}: {
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
