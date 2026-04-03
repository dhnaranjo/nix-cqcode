{
  python3Packages,
  fetchurl,
  ocp-tessellate,
}:
let
  version = "3.1.2";
in
python3Packages.buildPythonPackage {
  pname = "ocp-vscode";
  inherit version;
  format = "wheel";
  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/8c/9b/d9bbf7e11814b088e7d958aacf034136659335049b0684648b1f53cf5a6b/ocp_vscode-${version}-py3-none-any.whl";
    hash = "sha256-tRUgV/kFo9B1oBXwB35ld3CvzN2ANPNkvMma5LPFclQ=";
  };
  dontCheckRuntimeDeps = true;
  dependencies = [
    ocp-tessellate
    python3Packages.requests
    python3Packages.ipykernel
    python3Packages.orjson
    python3Packages.websockets
    python3Packages.pyaml
    python3Packages.flask
    python3Packages.flask-sock
    python3Packages.click
    python3Packages.pyperclip
    python3Packages.questionary
    python3Packages.pillow
  ];
}
