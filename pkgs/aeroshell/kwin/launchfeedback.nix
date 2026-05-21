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
  pname = "aeroshell-launchfeedback-${session}";
  version = "2026-02-21";
  src = aeroshell-kwin-repo;

  preConfigure = "cd effects_cpp/${session}/startupfeedback";
  buildInputs = [ kdePackages.qttools ] 
    ++ lib.optionals (session == "x11") [ kdePackages.kwin-x11 ]
    ++ lib.optionals (session == "wayland") [ kdePackages.kwin ];
  nativeBuildInputs = [ cmake pkg-config kdePackages.wrapQtAppsHook ];
  cmakeFlags = [ (lib.cmakeBool "KWIN_BUILD_WAYLAND" (session == "wayland")) ];
}