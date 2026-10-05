# devenv CLI for project environments (each repo's devenv.nix is separate),
# plus the binary caches that serve devenv and its cachix dependency.
{
  flake.modules.darwin.devenv = {pkgs, ...}: {
    environment.systemPackages = [pkgs.devenv];

    nix.settings = {
      extra-substituters = ["https://devenv.cachix.org" "https://cachix.cachix.org"];
      extra-trusted-public-keys = [
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
        "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
      ];
    };
  };
}
