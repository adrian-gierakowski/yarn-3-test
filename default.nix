# This is a minimal `default.nix` by yarn-plugin-nixify. You can customize it
# as needed, it will not be overwritten by the plugin.
{
  pkgs ? import nix/pkgs.nix
}:
let
  src = pkgs.nix-filter {
    root = ./.;
    include = [
      ./bin
      ./src
    ];
  };
in
pkgs.callPackage ./yarn-project.nix
  {
    nodejs = pkgs.nodejs;
    yarn-berry = pkgs.yarn-berry-nixify;
  }
  {
    inherit src;
    symlinkPackages = true;
  }


