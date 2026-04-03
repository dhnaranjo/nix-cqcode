{
  python3Packages,
  fetchurl,
  ocp,
  ocpsvg,
  lib3mf,
  ocp-gordon,
  trianglesolver,
}:
let
  version = "0.10.0";
in
python3Packages.buildPythonPackage {
  pname = "build123d";
  inherit version;
  format = "wheel";
  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/f3/5a/0fe9cc610a6d07eaaddd80629a49ea18ecf9acefb81c6788a854f0dea224/build123d-${version}-py3-none-any.whl";
    hash = "sha256-WJ85ex3HyFyZNqp7LuOZRswiahIeFKYhtnSSY6rl7X0=";
  };
  dontCheckRuntimeDeps = true;
  dependencies = [
    ocp
    ocpsvg
    lib3mf
    ocp-gordon
    trianglesolver
    python3Packages.typing-extensions
    python3Packages.numpy
    python3Packages.svgpathtools
    python3Packages.anytree
    python3Packages.ezdxf
    python3Packages.ipython
    python3Packages.sympy
    python3Packages.scipy
    python3Packages.webcolors
  ];
}
