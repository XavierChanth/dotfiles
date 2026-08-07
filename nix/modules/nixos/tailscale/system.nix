{ ... }: { dotfiles.labUpdate.requiredUnits = [ "tailscaled.service" ]; services.tailscale = { enable = true; extraSetFlags = [ "--accept-dns=false" ]; }; }
