{
  lib,
  stdenv,
  unzip,
}: let
  version = "tx-02";
in
  stdenv.mkDerivation {
    pname = "berkeley-mono";
    inherit version;

    # Licensed copy, intentionally gitignored — do not publish.
    src = ../berkeley-mono-ligatures.zip;

    nativeBuildInputs = [unzip];

    unpackPhase = ''
      runHook preUnpack
      unzip -q "$src" -d .
      runHook postUnpack
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p "$out/share/fonts/truetype"
      find . -name '*.ttf' -exec cp {} "$out/share/fonts/truetype/" \;
      runHook postInstall
    '';

    meta = {
      description = "Berkeley Mono (licensed user copy)";
      license = lib.licenses.unfree;
      platforms = lib.platforms.all;
    };
  }
