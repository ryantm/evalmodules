{ pkgs, writeScriptBin, bat, jq, example }:

let

  nix = pkgs.nixVersions.nix_2_17;

  moduleConfig = pkgs.writeText (builtins.baseNameOf example) ''
    ${pkgs.callPackage example {}}
  '';

in

(writeScriptBin
"print-config-${(builtins.parseDrvName moduleConfig.name).name}" ''
  echo "Module input:"
  ${bat}/bin/bat --theme=ansi --language=nix ${example}
  echo
  echo "Config output:"
  ${jq}/bin/jq < ${moduleConfig}
  echo
  echo "Closure:"
  ${nix}/bin/nix path-info --recursive --human-readable --closure-size ${moduleConfig}
''
).overrideAttrs (prev: {
  passthru = {
    inherit moduleConfig;
  };
})
