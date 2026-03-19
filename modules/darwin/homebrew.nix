{
  config,
  inputs,
  username,
  ...
}: {
  imports = [
    inputs.nix-homebrew.darwinModules.nix-homebrew
  ];

  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = username;
    autoMigrate = true;
    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
    };
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
    casks = [
      "discord"
      "ghostty"
      "google-chrome"
      "helium-browser"
      "karabiner-elements"
      "keepassxc"
      "microsoft-office"
      "microsoft-teams"
      "obs"
      "raycast"
      "spotify"
      "vlc"
      "visual-studio-code"
      "windows-app"
      "zed"
      "zoom"
    ];
  };
}
