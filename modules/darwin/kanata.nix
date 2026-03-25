{
  config,
  pkgs,
  username,
  ...
}: let
  userHome = config.users.users.${username}.home;
  kanataConfig = "${userHome}/.config/kanata/macos.kbd";
in {
  environment.systemPackages = [pkgs.kanata];

  launchd.daemons.kanata = {
    serviceConfig = {
      ProgramArguments = [
        "${pkgs.kanata}/bin/kanata"
        "-c"
        kanataConfig
      ];
      KeepAlive = true;
      RunAtLoad = true;
      StandardErrorPath = "/tmp/kanata.stderr";
      StandardOutPath = "/tmp/kanata.stdout";
    };
  };
}
