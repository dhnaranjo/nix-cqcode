# nix-cqcode

`nix-cqcode` is a Nix flake for reproducible CadQuery and build123d project workspaces, with a project-specific `cqcode` launcher wrapping an isolated VS Code.

## What? Why?

I use Nix, I like it. Getting CadQuery working on Nix is pretty complex on x86_64-linux, thanks [vinszent/cq-flake](https://github.com/vinszent/cq-flake), and straight up not possible on Apple Silicon when I started this project, good effort [n8henrie/nix-cadquery](https://github.com/n8henrie/nix-cadquery). This flake enables creating a cross-platform dev environment for your modeling project that will keep working. That's neat!

## What it provides

- A pinned Python package set for CadQuery, build123d, and related dependencies
- A `cqcode` launcher that opens VS Code with https://github.com/bernhard-42/vscode-ocp-cad-viewer extension.
- Project-local VS Code user data under `.vscode/user-data`, separate from your normal VS Code user profile

Current pinned core package versions:

- OCP `7.8.1.1.post1`
- CadQuery `2.7.0`
- build123d `0.10.0`

## Quick start

Initialize a new modeling project from the flake template:

```sh
mkdir my-model
cd my-model
nix flake init -t github:dhnaranjo/nix-cqcode
```

Then enter the shell and launch the editor:

```sh
nix develop
cqcode
```

The template creates a `flake.nix` wired to `nix-cqcode`.

If you already have your own flake-based project, see `example/teacup/flake.nix` for the minimal manual setup.

## Editor behavior

`cqcode` launches this flake's `vscode-with-extensions` build, not your system VS Code.

It stores VS Code user data in `.vscode/user-data`, separate from your normal user profile.

## Customization

You can add extra Python packages through `extraPythonPackages`. Those are appended to the default CadQuery shell environment, so users can pull in anything already packaged in Nixpkgs without redefining the whole Python environment:

```nix
{
  devShells = nix-cqcode.lib.mkCqShell {
    extraPythonPackages = { python, packages, ... }: [
      python.pkgs.numpy
      python.pkgs.scipy
      packages.build123d
    ];
  };
}
```

You can add extra VS Code extensions through `extraExtensions`. Those are passed to the underlying `pkgs.vscode-with-extensions` build; use Nixpkgs/NixOS package sources for extension selection, for example the `vscode-extensions` search: <https://search.nixos.org/packages?channel=unstable&query=vscode-extensions>.

The shell helpers also support `extraPackages` and `shellHook`. Those are just the usual `pkgs.mkShell` knobs, not custom `nix-cqcode` features. See the Nixpkgs manual's development shell helpers section: <https://nixos.org/manual/nixpkgs/stable/#sec-pkgs-mkShell>.

Required VS Code workspace settings are managed by the base flake. On shell entry, those required keys are merged into `.vscode/settings.json`, while any other existing workspace settings are preserved.

## License

MIT. See [LICENSE](LICENSE).

## Thanks

This repo was initially cloned from [n8henrie/nix-cadquery](https://github.com/n8henrie/nix-cadquery). Good lookin' out.
