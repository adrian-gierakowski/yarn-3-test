# This is a minimal `default.nix` by yarn-plugin-nixify. You can customize it
# as needed, it will not be overwritten by the plugin.

{ pkgs ? import <nixpkgs> { } }:

let
  nix-filter = import (import ./nix/sources.nix).nix-filter;
  src = nix-filter {
    root = ./.;
    include = [
      ./.yarn/releases/yarn-berry.cjs
      ./.yarn/plugins/yarn-plugin-nixify.cjs
      ./.yarnrc.yml
      ./package.json
      ./src/index.js
      ./yarn.lock
      ./bin/index.js
    ];
  };
  # src = ./.;
in
  pkgs.callPackage ./yarn-project.nix { } {
    inherit src;
    envVarNamesToPathStrings = {
      NPM_REGISTRY_AUTH_TOKEN = "/root/NPM_REGISTRY_AUTH_TOKEN";
    };
    # symlinkPackages = true;
    overrideNodeHidAttrs = old: {
      # npm_config_sqlite = "/";  # Don't accidentally use the wrong sqlite.
      buildInputs =
        old.buildInputs ++
        (with pkgs; [ python pkg-config libusb libudev ])
      ;
      phases = ["preBuild"] ++ old.phases;
      preBuild = ''
        echo CFLAGS: $CFLAGS
        pkg-config libusb-1.0 --cflags-only-I
      '';
      CFLAGS = "-isystem ${pkgs.libusb.dev}/include/libusb-1.0";
    };
    overrideKeccakAttrs = old: {
      # npm_config_sqlite = "/";  # Don't accidentally use the wrong sqlite.
      nativeBuildInputs =
        old.buildInputs ++
        (with pkgs; [ python3 ])
      ;
    };
    overrideSecp256k1Attrs = old: {
      # npm_config_sqlite = "/";  # Don't accidentally use the wrong sqlite.
      nativeBuildInputs =
        old.buildInputs ++
        (with pkgs; [ python3 ])
      ;
    };
  }
