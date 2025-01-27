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
      version = "0.1.1";

      src = ./.;

      nativeBuildInputs = [ pkgs.zig ];

      dontConfigure = true;

      preBuild = ''
        export HOME=$TMPDIR
      '';

      installPhase = ''
        runHook preInstall
        zig build -Doptimize=ReleaseSmall -Dcpu=baseline --prefix $out install
        runHook postInstall
      '';
    };
  };
}
