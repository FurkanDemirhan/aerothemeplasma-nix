{
  stdenv,
  aerothemeplasma-repo,
  kdePackages,
  libplasma,
  cmake
}:
stdenv.mkDerivation {
  pname = "aerothemeplasma-seventasks";
  version = "2026-03-06";
  src = aerothemeplasma-repo;

  preConfigure = "cd plasma/plasmoids/src/seventasks_src";
  buildInputs = [ libplasma ];
  nativeBuildInputs = [ cmake kdePackages.wrapQtAppsHook ];
  postInstall = ''
    mkdir -p $out/share/plasma/plasmoids
    cp -r $src/plasma/plasmoids/io.gitgud.wackyideas.seventasks $out/share/plasma/plasmoids
    substituteInPlace $out/share/plasma/plasmoids/io.gitgud.wackyideas.seventasks/contents/ui/*.qml \
      --replace-quiet "import org.kde.plasma.core" "import io.gitgud.wackyideas.plasma.core"
  '';
}