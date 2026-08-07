{ lib }:
let
  resolve = import ../lib/groups.nix { inherit lib; };
  base = { name = "both"; platforms = [ "darwin" "nixos" ]; darwin = [ "d" ]; nixos = [ "n" ]; };
  succeeds = value: (builtins.tryEval (builtins.deepSeq value true)).success;
  fails = value: !(succeeds value);
  dual = resolve { registry.both = base; kind = "darwin"; groups = [ "both" ]; };
  malformedBrew = base // { brew = { taps = [ 1 ]; brews = []; casks = []; }; };
  noDarwinBrew = { name = "linux"; platforms = [ "nixos" ]; brew = { taps=[]; brews=[]; casks=[]; }; };
  requiring = { name = "tool"; platforms = [ "nixos" ]; requires = [ "config" ]; };
  config = { name = "config"; platforms = [ "nixos" ]; };
in assert dual.systemModules == [ "d" ];
assert fails (resolve { registry.bad = malformedBrew; kind = "darwin"; groups = [ "bad" ]; });
assert fails (resolve { registry.linux = noDarwinBrew; kind = "nixos"; groups = [ "linux" ]; });
assert fails (resolve { registry = { tool = requiring; inherit config; }; kind = "nixos"; groups = [ "tool" ]; });
assert fails (resolve { registry.both = base; kind = "plan9"; groups = [ "both" ]; });
assert succeeds (resolve { registry = { tool = requiring; inherit config; }; kind = "nixos"; groups = [ "tool" "config" ]; });
true
