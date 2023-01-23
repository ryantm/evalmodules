{lib,...} : with lib; {
  options = {
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
