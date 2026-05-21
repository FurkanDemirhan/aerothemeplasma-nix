{
  stdenv,
  aeroshell-kwin-repo,
  kdePackages,
  cmake
}:
stdenv.mkDerivation {
  name = "aeroshell-default-rules";
  version = "2026-02-22";
  src = aeroshell-kwin-repo;
  
  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-fail \
      "add_subdirectory(effects_cpp)" "add_subdirectory(rules)"
  '';
  
  buildInputs = with kdePackages; [ 
    extra-cmake-modules qtdeclarative 
    qttools kconfig ki18n
  ];
  nativeBuildInputs = [ cmake kdePackages.wrapQtAppsHook ];
  cmakeFlags = [ "-DKWIN_INSTALL_MISC=false" ];
}