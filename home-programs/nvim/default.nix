{pkgs, lib, config, ...}:
{
    programs.nvf = {
		enable = true;
		settings = {
			vim = {
				lineNumberMode = "relative";
				options = {
					tabstop = 4;
					shiftwidth = 4;
					autoindent = true;
				};
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
