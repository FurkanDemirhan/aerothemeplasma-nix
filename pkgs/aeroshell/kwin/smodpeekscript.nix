{
  stdenvNoCC,
  aeroshell-kwin-repo
}:
stdenvNoCC.mkDerivation {
  pname = "aeroshell-smodpeekscript";
  version = "2026-03-03";
  src = aeroshell-kwin-repo;

  dontUnpack = true;
  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/kwin/scripts
    cp -r $src/kwin/scripts/smodpeekscript $out/share/kwin/scripts
    runHook postInstall
  '';
  dontFixup = true;
}