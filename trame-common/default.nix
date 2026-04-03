{
  python3Packages,
  fetchurl,
}:
let
  version = "1.1.3";
in
python3Packages.buildPythonPackage {
  pname = "trame-common";
  inherit version;
  format = "wheel";
  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/c6/40/bf161cf981eebf94bffbe9c23f4b35bf592b44d20b47d734258a17f1729c/trame_common-${version}-py3-none-any.whl";
    hash = "sha256-jZPNoyz+qGmqq67F2R3tNpiCsefyjA26KhAaeJbPpbI=";
  };
  pythonImportsCheck = [ "trame_common" ];
}
