{ lib, ... }:
{
    programs.fish = {
        enable = false;
        generateCompletions = true;
        shellAbbrs = {
            greenfn = "echo this worked lmao";
        };
	shellInit = ''
	if test -e $HOME/.nix-profile/etc/profile.d/nix.sh
    		source $HOME/.nix-profile/etc/profile.d/nix.sh
	end
	'';

    };
}
