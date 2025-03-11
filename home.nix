{config, pkgs, ...}: {
    home.username = "xavier";
    home.homeDirectory = "/home/xavier";
    home.stateVersion = "24.05"; # To figure this out you can comment out the line and see what version it expected.
    home.packages = [
        pkgs.ripgrep
    ];
    programs.home-manager.enable = true;

	programs.git = {
		enable = true;
		userName = "xv1r";
		userEmail = "xavytron@gmail.com";
		extraConfig = {
			init.defaultBranch = "main";
			push.autoSetupRemote = true;
			color.ui = "1";
		};
		aliases = {
			oops = "checkout --";
		};
	};
}
