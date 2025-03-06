{
  description = "Over engineered Nix Flake for RAI exam";

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
    devShells.default = with pkgs; stdenv.mkDerivation {
      name = "rai-nix";
      src = ./srcs;
      buildInputs = [
        poetry
        glib
        libGL
        texliveFull
        qt5.qtwayland
      ];
      shellHook = ''
        export LD_LIBRARY_PATH="${stdenv.cc.cc.lib}/lib/":$LD_LIBRARY_PATH
        export LD_LIBRARY_PATH="${pkgs.glib.out}/lib":$LD_LIBRARY_PATH
        export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath [pkgs.libGL]}":$LD_LIBRARY_PATH
        export LD_LIBRARY_PATH=/run/opengl-driver/lib/:$LD_LIBRARY_PATH
        export QT_QPA_PLATFORM=xcb
        # source $src/.nixshell_rc
      '';
    };
  });
}
