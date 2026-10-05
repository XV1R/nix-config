{
  flake.modules.homeManager.helix = {...}: let
    # uchū palette (https://github.com/NeverCease/uchu), hex-converted
    uchu = builtins.fromJSON (builtins.readFile ./uchu.json);
    inherit (uchu.general) yang yin;
    inherit
      (uchu)
      blue
      gray
      green
      pink
      purple
      orange
      red
      yellow
      ;
  in {
    programs.helix = {
      enable = true;
      settings.theme = "uchu";

      themes.uchu = {
        # Light mode: yang background, contrast from the .dark variants
        # NOTE: ui.background must set `bg` explicitly — a bare string only sets
        # the style's foreground, and nothing would paint the background.
        # --- UI ---
        "ui.background" = {
          bg = yang;
          fg = yin;
        };
        "ui.background.separator" = gray.light;
        "ui.cursor" = {
          bg = yin;
          fg = yang;
        };
        "ui.cursor.match" = {bg = blue.light;};
        "ui.cursorline.primary" = {bg = gray.light;};
        "ui.linenr" = gray.base;
        "ui.linenr.selected" = gray.dark;
        "ui.statusline" = {
          bg = gray.light;
          fg = yin;
        };
        "ui.statusline.normal" = {
          bg = gray.light;
          fg = yin;
        };
        "ui.statusline.insert" = {
          bg = green.dark;
          fg = yang;
        };
        "ui.statusline.select" = {
          bg = purple.base;
          fg = yang;
        };
        "ui.popup" = {
          bg = gray.light;
          fg = yin;
        };
        "ui.menu" = {
          bg = gray.light;
          fg = yin;
        };
        "ui.menu.selected" = {
          bg = blue.base;
          fg = yang;
        };
        "ui.selection" = {bg = blue.light;};
        "ui.virtual.whitespace" = gray.light;
        "ui.virtual.ruler" = {bg = gray.light;};
        "ui.virtual.wrap" = gray.base;
        "ui.window" = gray.light;
        "ui.help" = {
          bg = gray.light;
          fg = yin;
        };

        # --- syntax ---
        attribute = purple.base;
        comment = {
          fg = gray.dark;
          modifiers = ["italic"];
        };
        constant = orange.dark;
        "constant.builtin" = purple.dark;
        "constant.character.escape" = green.dark;
        constructor = yellow.dark;
        function = blue.base;
        "function.builtin" = pink.dark;
        "function.macro" = pink.dark;
        keyword = pink.dark;
        "keyword.control" = pink.dark;
        label = yellow.dark;
        namespace = blue.dark;
        operator = gray.dark;
        punctuation = gray.dark;
        "punctuation.delimiter" = gray.dark;
        special = pink.dark;
        string = green.dark;
        "string.special" = orange.base;
        tag = pink.dark;
        type = yellow.dark;
        "type.builtin" = yellow.dark;
        variable = yin;
        "variable.builtin" = purple.base;
        "variable.parameter" = blue.dark;

        # --- markup ---
        "markup.heading" = yellow.dark;
        "markup.bold" = {
          fg = yin;
          modifiers = ["bold"];
        };
        "markup.italic" = {
          fg = pink.dark;
          modifiers = ["italic"];
        };
        "markup.link" = blue.base;
        "markup.link.text" = blue.dark;
        "markup.quote" = gray.dark;
        "markup.raw" = green.dark;

        # --- diagnostics ---
        error = red.base;
        warning = yellow.dark;
        info = blue.base;
        hint = green.dark;
        "diagnostic.error" = {
          fg = red.base;
          modifiers = ["underlined"];
        };
        "diagnostic.warning" = {
          fg = yellow.dark;
          modifiers = ["underlined"];
        };
        "diagnostic.info" = {
          fg = blue.base;
          modifiers = ["underlined"];
        };
        "diagnostic.hint" = {
          fg = green.dark;
          modifiers = ["underlined"];
        };
      };

      themes."uchu-dark" = {
        # Dark mode: yin background, vivid .base variants
        # --- UI ---
        "ui.background" = {
          bg = yin;
          fg = gray.base;
        };
        "ui.background.separator" = gray.dark;
        "ui.cursor" = {
          bg = yang;
          fg = yin;
        };
        "ui.cursor.match" = {bg = blue.dark;};
        "ui.cursorline.primary" = {bg = "#10141b";};
        "ui.linenr" = gray.dark;
        "ui.linenr.selected" = gray.base;
        "ui.statusline" = {
          bg = "#10141b";
          fg = gray.base;
        };
        "ui.statusline.normal" = {
          bg = "#10141b";
          fg = gray.base;
        };
        "ui.statusline.insert" = {
          bg = green.base;
          fg = yin;
        };
        "ui.statusline.select" = {
          bg = purple.base;
          fg = yin;
        };
        "ui.popup" = {
          bg = "#10141b";
          fg = gray.base;
        };
        "ui.menu" = {
          bg = "#10141b";
          fg = gray.base;
        };
        "ui.menu.selected" = {
          bg = blue.base;
          fg = yin;
        };
        "ui.selection" = {bg = blue.dark;};
        "ui.virtual.whitespace" = gray.dark;
        "ui.virtual.ruler" = {bg = "#10141b";};
        "ui.virtual.wrap" = gray.dark;
        "ui.window" = gray.dark;
        "ui.help" = {
          bg = "#10141b";
          fg = gray.base;
        };

        # --- syntax ---
        attribute = purple.base;
        comment = {
          fg = gray.dark;
          modifiers = ["italic"];
        };
        constant = orange.base;
        "constant.builtin" = pink.base;
        "constant.character.escape" = green.base;
        constructor = yellow.base;
        function = blue.base;
        "function.builtin" = pink.base;
        "function.macro" = pink.base;
        keyword = pink.base;
        "keyword.control" = pink.base;
        label = yellow.base;
        namespace = blue.light;
        operator = pink.base;
        punctuation = gray.base;
        "punctuation.delimiter" = gray.dark;
        special = pink.base;
        string = green.base;
        "string.special" = orange.base;
        tag = pink.base;
        type = yellow.base;
        "type.builtin" = yellow.base;
        variable = gray.base;
        "variable.builtin" = purple.base;
        "variable.parameter" = blue.light;

        # --- markup ---
        "markup.heading" = yellow.base;
        "markup.bold" = {
          fg = yang;
          modifiers = ["bold"];
        };
        "markup.italic" = {
          fg = pink.base;
          modifiers = ["italic"];
        };
        "markup.link" = blue.base;
        "markup.link.text" = blue.light;
        "markup.quote" = gray.dark;
        "markup.raw" = green.base;

        # --- diagnostics ---
        error = red.base;
        warning = yellow.base;
        info = blue.base;
        hint = green.base;
        "diagnostic.error" = {
          fg = red.base;
          modifiers = ["underlined"];
        };
        "diagnostic.warning" = {
          fg = yellow.base;
          modifiers = ["underlined"];
        };
        "diagnostic.info" = {
          fg = blue.base;
          modifiers = ["underlined"];
        };
        "diagnostic.hint" = {
          fg = green.base;
          modifiers = ["underlined"];
        };
      };

      languages.language = [
        {
          name = "nix";
          auto-format = true;
          formatter = {
            command = "alejandra";
            args = ["-"];
          };
        }
      ];
    };
  };
}
