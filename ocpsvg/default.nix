{
  python3Packages,
  fetchurl,
  ocp,
}:
let
  version = "0.5.0";
in
python3Packages.buildPythonPackage {
  pname = "ocpsvg";
  inherit version;
  format = "wheel";
  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/e1/7b/0cf408c8c2bdf10685a284253e0004e6c672a9dbd23070d0889f4b54b284/ocpsvg-${version}-py3-none-any.whl";
    hash = "sha256-aMr9w9aBoXB1MDYLry1Rz9WEFLfUOfQur70x6ELPKV4=";
  };
  dependencies = [
    ocp
    python3Packages.svgelements
  ];
  dontCheckRuntimeDeps = true;
}
