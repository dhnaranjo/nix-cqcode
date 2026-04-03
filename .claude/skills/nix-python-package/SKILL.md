---
name: nix-python-package
description: Package a Python library for Nix. Use when asked to "package <lib> <version>" or when resolving a missing dependency while packaging another Python library.
argument-hint: <library-name> [version] [output-path]
allowed-tools: Bash(nix-search *) Bash(nix-init *) Bash(nix *) Bash(curl *) Bash(jq *) Read Glob Write Edit
model: haiku
effort: medium
context: fork
---

# Nix Python Package

Package `$ARGUMENTS` for Nix. Arguments: `<library-name> [version] <output-path>`.

The `output-path` is the full path to write the `default.nix` to (e.g. `/repo/nptyping/default.nix`), provided by the caller. The parent directory of `output-path` is the packages root — you may create new subdirectories there when packaging dependencies recursively. **Never edit existing files outside directories you created in this session.**

## Steps

1. **Search nixpkgs** — run `nix-search --name $ARGUMENTS` (or `nix-search $ARGUMENTS` for a broader search). If a suitable version exists, use it directly. Done.

2. **Check for wheels** — fetch the PyPI JSON and filter for wheels:
   ```bash
   # Latest version
   curl -s https://pypi.org/pypi/$ARGUMENTS/json | jq '[.urls[] | select(.packagetype=="bdist_wheel") | .filename]'
   # Specific version (if provided as second argument)
   curl -s https://pypi.org/pypi/$ARGUMENTS/json | jq '[.urls[] | select(.packagetype=="bdist_wheel") | .filename]'
   ```
   Use `buildPythonPackage` with `format = "wheel"` **only if** wheels exist covering both required arches:
   - Linux: filename contains `linux_x86_64` or `none-any`
   - Mac: filename contains `macosx` + `arm64`, or `none-any`

   A `none-any` wheel covers all platforms.

3. **Source build** — if no wheel covers both arches, run `nix-init` in headless mode:
   ```bash
   nix-init --url https://pypi.org/project/$ARGUMENTS/ --builder buildPythonPackage --headless <output-path>
   ```
   Review and fix any build errors using the Edit tool.

4. **Verify** — run `nix build` on the package. Confirm `python -c "import $ARGUMENTS"` succeeds in the resulting environment.

## Constraints

- Write to `output-path` and, if needed, new sibling directories for dependencies. Never edit files that already exist outside directories you created in this session.
- Support only the latest Python version (no multi-version maps).
- Result must work on both x86_64-linux (PC) and aarch64-darwin (Mac).
- Always use `nix-init --headless` — interactive mode is not available in this environment.
- Requires `nix-init` to be installed. If `command not found`, stop and report this to the user before proceeding.
