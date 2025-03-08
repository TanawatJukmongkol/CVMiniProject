{
  description = "Computer Vision - Mini Project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    utils.url = "github:numtide/flake-utils";
    flake-compat.url = "https://flakehub.com/f/edolstra/flake-compat/1.tar.gz";
  };

  outputs = { self, nixpkgs, utils, flake-compat }: utils.lib.eachDefaultSystem (system:
  let
    pkgs = import nixpkgs {
      inherit system;
      config = { allowUnfree = true; };
    };
  in
  {
    devShells.default = with pkgs; stdenv.mkDerivation rec {
      name = "rai-nix";
      src = ./srcs;
      buildInputs = [
        # Libs
        qt5.qtwayland
        zlib
        # Packages
        python312
        python312Packages.pyqt5
        poetry
        glib
        libGL
        texliveFull
      ];
      shellHook = ''
        export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath buildInputs}:$LD_LIBRARY_PATH"
        export LD_LIBRARY_PATH="${pkgs.stdenv.cc.cc.lib.outPath}/lib:$LD_LIBRARY_PATH"
        export QT_QPA_PLATFORM_PLUGIN_PATH="${qt5.qtbase.bin}/lib/qt-${qt5.qtbase.version}/plugins";
      '';
    };
  });
}
