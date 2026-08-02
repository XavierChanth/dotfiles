{hostname, username, ...}: {
  imports = [
    ../shared/nix.nix
    ./defaults.nix
    ./homebrew.nix
    ./raycast.nix
  ];

  networking.hostName = hostname;
  networking.computerName = hostname;
  users.users.${username}.home = "/Users/${username}";
  system.primaryUser = username;
  system.stateVersion = 6;
}
