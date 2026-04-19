{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nix-cqcode.url = "github:dhnaranjo/nix-cqcode";
    # Uncomment and replace FAKECOMMIT with the nix-cqcode commit you want to pin.
    # nix-cqcode.url = "github:dhnaranjo/nix-cqcode/FAKECOMMIT";
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
