{
  stdenvNoCC,
  fetchFromGitHub,
  imagemagick,
  segoe-ui,
  makeFontsConf,
  settings ? {},
  lib
}:
let
  pvizeAttrs = attrs: lib.mapAttrs (name: value: 
    if (lib.isString value) then value
    else if (lib.isInt value) then (lib.toString value)
    else if (lib.isBool value) then (if value then "1" else "0") 
    # https://github.com/NixOS/nixpkgs/blob/56c315f08829fa61c48320e4e4371ef4177d1e5a/lib/types.nix#L891
    else throw "plymouthvista: setting `${name}' is not of type `string or boolean or signed integer'."
  ) attrs;

  mkPvConfs = attrs: lib.concatMapAttrsStringSep "\n" (name: value:
    "./pv_conf.sh -s ${lib.escapeShellArg name} -v ${lib.escapeShellArg value}"
  ) (pvizeAttrs attrs);
in 
stdenvNoCC.mkDerivation {
  pname = "plymouthvista";
  version = "2026-02-22";
  src = fetchFromGitHub {
    owner = "furkrn";
    repo = "PlymouthVista";
    rev = "cc6592a29387462d003c2c95cb9cb5df3fea851f";
    hash = "sha256-14wLKz9CL+ZwcgT8x8BXDs105dORl9CL4ITvjWx1gRI=";
  };

  env = {
    # https://discourse.nixos.org/t/fontconfig-error-no-writable-cache-directories/34447/2
    XDG_CACHE_HOME = "$(mktemp -d)";
    # https://discourse.nixos.org/t/imagemagicks-convert-command-fails-due-to-fontconfig-error/20518/5
    FONTCONFIG_FILE = makeFontsConf {
      fontDirectories = [ segoe-ui ];
    };
  };
  nativeBuildInputs = [ imagemagick ];
  buildPhase = ''
    runHook preBuild
    patchShebangs ./compile.sh ./pv_conf.sh ./gen_blur.sh

    ./compile.sh
    ${mkPvConfs settings}
    ./gen_blur.sh

    substituteInPlace PlymouthVista.plymouth \
      --replace-fail "/usr/share" "$out/share"

    mkdir -p $out/share/plymouth/themes/PlymouthVista
    cp -r images PlymouthVista.plymouth PlymouthVista.script \
      $out/share/plymouth/themes/PlymouthVista

    runHook postBuild
  '';
}