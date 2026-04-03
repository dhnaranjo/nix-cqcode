{
  python3Packages,
  fetchurl,
  multimethod,
  ocp,
  runtype,
  trame,
  trame-vtk,
  trame-components,
  trame-vuetify,
}:
let
  version = "2.7.0";
in
python3Packages.buildPythonPackage {
  pname = "cadquery";
  inherit version;
  format = "wheel";
  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/85/46/2544f1d16a912770ecfed25602a273ab0ad4648838decf974781a8f83b78/cadquery-${version}-py3-none-any.whl";
    hash = "sha256-E73/46HJp7KdhtQzEwIRc7FiD0UiOSnSYxz41MXb4sA=";
  };
  dontCheckRuntimeDeps = true;
  dependencies =
    (with python3Packages; [
      casadi
      ezdxf
      nlopt
      numpy
      path
      pyparsing
      typing-extensions
    ])
    ++ [
      multimethod
      ocp
      runtype
      trame
      trame-vtk
      trame-components
      trame-vuetify
    ];
}
