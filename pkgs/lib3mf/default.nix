{
  stdenv,
  python3Packages,
  fetchurl,
}:
let
  version = "2.5.0";
  system = stdenv.hostPlatform.system;
  wheel =
    if system == "aarch64-darwin" || system == "x86_64-darwin" then
      {
        url = "https://files.pythonhosted.org/packages/04/87/47504d69f0f36841670d12ce3fe1668025bad74d83ed361ead378f626fed/lib3mf-${version}-py3-none-macosx_10_9_universal2.whl";
        hash = "sha256-99xX6iIhT6ktrHKLpm5YxLJLd11GeIgmKoIDONfYQUU=";
      }
    else if system == "x86_64-linux" then
      {
        url = "https://files.pythonhosted.org/packages/88/83/8b987ba95ac0ed9cc7e9c407a579bf43eff6349b1792b4a66c992ce4f76b/lib3mf-${version}-py3-none-manylinux2014_x86_64.whl";
        hash = "sha256-tMAAM8R8/qyTt9qgaftG6N6kOR1VIrec1un2r3XjMBM=";
      }
    else
      throw "lib3mf: unsupported system ${system}; add platform-specific wheel metadata";
in
python3Packages.buildPythonPackage {
  pname = "lib3mf";
  inherit version;
  format = "wheel";
  src = fetchurl {
    inherit (wheel) url hash;
  };
  pythonImportsCheck = [ "lib3mf" ];
}
