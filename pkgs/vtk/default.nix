{
  stdenv,
  python3Packages,
  fetchurl,
}:
let
  version = "9.3.1";
  system = stdenv.hostPlatform.system;
  wheel =
    if system == "aarch64-darwin" then
      {
        url = "https://files.pythonhosted.org/packages/8e/75/c637c620d23ccecb8ddf58fdb80af1dc56ecdd60f3e018c55e041663398b/vtk-${version}-cp312-cp312-macosx_11_0_arm64.whl";
        hash = "sha256-vb77Gu+VmaCguCIslYLyaUZzKpNTTm7DfUuOLFJMYn4=";
      }
    else if system == "x86_64-darwin" then
      {
        url = "https://files.pythonhosted.org/packages/6f/ba/1571d61013f3f5778c11741d5de19db197b437d1a52215560f016662597b/vtk-${version}-cp312-cp312-macosx_10_10_x86_64.whl";
        hash = "sha256-BaS244epBujI1oREQfkgARbpNwab/IF0PiYA8m6wRt4=";
      }
    else if system == "x86_64-linux" then
      {
        url = "https://files.pythonhosted.org/packages/01/ee/730d57c6d7353c1afb919ceedfac387a190ccb92e611c4b14f88e6f39066/vtk-${version}-cp312-cp312-manylinux_2_17_x86_64.manylinux2014_x86_64.whl";
        hash = "sha256-9yi7YfQ/z4UNYiztOz1RszEW92hlyk5OB3b2JOLSMH0=";
      }
    else
      throw "vtk: unsupported system ${system}; add platform-specific wheel metadata";
in
python3Packages.buildPythonPackage {
  pname = "vtk";
  inherit version;
  format = "wheel";
  src = fetchurl {
    inherit (wheel) url hash;
  };
  dependencies = with python3Packages; [ matplotlib ];
  dontCheckRuntimeDeps = true;
  # Import check requires a display/OpenGL context; skip it
  doInstallCheck = false;
}
