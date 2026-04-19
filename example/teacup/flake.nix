{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    nix-cadquery.url = "path:../..";
    nix-cadquery.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      nix-cadquery,
      nixpkgs,
      self,
    }:
    {
      devShells = nix-cadquery.lib.mkCqShell {
        extraPythonPackages = { python, ... }: [
          python.pkgs.numpy
        ];
        extraExtensions = { pkgs, ... }: [
          pkgs.vscode-extensions.jnoortheen.nix-ide
        ];
      };
    };
}
