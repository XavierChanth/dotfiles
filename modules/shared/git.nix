{config, ...}: {
  home.file.".config/git/user-default".text = ''
    [user]
    	name = xavierchanth
    	email = xchanthavong@gmail.com
    	signingkey = ~/.ssh/id_ed25519.pub
  '';

  home.file.".config/git/user-atsign".text = ''
    [user]
    	name = xavierchanth
    	email = xavier@atsign.com
    	signingkey = ~/.ssh/id_ed25519.pub
  '';

  home.file.".config/git/user-woosah".text = ''
    [user]
    	name = xavierchanth
    	email = xavier@woosah.io
    	signingkey = ~/.ssh/id_ed25519.pub
  '';

  home.file.".config/git/user-consulting".text = ''
    [user]
    	name = xavierchanth
    	email = xavier@chanthavongconsulting.ca
    	signingkey = ~/.ssh/id_ed25519.pub
  '';

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
    includes = [
      {
        path = "${config.home.homeDirectory}/.config/git/user-default";
      }
      {
        condition = "hasconfig:remote.*.url:git@github.com:atsign-*/**";
        path = "${config.home.homeDirectory}/.config/git/user-atsign";
      }
      {
        condition = "hasconfig:remote.*.url:git@github.com:woosah-tech/**";
        path = "${config.home.homeDirectory}/.config/git/user-woosah";
      }
      {
        condition = "gitdir:${config.home.homeDirectory}/src/af/";
        path = "${config.home.homeDirectory}/.config/git/user-atsign";
      }
      {
        condition = "gitdir:${config.home.homeDirectory}/src/ac/";
        path = "${config.home.homeDirectory}/.config/git/user-atsign";
      }
      {
        condition = "gitdir:${config.home.homeDirectory}/src/ws/";
        path = "${config.home.homeDirectory}/.config/git/user-woosah";
      }
      {
        condition = "gitdir:${config.home.homeDirectory}/src/cc/";
        path = "${config.home.homeDirectory}/.config/git/user-consulting";
      }
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
