{
  python3Packages,
  fetchurl,
  trame-client,
}:
let
  version = "2.11.6";
in
python3Packages.buildPythonPackage {
  pname = "trame-vtk";
  inherit version;
  format = "wheel";
  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/c9/65/ff0726e549961ded1ab590a6d791aabd1d132d734bd1890ca45a171d9078/trame_vtk-${version}-py3-none-any.whl";
    hash = "sha256-3gITlivpPt9zqM2dw2+4/ASiE0nKdpiwLDwOzEejVlI=";
  };
  dependencies = [ trame-client ];
  pythonImportsCheck = [ "trame_vtk" ];
}
