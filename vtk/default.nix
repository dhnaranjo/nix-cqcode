{
  python3Packages,
  fetchurl,
}:
let
  version = "9.3.1";
in
python3Packages.buildPythonPackage {
  pname = "vtk";
  inherit version;
  format = "wheel";
  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/8e/75/c637c620d23ccecb8ddf58fdb80af1dc56ecdd60f3e018c55e041663398b/vtk-${version}-cp312-cp312-macosx_11_0_arm64.whl";
    hash = "sha256-vb77Gu+VmaCguCIslYLyaUZzKpNTTm7DfUuOLFJMYn4=";
  };
  dependencies = with python3Packages; [ matplotlib ];
  dontCheckRuntimeDeps = true;
  # Import check requires a display/OpenGL context; skip it
  doInstallCheck = false;
}
