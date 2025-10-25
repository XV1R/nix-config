{config, pkgs, ...}: {
	imports = [
	    ./variables.nix
	    ./home-programs/git
	    ./home-programs/nvim
        ./home-programs/bash
        ./home-programs/lazy-git
        ./home-programs/zoxide
        ./home-programs/fzf
        ./home-programs/zellij
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
            glow
		];
        shellAliases = {
            g = "git";
            c = "z";
            ls = "exa --group-directories-first";
            l = "ls";
            ll = "ls -T";
            j = "just";
            copy = "xclip -sel clip";
            ".." = "cd ..";
            "md" = "glow";
        };
        sessionVariables = {
            EDITOR = "neovim";
        };
	shell.enableBashIntegration = true;
		stateVersion = "24.05";
	};
    programs.home-manager.enable = true;
}
