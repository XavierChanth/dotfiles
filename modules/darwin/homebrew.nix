{
  config,
  hostProfile,
  inputs,
  username,
  ...
}: let
  baseTaps = {
    "homebrew/homebrew-core" = inputs.homebrew-core;
    "homebrew/homebrew-cask" = inputs.homebrew-cask;
  };

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
    taps = baseTaps;
    mutableTaps = false;
  };

  homebrew = {
    enable = true;
    # Keep Brew Bundle from trying to mutate the immutable Taps dir.
    taps = builtins.attrNames baseTaps;
    caskArgs.appdir = "/Applications";
    onActivation = {
      autoUpdate = false;
      cleanup = "uninstall";
      upgrade = false;
    };
    brews = [];
    casks = baseCasks ++ (if hostProfile.isRemote then [] else localOnlyCasks);
  };
}
