{ ... }: {
  services.logind.settings.Login = { HandleHibernateKey = "ignore"; HandleLidSwitch = "ignore"; HandleLidSwitchDocked = "ignore"; HandleLidSwitchExternalPower = "ignore"; HandleSuspendKey = "ignore"; IdleAction = "ignore"; };
  systemd.targets = { sleep.enable = false; suspend.enable = false; hibernate.enable = false; hybrid-sleep.enable = false; };
}
