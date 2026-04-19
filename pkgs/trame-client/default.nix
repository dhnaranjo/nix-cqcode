{
  python3Packages,
  fetchurl,
  trame-common,
}:
let
  version = "3.11.4";
in
python3Packages.buildPythonPackage {
  pname = "trame-client";
  inherit version;
  format = "wheel";
  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/64/ba/fe836f9ea0407ab85ae39c2ed322b5eb6841a975975cc1be0bc9b760925f/trame_client-${version}-py3-none-any.whl";
    hash = "sha256-rcQVgjdKUXe7wWiHgrfXsOFhwDzBA8j69hTVMgFLDSw=";
  };
  dependencies = [ trame-common ];
  pythonImportsCheck = [ "trame_client" ];
}
