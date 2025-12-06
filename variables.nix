{ config, lib, ... }: {
    config.var = {
        username = "xavier";
        git = {
            username = "XV1R";
            email = "xavytron@gmail.com";
        };

        uchu = lib.importJSON ./uchu.json;
  };

	options = {
		var = lib.mkOption {
			type = lib.types.attrs;
			default = { };
		};
	};
}
