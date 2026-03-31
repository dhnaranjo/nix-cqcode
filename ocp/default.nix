{
  python3Packages,
  fetchurl,
}:
let
  version = "7.7.2";
in
python3Packages.buildPythonPackage {
  pname = "cadquery-ocp";
  inherit version;
  format = "wheel";
  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/9b/15/f738b679609071932395138925eb97358c36eebf6433ac2596e9b7f7a2cf/cadquery_ocp-${version}-cp312-cp312-macosx_11_0_arm64.whl";
    hash = "sha256-Uf+81tNW1PDC5fnhWBImEhzXMP5FIeq6wF6dceakP28=";
  };
  pythonImportsCheck = [ "OCP" ];
}
