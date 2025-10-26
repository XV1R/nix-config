{pkgs, lib, config, ...}:
let
  fakeBash = pkgs.runCommand "fake-bash" {} "mkdir $out";
in
{
    programs.bash = {
		enable = true;
        package = fakeBash;
        enableCompletion = true;
        historyIgnore = [
            "ls"
            "eza"
            "cd"
            "exit"
        ];
	};
}
