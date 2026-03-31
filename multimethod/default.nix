{
  python3Packages,
  fetchurl,
}:
let
  version = "1.9.1";
in
python3Packages.buildPythonPackage {
  pname = "multimethod";
  inherit version;
  format = "wheel";
  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/21/91/01ec16d3d0cadb499b83e6f6435c63e43f3c122c146d82a4eb9575169817/multimethod-${version}-py3-none-any.whl";
    hash = "sha256-Uvjx8rnVpMet/cwRTb7uvjJFpEIIAeiAfiZSKnn7a8I=";
  };
  pythonImportsCheck = [ "multimethod" ];
}
