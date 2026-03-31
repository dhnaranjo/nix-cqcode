{
  python3Packages,
  fetchurl,
}:
python3Packages.buildPythonPackage {
  pname = "qtawesome";
  version = "1.4.0";
  format = "wheel";
  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/a5/ee/6e6c6715129c929af2d95ddb2e9decf54c1beffe58f336911197aacc0448/qtawesome-1.4.0-py3-none-any.whl";
    hash = "sha256-pNaJ+gccWVqmGEFxzh8PhHZ3y40ttFOCxDEp8dcqPZM=";
  };
  dependencies = with python3Packages; [
    qtpy
    requests
  ];
}
