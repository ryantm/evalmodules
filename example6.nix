# Using modules to create a CSV config file
{ pkgs }:

builtins.toJSON (
  (pkgs.lib.evalModules {
    modules = [
      { _module.args.pkgs = pkgs; }

      (
        { config, lib, pkgs, ... }: with lib; {
          options.csv.port = mkOption { type = types.int; default = 3000; };
          options.csv.log_level = mkOption { type = types.str; default = "debug"; };
          options.csv.output = mkOption { type = types.lines; default =
            "port,${toString config.csv.port}\n" +
            "log_level,${config.csv.log_level}";
          };
          config.csv.port = 8080;
          config.csv.log_level = "warn";
        }
      )
    ];
  }).config)
