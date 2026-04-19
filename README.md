# nix-cqcode

`nix-cqcode` is a Nix flake for reproducible CadQuery and build123d project workspaces, with a project-specific `cqcode` launcher wrapping an isolated VS Code.

## What? Why?

I use Nix, I like it. Getting CadQuery working on Nix is pretty complex on x86_64-linux (ref: https://github.com/vinszent/cq-flake) and straight up not possible on Apple Silicon when I started this project (good effort: https://github.com/n8henrie/nix-cadquery). This flake enables creating a cross-platform dev environment for your modeling project that will keep working. That's neat!

## What it provides

- A pinned Python package set for CadQuery, build123d, and related dependencies
- A `cqcode` launcher that opens VS Code with https://github.com/bernhard-42/vscode-ocp-cad-viewer extension.
- Project-local VS Code user data under `.vscode/user-data`, separate from your normal VS Code user profile

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

The template creates a `flake.nix` wired to `nix-cqcode` and ignores `.vscode/`.

If you already have your own flake-based project, see `example/teacup/flake.nix` for the minimal manual setup.

## Editor behavior

`cqcode` launches this flake's `vscode-with-extensions` build, not your system VS Code.

It stores VS Code user data in `.vscode/user-data`, separate from your normal user profile.

In the example project, `.vscode/` is ignored.

## Customization

You can add extra VS Code extensions through `extraExtensions`.

The shell helpers also support extra packages and shell hooks.

Required VS Code workspace settings are managed by the base flake. On shell entry, those required keys are merged into `.vscode/settings.json`, while any other existing workspace settings are preserved.

## TODO

- Extra Python packages
- Version upgrade helpers

## Thanks

This repo was initially cloned from [n8henrie/nix-cadquery](https://github.com/n8henrie/nix-cadquery). Good lookin' out.
