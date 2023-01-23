{lib,...} : with lib; {
  options = {
    deps = mkOption {
      type = types.listOf types.str;
      default = [];
    };
    rails.db = mkOption {
      type = types.enum [ "sqlite" "mariadb"];
      default = "sqlite";
    };
  };
  config = {
    deps = [ "ruby" "bundler" ];
    rails.db = "mariadb";
  };
}
