{
  kdePackages,
  fetchpatch
}:
kdePackages.libplasma.overrideAttrs (oldAttrs: {
  pname = "aeroshell-libplasma";
  patches = [
    # "Apply ATP patches to libplasma"
    (fetchpatch {
      url = "https://github.com/aeroshell-desktop/libplasma/commit/3b0709a266625c00d3e7d09d4eeecb9ff52e4d41.patch";
      hash = "sha256-XULB9ogLDtuxhGFrXGDyrKxFlKz+jUyKLq1MunlKG3A=";
    })
    # "Remove assertion failure on empty dialogs"
    (fetchpatch {
      url = "https://github.com/aeroshell-desktop/libplasma/commit/a4e0bcc9e01434e5680070197e0e217ba50699c8.patch";
      hash = "sha256-wPpWVZOB4AAuLY+/IuU8JzUmRpzpLW8+sysy8ExAqfg=";
    })
  ];
  postPatch = ''
    shopt -s globstar

    substituteInPlace src/**/CMakeLists.txt \
      --replace-warn 'URI "org.kde.plasma.' 'URI "io.gitgud.wackyideas.plasma.' \
      --replace-warn "EXPORT_NAME Plasma" "OUTPUT_NAME ATPlasma"
    substituteInPlace src/**/*.qml --replace-quiet "import org.kde.plasma." "import io.gitgud.wackyideas.plasma."

    substituteInPlace src/declarativeimports/core/tooltipdialog.cpp --replace-fail \
      'SourceFromModule("org.kde.plasma.' 'SourceFromModule("io.gitgud.wackyideas.plasma.'

    substituteInPlace src/declarativeimports/CMakeLists.txt --replace-fail "add_subdirectory(kirigamiplasmastyle)" ""
    substituteInPlace src/plasma/CMakeLists.txt --replace-fail "add_subdirectory(packagestructure)" ""
  '';
  ninjaFlags = ["corebindingsplugin"];
  postFixup = "rm -rf $out/share";
})
