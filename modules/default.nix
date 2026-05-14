perSystem:
{ config, lib, pkgs, ... }:
let
  cfg = config.programs.aeroshell;
  atpkgs = perSystem.config.packages;
in
{
  # this is rather silly but if the options are dropped entirely the
  # evaluation will fail and the consumer never gets the "we've moved"
  # message, so keep these around until Plasma 6.7 or so
  options.aerothemeplasma = {
    enable = lib.mkEnableOption "nothing";
    plasma.enable = lib.mkEnableOption "nothing";
    fonts.enable = lib.mkEnableOption "nothing";
    plymouth.enable = lib.mkEnableOption "nothing";
    polkit.enable = lib.mkEnableOption "nothing";
    sddm.enable = lib.mkEnableOption "nothing";
  };
  options.programs.sevulet.enable = lib.mkEnableOption "nothing";
  
  options.programs = {
    aeroshell = {
      enable = lib.mkEnableOption "AeroShell, a set of core components for AeroThemePlasma";
      fonts.enable = lib.mkEnableOption "the Segoe UI and Lucida Console fonts";
      fonts.segoe.enable = lib.mkEnableOption "the Segoe UI font";
      fonts.lucida.enable = lib.mkEnableOption "the Lucida Console font";
      polkit.enable = lib.mkEnableOption "the AeroShell Polkit agent replacement";
      aerothemeplasma = {
        enable = lib.mkEnableOption "AeroThemePlasma, a set of Plasma theme packages";
        plymouth.enable = lib.mkEnableOption "the PlymouthVista theme using the 7 style";
        sddm.enable = lib.mkEnableOption "the SDDM theme";
      };
    };

    linver.enable = lib.mkEnableOption "the Linver application";
    execbin.enable = lib.mkEnableOption "the ExecBin application";
  };

  config = lib.mkIf (config.aerothemeplasma.enable || cfg.enable) {
    assertions = [
      {
        assertion = cfg.aerothemeplasma.plymouth.enable -> cfg.fonts.segoe.enable;
        message = ''
          The Plymouth theme requires the Segoe font to be enabled.
          Like so: "programs.aeroshell.fonts.segoe.enable = true;"
        '';
      }
      {
        assertion = !config.aerothemeplasma.enable;
        message = ''
          The "aerothemeplasma" option set has been moved to "programs.aeroshell". This reflects 
          the changes in Plasma 6.6, fits in better with other NixOS options, and is needed to add 
          VistaThemePlasma in the future. Sorry for the trouble! For how the options work now, see:
          https://github.com/nyakase/aerothemeplasma-nix#configuration
        '';
      }
      {
        assertion = !config.programs.sevulet.enable;
        message = ''
          The Sevulet software suite was deleted by its author and is no longer available. 
          Please remove the "programs.sevulet.enable = true;" option from your configuration.
        '';
      }
    ];

    services.displayManager.sessionPackages = lib.mkIf cfg.aerothemeplasma.enable [ atpkgs.login-session ];
    environment.systemPackages = with atpkgs; [
      pkgs.kdePackages.qtmultimedia
      libplasma libtaskmanager libshowdesktop
      plasma-workspace default-rules
    ] ++ (with atpkgs; lib.optionals cfg.aerothemeplasma.enable [
      cursors icons sounds

      atpootb authui7 color-scheme kvantum-windows7aero
      layout-template seven-black

      keyboardlayout win7showdesktop
      seventasks sevenstart aeroglassblur
      shell smod smodglow desktopcontainment
      systemtray notifications volume flip3d
      digitalclocklite panel thumbnail-aero
      fadingpopupsaero squashaero loginaero
      dimscreenaero launchfeedback smodsnap
      aeroglide kcmloader battery
      networkmanagement

      pkgs.kdePackages.qtstyleplugin-kvantum
    ]) ++ (with atpkgs; lib.optionals config.programs.sevulet.enable [ 
      sevulet-explorer sevulet-notepad 
      sevulet-photoview sevulet-stickies 
    ]) ++ lib.optionals config.programs.linver.enable [ atpkgs.linver ]
       ++ lib.optionals config.programs.execbin.enable [ atpkgs.execbin ];

    # backward compat for users of "programs.aeroshell.fonts.enable"
    programs.aeroshell.fonts = lib.mkIf cfg.fonts.enable {
      segoe.enable = lib.mkDefault true;
      lucida.enable = lib.mkDefault true;
    };

    fonts.packages = lib.optionals cfg.fonts.segoe.enable [ atpkgs.segoe-ui ] 
      ++ lib.optionals cfg.fonts.lucida.enable [ atpkgs.lucida-console ];
    
    systemd.packages = with atpkgs; lib.optionals cfg.polkit.enable [
      uac-polkit-agent
    ];

    boot.plymouth = lib.mkIf cfg.aerothemeplasma.plymouth.enable {
      theme = "PlymouthVista";
      themePackages = [ atpkgs.plymouthvista ];
    };

    services.displayManager.sddm = lib.mkIf cfg.aerothemeplasma.sddm.enable {
      theme = "${atpkgs.sddm-theme-mod}/share/sddm/themes/sddm-theme-mod";
      extraPackages = [ pkgs.kdePackages.kitemmodels ];
      settings = {
        Theme = {
          CursorTheme = "aero-drop";
          CursorSize = 30;
          Font = lib.mkIf cfg.fonts.segoe.enable "Segoe UI";
        };
      };
    };
  };
}
