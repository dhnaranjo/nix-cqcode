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
      result =
        eachSystem (
          system:
          let
            pkgs = import nixpkgs {
              inherit system;
              config.allowUnfree = true;
            };
            python = pkgs.python312;
            overrides.python3Packages = python.pkgs;
            ocpCadViewerVersion = self.outputs.packages.${system}.ocp-vscode.version;
            ocpCadViewer = pkgs.vscode-utils.buildVscodeExtension {
              pname = "ocp-cad-viewer";
              version = ocpCadViewerVersion;
              vscodeExtPublisher = "bernhard-42";
              vscodeExtName = "ocp-cad-viewer";
              vscodeExtUniqueId = "bernhard-42.ocp-cad-viewer";
              src = pkgs.fetchurl {
                url = "https://github.com/bernhard-42/vscode-ocp-cad-viewer/releases/download/v${ocpCadViewerVersion}/ocp-cad-viewer-${ocpCadViewerVersion}.vsix";
                hash = "sha256-RkG3Hr4GFiHoeuz4s93lU2NS72aDaEH/P3fYYyfKYSo=";
              };
            };
            baseEditorExtensions = [
              pkgs.vscode-extensions.ms-python.python
              ocpCadViewer
            ];
            shellScope = {
              inherit pkgs python system;
              packages = self.outputs.packages.${system};
            };
            resolveShellValue =
              value:
              if builtins.isFunction value then
                value shellScope
              else
                value;
            mkCqcode =
              {
                extraExtensions ? [ ],
              }:
              let
                vscodeWithExtensions = pkgs.vscode-with-extensions.override {
                  vscodeExtensions = baseEditorExtensions ++ resolveShellValue extraExtensions;
                };
              in
              pkgs.writeShellScriptBin "cqcode" ''
                exec ${vscodeWithExtensions}/bin/code "$@"
              '';
            mkWorkspaceShell =
              {
                pythonLibs ? (
                  ps: [
                    self.outputs.packages.${system}.cadquery
                    self.outputs.packages.${system}.ocp-vscode
                    ps.pip
                  ]
                ),
                extraExtensions ? [ ],
                editorPackage ? mkCqcode { inherit extraExtensions; },
                extraPackages ? [ ],
                settings ? { },
                shellHook ? "",
              }:
              let
                resolvedEditorPackage = resolveShellValue editorPackage;
                resolvedExtraPackages = resolveShellValue extraPackages;
                resolvedSettings = resolveShellValue settings;
                resolvedShellHook = resolveShellValue shellHook;
                pythonEnv = python.buildEnv.override {
                  extraLibs = pythonLibs python.pkgs;
                  ignoreCollisions = true;
                };
                workspaceSettings = pkgs.writeText "settings.json" (builtins.toJSON (
                  {
                    "python.defaultInterpreterPath" = "${pythonEnv}/bin/python";
                    "python.useEnvironmentsExtension" = false;
                  }
                  // resolvedSettings
                ));
              in
              pkgs.mkShell {
                packages = [
                  pythonEnv
                  resolvedEditorPackage
                ] ++ resolvedExtraPackages;
                shellHook = ''
                  mkdir -p .vscode
                  [ -e .vscode/settings.json ] || cp ${workspaceSettings} .vscode/settings.json
                  chmod -R u+w .vscode
                '' + resolvedShellHook;
              };
          in
          {
            lib = {
              inherit mkCqcode mkWorkspaceShell;
              mkCqcodeShell = mkWorkspaceShell;
            };
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
          cqcode = mkCqcode { };
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
              in
              {
                default = pkgs.mkShell {
                  packages = [
                    defaultPythonEnv
                  ];
                };
                cqcode = mkWorkspaceShell { };
              };
          }
        );
    in
    result
    // {
      lib =
        result.lib
        // {
          mkCqShell =
            shellConfig:
            nixpkgs.lib.mapAttrs (system: _: {
              default = result.lib.${system}.mkCqcodeShell shellConfig;
            }) result.devShells;
        };
    };
}
