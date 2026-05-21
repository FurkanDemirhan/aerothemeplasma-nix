{
  stdenvNoCC,
  aerothemeplasma-repo
}:
stdenvNoCC.mkDerivation {
  pname = "aerothemeplasma-kvantum-windows7aero";
  version = "2026-03-04";
  src = aerothemeplasma-repo;

  dontUnpack = true;
  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/Kvantum/Windows7Aero
    cp -r $src/misc/kvantum/Windows7Aero $out/share/Kvantum
    runHook postInstall
  '';
  dontFixup = true;
}