{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    nix-cqcode.url = "github:dhnaranjo/nix-cqcode";
    nix-cqcode.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      nix-cqcode,
      nixpkgs,
      self,
    }:
    {
      devShells = nix-cqcode.lib.mkCqShell {
        extraExtensions = { pkgs, ... }: [
          pkgs.vscode-extensions.jnoortheen.nix-ide
        ];
      };
    };
}
