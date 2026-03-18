{
  lib,
  pkgs,
  ...
}: let
  addSessionFn = ''
    add_session() {
      selected="$1"
      [ -z "$selected" ] && return

      name="$2"
      if [ -z "$name" ]; then
        case "$selected" in
          */work/*)
            work_path="''${selected#*"/work/"}"
            name="w/$(printf '%s' "$work_path" | sed -e 's/\./_/g')"
            ;;
          *)
            name="$(basename "$selected" | sed -e 's/\./_/g')"
            ;;
        esac
      fi

      command="$3"

      tmux if-shell -F '#{==:#{pane_mode},tree-mode}' 'send q'
      if [ -n "$command" ]; then
        session="$(tmux new-session -dPF "#S" -c "$selected" -s "$name" "$command")"
        tmux set-option -t "$session" default-command "$command"
      else
        session="$(tmux new-session -dPF "#S" -c "$selected" -s "$name" || printf '%s' "$name")"
      fi

      if [ -z "$TMUX" ]; then
        tmux attach -t "$session"
      else
        tmux switch-client -t "$session"
      fi
    }
  '';

  fzfSession = pkgs.writeShellApplication {
    name = "fzf_session";
    runtimeInputs = with pkgs; [bash fzf tmux];
    text = ''
      ${addSessionFn}

      projects_dir="$(
        { [ -d '/Volumes/xcdata/src' ] && echo '/Volumes/xcdata/src'; } ||
          { [ -d '/mnt/xcdata/src' ] && echo '/mnt/xcdata/src'; } ||
          echo "$HOME/src"
      )"

      selected="$(
        (
          find "$projects_dir" -mindepth 0 -maxdepth 2 -type d
          [ -d "$HOME/work" ] && find "$HOME/work" -mindepth 2 -maxdepth 2 -type d
          echo "$HOME/.dotfiles"
          echo "main"
        ) | fzf --scheme=path --tiebreak=end,index --header "Open session in..."
      )"

      name=""
      if [ -n "$selected" ]; then
        case "$selected" in
          "$projects_dir"/*)
            rel_path="''${selected#"$projects_dir"/}"
            if [[ "$rel_path" == */* ]]; then
              name="$(printf '%s' "$rel_path" | sed -e 's/\./_/g')"
            fi
            ;;
        esac
      fi

      add_session "$selected" "$name"
    '';
  };

  fzfJjSession = pkgs.writeShellApplication {
    name = "fzf_jj_session";
    runtimeInputs = with pkgs; [bash fzf jujutsu tmux];
    text = ''
      ${addSessionFn}

      projects_dir="$(
        { [ -d '/Volumes/xcdata/src' ] && echo '/Volumes/xcdata/src'; } ||
          { [ -d '/mnt/xcdata/src' ] && echo '/mnt/xcdata/src'; } ||
          echo "$HOME/src"
      )"

      selected="$(
        (
          find "$projects_dir" -mindepth 2 -maxdepth 2 -type d
          echo "$HOME/.dotfiles"
          echo "main"
        ) | fzf --scheme=path --tiebreak=end,index --header "Open new workspace in..."
      )"

      if [ -z "$selected" ]; then
        exit 0
      fi

      printf "Workspace name: "
      read -r name

      if [ -z "$name" ]; then
        exit 0
      fi

      work_root="$HOME/work/$(basename "$selected")"
      workspace_path="$work_root/$name"

      if [ -e "$workspace_path" ]; then
        echo "Workspace already exists: $workspace_path"
        read -r _
        exit 1
      fi

      (
        set -e
        cd "$selected"
        mkdir -p "$work_root"
        jj workspace add "$workspace_path"
      ) || {
        echo "Failed to create workspace. Press enter to continue."
        read -r _
        exit 1
      }

      add_session "$workspace_path"
    '';
  };

  fzfSshSession = pkgs.writeShellApplication {
    name = "fzf_ssh_session";
    runtimeInputs = with pkgs; [bash fzf openssh ripgrep tmux];
    text = ''
      ${addSessionFn}

      if [ ! -f "$HOME/.ssh/config" ]; then
        exit 0
      fi

      includes="$(rg '^Include ' "$HOME/.ssh/config" | cut -d ' ' -f2 | sed -e "s|^|$HOME/.ssh/|")"
      files="$includes"
      hosts="$(
        tr ' ' '\n' <<<"$files" |
          xargs -I % /bin/sh -c 'cat "%" | grep "Host " | grep -v "Host \\*" | cut -d " " -f2'
      )"

      selected="$(
        tr ' ' '\n' <<<"$hosts" |
          fzf -d=' ' --scheme=path --tiebreak=end,index --header "Open ssh session..."
      )"

      [ -z "$selected" ] && exit 0

      name="ssh-$selected"
      command="PATH='$PATH:$HOME/.local/bin'; ssh $selected"

      add_session "$selected" "$name" "$command"
    '';
  };

  jjTermCleanup = pkgs.writeShellApplication {
    name = "jj-term-cleanup";
    runtimeInputs = with pkgs; [bash gnugrep tmux];
    text = ''
      name="jj-"
      existing="$(tmux list-windows -F "#{window_id}" -f "#{==:#W,$name}")"
      [ -z "$existing" ] && exit 0

      tmux list-panes -t "$existing" -F "#{pane_current_command}" | grep -qv "^uv$" || tmux kill-window -t "$existing"
    '';
  };

  jjTerm = pkgs.writeShellApplication {
    name = "jj-term";
    runtimeInputs = with pkgs; [bash git tmux];
    text = ''
      workdir="$(pwd -P)"
      if [[ "$workdir" == *"/work/"* ]]; then
        work_parent="''${workdir%%/work/*}"
        work_path="''${workdir#*"/work/"}"
        repo="''${work_path%%/*}"
        rest="''${work_path#*/}"
        if [[ "$rest" == "$work_path" ]]; then
          root="$work_parent/work/$repo"
        else
          ws="''${rest%%/*}"
          root="$work_parent/work/$repo/$ws"
        fi
      else
        root="$(git rev-parse --show-toplevel)"
      fi

      name="jj-"
      existing="$(tmux list-windows -F "#{window_id}" -f "#{==:#W,$name}")"

      if [ -n "$existing" ]; then
        tmux select-window -t "$existing"
        exit 0
      fi

      tmux new-window -c "$root"
      tmux rename-window "$name"
      tmux move-window -b -t :2
      tmux select-window -t :2
    '';
  };

  agentTerm = pkgs.writeShellApplication {
    name = "agent-term";
    runtimeInputs = with pkgs; [bash git tmux];
    text = ''
      root="$(git rev-parse --show-toplevel)"

      name="agent-"
      command="opencode"
      editor="nvim"

      existing="$(tmux list-windows -F "#{window_id}" -f "#{==:#W,$name}")"

      if [ -n "$existing" ]; then
        tmux select-window -t "$existing"
        exit 0
      fi

      tmux new-window -c "$root" "export EDITOR='$editor'; $command"
      tmux rename-window "$name"
      jj_pos="$(tmux list-windows -F "#I" -f "#{==:#W,jj-}")"

      if [ -n "$jj_pos" ]; then
        pos=$((jj_pos + 1))
        tmux move-window -b -t ":$pos"
        tmux select-window -t ":$pos"
      else
        tmux move-window -b -t :2
        tmux select-window -t :2
      fi
    '';
  };

  mergeHistory = pkgs.writeShellApplication {
    name = "merge_history";
    runtimeInputs = with pkgs; [bash coreutils];
    text = ''
      src="$1"
      dst="$2"

      if [ -n "$src" ] && [ -n "$dst" ]; then
        tmp="$(mktemp)"
        cat "$dst" "$src" | sort -u >"$tmp"
        mv "$tmp" "$dst"
      fi
    '';
  };

  tmuxPlugins = with pkgs.tmuxPlugins; [
    minimal-tmux-status
  ];
in {
  home.packages = [
    agentTerm
    fzfJjSession
    fzfSession
    fzfSshSession
    jjTerm
    jjTermCleanup
    mergeHistory
  ];

  xdg.configFile."tmux/plugins.conf".text = ''
    # generated by Home Manager
    ${lib.concatMapStringsSep "\n" (plugin: "run-shell ${plugin.rtp}") tmuxPlugins}
  '';
}
