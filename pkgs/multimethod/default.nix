{
  python3Packages,
  fetchurl,
}:
let
  version = "1.12";
in
python3Packages.buildPythonPackage {
  pname = "multimethod";
  inherit version;
  format = "wheel";
  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/af/98/cff14d53a2f2f67d7fe8a4e235a383ee71aba6a1da12aeea24b325d0c72a/multimethod-${version}-py3-none-any.whl";
    hash = "sha256-/QxHPENViQjZfMBuTWjo9pIC8WfbRve05AWIk+fb32A=";
  };
  pythonImportsCheck = [ "multimethod" ];
}
