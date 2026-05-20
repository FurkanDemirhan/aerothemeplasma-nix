{
  stdenv,
  aerothemeplasma-repo,
  kdePackages,
  cmake
}:
stdenv.mkDerivation {
  pname = "aerothemeplasma-desktopcontainment";
  version = "2026-03-11";
  src = aerothemeplasma-repo;

  preConfigure = ''
    cd plasma/plasmoids/src/desktopcontainment
    substituteInPlace CMakeLists.txt --replace-fail \
      "ecm_find_qmlmodule(org.kde.kirigami REQUIRED)" ""
  '';
  buildInputs = with kdePackages; [
    libplasma kauth kcmutils
    knewstuff knotifyconfig
    krunner attica plasma5support
    plasma-activities-stats
  ];
  nativeBuildInputs = [ cmake kdePackages.wrapQtAppsHook ];
  postInstall = ''
    mkdir -p $out/share/plasma/plasmoids
    cp -r $src/plasma/plasmoids/io.gitgud.wackyideas.desktopcontainment $out/share/plasma/plasmoids
  '';
}