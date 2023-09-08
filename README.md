This is a collection of examples of using Nixpkgs lib.evalModules. It
was used in a talk "Declaring an IDE with evalModules"

## Slides

The slides from the presentation are here:

https://docs.google.com/presentation/d/1f3Nq9FvSPT8q-NtOtqAN2nsXSEP19Zck7943_yH9Q_s/edit?usp=sharing

## Video

The video of the presentation is here:

https://www.youtube.com/watch?v=WsU7sQvIh0U

## Usage

Run examples like

```
nix run github:ryantm/evalmodules#example4
```

```
Module input:
───────┬───────────────────────────────────────────────────────────────────────
       │ File: /nix/store/37aa4pz3j0iwp6z6lfm6wg7nnjq6zl79-example4.nix
───────┼───────────────────────────────────────────────────────────────────────
   1   │ { pkgs }:
   2   │ 
   3   │ builtins.toJSON (
   4   │   (pkgs.lib.evalModules {
   5   │     modules = [
   6   │       { _module.args.pkgs = pkgs; }
   7   │ 
   8   │       (
   9   │         { lib, pkgs, ... }: with lib; let
  10   │           languageServerModule = { config, ... }: {
  11   │             options.name = mkOption { type = types.str; };
  12   │             options.start = mkOption { type = types.str; };
  13   │           };
  14   │         in
  15   │         {
  16   │           options.lsp = mkOption {
  17   │             type = types.attrsOf (types.submodule languageServerModule
       │ );
  18   │             default = { };
  19   │           };
  20   │           config.lsp.go = {
  21   │             name = "go lsp";
  22   │             start = "${pkgs.gopls}/bin/gopls";
  23   │           };
  24   │           config.lsp.rust = {
  25   │             name = "rust lsp";
  26   │             start = "${pkgs.rust-analyzer}/bin/rust-analyzer";
  27   │           };
  28   │         }
  29   │       )
  30   │     ];
  31   │   }).config)
───────┴───────────────────────────────────────────────────────────────────────

Config output:
{
  "lsp": {
    "go": {
      "name": "go lsp",
      "start": "/nix/store/f6q5lyk2fa9lajhqnjdz1m86cinchzk0-gopls-0.11.0/bin/gopls"
    },
    "rust": {
      "name": "rust lsp",
      "start": "/nix/store/dzdl1rwniqi9s2v0npsfzakblzmpw56i-rust-analyzer-2023-05-15/bin/rust-analyzer"
    }
  }
}

Closure:
/nix/store/567zfi9026lp2q6v97vwn640rv6i3n4c-libunistring-1.1                  	   1.8M
/nix/store/4563gldw8ibz76f1a3x69zq3a1vhdpz9-libidn2-2.3.4                     	   2.1M
/nix/store/jd99cyc0251p0i5y69w8mqjcai8mcq7h-xgcc-12.2.0-libgcc                	 139.3K
/nix/store/46m4xx889wlhsdj72j38fnlyyvvvvbyb-glibc-2.37-8                      	  31.1M
/nix/store/8fv91097mbh5049i9rglc73dx6kjg3qk-bash-5.2-p15                      	  32.7M
/nix/store/81d13il7plchw65gz8y9ywcxrngq149c-gcc-12.2.0-libgcc                 	 139.3K
/nix/store/843dqq10jdkalr2yazaz6drx334visrb-gcc-12.2.0-lib                    	  38.8M
/nix/store/90jqd93cbmp3pa0s4qc5nc207mjcdsmq-rust-analyzer-unwrapped-2023-05-15	  80.0M
/nix/store/zzdsvizbcndb0qp0ga762bvgc9jg3f52-rust-lib-src                      	  52.7M
/nix/store/dzdl1rwniqi9s2v0npsfzakblzmpw56i-rust-analyzer-2023-05-15          	 134.3M
/nix/store/3vxbq3ih3rjfrwwh8324cx23wn4y1b88-mailcap-2.1.53                    	 109.4K
/nix/store/3yx6fa7gxgp4p6d79skvscvdd21alclp-tzdata-2023c                      	   2.0M
/nix/store/62x656g2c42fp2k5ki41pd1z2l393649-iana-etc-20230316                 	 556.4K
/nix/store/f6q5lyk2fa9lajhqnjdz1m86cinchzk0-gopls-0.11.0                      	  53.4M
/nix/store/3phibph2vhxi21h2xg3imlfqgi6nbai0-example4.nix                      	 156.6M
```

## Passthru attributes

If you want to just build the configuration instead of this output, you can use

```
nix run github:ryantm/evalmodules#example4.moduleConfig
```
