{pkgs, lib, config, ...}@inputs:
{
	programs.nvf = {
		enable = true;
		settings = {
			vim = {
				theme = {
						enable = true;
						name = "gruvbox";
						style = "dark";
				};
				statusline.lualine.enable = true;
				autocomplete.nvim-cmp.enable = true;
				telescope.enable = true;
				languages = {
					enableLSP = true;
					enableTreesitter = true;
					nix.enable = true;
				};
			};
		};
	};
}
