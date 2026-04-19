{
  python3Packages,
  fetchurl,
  trame-client,
}:
let
  version = "3.2.1";
in
python3Packages.buildPythonPackage {
  pname = "trame-vuetify";
  inherit version;
  format = "wheel";
  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/ec/73/08e61712de488fddca38bced13968f2c0fc74bc16e1034c21254246e8528/trame_vuetify-${version}-py3-none-any.whl";
    hash = "sha256-RSObmXK8+48SFIfv5/U3wNxEF0qHU1u9ITGpyG5AU78=";
  };
  dependencies = [ trame-client ];
  pythonImportsCheck = [ "trame_vuetify" ];
}
