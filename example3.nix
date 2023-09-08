# Using a language server submodule to enable multiple language servers
{ pkgs }:

builtins.toJSON (
  (pkgs.lib.evalModules {
    modules = [
      { _module.args.pkgs = pkgs; }

      (
        { lib, pkgs, ... }: with lib; let
          languageServerSubmodule = { config, ... }: {
            options.name = mkOption { type = types.str; };
            options.start = mkOption { type = types.str; };
          };
        in
        {
          options.lsp = mkOption {
            type = types.attrsOf (types.submodule languageServerSubmodule);
            default = { };
          };
          config.lsp.go = {
            name = "go lsp";
            start = "${pkgs.gopls}/bin/gopls";
          };
        }
      )
    ];
  }).config)
