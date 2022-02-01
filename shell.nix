# This is a minimal `default.nix` by yarn-plugin-nixify. You can customize it
# as needed, it will not be overwritten by the plugin.
{
  pkgs ? import nix/pkgs.nix
}:
pkgs.mkShell {
  buildInputs = with pkgs; [
    starkware-crypto-cpp
    cmake
    nodejs
    nodejs.python
  ];
  shellHook = ''
    export CMAKE_JS_INC="${pkgs.nodejs}/include/node";
  '';
}
