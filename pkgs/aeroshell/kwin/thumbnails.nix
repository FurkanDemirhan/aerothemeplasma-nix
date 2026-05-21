{
  stdenvNoCC,
  aeroshell-kwin-repo
}:
stdenvNoCC.mkDerivation {
  pname = "aeroshell-thumbnails";
  version = "2026-04-03";
  src = aeroshell-kwin-repo;

  dontUnpack = true;
  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/kwin-x11/effects
    cp -r $src/kwin/effects/aeroshell-thumbnails $out/share/kwin-x11/effects
    runHook postInstall
  '';
  dontFixup = true;
}