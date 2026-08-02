{...}: {
  programs.bat = {
    enable = true;
    config = {
      theme = "ansi";
      style = "numbers,changes,header";
    };
  };

  programs.delta = {
    enable = true;
    options = {
      navigate = true;
      line-numbers = true;
      pager = "bat --plain";
    };
  };

  programs.git = {
    enable = true;
    ignores = [
      "**/.claude/"
      "**/.codex/"
      "**/.opencode/"
      "/.work"
    ];
    lfs.enable = true;
    settings = {
      alias = {
        st = "status";
        wt = "worktree";
        wtls = "worktree list";
      };
      commit.gpgsign = true;
      core.pager = "delta";
      diff.colorMoved = "default";
      gpg.format = "ssh";
      interactive.diffFilter = "delta --color-only";
      init.defaultBranch = "main";
      merge.conflictstyle = "diff3";
      pull.ff = "only";
      pull.rebase = false;
    };
  };
}
