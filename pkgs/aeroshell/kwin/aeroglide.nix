{
  stdenv,
  aeroshell-kwin-repo,
  kdePackages,
  pkg-config,
  cmake,
  lib
}:
stdenv.mkDerivation {
  pname = "aeroshell-aeroglide";
  version = "2026-03-18";
  src = aeroshell-kwin-repo;

  preConfigure = "cd effects_cpp/wayland/aeroglide";
  buildInputs = with kdePackages; [ kwin qttools ];
  nativeBuildInputs = [ cmake pkg-config kdePackages.wrapQtAppsHook ];
  cmakeFlags = [ (lib.cmakeBool "KWIN_BUILD_WAYLAND" true) ];
}