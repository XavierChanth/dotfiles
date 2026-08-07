{ ... }: { services.openssh = { enable = true; openFirewall = true; settings = { KbdInteractiveAuthentication = false; PasswordAuthentication = false; PermitRootLogin = "no"; }; }; }
