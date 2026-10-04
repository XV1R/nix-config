# Machine rules — saturn

Guidance for AI coding agents working on this machine. These rules apply in every project.

## Version control: Jujutsu, not git

This machine uses Jujutsu (`jj`) for version control. Repositories may be colocated with git, but agents must not drive git directly.

- Use `jj` for all version control operations: `jj st`, `jj log`, `jj diff`, `jj describe`, `jj commit`, `jj new`, `jj undo`.
- Never run git commands — including `git add` for nix flake visibility. This workspace is deliberately **not** colocated with git, so nix reads the working copy directly and no git plumbing is ever needed. If a tool reports files are "not tracked by Git", the workspace has been re-colocated by mistake; fix the setup instead of running git.

## Declarative configuration only

All persistent configuration on saturn lives in the flake at `~/config`: NixOS in `configuration.nix`, user configuration in `home.nix` (Home Manager as a NixOS module), opencode assets under `opencode/`.

- Change the repo, then rebuild. Never make imperative or manual changes: no `nix-env -i`, `nix profile install`, `nix-channel`, no hand-editing of home-manager-managed files under `~/.config`, no edits to `/etc`.
- opencode customization — agents, skills, `opencode.json`, commands, plugins — is declared under `~/config/opencode/` and linked into place by `home.nix`. Never edit `~/.config/opencode` directly.
- Validate with `nixos-rebuild build --flake ~/config#saturn` before proposing a switch; run `sudo nixos-rebuild switch --flake ~/config#saturn` only after the user approves.
