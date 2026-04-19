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
          cadquery-env = python.buildEnv.override {
            extraLibs = [ self.outputs.packages.${system}.cadquery ];
            ignoreCollisions = true;
          };
          cadquery = pkgs.callPackage ./cadquery (
            overrides
            // {
              inherit (self.outputs.packages.${system})
                multimethod
                ocp
                runtype
                trame
                trame-vtk
                trame-components
                trame-vuetify
                ;
            }
          );
          vtk = pkgs.callPackage ./vtk overrides;
          ocp = pkgs.callPackage ./ocp (
            overrides
            // {
              inherit (self.outputs.packages.${system}) vtk;
              inherit (pkgs) darwin;
            }
          );
          multimethod = pkgs.callPackage ./multimethod overrides;
          runtype = pkgs.callPackage ./runtype overrides;
          lib3mf = pkgs.callPackage ./lib3mf overrides;
          trianglesolver = pkgs.callPackage ./trianglesolver overrides;
          trame-common = pkgs.callPackage ./trame-common overrides;
          trame-client = pkgs.callPackage ./trame-client (
            overrides
            // {
              inherit (self.outputs.packages.${system}) trame-common;
            }
          );
          trame-server = pkgs.callPackage ./trame-server overrides;
          trame = pkgs.callPackage ./trame (
            overrides
            // {
              inherit (self.outputs.packages.${system}) trame-server trame-client trame-common;
            }
          );
          trame-vtk = pkgs.callPackage ./trame-vtk (
            overrides
            // {
              inherit (self.outputs.packages.${system}) trame-client;
            }
          );
          trame-components = pkgs.callPackage ./trame-components (
            overrides
            // {
              inherit (self.outputs.packages.${system}) trame-client;
            }
          );
          trame-vuetify = pkgs.callPackage ./trame-vuetify (
            overrides
            // {
              inherit (self.outputs.packages.${system}) trame-client;
            }
          );
          ocpsvg = pkgs.callPackage ./ocpsvg (
            overrides
            // {
              inherit (self.outputs.packages.${system}) ocp;
            }
          );
          ocp-gordon = pkgs.callPackage ./ocp-gordon (
            overrides
            // {
              inherit (self.outputs.packages.${system}) ocp;
            }
          );
          build123d = pkgs.callPackage ./build123d (
            overrides
            // {
              inherit (self.outputs.packages.${system}) ocp ocpsvg lib3mf ocp-gordon trianglesolver;
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
        devShells =
          let
            defaultPythonEnv = python.buildEnv.override {
              extraLibs = (ps: [
                self.outputs.packages.${system}.cadquery
                self.outputs.packages.${system}.build123d
                self.outputs.packages.${system}.ocp-vscode
                ps.pip
              ]) python.pkgs;
              ignoreCollisions = true;
            };
            vscodePythonEnv = python.buildEnv.override {
              extraLibs = (ps: [
                self.outputs.packages.${system}.cadquery
                self.outputs.packages.${system}.ocp-vscode
                ps.pip
              ]) python.pkgs;
              ignoreCollisions = true;
            };
            workspaceSettings = pkgs.writeText "settings.json" (builtins.toJSON {
              "python.defaultInterpreterPath" = "${vscodePythonEnv}/bin/python";
              "python.useEnvironmentsExtension" = false;
            });
            workspaceExtensions = pkgs.writeText "extensions.json" (builtins.toJSON {
              recommendations = [
                "ms-python.python"
                "bernhard-42.ocp-cad-viewer"
              ];
            });
          in
          {
            default = pkgs.mkShell {
              packages = [
                defaultPythonEnv
              ];
            };
            vscode = pkgs.mkShell {
              packages = [
                vscodePythonEnv
              ];
              shellHook = ''
                mkdir -p .vscode
                [ -e .vscode/settings.json ] || cp ${workspaceSettings} .vscode/settings.json
                [ -e .vscode/extensions.json ] || cp ${workspaceExtensions} .vscode/extensions.json
                chmod -R u+w .vscode
              '';
            };
          };
      }
    );
}
