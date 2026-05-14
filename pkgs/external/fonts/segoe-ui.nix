{
  stdenvNoCC,
  fetchurl,
  lib
}:
let
  fetchFont = name: hash: fetchurl {
    inherit hash;
    url = "https://media.githubusercontent.com/media/microsoft/MixedReality-AzureCommunicationServices-Sample/0be22d2d10aa8172053206fa3d3a29799817313a/unity/acsShowcase/Assets/Resources/Fonts/Segue%20UI/${name}";
  };
in
stdenvNoCC.mkDerivation {
  pname = "segoe-ui";
  version = "5.05";

  srcs = [
    (fetchFont "SegoeUI.ttf" "sha256-UgTdsxVMCHGkhDOuhezneXwY+HD6WNpD6XHI+T4vu7k=")
    (fetchFont "SegoeUI-Bold.ttf" "sha256-LMO76M+n10zvV6AZ7dLdqSZ021874s8o+6+1MagAZnQ=")
    (fetchFont "SegoeUI-SemiBold.ttf" "sha256-qw6wberphuy66f5h7cP7520HNTFq9N3kiK3yfY+l5FM=")
    (fetchFont "SegoeUI-Italic.ttf" "sha256-0aKKZ4TwaUQ24W2999PjLCLsch845UpLQXdEOqBlwrc=")
  ];

  dontUnpack = true;
  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/fonts/truetype
    ln -st $out/share/fonts/truetype $srcs
    runHook postInstall
  '';

  # https://github.com/microsoft/MixedReality-AzureCommunicationServices-Sample/blob/0be22d2d10aa8172053206fa3d3a29799817313a/LICENSE
  meta.license = lib.licenses.mit;
}