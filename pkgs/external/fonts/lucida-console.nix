{
  stdenvNoCC,
  requireFile
}:
stdenvNoCC.mkDerivation {
  pname = "lucida-console";
  version = "5";

  src = requireFile rec {
    name = "lucon.ttf";
    hash = "sha256-9N9NbRpp0k4I2irS9FIDtMcUfdqlGHzNcwh5A8o20Xc=";
    message = ''
      Please grab C:\Windows\Fonts\${name} from an up-to-date install of Windows 7.
      Once you have grabbed the file, run "nix store add-file ${name}", then try again.
      See https://github.com/nyakase/aerothemeplasma-nix#lucida-console-font for more info.
    '';
  };

  dontUnpack = true;
  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/fonts/truetype
    ln -st $out/share/fonts/truetype $src
    runHook postInstall
  '';
}