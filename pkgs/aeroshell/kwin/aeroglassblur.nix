{
  stdenv,
  aeroshell-kwin-repo,
  kdePackages,
  pkg-config,
  cmake,
  lib
}:
stdenv.mkDerivation {
  pname = "aeroshell-aeroglassblur";
  version = "2026-03-23";
  src = aeroshell-kwin-repo;

  preConfigure = "cd effects_cpp/wayland/kde-effects-aeroglassblur";
  buildInputs = with kdePackages; [ kwin qttools ];
  nativeBuildInputs = [ cmake kdePackages.wrapQtAppsHook ];
  cmakeFlags = [ (lib.cmakeBool "KWIN_BUILD_WAYLAND" true) ];
}