{
  python3Packages,
  fetchurl,
}:
let
  version = "2.10.0";
in
python3Packages.buildPythonPackage {
  pname = "nlopt";
  inherit version;
  format = "wheel";
  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/a4/39/76558756c758962fcf2c6f8450384e43a8e65cb8dfbb8a93d40014b09b3a/nlopt-${version}-cp312-cp312-macosx_11_0_arm64.whl";
    hash = "sha256-Geel3YI+qx0Wek+y89oTl4uZcCnJteYWTTPHR/x+xUI=";
  };
  dependencies = [ python3Packages.numpy ];
  pythonImportsCheck = [ "nlopt" ];
}
