# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal dotfiles repository containing configurations for Neovim, tmux, and zsh. The setup is designed for macOS development environments with Homebrew as the package manager.

## Installation and Setup

### Full MacOS Setup
```bash
./install.sh --macos
```
This installs all dependencies (Homebrew, iTerm2, zsh, oh-my-zsh, neovim, tmux, etc.) and links dotfiles.

### Link Dotfiles Only
```bash
./install.sh --dotfiles
```
Creates symlinks for all configuration files without installing dependencies.

### dbt Development
```bash
./install.sh --dbt
```
Installs the [dbt language server](https://github.com/j-clemons/dbt-language-server) (`~/.local/bin/dbt-language-server`) for dbt autocomplete/go-to-definition in Neovim. See the "dbt Support" section below for how highlighting, LSP, and formatting are wired up.

### Verify Installation
```bash
./install.sh --check
```
Checks if all tools are installed and configurations are properly linked.

### Dry Run
```bash
./install.sh --dry-run --macos
```
Shows what would be installed/changed without making any modifications.

## Repository Structure

### Neovim Configuration (`nvim/`)
Based on kickstart.nvim with modular plugin organization:
- `init.lua` - Entry point, loads core modules
- `lua/options.lua` - Editor options and settings
- `lua/keymaps.lua` - Key bindings and custom commands
- `lua/auto_commands.lua` - Auto commands
- `lua/plugins.lua` - Lazy.nvim plugin manager setup
- `lua/plugins/` - Modular plugin configurations:
  - `language.lua` - LSP, linters, formatters (Mason, nvim-lspconfig, conform.nvim, nvim-lint)
  - `navigation.lua` - Telescope, fzf, file navigation
  - `appearance.lua` - Color schemes, UI plugins
  - `file_explorer.lua` - File explorer configuration
  - `git.lua` - Git integration plugins
  - `utilities.lua` - Misc utility plugins
- `lua/utils/` - Utility modules:
  - `diagnostics.lua` - LSP/formatter/linter diagnostic helpers

Plugin manager: [lazy.nvim](https://github.com/folke/lazy.nvim)

### Language Support Configuration
- **LSP servers**: `pylsp` (Python), `bashls` (Bash), `terraformls` (Terraform), `lua_ls` (Lua), `gh_actions_ls` (GitHub Actions YAML), plus `dbt` (dbt language server, enabled only when its binary is on `$PATH` — see "dbt Support")
- **Formatters**: stylua (Lua), shfmt (Bash/sh), black (Python), sqlfluff (SQL/dbt), yamlfmt (YAML)
- **Linters**: Configured per-filetype in `lua/plugins/language.lua`

Tools are managed via Mason (`:Mason` to open). All LSP/linter/formatter configs are in `lua/plugins/language.lua:1-47`.

**Note:** Variable name was corrected from `forrmater_config` to `formatter_config` in the language configuration.

### dbt Support (Neovim)
dbt projects (detected via a `dbt_project.yml` ancestor) get three features, all configured in `lua/plugins/language.lua`:

1. **Syntax highlighting (`.sql` + Jinja):** The `jinja` Treesitter parser is registered as the root language for `sql`-filetype buffers (`vim.treesitter.language.register('jinja', 'sql')`). Jinja highlights `{{ ... }}` / `{% ... %}` (e.g. `ref()`, `source()` render as function calls), and SQL is injected into the surrounding text via `nvim/after/queries/jinja/injections.scm`. Plain (non-dbt) `.sql` files parse as a single injected SQL region, so they keep full SQL highlighting. Treesitter indent is disabled for `sql`/`jinja` (sqlfluff handles formatting). Requires the `sql`, `jinja`, and `jinja_inline` parsers.
2. **LSP autocomplete:** `dbt-language-server` is registered under the config name `dbt` (filetypes `sql`, `yaml`; root marker `dbt_project.yml`). It only enables when the binary is on `$PATH` (install via `./install.sh --dbt`). Provides completion for `ref()`/`source()`/seeds/macros/vars, hover, and go-to-definition.
3. **Format on save:** `.sql` → `sqlfluff`, `.yml` → `yamlfmt` (both via conform.nvim). The `sqlfluff` formatter prefers the dbt project's own `.venv/bin/sqlfluff` (falling back to the Mason-installed one), runs from the project root so the project's `.sqlfluff` is honored, and passes `--templater jinja` so formatting works offline without a warehouse connection (sqlfluff's `apply_dbt_builtins` mocks `ref`/`source`/`config`/`var`). To honor a project's `dbt` templater exactly instead, remove the `--templater jinja` arg (slower; requires dbt + a profile).

**Per-project tooling:** Install `sqlfluff` and `dbt` inside each dbt project's virtualenv (e.g. `uv sync`); Neovim automatically prefers `<project>/.venv/bin/sqlfluff`.

### Custom Neovim Commands
All diagnostic commands use the centralized utility module at `lua/utils/diagnostics.lua`:
- `:CheckLSP` - Show active LSP servers for current buffer
- `:CheckFormatter` - Show available formatters for current filetype
- `:CheckLinter` - Show configured linters for current filetype
- `:JupyterOpen` - Open current .ipynb file in Jupyter Lab

### Tmux Configuration (`tmux/`)
- `tmux.conf` - Main tmux configuration
- `tmux-sessionizer` - Custom session manager script (fuzzy finder for projects)
  - Keybind: `Ctrl+a f` in tmux or `Ctrl+f` in Neovim
  - Searches directories in `~/` and `~/projects` by default
  - Configure via `~/.config/tmux-sessionizer/tmux-sessionizer.conf`

### Zsh Configuration (`zsh/`)
**Modular structure:**
- `zshrc` - Main configuration file that sources other modules
- `aliases.zsh` - Command aliases (vim, reload, fcd, pcd, glog, lsl)
- `path.zsh` - PATH configuration
- `tools.zsh` - Tool-specific configurations (fzf, zoxide, nvm, tmux-sessionizer)
- `zshrc.local` - Optional local overrides (not tracked by git)

**Theme:** Dracula (from `schemes/`)
**Plugins:** git, zsh-autosuggestions
**Default editor:** `nvim`
**Key integrations:**
  - fzf with ag (silver searcher) as default
  - zoxide for smart directory jumping
  - tmux-sessionizer bound to `Ctrl+f`

**Linking:** Both `~/.config/zsh` directory and `~/.zshrc` are symlinked. The zshrc uses relative paths to source module files.

## Common Aliases
```bash
vim="nvim"
reload="source ~/.zshrc"
fcd='cd $(find . -type d -print | fzf)'  # cd to directory via fzf
pcd='cd $(find ~/projects -type d -name ".git" -prune -exec dirname {} \; | fzf)'  # cd to project
glog='git log --graph --oneline --decorate --all'
```

## Key Dependencies
- **Neovim**: Latest stable/nightly
- **tmux**: Terminal multiplexer with TPM (Tmux Plugin Manager)
- **fzf**: Fuzzy finder
- **ag (the_silver_searcher)**: Fast file/content search
- **zoxide**: Smart cd command
- **nvm**: Node Version Manager (for Claude Code installation)
- **flashspace**: Workspace manager for macOS

## Development Notes

### Modifying Neovim Configuration
- When adding LSP servers, update `lsp_servers_config` in `lua/plugins/language.lua`
- When adding formatters, update `formatter_config` in `lua/plugins/language.lua`
- When adding linters, update `linter_config` in `lua/plugins/language.lua`
- Plugins are organized by category in separate files under `lua/plugins/`
- Utility functions are in `lua/utils/` (e.g., diagnostic helpers)
- Use `:Lazy` to manage plugins, `:Lazy update` to update all

### Local Overrides
Create local machine-specific configurations without tracking them in git:
- `zsh/zshrc.local` - Custom zsh configuration
- `nvim/lua/local.lua` - Custom Neovim configuration (if needed)

These files are automatically sourced if they exist and are ignored by git.

### Shell Linting
The repository uses shellcheck for bash scripts. `install.sh` has been configured with linting rules.

### EditorConfig
The `.editorconfig` file enforces consistent coding styles across files:
- Space indentation (2 spaces) for sh, lua, py, tf, js, ts, yaml/yml
- UTF-8 encoding, LF line endings, final newline
- Markdown files preserve trailing whitespace