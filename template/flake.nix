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
        # Add Python packages to the default CadQuery environment.
        extraPythonPackages = { python, packages, ... }: [
          python.pkgs.numpy
          # python.pkgs.scipy
          # packages.build123d
        ];

        extraExtensions = { pkgs, ... }: [
          pkgs.vscode-extensions.jnoortheen.nix-ide
        ];

        # Standard mkShell options are passed through as well.
        extraPackages = { pkgs, ... }: [
          pkgs.git
          # pkgs.ruff
        ];

        shellHook = ''
          echo "CadQuery workspace ready."
        '';
      };
    };
}
