{
  stdenv,
  aeroshell-kwin-repo,
  kdePackages,
  pkg-config,
  cmake,
  lib,
  session ? "wayland"
}:
stdenv.mkDerivation {
  pname = "aeroshell-aeroglassblur-${session}";
  version = "2026-03-23";
  src = aeroshell-kwin-repo;

  preConfigure = ''
    cd effects_cpp/${session}/kde-effects-aeroglassblur
    substituteInPlace src/metadata.json src/kcm/CMakeLists.txt --replace-fail \
      "kwin_aeroglassblur_config" "kwin_aeroglassblur_${session}_config"
  '';
  buildInputs = [ kdePackages.qttools ] 
    ++ lib.optionals (session == "x11") [ kdePackages.kwin-x11 ]
    ++ lib.optionals (session == "wayland") [ kdePackages.kwin ];
  nativeBuildInputs = [ cmake kdePackages.wrapQtAppsHook ];
  cmakeFlags = [ (lib.cmakeBool "KWIN_BUILD_WAYLAND" (session == "wayland")) ];
}