{
  pkgs,
  username,
  ...
}: let
  kanataConfigDir = "/Users/${username}/.config/kanata";
in {
  launchd.daemons.kanata = {
    serviceConfig = {
      ProgramArguments = [
        "${pkgs.kanata}/bin/kanata"
        "-c"
        "${kanataConfigDir}/macos.kbd"
      ];
      KeepAlive = true;
      RunAtLoad = true;
      StandardErrorPath = "/tmp/kanata.stderr";
      StandardOutPath = "/tmp/kanata.stdout";
    };
  };
}
