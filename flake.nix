{
  description = "Simple personal sway bar";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      pname = "piebar";
      bin = "$out/bin";
    in
    {
    packages."x86_64-linux".default = with import nixpkgs { system = "x86_64-linux"; }; stdenv.mkDerivation {
      inherit pname;
      version = "1.0.0";
      src = ./src;
      buildPhase = "gcc *.c -o ${pname} -O3";
      installPhase = ''
        mkdir -p ${bin}
        cp ${pname} ${bin}
        strip ${bin}/${pname}
      '';
    };
  };
}
