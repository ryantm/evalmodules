pkgs:

[

  ({ lib, ... }: {
    options.msg = lib.mkOption { type = lib.types.str; };
    config.msg = "hello world";
  })

]
