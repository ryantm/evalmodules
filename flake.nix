{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
  inputs.systems.url = "github:nix-systems/default";
  outputs = { self, nixpkgs, systems, ... }:
    let
      eachSystem = nixpkgs.lib.genAttrs (import systems);
    in
    {
      formatter = eachSystem (system: nixpkgs.legacyPackages.${system}.nixpkgs-fmt);

      packages = eachSystem (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          ex = example: pkgs.callPackage ./pkgs/print_config.nix {
            inherit example;
          };
        in
        rec {
          default = example4;

          example0 = ex ./example0.nix;
          example1 = ex ./example1.nix;
          example2 = ex ./example2.nix;
          example3 = ex ./example3.nix;
          example4 = ex ./example4.nix;
          docker4 = pkgs.dockerTools.buildLayeredImage {
            name = "rust-lsp";
            config.Cmd = [
              "${pkgs.bash}/bin/bash"
              "-c"
              "$(${pkgs.jq}/bin/jq -r .lsp.rust.start <${example4.moduleConfig}) --version"
            ];
          };
          docker4-load-and-run = pkgs.writeScriptBin "docker-load-and-run" ''
            ${pkgs.docker}/bin/docker run $(${pkgs.docker}/bin/docker load -q < ${docker4} | cut -d' ' -f3)
          '';
        });
    };
}
