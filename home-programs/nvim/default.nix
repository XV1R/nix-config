{pkgs, lib, config, ...}:
{
    programs.nvf = {
		enable = true;
		settings = {
			vim = {
                lsp.enable = true;
				lineNumberMode = "relNumber";
				options = {
					tabstop = 4;
					shiftwidth = 4;
					autoindent = true;
                    termguicolors = true;
				};
                ui = {
                    nvim-highlight-colors.enable = true;
                };
				theme = {
					enable = false;
                    #name = "gruvbox";
                    #style = "dark";
				};
				statusline.lualine.enable = true;
				autocomplete.nvim-cmp.enable = true;
				telescope.enable = true;
				languages = {
					enableTreesitter = true;
					nix.enable = true;
                    clang.enable = true;
                    python.enable = true;
				};
                extraPlugins = with pkgs.vimPlugins; {
                    mini-nvim = {
                        package = mini-nvim;
                    };
                };
                luaConfigRC.uchuTheme = ''
                          require('mini.base16').setup({
                            palette = {
                                base00 = "${config.var.uchu.general.yang}",
                                base01 = "${config.var.uchu.yin.light}",
                                base02 = "${config.var.uchu.blue.light}",
                                base03 = "${config.var.uchu.orange.light}",
                                base04 = "${config.var.uchu.gray.dark}",
                                base05 = "${config.var.uchu.general.yin}",
                                base06 = "${config.var.uchu.purple.light}",
                                base07 = "${config.var.uchu.yellow.light}",
                                base08 = "${config.var.uchu.pink.base}",
                                base09 = "${config.var.uchu.orange.base}",
                                base0A = "${config.var.uchu.yellow.dark}",
                                base0B = "${config.var.uchu.green.dark}",
                                base0C = "${config.var.uchu.blue.base}",
                                base0D = "${config.var.uchu.red.base}",
                                base0E = "${config.var.uchu.blue.dark}",
                                base0F = "${config.var.uchu.purple.dark}"
                            }
                          })
                '';
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
