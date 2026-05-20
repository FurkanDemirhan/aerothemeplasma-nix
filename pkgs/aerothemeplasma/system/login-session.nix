{
  stdenv,
  lib,
  aerothemeplasma-repo,
  xdg,
  kdePackages,
  cmake
}:
stdenv.mkDerivation {
  pname = "aerothemeplasma-login-session";
  version = "2026-03-14";
  src = aerothemeplasma-repo;

  nativeBuildInputs = [ cmake ];
  buildInputs = [ kdePackages.extra-cmake-modules ];
  preConfigure = "cd plasma/sddm/login-sessions";

  postFixup = ''
    substituteInPlace $out/bin/startatp-wayland \
      --replace-fail "$out/libexec/plasma-dbus-run-session-if-needed" "${kdePackages.plasma-workspace}/libexec/plasma-dbus-run-session-if-needed" \
      --replace-fail "$out/bin/startplasma-wayland" "${kdePackages.plasma-workspace}/bin/startplasma-wayland" \
      --replace-fail "/etc/xdg/aerothemeplasma:/etc/xdg:" "${xdg}/etc/xdg:"
  '';

  passthru.providedSessions = [ "aerothemeplasma" ];
}