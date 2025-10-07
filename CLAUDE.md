# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository managed by [chezmoi](https://chezmoi.io/). It contains configuration files for development tools, shell environments, and applications that are synchronized across machines.

## Key Commands

### Chezmoi Management
- `chezmoi apply` - Apply all managed files to their target locations
- `chezmoi diff` - Show differences between source and target files
- `chezmoi status` - Show which files have changed
- `chezmoi edit <file>` - Edit a managed file (e.g., `chezmoi edit ~/.zshrc`)
- `chezmoi add <file>` - Add a new file to be managed by chezmoi

### Development Environment
- Shell configuration is in `dot_zshrc` which sets up:
  - Development tools (mise, uv, pnpm, fzf, codex)
  - Cloud tools (Google Cloud SDK)
  - Java environment (SDKMAN)
  - SCM Breeze for git shortcuts

## Repository Structure

- `dot_*` files map to dotfiles in the home directory (e.g., `dot_zshrc` → `~/.zshrc`)
- `.chezmoi.toml.tmpl` - Template for chezmoi configuration with user prompts
- `dot_config/` - Contains application configurations:
  - `doom/` - Doom Emacs configuration (packages.el, config.el, init.el)
  - `zed/` - Zed editor settings with Python/Swift language servers configured
  - `taplo/` - TOML formatter configuration
- `run_once_*.sh` - Scripts that run once during chezmoi apply (e.g., SCM Breeze setup)

## Configuration Templates

The repository uses chezmoi templates with variables:
- Email and name are prompted during initial setup via `.chezmoi.toml.tmpl`
- Git configuration in `dot_gitconfig.tmpl` uses these template variables

## Important Notes

- Files prefixed with `dot_` become hidden dotfiles when applied (dot_ → .)
- Template files (`.tmpl` extension) are processed by chezmoi before application
- The zsh configuration includes conditional loading for Claude Code environment (`CLAUDECODE` variable)
- SCM Breeze is disabled when running in Claude Code to avoid conflicts
