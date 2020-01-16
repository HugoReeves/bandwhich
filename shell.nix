let
  moz_overlay = import (builtins.fetchTarball https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz);
  nixpkgs = import <nixpkgs> { overlays = [ moz_overlay ]; };
  rustStableChannel = nixpkgs.latest.rustChannels.stable.rust.override {
    extensions = [
      "rust-src"
      "rustfmt-preview"
      #clippy-preview"
    ];
  };
  frameworks = nixpkgs.darwin.apple_sdk.frameworks;
in
  with nixpkgs;
  with nixpkgs.latest.rustChannels.stable;
stdenv.mkDerivation {
  name = "bandwhich-rust-stable-shell";
  buildInputs = [
    gcc
    rustStableChannel
    rustup
  ]
  ++ lib.optional stdenv.isDarwin [
    frameworks.Security
    frameworks.CoreFoundation
    frameworks.CoreServices
  ];
}
