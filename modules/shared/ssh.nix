{
  config,
  lib,
  ...
}: {
  home.file.".ssh/config".text = ''
    Host *
      IdentitiesOnly yes
      ControlMaster auto
      ControlPath ~/.ssh/control/%r@%n:%p
      ControlPersist 900
      SetEnv TERM=xterm-256color

    Include config.d/*

    Host localhost
      ControlMaster no
  '';

  home.activation.ensureSshPaths = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p "${config.home.homeDirectory}/.ssh/config.d"
    mkdir -p "${config.home.homeDirectory}/.ssh/control"
    chmod 700 "${config.home.homeDirectory}/.ssh"
    chmod 700 "${config.home.homeDirectory}/.ssh/config.d"
    chmod 700 "${config.home.homeDirectory}/.ssh/control"
  '';
}
