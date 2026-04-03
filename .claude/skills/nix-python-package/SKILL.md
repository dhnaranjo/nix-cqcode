---
name: nix-python-package
description: Finds or creates a Nix package for a Python library and version. Use when user says to "Package the Python lib $name $version, or to resolve dependencies when packaging another.
compatibility: `nix`, `nix-init`, `nix-search`
---

# Nix Python Package


Steps:
1. Check if the library is already packaged in nixpkgs using `nix-search`. If so, use it.
2. If not in nixpkgs, check if the package is distributed as a wheel. If so, use it, providing wheels for both x86_64 and darwin arch.
3. If no wheel exists, use `nix-init` to create an initial nix package. Verify the package works.
Result: A Nix package of the target library and version, functional on PCs and Macs.