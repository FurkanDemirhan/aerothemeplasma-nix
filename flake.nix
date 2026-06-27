{
  description = "AeroThemePlasma on NixOS";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } ({ self, withSystem, moduleWithSystem, ... }: {
      systems = [ "x86_64-linux" "aarch64-linux" "i686-linux" ];

      flake.nixosModules.aerothemeplasma-nix = moduleWithSystem (
        perSystem@{ config }: import ./modules/default.nix perSystem
      );
      flake.homeModules.aerothemeplasma-nix = throw ''
        aerothemeplasma-nix's home-manager module has been removed for Plasma 6.6, as the theme
        now comes with an "Out of the Box Experience" wizard that can configure itself. It is stabler
        than attempting to enable AeroThemePlasma through plasma-manager, which has a few odd quirks.

        Please remove aerothemeplasma from home-manager and read the README's configuration section again:
        https://github.com/nyakase/aerothemeplasma-nix#configuration. You will see the wizard open on your 
        next login. Note that plasma-manager settings could override the wizard's settings if conflicting. 
      '';

      # This configuration is intended for testing,
      # please do not try to switch to it!
      flake.nixosConfigurations.atp = inputs.nixpkgs.lib.nixosSystem {
        modules = [
          self.nixosModules.aerothemeplasma-nix
          ./vms/aerothemeplasma.nix
        ];
      };

      perSystem = { pkgs, system, ... }: {
        packages = pkgs.lib.filterAttrs (_: pkgs.lib.isDerivation) (
          pkgs.lib.makeScope pkgs.newScope (self: {
            aeroshell-kwin-repo = pkgs.fetchFromGitLab {
              domain = "gitgud.io";
              owner = "aeroshell";
              repo = "aeroshell-kwin-components";
              rev = "148c3c2034feab345b93c12a3295c877faf46f87";
              hash = "sha256-Q6Pt55f9ZneGCskdmjrRobYtm04ggyhk95JlClWfyrM=";
            };
            aeroshell-smod-repo = pkgs.fetchFromGitLab {
              domain = "gitgud.io";
              owner = "aeroshell";
              repo = "smod";
              rev = "111d3e6554b68c72b64bf475f82eae6019d85c81";
              hash = "sha256-41GhLAekK4adNL3Bkm6WFOvJZSqBzoTnVK4q0U2KPNA=";
            };
            aeroshell-workspace-repo = pkgs.fetchFromGitLab {
              domain = "gitgud.io";
              owner = "aeroshell";
              repo = "aeroshell-workspace";
              rev = "00a39ba08f3b9441b0883f1b82fc4e7e9e6a44b7";
              hash = "sha256-UGT+MaFwSgLzacdwZTLhaxW5qhaSVa6ZFE6F4XCaHbE=";
            };
            aerothemeplasma-icons-repo = pkgs.fetchFromGitLab {
              domain = "gitgud.io";
              owner = "aeroshell";
              repo = "atp/aerothemeplasma-icons";
              rev = "96950b8028a5d960cb683280fe5f1d9e33e6b8a2";
              hash = "sha256-7dfoGD3LQiBQ7/JeM1CwAZ+NNMaAJyAN/SaYIHZl1xg=";
            };

            aerothemeplasma-repo = pkgs.fetchFromGitLab {
              domain = "gitgud.io";
              owner = "aeroshell";
              repo = "atp/aerothemeplasma";
              rev = "713fbc2f0bb728b3f4e20aaf8d7eeae166fd39ba";
              hash = "sha256-JKUCMf0sJEstdrjYjt4yerKarcBMsg4is5pToDokkDg=";
            };
            
            libplasma = self.callPackage ./pkgs/aeroshell/hacks/libplasma.nix {};
            plasma-workspace = self.callPackage ./pkgs/aeroshell/hacks/plasma-workspace.nix {};

            aeroglassblur = self.callPackage ./pkgs/aeroshell/kwin/aeroglassblur.nix {};
            aeroglide = self.callPackage ./pkgs/aeroshell/kwin/aeroglide.nix {};
            default-rules = self.callPackage ./pkgs/aeroshell/kwin/default-rules.nix {};
            dimscreenaero = self.callPackage ./pkgs/aeroshell/kwin/dimscreenaero.nix {};
            fadingpopupsaero = self.callPackage ./pkgs/aeroshell/kwin/fadingpopupsaero.nix {};
            flip3d = self.callPackage ./pkgs/aeroshell/kwin/flip3d.nix {};
            i18n-kwin = self.callPackage ./pkgs/aeroshell/kwin/i18n.nix {};
            launchfeedback = self.callPackage ./pkgs/aeroshell/kwin/launchfeedback.nix {};
            loginaero = self.callPackage ./pkgs/aeroshell/kwin/loginaero.nix {};
            smod = self.callPackage ./pkgs/aeroshell/kwin/smod.nix {};
            smodglow = self.callPackage ./pkgs/aeroshell/kwin/smodglow.nix {};
            smodsnap = self.callPackage ./pkgs/aeroshell/kwin/smodsnap.nix {};
            smodpeekeffect = self.callPackage ./pkgs/aeroshell/kwin/smodpeekeffect.nix {};
            smodpeekscript = self.callPackage ./pkgs/aeroshell/kwin/smodpeekscript.nix {};
            squashaero = self.callPackage ./pkgs/aeroshell/kwin/squashaero.nix {};
            thumbnail-aero = self.callPackage ./pkgs/aeroshell/kwin/thumbnail-aero.nix {};
            thumbnails = self.callPackage ./pkgs/aeroshell/kwin/thumbnails.nix {};

            kcmloader = self.callPackage ./pkgs/aeroshell/plasma/kcmloader.nix {};
            libaeroshellutils = self.callPackage ./pkgs/aeroshell/plasma/libaeroshellutils.nix {};
            libshowdesktop = self.callPackage ./pkgs/aeroshell/plasma/libshowdesktop.nix {};
            libtaskmanager = self.callPackage ./pkgs/aeroshell/plasma/libtaskmanager.nix {};

            cursors = self.callPackage ./pkgs/aerothemeplasma/assets/cursors.nix {};
            icons = self.callPackage ./pkgs/aerothemeplasma/assets/icons.nix {};
            sounds = self.callPackage ./pkgs/aerothemeplasma/assets/sounds.nix {};

            atpootb = self.callPackage ./pkgs/aerothemeplasma/plasma/atpootb.nix {};
            authui7 = self.callPackage ./pkgs/aerothemeplasma/plasma/authui7.nix {};
            color-scheme = self.callPackage ./pkgs/aerothemeplasma/plasma/color-scheme.nix {};
            kvantum-windows7aero = self.callPackage ./pkgs/aerothemeplasma/plasma/kvantum-windows7aero.nix {};
            layout-template = self.callPackage ./pkgs/aerothemeplasma/plasma/layout-template.nix {};
            seven-black = self.callPackage ./pkgs/aerothemeplasma/plasma/seven-black.nix {};
            shell = self.callPackage ./pkgs/aerothemeplasma/plasma/shell.nix {};
            xdg = self.callPackage ./pkgs/aerothemeplasma/plasma/xdg.nix {};

            battery = self.callPackage ./pkgs/aerothemeplasma/plasmoids/battery.nix {};
            desktopcontainment = self.callPackage ./pkgs/aerothemeplasma/plasmoids/desktopcontainment.nix {};
            digitalclocklite = self.callPackage ./pkgs/aerothemeplasma/plasmoids/digitalclocklite.nix {};
            keyboardlayout = self.callPackage ./pkgs/aerothemeplasma/plasmoids/keyboardlayout.nix {};
            networkmanagement = self.callPackage ./pkgs/aerothemeplasma/plasmoids/networkmanagement.nix {};
            notifications = self.callPackage ./pkgs/aerothemeplasma/plasmoids/notifications.nix {};
            panel = self.callPackage ./pkgs/aerothemeplasma/plasmoids/panel.nix {};
            sevenstart = self.callPackage ./pkgs/aerothemeplasma/plasmoids/sevenstart.nix {};
            seventasks = self.callPackage ./pkgs/aerothemeplasma/plasmoids/seventasks.nix {};
            systemtray = self.callPackage ./pkgs/aerothemeplasma/plasmoids/systemtray.nix {};
            volume = self.callPackage ./pkgs/aerothemeplasma/plasmoids/volume.nix {};
            win7showdesktop = self.callPackage ./pkgs/aerothemeplasma/plasmoids/win7showdesktop.nix {};

            login-session = self.callPackage ./pkgs/aerothemeplasma/system/login-session.nix {};
            sddm-theme-mod = self.callPackage ./pkgs/aerothemeplasma/system/sddm-theme-mod.nix {};

            segoe-ui = self.callPackage ./pkgs/external/fonts/segoe-ui.nix {};
            lucida-console = self.callPackage ./pkgs/external/fonts/lucida-console.nix {};

            aeroglasspane = self.callPackage ./pkgs/external/software/aeroglasspane.nix {};
            execbin = self.callPackage ./pkgs/external/software/execbin.nix {};
            linver = self.callPackage ./pkgs/external/software/linver.nix {};

            plymouthvista = self.callPackage ./pkgs/external/system/plymouthvista.nix {};
            uac-polkit-agent = self.callPackage ./pkgs/external/system/uac-polkit-agent.nix {};
          })
        );
      };
    });
}
