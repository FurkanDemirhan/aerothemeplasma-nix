{
  stdenv,
  aeroshell-kwin-repo,
  kdePackages,
  pkg-config,
  smod,
  cmake,
  lib,
  session ? "wayland"
}:
stdenv.mkDerivation {
  pname = "aeroshell-smodsnap-${session}";
  version = "2026-02-23";
  src = aeroshell-kwin-repo;

  preConfigure = "cd effects_cpp/${session}/kwin-effect-smodsnap-v2";
  buildInputs = [ kdePackages.qttools smod ] 
    ++ lib.optionals (session == "x11") [ kdePackages.kwin-x11 ]
    ++ lib.optionals (session == "wayland") [ kdePackages.kwin ];
  nativeBuildInputs = [ cmake pkg-config kdePackages.wrapQtAppsHook ];
  cmakeFlags = [ (lib.cmakeBool "KWIN_BUILD_WAYLAND" (session == "wayland")) ];
}