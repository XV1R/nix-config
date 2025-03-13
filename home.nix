{config, pkgs, ...}: {
	imports = [
		./variables.nix
		./home-programs/git
		./home-programs/nvim
	];

	home = {
		inherit (config.var) username;
		homeDirectory = "/home/" + config.var.username;
		packages = [
			pkgs.ripgrep
		];
		stateVersion = "24.05";
	};
    programs.home-manager.enable = true;
}
