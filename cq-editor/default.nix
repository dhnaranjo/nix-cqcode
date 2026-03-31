{
  lib,
  fetchFromGitHub,
  python3Packages,
  cadquery,
  qtawesome,
  qt5,
}:
let
  version = "0.6.2";
  inherit (python3Packages) buildPythonApplication;
in
buildPythonApplication {
  pname = "cq-editor";
  inherit version;
  pyproject = true;
  build-system = [ python3Packages.setuptools ];

  src = fetchFromGitHub {
    owner = "CadQuery";
    repo = "CQ-editor";
    rev = version;
    hash = "sha256-8Kj8WmzlchDbd7H9MJatUHsevJf1NSQjshor+vrdhwg=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'CQ-editor = "cq_editor.cqe_run:main"' ""
  '';

  dependencies = with python3Packages; [
    cadquery
    pyqt5
    pyqtgraph
    qtconsole
    path
    logbook
    requests
    packaging
    qtawesome
  ];

  nativeBuildInputs = [ qt5.wrapQtAppsHook ];

  dontCheckRuntimeDeps = true;
  doCheck = false;

  dontWrapQtApps = true;
  preFixup = ''
    wrapQtApp "$out/bin/cq-editor"
  '';

  meta = with lib; {
    description = "CadQuery GUI editor based on PyQt5";
    homepage = "https://github.com/CadQuery/CQ-editor";
    license = licenses.asl20;
  };
}
