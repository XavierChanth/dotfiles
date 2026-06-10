{
  config,
  hostProfile,
  inputs,
  username,
  ...
}: let
  managedTaps = {
    "homebrew/homebrew-core" = inputs.homebrew-core;
    "homebrew/homebrew-cask" = inputs.homebrew-cask;
    "rwx-cloud/homebrew-tap" = inputs.homebrew-rwx;
    "CleverCloud/homebrew-misc" = inputs.homebrew-clevercloud-misc;
  };

  brewTaps = [
    "CleverCloud/misc"
    "homebrew/homebrew-cask"
    "homebrew/homebrew-core"
    "rwx-cloud/tap"
  ];

  baseCasks = [
    "claude"
    "codex-app"
    "cursor"
    "docker-desktop"
    "ghostty"
    "google-chrome"
    "helium-browser"
    "keepassxc"
    "obsidian"
    "raycast"
    "t3-code"
    "tailscale-app"
    "vlc"
    "zed"
  ];

  localOnlyCasks = [
    "discord"
    "hiddenbar"
    "hyperkey"
    "macshot"
    "microsoft-office"
    "microsoft-teams"
    "readdle-spark"
    "spotify"
    "steam"
    "windows-app"
    "zoom"
  ];
in {
  imports = [
    inputs.nix-homebrew.darwinModules.nix-homebrew
  ];

  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = username;
    autoMigrate = true;
    taps = managedTaps;
    mutableTaps = false;
  };

  homebrew = {
    enable = true;
    # Keep Brew Bundle from trying to mutate the immutable Taps dir.
    taps = brewTaps;
    caskArgs.appdir = "/Applications";
    onActivation = {
      autoUpdate = false;
      cleanup = "uninstall";
      upgrade = false;
    };
    brews = [
      "mdr"
      "rwx"
    ];
    casks = baseCasks ++ (if hostProfile.isRemote then [] else localOnlyCasks);
  };
}
