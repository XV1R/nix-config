{config, pkgs, ...}: {
	imports = [
	    ./variables.nix
	    ./home-programs/git
	    ./home-programs/nvim
        ./home-programs/bash
        ./home-programs/lazy-git
        ./home-programs/starship
        ./home-programs/zoxide
        ./home-programs/fzf
       # ./home-programs/fish
	];

	home = {
		inherit (config.var) username;
		homeDirectory = "/home/" + config.var.username;
		
		packages = with pkgs; [
		    ripgrep
			eza
            just
            dua
            jq
		];
        shellAliases = {
            g = "git";
            c = "z";
            ls = "exa --icons=always --group-directories-first";
            l = "ls";
            ll = "ls -T";
            j = "just";
            ".." = "cd ..";
        };
        sessionVariables = {
            EDITOR = "neovim";
        };
        #shell.enableFishIntegration = true;
	shell.enableBashIntegration = true;
		stateVersion = "24.05";
	};
    programs.home-manager.enable = true;
}
