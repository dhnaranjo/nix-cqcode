{

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
  };
  outputs =
    {
      self,
      nixpkgs,
    }:

    let
      systems = [
        # "x86_64-darwin"
        "aarch64-darwin"
        # "x86_64-linux"
        # "aarch64-linux"
      ];
      eachSystem =
        with nixpkgs.lib;
        f: foldAttrs mergeAttrs { } (map (s: mapAttrs (_: v: { ${s} = v; }) (f s)) systems);
    in
    eachSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
        python = pkgs.python312;
        overrides.python3Packages = python.pkgs;
      in
      {
        packages = {
          default = self.outputs.packages.${system}.cadquery-env;
          cadquery-env = python.withPackages (
            ps: [ self.outputs.packages.${system}.cadquery ]
          );
          cadquery = pkgs.callPackage ./cadquery (
            overrides
            // {
              inherit (self.outputs.packages.${system}) casadipy multimethod nloptpy ocp;
            }
          );
          ocp = pkgs.callPackage ./ocp overrides;
          nloptpy = pkgs.callPackage ./nloptpy overrides;
          casadipy = pkgs.callPackage ./casadipy overrides;
          multimethod = pkgs.callPackage ./multimethod overrides;
        };
      }
    );
}
