let
  sources = import ./sources.nix;
in import sources.nixpkgs {
  overlays = [
    (self: super: { nix-filter = import sources.nix-filter; })
    (self: super: {
      yarn-plugin-nixify = "${sources.yarn-plugin-nixify}/dist/yarn-plugin-nixify.js";
      yarn-berry-source = sources.yarn-berry-cjs-rhinofi;
      yarn-berry = self.callPackage (import ./packages/yarn-berry.nix) {};
      yarn-berry-nixify = self.writers.writeBashBin
        "yarn"
        ''
        set -euo pipefail
        export YARN_PLUGINS="''${YARN_PLUGINS:+''${YARN_PLUGINS};}${self.yarn-plugin-nixify}"

        exec ${self.lib.getExe self.yarn-berry} "''${@}"
        ''
      ;
    })
  ];
}
