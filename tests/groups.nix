{ lib ? import <nixpkgs/lib> }:
let
  resolve = import ../nix/lib/groups.nix { inherit lib; };
  registry = {
    good = { name = "good"; platforms = [ "darwin" "nixos" ]; stow = [ { name = "a"; target = ".a"; } ]; };
    other = { name = "other"; platforms = [ "darwin" ]; stow = [ { name = "b"; target = ".a"; } ]; };
    same = { name = "same"; platforms = [ "darwin" ]; stow = [ { name = "a"; target = ".b"; } ]; };
  };
  fails = value: !(builtins.tryEval (builtins.deepSeq value true)).success;
in assert fails (resolve { inherit registry; kind = "darwin"; groups = [ "missing" ]; });
   assert fails (resolve { inherit registry; kind = "darwin"; groups = [ "good" "good" ]; });
   assert fails (resolve { inherit registry; kind = "nixos"; groups = [ "other" ]; });
   assert fails (resolve { inherit registry; kind = "darwin"; groups = [ "good" "other" ]; });
   assert fails (resolve { inherit registry; kind = "darwin"; groups = [ "good" "same" ]; });
   true
