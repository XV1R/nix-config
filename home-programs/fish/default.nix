{}:
{
    programs.fish = {
        enable = true;
        generateCompletions = true;
        shellAbbrs = {
            ls = "exa --icons=always --group-directories-first";
            l = "exa -l";
            ".." = "cd ..";
        };
    };
}
