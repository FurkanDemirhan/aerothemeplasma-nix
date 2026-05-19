{
  stdenv,
  aeroshell-workspace-repo,
  kdePackages,
  cmake,
  ninja
}:
stdenv.mkDerivation {
  pname = "aeroshell-libaeroshellutils";
  version = "2026-03-15";
  src = aeroshell-workspace-repo;

  postPatch = ''
    substituteInPlace libaeroshellutils/sddm.cpp --replace-fail \
      "/etc/sddm.conf.d/kde_settings.conf" "/etc/sddm.conf.d/00-nixos.conf"
  '';

  ninjaFlags = [ "aeroshellutilsplugin" ];
  buildInputs = with kdePackages; [
    extra-cmake-modules kconfig ki18n
    kio knotifications kservice kwindowsystem
    libksysguard plasma-workspace
  ];
  nativeBuildInputs = [ cmake ninja ];
  dontWrapQtApps = true;
  installPhase = ''
    runHook preInstall
    ninja libaeroshellutils/install
    runHook postInstall
  '';
}