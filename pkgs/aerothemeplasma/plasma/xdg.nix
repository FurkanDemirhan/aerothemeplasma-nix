{
  stdenvNoCC,
  lib,
  aerothemeplasma-repo,
  atpootb
}:
stdenvNoCC.mkDerivation {
  pname = "aerothemeplasma-xdg";
  version = "2026-03-02";
  src = aerothemeplasma-repo;

  dontUnpack = true;
  installPhase = ''
    runHook preInstall
    shopt -s extglob
    mkdir -p $out/share/aerothemeplasma/branding $out/etc/xdg

    cp $src/misc/branding/kcminfo.png $out/share/aerothemeplasma/branding
    cp $src/misc/xdg/!(autostart|CMakeLists.txt) $out/etc/xdg
    # The one autostart, atpootb, is part of the atpootb package instead.
    
    substituteInPlace $out/etc/xdg/kcm-about-distrorc \
      --replace-fail "/usr/share/aerothemeplasma" "$out/share/aerothemeplasma"

    # There was a bug in atpootb where the effects were never
    # actually applied to the user's kwinrc, but the session
    # kwinrc had them configured, creating the illusion it was
    # working fine (until you went to the regular session).

    # This bug was fixed but atpootb has no update mechanism, and
    # the effects were removed from the session kwinrc. They need
    # to be put back so existing installs don't lose the effects.
    chmod +w $out/etc/xdg/kwinrc
    cat >> $out/etc/xdg/kwinrc << EOF
    
    [Plugins]
    aeroglassblurEnabled=true
    aeroglideEnabled=true
    blurEnabled=false
    dialogparentEnabled=false
    dimscreenaeroEnabled=true
    fadingpopupsEnabled=false
    libkwin_effect_smodsnapEnabled=true
    loginEnabled=false
    logoutEnabled=false
    maximizeEnabled=false
    minimizeallEnabled=true
    scaleEnabled=false
    slideEnabled=false
    slidingpopupsEnabled=false
    smodglowEnabled=true
    smodglow-x11Enabled=true
    smodpeekeffectEnabled=true
    smodpeekscriptEnabled=true
    squashEnabled=false
    windowapertureEnabled=false
    EOF

    runHook postInstall
  '';
}