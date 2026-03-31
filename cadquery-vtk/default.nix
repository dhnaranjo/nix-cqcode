{
  python3Packages,
  fetchurl,
}:
let
  version = "9.3.1";
in
python3Packages.buildPythonPackage {
  pname = "cadquery-vtk";
  inherit version;
  format = "wheel";
  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/d1/34/4d0329c459c1e4f332c1e71790c4584c0bff042cf74e589e81a9995cb2c3/cadquery_vtk-${version}-cp313-cp313-macosx_11_0_arm64.whl";
    hash = "sha256-G4aS6Z0N5aK0SSE/XLcdkw5F9ZsAYT5wMHW6UItOt9g=";
  };
  pythonImportsCheck = [ "vtkmodules" ];
}
