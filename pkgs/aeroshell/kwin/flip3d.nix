{
  stdenvNoCC,
  aeroshell-kwin-repo
}:
stdenvNoCC.mkDerivation {
  pname = "aeroshell-flip3d";
  version = "2026-03-03";
  src = aeroshell-kwin-repo;

  dontUnpack = true;
  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/kwin/tabbox
    cp -r $src/kwin/tabbox/flip3d $out/share/kwin/tabbox
    runHook postInstall
  '';
  dontFixup = true;
}