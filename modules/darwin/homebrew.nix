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
    "claude-code"
    "codex"
    "codex-app"
    "cursor"
    "docker"
    "ghostty"
    "google-chrome"
    "helium-browser"
    "keepassxc"
    "obs"
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
    "microsoft-office"
    "microsoft-teams"
    "readdle-spark"
    "shottr"
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
    taps = builtins.attrNames config.nix-homebrew.taps;
    caskArgs.appdir = "/Applications";
    onActivation = {
      autoUpdate = false;
      cleanup = "uninstall";
      upgrade = false;
    };
    casks = baseCasks ++ (if hostProfile.isRemote then [] else localOnlyCasks);
  };
}
