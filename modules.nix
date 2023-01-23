{lib,...} : with lib; {
  options = {
    deps = mkOption {
      type = types.listOf types.str;
      default = [];
    };
  };
  imports = [ ./rails.nix ];
}
