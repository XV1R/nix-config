{config, pkgs, ...}: {
	imports = [
		./variables.nix
		./home-programs/git
		./home-programs/nvim
        ./home-programs/bash
        #        ./home-programs/fish
	];

	home = {
		inherit (config.var) username;
		homeDirectory = "/home/" + config.var.username;
		
		packages = with pkgs; [
		    ripgrep
			eza
            just
            dua
		];
        shellAliases = {
            g = "git";
            ls = "exa --icons=always --group-directories-first";
            ".." = "cd ..";
        };
        sessionVariables = {
            EDITOR = "neovim";
        };
        #shell.enableFishIntegration = true;
		stateVersion = "24.05";
	};
    programs.home-manager.enable = true;
}
