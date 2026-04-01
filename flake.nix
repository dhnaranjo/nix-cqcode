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
          default = self.outputs.packages.${system}.cq-editor;
          cq-editor = pkgs.callPackage ./cq-editor (
            overrides
            // {
              inherit (self.outputs.packages.${system}) cadquery qtawesome;
              inherit (pkgs) qt5;
            }
          );
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
          qtawesome = pkgs.callPackage ./qtawesome overrides;
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
        apps.default = {
          type = "app";
          program = "${self.outputs.packages.${system}.cq-editor}/bin/cq-editor";
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
              export PATH="${self.outputs.packages.${system}.cq-editor}/bin:$PATH"
              mkdir -p .vscode
              ln -sfn ${pythonEnv}/bin/python .vscode/python
            '';
          };
      }
    );
}
