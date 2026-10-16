# Tools for Profound work: secrets handling and database access.
{pkgs, ...}: {
  home.packages = with pkgs; [
    dotenvx
    gitleaks # secret scanner
    # psql and friends; nixpkgs' libpq ships only the library. Matches the
    # major version of the Homebrew libpq it replaces.
    postgresql_18
  ];
}
