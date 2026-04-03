{
  python3Packages,
  fetchurl,
}:
let
  version = "2.5.0";
in
python3Packages.buildPythonPackage {
  pname = "lib3mf";
  inherit version;
  format = "wheel";
  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/04/87/47504d69f0f36841670d12ce3fe1668025bad74d83ed361ead378f626fed/lib3mf-${version}-py3-none-macosx_10_9_universal2.whl";
    hash = "sha256-99xX6iIhT6ktrHKLpm5YxLJLd11GeIgmKoIDONfYQUU=";
  };
  pythonImportsCheck = [ "lib3mf" ];
}
