{ pkgs, python, mkPythonEnv }:
let
  overrides.python3Packages = python.pkgs;
  scope = pkgs.lib.makeScope pkgs.newScope (self: {
    default = self.cadquery;
    cadquery-env = mkPythonEnv (ps: [ self.cadquery ]);
    vtk = self.callPackage ./vtk overrides;
    multimethod = self.callPackage ./multimethod overrides;
    runtype = self.callPackage ./runtype overrides;
    lib3mf = self.callPackage ./lib3mf overrides;
    trianglesolver = self.callPackage ./trianglesolver overrides;
    trame-common = self.callPackage ./trame-common overrides;
    trame-server = self.callPackage ./trame-server overrides;

    ocp = self.callPackage ./ocp (
      overrides
      // pkgs.lib.optionalAttrs pkgs.stdenv.isDarwin {
        inherit (pkgs.darwin) autoSignDarwinBinariesHook;
      }
    );

    trame-client = self.callPackage ./trame-client overrides;
    trame = self.callPackage ./trame overrides;
    trame-vtk = self.callPackage ./trame-vtk overrides;
    trame-components = self.callPackage ./trame-components overrides;
    trame-vuetify = self.callPackage ./trame-vuetify overrides;

    ocpsvg = self.callPackage ./ocpsvg overrides;
    ocp-gordon = self.callPackage ./ocp-gordon overrides;
    build123d = self.callPackage ./build123d overrides;
    ocp-tessellate = self.callPackage ./ocp-tessellate overrides;
    ocp-vscode = self.callPackage ./ocp-vscode overrides;
    cadquery = self.callPackage ./cadquery overrides;
  });
in
pkgs.lib.removeAttrs scope [
  "newScope"
  "callPackage"
  "overrideScope"
  "packages"
]
