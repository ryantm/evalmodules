{ pkgs }:

builtins.toJSON (
  (pkgs.lib.evalModules {
    modules = [
      { _module.args.pkgs = pkgs; }

      ({ lib, pkgs, ... }: with lib; {
        options.lsp = {
          name = mkOption { type = types.str; };
          start = mkOption { type = types.str; };
        };
        config = {
          lsp.name = "go lsp";
          lsp.start = "${pkgs.gopls}/bin/gopls";
        };
      })
    ];
  }).config)
