{ pkgs }:

builtins.toJSON (
  (pkgs.lib.evalModules {
    modules = [
      {}
    ];
  }).config)
