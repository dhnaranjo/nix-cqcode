{
  lib,
  stdenv,
  python3Packages,
  fetchurl,
  vtk,
  cctools ? null,
  autoSignDarwinBinariesHook ? null,
}:
let
  version = "7.8.1.1.post1";
  system = stdenv.hostPlatform.system;
  wheel =
    if system == "aarch64-darwin" then
      {
        url = "https://files.pythonhosted.org/packages/3a/98/7b81196dd990bfbbdeff7858db7d319dede6fef2fb6c153ede9eb409a9e9/cadquery_ocp-7.8.1.1.post1-cp312-cp312-macosx_11_0_arm64.whl";
        hash = "sha256-ACLoVKOEDv1cf8FP6TN3JhN5R3fV6wVqR1TUSoa68Co=";
        extensionSuffix = "darwin.so";
      }
    else if system == "x86_64-darwin" then
      {
        url = "https://files.pythonhosted.org/packages/b4/b3/aea4e4d84916b6a26bc3635a0aeaa3737b24671ac90c117e5779554eebbb/cadquery_ocp-7.8.1.1.post1-cp312-cp312-macosx_11_0_x86_64.whl";
        hash = "sha256-U9wkrtQCsq5SY0ops7F+nAHoV7isNLsQHU6Pp209x/c=";
        extensionSuffix = "darwin.so";
      }
    else if system == "x86_64-linux" then
      {
        url = "https://files.pythonhosted.org/packages/fa/3f/4b28aedbbb7c6cd5f1aa4e1d6e9a0f88d138941096a3d70f1878a406075f/cadquery_ocp-7.8.1.1.post1-cp312-cp312-manylinux_2_31_x86_64.whl";
        hash = "sha256-SIIHToZyIghRNXm6ruJGvk+xC9oi3CDRAcQVHzZCB7k=";
        extensionSuffix = "x86_64-linux-gnu.so";
      }
    else
      throw "cadquery-ocp: unsupported system ${system}; add platform-specific wheel metadata";
in
python3Packages.buildPythonPackage {
  pname = "cadquery-ocp";
  inherit version;
  format = "wheel";
  src = fetchurl {
    inherit (wheel) url hash;
  };
  nativeBuildInputs = lib.optionals stdenv.isDarwin (builtins.filter (x: x != null) [
    cctools
    autoSignDarwinBinariesHook
  ]);
  dependencies = [ vtk ];
  dontCheckRuntimeDeps = true;
  postFixup = lib.optionalString stdenv.isDarwin ''
    install_name_tool -add_rpath \
      ${vtk}/lib/python3.12/site-packages/vtkmodules/.dylibs \
      $out/lib/python3.12/site-packages/OCP/OCP.cpython-312-${wheel.extensionSuffix}
  '';
}
