# Repository Guidelines

## Project Structure & Module Organization
- dotfiles: Files prefixed with `dot_` map to home dotfiles (e.g., `dot_zshrc` → `~/.zshrc`, `dot_gitconfig.tmpl` → `~/.gitconfig`).
- app configs: `dot_config/<app>/` stores tool settings (e.g., `dot_config/doom`, `dot_config/zed`, `dot_config/taplo`).
- templates: Files ending in `.tmpl` use chezmoi templating and prompt variables defined in `.chezmoi.toml.tmpl`.
- bootstrap scripts: `run_once_*.sh` execute a single time on apply (keep them idempotent).

## Build, Test, and Development Commands
- `chezmoi status`: Show tracked changes vs target system.
- `chezmoi diff`: Review pending changes before applying.
- `chezmoi apply`: Apply all changes to the home directory.
- `chezmoi apply --dry-run --verbose`: Safe preview of actions.
- `chezmoi edit <target>`: Edit a managed file (e.g., `chezmoi edit ~/.zshrc`).
- `chezmoi add <target>`: Start managing a new file (e.g., `chezmoi add ~/.gitconfig`).

## Coding Style & Naming Conventions
- mapping: Use `dot_<name>` for files in `$HOME` and `dot_config/<app>` for config folders.
- templates: Prefer `.tmpl` for files requiring per-host/user values.
- shell: Use POSIX sh where possible; if Bash required, add `#!/usr/bin/env bash`, `set -euo pipefail`, and 2‑space indents.
- zsh: Keep aliases/functions in `dot_zshrc`; prefer small, readable functions over long one‑liners.
- scripts: Name bootstrap scripts `run_once_<task>.sh`; make them rerunnable without side effects.

## Testing Guidelines
- validate: Run `chezmoi diff` before `chezmoi apply`.
- dry runs: Use `chezmoi apply --dry-run` on new machines first.
- scope: Test changes in an isolated shell (`zsh -f` or a new terminal) before global adoption.
- coverage: If editing editor/IDE configs, open the app once to verify it picks up changes.

## Commit & Pull Request Guidelines
- messages: Imperative mood, concise summary; include scope when useful (e.g., `zsh: speed up fzf init`, `doom: add lsp tweaks`).
- atomicity: One logical change per commit; avoid bundling unrelated updates.
- PRs: Include a summary, rationale, `chezmoi diff` snippet, and any screenshots for UI‑facing configs.

## Security & Configuration Tips
- secrets: Do not commit secrets. Prefer templating with environment variables or integrate a secret backend if needed.
- safety: Keep `run_once_*` scripts idempotent and avoid destructive commands; gate network/actions behind checks.
- portability: Favor cross‑platform paths and conditionals in templates (Darwin/Linux guards) to keep setups reproducible.

