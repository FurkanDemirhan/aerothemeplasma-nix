{
  stdenvNoCC,
  aerothemeplasma-repo
}:
stdenvNoCC.mkDerivation {
  pname = "aerothemeplasma-authui7";
  version = "2026-03-15";
  src = aerothemeplasma-repo;

  dontUnpack = true;
  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/plasma/look-and-feel
    cp -r $src/plasma/look-and-feel/authui7 $out/share/plasma/look-and-feel

    # QtMultimedia is not used, so let's just remove it
    substituteInPlace \
      $out/share/plasma/look-and-feel/authui7/contents/splash/Splash.qml \
      --replace-fail "import QtMultimedia" ""

    runHook postInstall
  '';
}