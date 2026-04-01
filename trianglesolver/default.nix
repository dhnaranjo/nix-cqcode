{
  python3Packages,
  fetchurl,
}:
let
  version = "1.2";
in
python3Packages.buildPythonPackage {
  pname = "trianglesolver";
  inherit version;
  format = "wheel";
  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/ff/8e/43d45cf3e18e3f455e4b5ab333a7c27b8e38c4e535f7346b7148ce08eb65/trianglesolver-${version}-py3-none-any.whl";
    hash = "sha256-qgkDw3CLTitJbwbUkMrnLG/2J0sA0e3OQg/Po7K3ZoI=";
  };
  pythonImportsCheck = [ "trianglesolver" ];
}
