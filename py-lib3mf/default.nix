{
  python3Packages,
  fetchurl,
}:
let
  version = "2.3.1";
in
python3Packages.buildPythonPackage {
  pname = "py-lib3mf";
  inherit version;
  format = "wheel";
  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/8e/39/74a0871fb2f5d04be50ac83c872a872e5ad8c8c6baaac9482ba5ddc8719d/py_lib3mf-${version}-py3-none-any.whl";
    hash = "sha256-hqhw7zht67qbdGg9OggSWjTBU6qmXpZ/YWd8xaCmXiQ=";
  };
  pythonImportsCheck = [ "py_lib3mf" ];
}
