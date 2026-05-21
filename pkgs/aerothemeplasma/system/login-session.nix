{
  stdenv,
  lib,
  aerothemeplasma-repo,
  xdg,
  kdePackages,
  cmake,
  session ? "wayland"
}:
stdenv.mkDerivation {
  pname = "aerothemeplasma-login-session-${session}";
  version = "2026-03-14";
  src = aerothemeplasma-repo;

  preConfigure = "cd plasma/sddm/login-sessions";
  nativeBuildInputs = [ cmake ];
  buildInputs = [ kdePackages.extra-cmake-modules ];
  cmakeFlags = [ (lib.cmakeBool "INSTALL_X11_COMPONENTS" (session == "x11")) ];

  postFixup = if (session == "wayland") then ''
    substituteInPlace $out/bin/startatp-wayland \
      --replace-fail "$out/libexec/plasma-dbus-run-session-if-needed" "${kdePackages.plasma-workspace}/libexec/plasma-dbus-run-session-if-needed" \
      --replace-fail "$out/bin/startplasma-wayland" "${kdePackages.plasma-workspace}/bin/startplasma-${session}" \
      --replace-fail "/etc/xdg/aerothemeplasma:/etc/xdg:" "${xdg}/etc/xdg:"
  '' else ''
    substituteInPlace $out/bin/startatp \
      --replace-fail "startplasma-x11" "${kdePackages.plasma-workspace}/bin/startplasma-x11" \
      --replace-fail "/etc/xdg/aerothemeplasma:/etc/xdg:" "${xdg}/etc/xdg:"
  '';

  passthru.providedSessions = if (session == "wayland") then [ "aerothemeplasma" ] else [ "aerothemeplasmax11" ];
}