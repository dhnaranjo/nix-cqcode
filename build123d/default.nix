{
  python3Packages,
  fetchurl,
  ocp,
  ocpsvg,
  py-lib3mf,
  trianglesolver,
}:
let
  version = "0.8.0";
in
python3Packages.buildPythonPackage {
  pname = "build123d";
  inherit version;
  format = "wheel";
  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/43/96/f29a26ac97080b2327ea59f6cabc136c89958e79923b147aab70c58e5395/build123d-${version}-py3-none-any.whl";
    hash = "sha256-Z2vgSMcLKntsOnxAIu3g9RNpuIq6E+TJZLYN34wA9QM=";
  };
  dontCheckRuntimeDeps = true;
  dependencies = [
    ocp
    ocpsvg
    py-lib3mf
    trianglesolver
    python3Packages.typing-extensions
    python3Packages.numpy
    python3Packages.svgpathtools
    python3Packages.anytree
    python3Packages.ezdxf
    python3Packages.ipython
  ];
  pythonImportsCheck = [ "build123d" ];
}
