{
  lib,
  stdenv,
  meson,
  ninja,
  pkg-config,
  curl,
  jansson,
  src,
}:
stdenv.mkDerivation {
  pname = "hax";
  version = "0.5.0";

  # Flake input (github:OleksandrChekhovskyi/hax), locked in flake.lock
  inherit src;

  nativeBuildInputs = [meson ninja pkg-config];
  buildInputs = [curl jansson];

  meta = {
    description = "Minimalist, terminal-native coding agent in C";
    homepage = "https://github.com/OleksandrChekhovskyi/hax";
    license = lib.licenses.mit;
    mainProgram = "hax";
    platforms = lib.platforms.unix;
  };
}
