{ pkgs, lib, config, ... }:

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

        ui.nvim-highlight-colors.enable = true;

        # Disable NVF's theme system
        theme.enable = false;

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
          mini-nvim = { package = mini-nvim; };
        };

        # Run LAST
        luaConfigRC.brogrammer = ''
          local p = {
            base00 = "${config.var.brogrammer.base00}", -- #131313
            base01 = "${config.var.brogrammer.base01}", -- #1f1f1f
            base02 = "${config.var.brogrammer.base02}",
            base03 = "${config.var.brogrammer.base03}", -- #b9b9b9
            base04 = "${config.var.brogrammer.base04}",
            base05 = "${config.var.brogrammer.base05}", -- #d6dbe5
            base06 = "${config.var.brogrammer.base06}", -- #ffffff
            base07 = "${config.var.brogrammer.base07}",

            base08 = "${config.var.brogrammer.base08}",
            base09 = "${config.var.brogrammer.base09}",
            base0A = "${config.var.brogrammer.base0A}",
            base0B = "${config.var.brogrammer.base0B}",
            base0C = "${config.var.brogrammer.base0C}",
            base0D = "${config.var.brogrammer.base0D}",
            base0E = "${config.var.brogrammer.base0E}",
            base0F = "${config.var.brogrammer.base0F}",
          }

          require('mini.base16').setup({ palette = p })

          -- Hard force core groups so nothing looks "unstyled"
          vim.api.nvim_set_hl(0, "Normal",   { fg = p.base05, bg = p.base00 })
          vim.api.nvim_set_hl(0, "NormalNC", { fg = p.base05, bg = p.base00 })
          vim.api.nvim_set_hl(0, "EndOfBuffer", { fg = p.base00, bg = p.base00 })

          vim.api.nvim_set_hl(0, "Visual", {
            bg = "${config.var.brogrammer.selection.background}",
            fg = "${config.var.brogrammer.selection.foreground}",
          })

          vim.api.nvim_set_hl(0, "Cursor", {
            fg = "${config.var.brogrammer.cursor.text}",
            bg = "${config.var.brogrammer.cursor.color}",
          })

          -- Brogrammer-style comments
          vim.api.nvim_set_hl(0, "Comment", { fg = p.base03, italic = true })
        '';

        keymaps = [
          { key = "<leader>ff"; mode = "n"; silent = true; action = "<cmd>Telescope find_files<cr>"; }
          { key = "<leader>fg"; mode = "n"; silent = true; action = "<cmd>Telescope live_grep<cr>"; }
          { key = "<leader>fb"; mode = "n"; silent = true; action = "<cmd>Telescope buffers<cr>"; }
          { key = "<leader>fh"; mode = "n"; silent = true; action = "<cmd>Telescope help_tags<cr>"; }
        ];
      };
    };
  };
}

