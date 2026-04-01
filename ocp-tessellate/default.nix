{
  python3Packages,
  fetchurl,
  ocp,
}:
let
  version = "3.1.2";
in
python3Packages.buildPythonPackage {
  pname = "ocp-tessellate";
  inherit version;
  format = "wheel";
  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/85/a4/837da6d08faa848db79745c150177785ee55fd878455b923e8da5b9e8e3d/ocp_tessellate-${version}-py3-none-any.whl";
    hash = "sha256-O6FO9gNEE7sm6NiCTRLw2iCsK29XnBHQU+hw7bKF6lw=";
  };
  dontCheckRuntimeDeps = true;
  dependencies = [
    ocp
    python3Packages.webcolors
    python3Packages.numpy
    python3Packages.cachetools
    python3Packages.imagesize
  ];
  pythonImportsCheck = [ "ocp_tessellate" ];
}
