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
      devShells = nixpkgs.lib.mapAttrs (_: shells: {
        default = shells.vscode;
      }) nix-cadquery.devShells;
    };
}
