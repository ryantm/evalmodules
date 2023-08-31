pkgs:

[

  { _module.args.pkgs = pkgs; }

  (
    {lib,pkgs,...} : with lib; let
      languageServerModule = { name, config, ... }: {
        options.name = mkOption { type = types.str; };
        options.start = mkOption { type = types.str; };
      };
    in
    {
      options.lsp = mkOption {
        type = types.attrsOf (types.submodule languageServerModule);
        default = { };
      };
      config.lsp.go = {
        name = "go lsp";
        start = "${pkgs.gopls}/bin/gopls";
      };
    }
  )

]
