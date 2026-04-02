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
          default = self.outputs.packages.${system}.cadquery;
          cadquery-env = python.withPackages (
            ps: [ self.outputs.packages.${system}.cadquery ]
          );
          cadquery = pkgs.callPackage ./cadquery (
            overrides
            // {
              inherit (self.outputs.packages.${system}) multimethod ocp;
            }
          );
          ocp = pkgs.callPackage ./ocp overrides;
          multimethod = pkgs.callPackage ./multimethod overrides;
          trianglesolver = pkgs.callPackage ./trianglesolver overrides;
          py-lib3mf = pkgs.callPackage ./py-lib3mf overrides;
          ocpsvg = pkgs.callPackage ./ocpsvg (
            overrides
            // {
              inherit (self.outputs.packages.${system}) ocp;
            }
          );
          build123d = pkgs.callPackage ./build123d (
            overrides
            // {
              inherit (self.outputs.packages.${system}) ocp ocpsvg py-lib3mf trianglesolver;
            }
          );
          ocp-tessellate = pkgs.callPackage ./ocp-tessellate (
            overrides
            // {
              inherit (self.outputs.packages.${system}) ocp;
            }
          );
          ocp-vscode = pkgs.callPackage ./ocp-vscode (
            overrides
            // {
              inherit (self.outputs.packages.${system}) ocp-tessellate;
            }
          );
        };
        devShells.default =
          let
            pythonEnv = python.withPackages (ps: [
              self.outputs.packages.${system}.cadquery
              self.outputs.packages.${system}.build123d
              self.outputs.packages.${system}.ocp-vscode
              ps.pip
            ]);
          in
          pkgs.mkShell {
            packages = [
              pythonEnv
            ];
            shellHook = ''
              mkdir -p .vscode
              ln -sfn ${pythonEnv}/bin/python .vscode/python
            '';
          };
      }
    );
}
