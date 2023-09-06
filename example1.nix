{ pkgs }:

builtins.toJSON (
  (pkgs.lib.evalModules {
    modules = [
      ({ lib, ... }: {
        options.msg = lib.mkOption { type = lib.types.str; };
        config.msg = "hello world";
      })
    ];
  }).config)
