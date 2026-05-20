{
  stdenv,
  aeroshell-smod-repo,
  kdePackages,
  pkg-config,
  smod,
  cmake,
  lib
}:
stdenv.mkDerivation {
  pname = "aeroshell-smodglow";
  version = "2026-02-26";
  src = aeroshell-smod-repo;

  preConfigure = "cd smodglow";
  buildInputs = with kdePackages; [ kwin smod ];
  nativeBuildInputs = [ cmake pkg-config kdePackages.wrapQtAppsHook ];
  cmakeFlags = [ (lib.cmakeBool "KWIN_BUILD_WAYLAND" true) ];
}