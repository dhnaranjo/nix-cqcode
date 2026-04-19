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
        "x86_64-darwin"
        "aarch64-darwin"
        "x86_64-linux"
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
            mkPythonEnv =
              pythonLibs:
              python.buildEnv.override {
                extraLibs = pythonLibs python.pkgs;
                ignoreCollisions = true;
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
                project_root="$PWD"
                user_data_dir="$project_root/.vscode/user-data"
                mkdir -p "$user_data_dir"

                if [ "$#" -eq 0 ]; then
                  set -- "$project_root"
                fi

                exec ${vscodeWithExtensions}/bin/code \
                  --user-data-dir "$user_data_dir" \
                  "$@"
              '';
            mkWorkspaceShell =
              {
                pythonLibs ? (
                  ps: [
                    packages.cadquery
                    packages.ocp-vscode
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
                pythonEnv = mkPythonEnv pythonLibs;
                workspaceSettings = pkgs.writeText "settings.json" (builtins.toJSON (
                  {
                    "python.defaultInterpreterPath" = "${pythonEnv}/bin/python";
                    "python.useEnvironmentsExtension" = false;
                    "terminal.integrated.defaultProfile.linux" = "nix-cqcode bash";
                    "terminal.integrated.defaultProfile.osx" = "nix-cqcode bash";
                    "terminal.integrated.profiles.linux" = {
                      "nix-cqcode bash" = {
                        path = "${pkgs.bash}/bin/bash";
                        args = [ "-i" ];
                      };
                    };
                    "terminal.integrated.profiles.osx" = {
                      "nix-cqcode bash" = {
                        path = "${pkgs.bash}/bin/bash";
                        args = [ "-i" ];
                      };
                    };
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
                  mkdir -p .vscode/user-data/User
                  [ -e .vscode/settings.json ] || cp ${workspaceSettings} .vscode/settings.json
                  chmod -R u+w .vscode
                  echo "Use 'cqcode' to launch VS Code with the CadQuery setup."
                '' + resolvedShellHook;
              };
            packages = (import ./pkgs {
              inherit pkgs python mkPythonEnv;
            }) // {
              cqcode = mkCqcode { };
            };
            ocpCadViewerVersion = packages.ocp-vscode.version;
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
              inherit pkgs python system packages;
            };
            devShells =
              let
                defaultPythonEnv = mkPythonEnv (ps: [
                  packages.cadquery
                  packages.build123d
                  packages.ocp-vscode
                  ps.pip
                ]);
              in
              {
                default = pkgs.mkShell {
                  packages = [
                    defaultPythonEnv
                  ];
                };
                cqcode = mkWorkspaceShell { };
              };
          in
          {
            lib = {
              inherit mkCqcode mkWorkspaceShell;
              mkCqcodeShell = mkWorkspaceShell;
            };
            inherit packages devShells;
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
      templates.default = {
        path = ./template;
        description = "CadQuery and build123d project with nix-cqcode dev shell";
        welcomeText = ''
          Initialized a CadQuery project template.

          Run `nix develop`, then launch the editor with `cqcode`.
        '';
      };
    };
}
