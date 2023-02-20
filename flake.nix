{
  description = "Small and simple status bar";

  inputs.nixpkgs.url = "nixpkgs";

  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
    };
  in
  {
    packages."${system}".default = pkgs.stdenv.mkDerivation rec {
      pname = "statxt";
      version = "0.1.0";

      src = ./.;

      nativeBuildInputs = [ pkgs.zig ];

      dontConfigure = true;

      preBuild = ''
        export HOME=$TMPDIR
      '';

      installPhase = ''
        runHook preInstall
        zig build -Drelease-small -Dcpu=baseline --prefix $out install
        runHook postInstall
      '';
    };
  };
}
