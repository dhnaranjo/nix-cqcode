{
  python3Packages,
  fetchurl,
  trame-server,
  trame-client,
  trame-common,
}:
let
  version = "3.12.0";
in
python3Packages.buildPythonPackage {
  pname = "trame";
  inherit version;
  format = "wheel";
  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/70/15/5869b2c7556fce52306b6b65b06ec7c088f063b865cdfa75ad30bc229b7c/trame-${version}-py3-none-any.whl";
    hash = "sha256-mzMCBiXg0XENBgwPq+ezvg4xteUThDnsmnlvr2/paRU=";
  };
  dependencies =
    [
      trame-server
      trame-client
      trame-common
    ]
    ++ (with python3Packages; [
      wslink
      pyyaml
    ]);
  dontCheckRuntimeDeps = true;
  pythonImportsCheck = [ "trame" ];
}
