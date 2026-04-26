{pkgs, ...}: {
  programs.ghostty = {
    enable = true;
    package = null;

    settings = {
      theme = "light:Monokai Pro Light Sun,dark:tokyonight-storm";

      font-family = "CommitMono Nerd Font";
      font-feature = "+cv07,+ss03,+ss04,+ss05";
      font-size = 13;
      adjust-cell-height = "20%";

      window-padding-balance = true;
      background-opacity = 0.95;
      background-blur-radius = 20;

      title = "Ghostty";

      confirm-close-surface = false;
      quit-after-last-window-closed = true;
      link-url = true;
      app-notifications = "no-clipboard-copy";

      mouse-hide-while-typing = true;
      mouse-shift-capture = false;

      # Keybinds
      macos-option-as-alt = true;
      keybind = [
        "ctrl+shift+t=unbind"
        "super+r=reload_config"
        "super+j=text:5j"
        "super+k=text:5k"

        "super+physical:one=text:\\x001"
        "super+physical:two=text:\\x002"
        "super+physical:three=text:\\x003"
        "super+physical:four=text:\\x004"
        "super+physical:five=text:\\x005"
        "super+physical:six=text:\\x006"
        "super+physical:seven=text:\\x007"
        "super+physical:eight=text:\\x008"
        "super+physical:nine=text:\\x009"

        "super+ctrl+alt+shift+a=text:\\x00a"
        "super+ctrl+alt+shift+s=text:\\x00s"
        "super+ctrl+alt+shift+d=text:\\x00d"
        "super+ctrl+alt+shift+r=text:\\x00r"
        "super+ctrl+alt+shift+c=text:\\x00c"
        "super+ctrl+alt+shift+p=text:\\x00p"
        "super+ctrl+alt+shift+l=text:\\x00l"
        "super+ctrl+alt+shift+v=text:\\x00v"
        "super+ctrl+alt+shift+x=text:\\x00x"
        "super+ctrl+alt+shift+w=text:\\x00w"
        "super+ctrl+alt+shift+z=text:\\x00z"
        "super+ctrl+alt+shift+f=text:\\x00f"
        "super+ctrl+alt+shift+g=text:\\x00g"
        "super+ctrl+alt+shift+n=text:\\x00n"
        "super+ctrl+alt+shift+p=text:\\x00p"
        "super+ctrl+alt+shift+e=text:\\x00e"

        "super+ctrl+shift+alt+q=text:\\x00d"
      ];
    };

    # My preferred version of tokyonight-storm
    # There are multiple versions of the theme on the internet... I explicitly want this one.
    themes.tokyonight-storm = {
      palette = [
        "0=#1d202f"
        "1=#f7768e"
        "2=#9ece6a"
        "3=#e0af68"
        "4=#7aa2f7"
        "5=#bb9af7"
        "6=#7dcfff"
        "7=#a9b1d6"
        "8=#414868"
        "9=#ff899d"
        "10=#9fe044"
        "11=#faba4a"
        "12=#8db0ff"
        "13=#c7a9ff"
        "14=#a4daff"
        "15=#c0caf5"
      ];

      background = "#24283b";
      foreground = "#c0caf5";
      cursor-color = "#c0caf5";
      selection-background = "#2e3c64";
      selection-foreground = "#c0caf5";
    };
  };
}
