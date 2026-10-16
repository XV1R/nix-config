# Ghostty terminal. nixpkgs builds it from source only on Linux; macOS gets
# the upstream signed app bundle as ghostty-bin.
{pkgs, ...}: {
  home.packages = [
    (
      if pkgs.stdenv.isDarwin
      then pkgs.ghostty-bin
      else pkgs.ghostty
    )
  ];
}
