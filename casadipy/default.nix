{
  lib,
  python3Packages,
  fetchurl,
}:
let
  version = "3.7.2";
in
python3Packages.buildPythonPackage {
  pname = "casadi";
  inherit version;
  format = "wheel";
  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/1e/c0/3c4704394a6fd4dfb2123a4fd71ba64a001f340670a3eba45be7a19ac736/casadi-${version}-cp312-none-macosx_11_0_arm64.whl";
    hash = "sha256-YDM4EjTbgQsiR9FsY1LmeaAJ7ENl0EAI/HaIZuAR7Vg=";
  };
  dependencies = [ python3Packages.numpy ];
  pythonImportsCheck = [ "casadi" ];
  meta = with lib; {
    description = "Framework for algorithmic differentiation and numeric optimization";
    homepage = "https://casadi.org/";
    license = licenses.lgpl3Plus;
  };
}
