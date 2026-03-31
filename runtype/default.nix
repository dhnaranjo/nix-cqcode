{
  lib,
  python3Packages,
  fetchurl,
}:
let
  version = "0.5.3";
in
python3Packages.buildPythonPackage {
  pname = "runtype";
  inherit version;
  format = "wheel";
  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/80/db/879902580d720925092c86eaab2ceee7493e2fadbb5b718f54289b04d277/runtype-${version}-py3-none-any.whl";
    hash = "sha256-6ozGgoIX6/2lwVnc6WnoMu/YZaCdatH8mT9b9eGmJ+4=";
  };
  pythonImportsCheck = [ "runtype" ];
  meta = with lib; {
    description = "Type dispatch and validation for run-time Python";
    homepage = "https://github.com/erezsh/runtype";
    license = licenses.mit;
  };
}
