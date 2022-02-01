let
  sources = import ./sources.nix;
in import sources.nixpkgs {
  overlays = [
    (import "${sources.starkware-crypto-cpp-node}/overlay.nix")
    (self: super: { nix-filter = import sources.nix-filter; })
  ];
}
