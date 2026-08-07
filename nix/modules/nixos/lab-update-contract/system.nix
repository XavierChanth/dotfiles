{ config, lib, ... }: {
  options.dotfiles.labUpdate.requiredUnits = lib.mkOption {
    type = lib.types.listOf (lib.types.strMatching "^[A-Za-z0-9@_.:-]+\\.service$");
    default = [];
    description = "Units that must be active before a lab rollout is committed.";
  };
  config = {
    assertions = [{ assertion = config.dotfiles.labUpdate.requiredUnits != []; message = "lab-update requires at least one health unit"; }];
    environment.etc."lab-update/required-units".text = lib.concatMapStrings (unit: "${unit}\n") (lib.unique config.dotfiles.labUpdate.requiredUnits);
  };
}
