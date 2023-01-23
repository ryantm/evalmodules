{
  outputs = {self, nixpkgs,...} : let
    pkgs = import nixpkgs { system = "x86_64-linux";};
  in {
    packages.x86_64-linux.default = pkgs.writeScriptBin "print-config" ''
      echo '${(builtins.toJSON (pkgs.lib.evalModules { modules = [ ./modules.nix ]; }).config)}'
    '';
  };
}
