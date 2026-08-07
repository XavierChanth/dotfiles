{ lib, pkgs }:
{ home, declarations }:
let
  regular = lib.filter (item: !(item.special or false)) declarations;
  prepare = lib.unique (lib.concatMap (item: item.prepare or []) regular);
  mkdirCommands = lib.concatMapStringsSep "\n" (path: ''mkdir -p "${home}/${path}"'') prepare;
  command = item: ''
    ${pkgs.stow}/bin/stow --dir="$STOW_DIR" --target="${home}/${item.target}" --restow ${lib.escapeShellArg item.name}
  '';
in {
  inherit mkdirCommands;
  stowCommands = lib.concatMapStringsSep "\n" command regular;
}
