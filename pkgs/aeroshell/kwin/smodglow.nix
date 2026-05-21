{
  stdenv,
  aeroshell-smod-repo,
  kdePackages,
  pkg-config,
  smod,
  cmake,
  lib,
  session ? "wayland"
}:
stdenv.mkDerivation {
  pname = "aeroshell-smodglow-${session}";
  version = "2026-02-26";
  src = aeroshell-smod-repo;

  preConfigure = "cd smodglow";
  buildInputs = [ smod ]
    ++ lib.optionals (session == "x11") [ kdePackages.kwin-x11 ]
    ++ lib.optionals (session == "wayland") [ kdePackages.kwin ];
  nativeBuildInputs = [ cmake pkg-config kdePackages.wrapQtAppsHook ];
  cmakeFlags = [ (lib.cmakeBool "KWIN_BUILD_WAYLAND" (session == "wayland")) ];
}