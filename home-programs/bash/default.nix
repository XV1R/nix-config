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
        initExtra = ''
        if [ -f "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
            . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
        fi
        '';
	};
}
