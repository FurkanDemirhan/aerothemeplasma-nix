{
  stdenv,
  aerothemeplasma-repo,
  kdePackages,
  cmake,
}:
stdenv.mkDerivation {
  pname = "aerothemeplasma-atpootb";
  version = "2026-03-18";
  src = aerothemeplasma-repo;

  preConfigure = "cd plasma/atpootb";

  postPatch = ''
    substituteInPlace plasma/atpootb/src/CMakeLists.txt \
      --replace-fail "\''${CMAKE_INSTALL_PREFIX}/share/dbus-1/interfaces/org.kde.kwin.Effects.xml" "${kdePackages.kwin}/share/dbus-1/interfaces/org.kde.kwin.Effects.xml"
  '';

  buildInputs = with kdePackages; [kwin qttools];
  nativeBuildInputs = [cmake kdePackages.wrapQtAppsHook];

  cmakeFlags = [
    "-DKAUTH_ACTIONS_QML=false"
  ];

  postInstall = ''
    mkdir -p $out/etc/xdg/autostart
    cp $src/misc/xdg/autostart/x-atpootb.desktop $out/etc/xdg/autostart
    substituteInPlace $out/etc/xdg/autostart/x-atpootb.desktop \
      --replace-fail "/usr/bin/atpootb" "$out/bin/atpootb"
  '';

  meta = {
    mainProgram = "atpootb";
  };
}
