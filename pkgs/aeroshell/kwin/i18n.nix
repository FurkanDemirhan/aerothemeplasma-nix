{
  stdenv,
  aeroshell-kwin-repo,
  kdePackages,
  cmake
}:
stdenv.mkDerivation {
  name = "aeroshell-i18n-kwin";
  version = "2026-04-03";
  src = aeroshell-kwin-repo;
  
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "install()" "ki18n_install(po)" \
      --replace-fail "add_subdirectory(effects_cpp)" ""
  '';
  
  buildInputs = with kdePackages; [ 
    extra-cmake-modules qtdeclarative 
    qttools kconfig ki18n
  ];
  nativeBuildInputs = [ cmake kdePackages.wrapQtAppsHook ];
  cmakeFlags = [ "-DKWIN_INSTALL_MISC=false" ];
}