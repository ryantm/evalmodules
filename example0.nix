# Using evalModules with an empty configuration
{ pkgs }:

builtins.toJSON (
  (pkgs.lib.evalModules {
    modules = [
      {}
    ];
  }).config)
