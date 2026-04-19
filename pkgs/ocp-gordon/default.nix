{
  python3Packages,
  fetchurl,
  ocp,
}:
let
  version = "0.1.18";
in
python3Packages.buildPythonPackage {
  pname = "ocp-gordon";
  inherit version;
  format = "wheel";
  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/11/d7/d1b417bcfaf5e3a384a31d22572ae59e5993ede684424f9d5c97a2d9a831/ocp_gordon-${version}-py3-none-any.whl";
    hash = "sha256-voWlSmgut9k3ejRe4ltRoj26vXToX8KdwC7unhs8HwU=";
  };
  dependencies = [
    ocp
    python3Packages.numpy
    python3Packages.scipy
  ];
  dontCheckRuntimeDeps = true;
}
