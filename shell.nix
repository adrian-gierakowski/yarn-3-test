{
  pkgs ? import nix/pkgs.nix
}:
pkgs.mkShell {
  buildInputs = with pkgs; [
    nodejs
    yarn-berry-nixify
    niv
  ];
  shellHook = ''
  '';
}
