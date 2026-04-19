{
  python3Packages,
  fetchurl,
  trame-client,
}:
let
  version = "2.5.0";
in
python3Packages.buildPythonPackage {
  pname = "trame-components";
  inherit version;
  format = "wheel";
  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/02/e9/627ebbf56e00d80300940e8bbf54c6594f98fd214e3565b3abaa5450e0d4/trame_components-${version}-py3-none-any.whl";
    hash = "sha256-iXpsDrzHLZWkYb3ijSwuN8S8SSIBOtB986ZeZNSIRnI=";
  };
  dependencies = [ trame-client ];
  pythonImportsCheck = [ "trame_components" ];
}
