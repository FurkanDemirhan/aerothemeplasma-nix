{
  stdenvNoCC,
  aerothemeplasma-repo
}:
stdenvNoCC.mkDerivation {
  pname = "aerothemeplasma-battery";
  version = "2026-03-15";
  src = aerothemeplasma-repo;

  dontUnpack = true;
  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/plasma/plasmoids
    cp -r $src/plasma/plasmoids/io.gitgud.wackyideas.battery $out/share/plasma/plasmoids
    runHook postInstall
  '';
}