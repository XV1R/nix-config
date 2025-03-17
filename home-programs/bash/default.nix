{pkgs, lib, config, ...}:
{
    programs.bash = {
		enable = true;
        enableCompletion = true;
        shellAliases =  {
            #ls ="eza --icons=always --group-directories-first";
            #l = "eza -l"; 
            #".." = "cd ..";
        };
        historyIgnore = [
            "ls"
            "eza"
            "cd"
            "exit"
        ];
	};
}
