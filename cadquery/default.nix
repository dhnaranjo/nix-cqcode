{
  python3Packages,
  fetchurl,
  multimethod,
  ocp,
}:
let
  version = "2.4.0";
in
python3Packages.buildPythonPackage {
  pname = "cadquery";
  inherit version;
  format = "wheel";
  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/af/19/3c2286e1bedc8ba2e9f916db1100e0275f2c202a279a6c7de8f11abe3156/cadquery-${version}-py3-none-any.whl";
    hash = "sha256-ZshlseXbIFuBpd3IUz1HQVdykSks8tyAsQSunjCFsZU=";
  };
  dontCheckRuntimeDeps = true;
  dependencies =
    (with python3Packages; [
      casadi
      ezdxf
      nlopt
      nptyping
      numpy
      path
      pyparsing
      typing-extensions
      typish
    ])
    ++ [
      multimethod
      ocp
    ];
  pythonImportsCheck = [ "cadquery" ];
}
