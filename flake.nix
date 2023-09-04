{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
  inputs.systems.url = "github:nix-systems/default";
  outputs = { self, nixpkgs, systems, ... }:
    let
      pkgs = import nixpkgs { system = "x86_64_linux"; };
      eachSystem = nixpkgs.lib.genAttrs (import systems);

      moduleConfig = pkgs: modules: name: pkgs.writeText name ''
        ${builtins.toJSON (pkgs.lib.evalModules { modules = import modules pkgs; }).config}
      '';

      printClosure = pkgs: modulesConfig: pkgs.writeScriptBin "print-closure" ''
        ${pkgs.nixVersions.nix_2_17}/bin/nix path-info --recursive --human-readable --closure-size ${modulesConfig}
      '';

      printConfig = pkgs: modules: modulesConfig: pkgs.writeScriptBin
        "print-config-${(builtins.parseDrvName modulesConfig.name).name}" ''
        echo "Module input:"
        ${pkgs.bat}/bin/bat --theme=ansi --language=nix ${modules}
        echo
        echo "Config output:"
        ${pkgs.jq}/bin/jq < ${modulesConfig}
        echo
        echo "Closure:"
        ${printClosure pkgs modulesConfig}/bin/print-closure
      '';
    in
    {
      formatter = eachSystem (system: nixpkgs.legacyPackages.${system}.nixpkgs-fmt);

      packages = eachSystem (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        rec {

          default = example4;

          module0 = moduleConfig pkgs ./example0.nix "example0";
          closure0 = printClosure pkgs module0;
          example0 = printConfig pkgs ./example0.nix module0;

          module1 = moduleConfig pkgs ./example1.nix "example1";
          closure1 = printClosure pkgs module1;
          example1 = printConfig pkgs ./example1.nix module1;

          module2 = moduleConfig pkgs ./example2.nix "example2";
          closure2 = printClosure pkgs module2;
          example2 = printConfig pkgs ./example2.nix module2;

          module3 = moduleConfig pkgs ./example3.nix "example3";
          closure3 = printClosure pkgs module3;
          example3 = printConfig pkgs ./example3.nix module3;

          module4 = moduleConfig pkgs ./example4.nix "example4";
          closure4 = printClosure pkgs module4;
          example4 = printConfig pkgs ./example4.nix module4;
          docker4 = pkgs.dockerTools.buildLayeredImage {
            name = "rust-lsp";
            config.Cmd = [
              "${pkgs.bash}/bin/bash"
              "-c"
              "$(${pkgs.jq}/bin/jq -r .lsp.rust.start <${module4}) --version"
            ];
          };
          docker4-load-and-run = pkgs.writeScriptBin "docker-load-and-run" ''
            ${pkgs.docker}/bin/docker run $(${pkgs.docker}/bin/docker load -q < ${docker4} | cut -d' ' -f3)
          '';

          module5 = moduleConfig pkgs ./example5.nix "example5";
          closure5 = printClosure pkgs module5;
          example5 = printConfig pkgs ./example5.nix module5;
        });
    };
}
