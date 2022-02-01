# This is a minimal `default.nix` by yarn-plugin-nixify. You can customize it
# as needed, it will not be overwritten by the plugin.
{
  pkgs ? import nix/pkgs.nix
}:
let
  src = pkgs.nix-filter {
    root = ./.;
    include = [
      ./src/index.js
      ./src/index2.js
      ./bin/index.js
      ./.yalk
    ];
  };
in
  pkgs.callPackage ./yarn-project.nix { } {
    inherit src;
    secretsEnvVars = {
      NPM_REGISTRY_AUTH_TOKEN = "/root/NPM_REGISTRY_AUTH_TOKEN";
    };
    netrcFilePath = "/root/.netrc";
    symlinkPackages = true;
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
      nativeBuildInputs = with pkgs; [ nodejs.python ];
    };
    overrideSecp256k1Attrs = old: {
      # npm_config_sqlite = "/";  # Don't accidentally use the wrong sqlite.
      nativeBuildInputs =
        old.buildInputs ++
        (with pkgs; [ python3 ])
      ;
    };
    overrideNodeModuleTestAttrs = old: {
      # npm_config_sqlite = "/";  # Don't accidentally use the wrong sqlite.
      preBuild = "echo overrideNodeModuleTestAttrs";
    };
    overrideStarkwareCryptoCppNodeAttrs = old: {
      nativeBuildInputs =
        (old.nativeBuildInputs or []) ++
        (with pkgs; [ nodejs.python starkware-crypto-cpp cmake ])
      ;
      CMAKE_JS_INC = "${pkgs.nodejs}/include/node";
    };
  }
