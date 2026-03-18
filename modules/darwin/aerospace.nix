{
  hostname,
  pkgs,
  username,
  ...
}: let
  dotfilesDir = "/Users/${username}/.dotfiles";
  swapWorkspaceMonitors = pkgs.writeShellScript "aerospace-swap-workspace-monitors" ''
    set -euo pipefail

    usage() {
      echo "USAGE: $(basename "$0") [--wrap-around] (left|down|up|right|next|prev|<monitor-pattern>)"
    }

    if [ $# -lt 1 ]; then
      usage
      exit 1
    fi

    is_debug=false
    focus_args=()

    while [ $# -gt 1 ]; do
      case "$1" in
        --debug)
          is_debug=true
          ;;
        --wrap-around)
          focus_args+=(--wrap-around)
          ;;
        *)
          usage
          exit 1
          ;;
      esac
      shift
    done

    debug() {
      if $is_debug; then
        echo "$@" | tee -a /tmp/aerowrap
      fi
    }

    summon() {
      aerospace summon-workspace --fail-if-noop "$1"
    }

    direction="$1"

    debug "grabbing w1, m1"
    w1="$(aerospace list-workspaces --focused)"
    m1="$(aerospace list-monitors --focused | sed -E 's/^(.*) \| .*$/\1/')"
    debug "w1: $w1, m1: $m1"

    debug "going to m2 (direction $direction)"
    aerospace focus-monitor "''${focus_args[@]}" "$direction"

    debug "grabbing w2"
    w2="$(aerospace list-workspaces --focused)"
    m2="$(aerospace list-monitors --focused | sed -E 's/^(.*) \| .*$/\1/')"
    debug "w2: $w2, m2: $m2"

    debug "summoning w1: $w1"
    summon "$w1" || {
      echo "ERROR[summon w1]: can't move workspace $w1"
      exit 1
    }

    aerospace move-workspace-to-monitor --workspace "$w1" "$m2" || {
      echo "ERROR[move w1 m2]: can't move workspace $w1 to monitor $m2"
      exit 1
    }
    debug "summoned w1"

    debug "going back to m1: $m1"
    aerospace focus-monitor "$m1"
    debug "focused monitor m1"

    debug "summoning w2: $w2"
    summon "$w2" || {
      echo "ERROR[summon w2]: can't move workspace $w2"
      debug "attempting to restore w1"
      summon "$w1" || {
        echo "ERROR[restore w1]: failed to restore the original layout"
      }
    }
    debug "summoned w2"
  '';
  userBinPaths = [
    "${dotfilesDir}/bin/shared"
    "${dotfilesDir}/bin/hosts/${hostname}"
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
    "/usr/local/bin"
  ];
in {
  services.aerospace = {
    enable = true;
    settings = {
      after-startup-command = [
        "move-workspace-to-monitor --workspace 2 prev"
      ];

      accordion-padding = 0;

      gaps = {
        inner.horizontal = 8;
        inner.vertical = 8;
        outer.left = 8;
        outer.top = 8;
        outer.bottom = [
          {monitor.built-in = 8;}
          {monitor.main = 48;}
          8
        ];
        outer.right = 8;
      };

      exec = {
        inherit-env-vars = true;
        env-vars.PATH = builtins.concatStringsSep ":" userBinPaths + ":\${PATH}";
      };

      on-window-detected = [
        {
          "if" = {
            app-name-regex-substring = "^mpv$|^KeePassXC$|^The Unarchiver$";
          };
          run = "layout floating";
        }
        {
          "if" = {
            app-name-regex-substring = "^LibreWolf$|^Firefox$|^Zen$";
            window-title-regex-substring = "^Picture-in-Picture$";
          };
          run = "layout floating";
        }
        {
          "if" = {
            app-name-regex-substring = "^LuLu$";
            window-title-regex-substring = "^LuLu Alert$";
          };
          run = "layout floating";
        }
        {
          "if" = {
            app-name-regex-substring = ".";
            during-aerospace-startup = true;
          };
          check-further-callbacks = true;
          run = "move-node-to-workspace 4";

        }
        {
          "if" = {
            app-name-regex-substring = "^Microsoft Teams$";
            during-aerospace-startup = true;
          };
          run = "move-node-to-workspace 1";
        }
        {
          "if" = {
            app-name-regex-substring = "^Helium$|^qutebrowser$|^LibreWolf$|^Firefox$|^Zen$|^Safari$|^Orion$";
            during-aerospace-startup = true;
          };
          run = "move-node-to-workspace 2";
        }
        {
          "if" = {
            app-name-regex-substring = "^alacritty$|^WezTerm$|^wezterm-gui$|^Ghostty$|^Codex$|^Code$";
            during-aerospace-startup = true;
          };
          run = "move-node-to-workspace 3";
        }
      ];

      mode.main.binding = {
        alt-shift-r = ["exec-and-forget aerospace reload-config"];

        alt-s = "layout tiles horizontal vertical";
        alt-f = "layout h_accordion tiles";

        alt-q = "enable off";
        alt-shift-f = "layout floating tiling";
        alt-shift-space = "exec-and-forget ${swapWorkspaceMonitors} --wrap-around next";
        alt-space = "move-workspace-to-monitor --wrap-around next";
        alt-r = "flatten-workspace-tree";
        alt-w = "close";

        alt-enter = ["exec-and-forget open -n /Applications/Ghostty.app"];
        alt-shift-enter = [
          "exec-and-forget open -n /Applications/Ghostty.app --args -e zsh"
        ];

        alt-t = [
          "workspace 3"
          "exec-and-forget open -a /Applications/Ghostty.app"
        ];
        alt-b = [
          "workspace 2"
          "exec-and-forget open -a /Applications/Zen\\ Browser.app"
        ];
        alt-v = [
          "workspace 2"
          "exec-and-forget open -a /Applications/zoom.us.app"
        ];
        alt-p = [
          "workspace 1"
          "exec-and-forget open -a /Applications/KeePassXC.app"
        ];

        alt-h = "focus left --boundaries all-monitors-outer-frame --boundaries-action wrap-around-all-monitors";
        alt-j = "focus down --boundaries all-monitors-outer-frame --boundaries-action wrap-around-all-monitors";
        alt-k = "focus up --boundaries all-monitors-outer-frame --boundaries-action wrap-around-all-monitors";
        alt-l = "focus right --boundaries all-monitors-outer-frame --boundaries-action wrap-around-all-monitors";

        alt-shift-h = "move left";
        alt-shift-j = "move down";
        alt-shift-k = "move up";
        alt-shift-l = "move right";

        alt-1 = "workspace 1";
        alt-2 = "workspace 2";
        alt-3 = "workspace 3";
        alt-4 = "workspace 4";
        alt-5 = "workspace 5";
        alt-6 = "workspace 6";
        alt-7 = "workspace 7";
        alt-8 = "workspace 8";
        alt-9 = "workspace 9";

        alt-shift-1 = ["move-node-to-workspace 1" "workspace 1"];
        alt-shift-2 = ["move-node-to-workspace 2" "workspace 2"];
        alt-shift-3 = ["move-node-to-workspace 3" "workspace 3"];
        alt-shift-4 = ["move-node-to-workspace 4" "workspace 4"];
        alt-shift-5 = ["move-node-to-workspace 5" "workspace 5"];
        alt-shift-6 = ["move-node-to-workspace 6" "workspace 6"];
        alt-shift-7 = ["move-node-to-workspace 7" "workspace 7"];
        alt-shift-8 = ["move-node-to-workspace 8" "workspace 8"];
        alt-shift-9 = ["move-node-to-workspace 9" "workspace 9"];

        alt-shift-minus = "resize smart -50";
        alt-shift-equal = "resize smart +50";
        alt-shift-0 = "balance-sizes";
      };
    };
  };
}
