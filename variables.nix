{ config, lib, ... }: {
  config.var = {
	username = "xavier";
    git = {
      username = "XV1R";
      email = "xavytron@gmail.com";
    };
  };

	options = {
		var = lib.mkOption {
			type = lib.types.attrs;
			default = { };
		};
	};
}
