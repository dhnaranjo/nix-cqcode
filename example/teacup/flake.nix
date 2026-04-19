{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    nix-cadquery.url = "path:../..";
    nix-cadquery.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-cadquery,
    }:
    let
      system = "aarch64-darwin";
      pkgs = import nixpkgs { inherit system; };
      python = pkgs.python312;
      pythonEnv = python.buildEnv.override {
        extraLibs = [
          nix-cadquery.packages.${system}.cadquery
          nix-cadquery.packages.${system}.ocp-vscode
          python.pkgs.pip
        ];
        ignoreCollisions = true;
      };

      workspaceSettings = pkgs.writeText "settings.json" (builtins.toJSON {
        "python.defaultInterpreterPath" = "${pythonEnv}/bin/python";
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
      devShells.${system}.default = pkgs.mkShell {
        packages = [
          pythonEnv
          pkgs.nodejs_22
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
