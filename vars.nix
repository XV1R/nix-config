# Personal values shared across modules. Declared as options so any module
# can read them via config.var — this is the proper version of "just a variable".
{lib, ...}: {
  options.var.git = {
    name = lib.mkOption {
      type = lib.types.str;
      description = "Author name for git and jujutsu";
    };
    email = lib.mkOption {
      type = lib.types.str;
      description = "Author email for git and jujutsu";
    };
  };

  config.var = {
    git = {
      name = "XV1R";
      email = "xavytron@gmail.com";
    };
  };
}
