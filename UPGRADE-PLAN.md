# build123d 0.8.0 → 0.10.0 Upgrade Plan

## Context

Upgrading build123d from 0.8.0 to 0.10.0. This cascades into upgrading cadquery-ocp (7.7.2 → 7.8.x), which in turn requires upgrading cadquery (2.4.0 → 2.7.0) and ocpsvg (0.3.4 → 0.5.0). Decision: go to cadquery 2.7.0 (latest).

## Current State

| Package | Current Version | Target Version |
|---------|----------------|----------------|
| cadquery-ocp | 7.7.2 | 7.8.1.1.post1 |
| cadquery | 2.4.0 | 2.7.0 |
| build123d | 0.8.0 | 0.10.0 |
| ocpsvg | 0.3.4 | 0.5.0 |
| multimethod | 1.9.1 | 1.12 |
| py-lib3mf | 2.3.1 | replaced by lib3mf |

## Dependency Changes by Package

### cadquery-ocp 7.7.2 → 7.8.1.1.post1
- Pre-built wheel, no deps declared
- Wheel URL: `https://files.pythonhosted.org/packages/3a/98/7b81196dd990bfbbdeff7858db7d319dede6fef2fb6c153ede9eb409a9e9/cadquery_ocp-7.8.1.1.post1-cp312-cp312-macosx_11_0_arm64.whl`

### cadquery 2.4.0 → 2.7.0
- OCP requirement changes from `>=7.7,<7.8` to `>=7.8.1,<7.9`
- multimethod changes from `==1.9.1` to `>=1.11,<2.0`
- **Dropped:** nptyping, typish
- **Added:** trame, trame-vtk, trame-components, trame-vuetify, runtype, pyparsing, path
- **Changed:** ezdxf `>=1.3.0`, nlopt `>=2.9.0,<3.0`
- Source build from GitHub (existing pattern)

### build123d 0.8.0 → 0.10.0
- OCP requirement stays `>=7.8,<7.9`
- **Dropped:** py-lib3mf
- **Added:** lib3mf (≥2.4.1), ocp-gordon (≥0.1.17), sympy, scipy, webcolors (~=24.8.0)
- ocpsvg tightened to `>=0.5,<0.6`
- ipython upper bound raised to `<10`

### ocpsvg 0.3.4 → 0.5.0
- OCP requirement changes to `>=7.8.1,<7.9.0`
- svgelements stays `>=1.9.1,<2`
- No other dep changes

### multimethod 1.9.1 → 1.12
- Pure Python wheel, no deps

## New Packages to Create

### Needed for build123d 0.10.0

| Package | Version | In nixpkgs? | Notes |
|---------|---------|-------------|-------|
| ocp-gordon | 0.1.18 | No | Pure Python wheel. Deps: cadquery-ocp >=7.8,<7.9, numpy >=2, scipy |
| lib3mf | 2.4.1+ | C lib only (2.4.1) | Python wheel exists on PyPI (`py3-none-macosx_10_9_universal2`). Replaces py-lib3mf |
| sympy | 1.14.0 | **Yes** (python312) | Use from nixpkgs |
| scipy | 1.17.0 | **Yes** (python312) | Use from nixpkgs |
| webcolors | 25.10.0 | **Yes** (python312) | nixpkgs has 25.10.0; build123d wants ~=24.8.0 but dontCheckRuntimeDeps bypasses this |

### Needed for cadquery 2.7.0

| Package | Version | In nixpkgs? | Notes |
|---------|---------|-------------|-------|
| trame-common | 1.1.3 | No | Pure Python, zero deps |
| trame-client | 3.11.4 | No | Pure Python, depends on trame-common |
| trame-server | 3.10.0 | No | Pure Python, depends on wslink + more-itertools |
| trame | 3.12.0 | No | Pure Python, depends on trame-server, trame-client, trame-common, wslink, pyyaml |
| trame-vtk | 2.11.6 | No | Pure Python, depends on trame-client |
| trame-components | 2.5.0 | No | Pure Python, depends on trame-client |
| trame-vuetify | 3.2.1 | No | Pure Python, depends on trame-client |
| runtype | 0.5.3 | No | Pure Python, zero deps |
| pyparsing | — | **Yes** (python312) | Use from nixpkgs |
| path | — | **Yes** (python312, v17.1.1) | Use from nixpkgs |
| nlopt | — | **Yes** (python312, v2.10.1) | Already used, version satisfies >=2.9.0 |
| casadi | — | **Yes** (python312, v3.7.2) | Already used |
| wslink | — | **Yes?** | Needs verification — exists in nixpkgs search but eval untested |
| more-itertools | — | **Yes** | Standard nixpkgs package |
| multimethod | 1.12 | No (nixpkgs has 2.0.2) | Too new in nixpkgs; keep custom package, bump to 1.12 |

### Packages to Remove
| Package | Reason |
|---------|--------|
| py-lib3mf | Replaced by lib3mf in build123d 0.10.0 |

## Upgrade Steps (smallest reasonable increments)

### Step 1: Leaf packages (no cascading effects)
- Update `multimethod/` 1.9.1 → 1.12 (new wheel URL+hash)
- Create `runtype/default.nix` (0.5.3, pure Python wheel, zero deps)
- Create `lib3mf/default.nix` (≥2.4.1, platform wheel, replaces py-lib3mf)
- **Verify:** `nix build .#multimethod`, `nix build .#runtype`, `nix build .#lib3mf`

### Step 2: trame ecosystem
- Create `trame-common/default.nix` (1.1.3, zero deps)
- Create `trame-client/default.nix` (3.11.4, depends on trame-common)
- Create `trame-server/default.nix` (3.10.0, depends on wslink + more-itertools from nixpkgs)
- Create `trame/default.nix` (3.12.0, depends on trame-server, trame-client, trame-common, wslink, pyyaml)
- Create `trame-vtk/default.nix` (2.11.6, depends on trame-client)
- Create `trame-components/default.nix` (2.5.0, depends on trame-client)
- Create `trame-vuetify/default.nix` (3.2.1, depends on trame-client)
- **Verify:** `nix build .#trame`, `nix build .#trame-vtk`, etc.

### Step 3: Add OCP 7.8 alongside existing 7.7
- Create `ocp-7.8/default.nix` for cadquery-ocp 7.8.1.1.post1 (new wheel, same pattern as `ocp/`)
- Add `ocp-7_8` to `flake.nix` packages (keep existing `ocp` as 7.7.2)
- **Verify:** `nix build .#ocp-7_8`

### Step 4: Packages depending on new OCP (using ocp-7_8)
- Create `ocpsvg-0.5/default.nix` for ocpsvg 0.5.0 (depends on ocp-7_8)
- Create `ocp-gordon/default.nix` (0.1.18, depends on ocp-7_8 + numpy + scipy from nixpkgs)
- Wire into `flake.nix` with ocp-7_8 passed through
- **Verify:** `nix build .#ocpsvg-0_5`, `nix build .#ocp-gordon`
- Existing cadquery, build123d, ocpsvg all remain working on OCP 7.7.2

### Step 5: cadquery upgrade
- Update `cadquery/default.nix` 2.4.0 → 2.7.0
  - Update fetchFromGitHub rev + hash
  - Update deps: drop nptyping/typish, add runtype/pyparsing/path/trame/trame-vtk/trame-components/trame-vuetify
  - Switch from `ocp` to `ocp-7_8` in flake.nix
  - Update multimethod passed through flake
  - Adjust deselected tests if needed
- Wire new packages into `flake.nix` (trame ecosystem, runtype passed to cadquery)
- **Verify:** `nix build .#cadquery`

### Step 6: build123d upgrade
- Update `build123d/default.nix` 0.8.0 → 0.10.0
  - New wheel URL+hash
  - Switch from `ocp` to `ocp-7_8`, from `ocpsvg` to `ocpsvg-0_5` in flake.nix
  - Drop py-lib3mf, add lib3mf, ocp-gordon, sympy, scipy, webcolors
- Wire new deps in `flake.nix`
- **Verify:** `nix build .#build123d`

### Step 7: ocp-tessellate / ocp-vscode
- Switch ocp-tessellate to use ocp-7_8 in flake.nix
- Check if ocp-tessellate 3.1.2 still works with OCP 7.8.x (it doesn't declare an OCP version pin)
- Update if needed
- **Verify:** `nix build .#ocp-vscode`, `nix develop` (full dev shell)

### Step 8: Clean up old OCP 7.7
- Remove `ocp/default.nix` (7.7.2)
- Rename `ocp-7.8/default.nix` → `ocp/default.nix`
- Remove `ocpsvg/default.nix` (0.3.4)
- Rename `ocpsvg-0.5/default.nix` → `ocpsvg/default.nix`
- Remove `py-lib3mf/` directory
- Update all references in `flake.nix` back to `ocp` / `ocpsvg`
- **Verify:** `nix build .#cadquery`, `nix build .#build123d`, `nix build .#ocp-vscode`, `nix develop`

## Files Modified

| File | Action |
|------|--------|
| `flake.nix` | Add new package declarations, wire deps |
| `ocp/default.nix` | Version bump |
| `cadquery/default.nix` | Version bump + dep changes |
| `build123d/default.nix` | Version bump + dep changes |
| `ocpsvg/default.nix` | Version bump |
| `multimethod/default.nix` | Version bump |
| `py-lib3mf/default.nix` | **Delete** |
| `lib3mf/default.nix` | **Create** |
| `ocp-gordon/default.nix` | **Create** |
| `runtype/default.nix` | **Create** |
| `trame-common/default.nix` | **Create** |
| `trame-client/default.nix` | **Create** |
| `trame-server/default.nix` | **Create** |
| `trame/default.nix` | **Create** |
| `trame-vtk/default.nix` | **Create** |
| `trame-components/default.nix` | **Create** |
| `trame-vuetify/default.nix` | **Create** |

## Risks / Open Questions

- **webcolors version mismatch:** nixpkgs has 25.10.0, build123d wants ~=24.8.0. Works with `dontCheckRuntimeDeps` but may have runtime incompatibilities.
- **wslink in nixpkgs:** Needs confirmation it's available as `python312Packages.wslink` (search found it but eval was not completed).
- **cadquery tests:** The 16 currently-deselected tests may change with 2.7.0; test suite may need re-evaluation.
- **ocp-tessellate/ocp-vscode:** No declared OCP version pin but may break at runtime with 7.8.x.
- **trame at runtime:** cadquery 2.7.0 imports trame — if it needs a running server or VTK, it may fail import checks even though it's optional for headless use.
