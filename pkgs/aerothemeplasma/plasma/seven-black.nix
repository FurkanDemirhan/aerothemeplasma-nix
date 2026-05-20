{
  stdenvNoCC,
  aerothemeplasma-repo
}:
stdenvNoCC.mkDerivation {
  pname = "aerothemeplasma-seven-black";
  version = "2026-03-14";
  src = aerothemeplasma-repo;

  dontUnpack = true;
  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/plasma/desktoptheme
    cp -R $src/plasma/desktoptheme/Seven-Black $out/share/plasma/desktoptheme
    runHook postInstall
  '';
}