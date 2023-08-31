{
  inputs.systems.url = "github:nix-systems/default";
  outputs = {self, nixpkgs, systems,...} : let
    pkgs = import nixpkgs { system = "x86_64-linux";};
    eachSystem = nixpkgs.lib.genAttrs (import systems);
    jsonConfig = modules: pkgs.writeScriptBin "print-config" ''
      echo '${(builtins.toJSON (pkgs.lib.evalModules { modules = import modules pkgs; }).config)}'
    '';
  in {
    packages = eachSystem (system: rec {
      default = example4;
      example0 = jsonConfig ./example0.nix;
      example1 = jsonConfig ./example1.nix;
      example2 = jsonConfig ./example2.nix;
      example3 = jsonConfig ./example3.nix;
      example4 = jsonConfig ./example4.nix;
    });
  };
}
