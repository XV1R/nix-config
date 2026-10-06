# starship prompt for bash and zsh. Without settings here, Home Manager
# leaves ~/.config/starship.toml to the user.
{
  flake.modules.homeManager.starship = {
    programs.starship.enable = true;
  };
}
