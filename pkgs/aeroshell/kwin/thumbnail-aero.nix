{
  stdenvNoCC,
  aeroshell-kwin-repo
}:
stdenvNoCC.mkDerivation {
  pname = "aeroshell-thumbnail-aero";
  version = "2026-03-03";
  src = aeroshell-kwin-repo;

  dontUnpack = true;
  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/kwin/tabbox
    cp -r $src/kwin/tabbox/thumbnail_aero $out/share/kwin/tabbox
    runHook postInstall
  '';
  dontFixup = true;
}