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
                    clang.enable = true;
                    python.enable = true;
				};
                keymaps = [
                    {
                        key = "<leader>ff";
                        mode = "n";
                        silent = true;
                        action = "<cmd>Telescope find_files<cr>";
                    }
                    {
                        key = "<leader>fg";
                        mode = "n";
                        silent = true;
                        action = "<cmd>Telescope live_grep<cr>";
                    }
                    {
                        key = "<leader>fb";
                        mode = "n";
                        silent = true;
                        action = "<cmd>Telescope buffers<cr>";
                    }
                    {
                        key = "<leader>fh";
                        mode = "n";
                        silent = true;
                        action = "<cmd>Telescope help_tags<cr>";
                    }
                ];
			};
		};
	};
}
