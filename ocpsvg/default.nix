{
  python3Packages,
  fetchurl,
  ocp,
}:
let
  version = "0.3.4";
in
python3Packages.buildPythonPackage {
  pname = "ocpsvg";
  inherit version;
  format = "wheel";
  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/48/e1/31bf08ca47659d0d7372f26a6cca60a542333e74413f89430a83b9e45a87/ocpsvg-${version}-py3-none-any.whl";
    hash = "sha256-+Z4zFkUbLDSnFr0n7YIqLUjb+dBA9ojvxRUqxH/IAko=";
  };
  dependencies = [
    ocp
    python3Packages.svgelements
  ];
  pythonImportsCheck = [ "ocpsvg" ];
}
