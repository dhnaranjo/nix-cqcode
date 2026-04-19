{
  python3Packages,
  fetchurl,
  vtk,
  darwin,
}:
let
  version = "7.8.1.1.post1";
in
python3Packages.buildPythonPackage {
  pname = "cadquery-ocp";
  inherit version;
  format = "wheel";
  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/3a/98/7b81196dd990bfbbdeff7858db7d319dede6fef2fb6c153ede9eb409a9e9/cadquery_ocp-7.8.1.1.post1-cp312-cp312-macosx_11_0_arm64.whl";
    hash = "sha256-ACLoVKOEDv1cf8FP6TN3JhN5R3fV6wVqR1TUSoa68Co=";
  };
  nativeBuildInputs = [ darwin.cctools darwin.autoSignDarwinBinariesHook ];
  dependencies = [ vtk ];
  dontCheckRuntimeDeps = true;
  postFixup = ''
    install_name_tool -add_rpath \
      ${vtk}/lib/python3.12/site-packages/vtkmodules/.dylibs \
      $out/lib/python3.12/site-packages/OCP/OCP.cpython-312-darwin.so
  '';
}
