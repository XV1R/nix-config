# Machine rules — saturn

Guidance for AI coding agents working on this machine. These rules apply in every project.

## Version control: Jujutsu, not git

This machine uses Jujutsu (`jj`) for version control. Repositories may be colocated with git, but agents must not drive git directly.

- Use `jj` for all version control operations: `jj st`, `jj log`, `jj diff`, `jj describe`, `jj commit`, `jj new`, `jj undo`.
- Never run mutating git commands (`git add`, `git commit`, `git push`, `git checkout`, `git restore`, ...).
- Narrow exception: nix flakes can only read git-tracked files, so after creating new files inside a nix flake repository, `git add <paths>` may be needed purely as build plumbing so evaluation can see them. This is not version control — jj tracks the working copy automatically. Use `jj describe`/`jj commit`/`jj new` for all history operations.

## Declarative configuration only

All persistent configuration on saturn lives in the flake at `~/config`: NixOS in `configuration.nix`, user configuration in `home.nix` (Home Manager as a NixOS module), opencode assets under `opencode/`.

- Change the repo, then rebuild. Never make imperative or manual changes: no `nix-env -i`, `nix profile install`, `nix-channel`, no hand-editing of home-manager-managed files under `~/.config`, no edits to `/etc`.
- opencode customization — agents, skills, `opencode.json`, commands, plugins — is declared under `~/config/opencode/` and linked into place by `home.nix`. Never edit `~/.config/opencode` directly.
- Validate with `nixos-rebuild build --flake ~/config#saturn` before proposing a switch; run `sudo nixos-rebuild switch --flake ~/config#saturn` only after the user approves.
