{
  python3Packages,
  fetchurl,
}:
let
  version = "3.10.0";
in
python3Packages.buildPythonPackage {
  pname = "trame-server";
  inherit version;
  format = "wheel";
  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/56/3a/d895d2069c9bf9288efde97aaa22845d3c711a7af031605863ac4019b7fc/trame_server-${version}-py3-none-any.whl";
    hash = "sha256-6ygva8b6j9uyxluObSLgiKJ7Vv4LehLwfPLZ6lRr2TU=";
  };
  dependencies = with python3Packages; [
    wslink
    more-itertools
  ];
  dontCheckRuntimeDeps = true;
  pythonImportsCheck = [ "trame_server" ];
}
