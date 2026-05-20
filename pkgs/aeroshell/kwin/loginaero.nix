{
  stdenvNoCC,
  aeroshell-kwin-repo
}:
stdenvNoCC.mkDerivation {
  pname = "aeroshell-loginaero";
  version = "2026-03-18";
  src = aeroshell-kwin-repo;

  dontUnpack = true;
  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/kwin/effects
    cp -r $src/kwin/effects/loginaero $out/share/kwin/effects
    runHook postInstall
  '';
  dontFixup = true;
}