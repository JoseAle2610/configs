# AGENTS.md - System Configuration Authority

## 🎯 Context
This repository contains the central nervous system of the developer's environment. We manage configurations for Neovim (VimL/Lua), Tmux, Zsh/Bash, i3/Niri window managers, and terminal emulators (Alacritty/Kitty). Mediocrity is not tolerated. Every line must have a purpose.

## 🛠 Critical Commands

### 1. Validation & Testing
Since these are configuration files, "testing" means syntax validation and dry runs.
- **Bash/Zsh**: Always validate syntax before committing.
  - `bash -n <file>`
  - `zsh -n <file>`
- **Lua (Neovim)**: Check for syntax errors using headless nvim.
  - `nvim --headless -c "luafile %" -c "qa"`
- **VimScript**:
  - `nvim --headless -c "source %" -c "qa"`
- **JSON (Zed/Alacritty)**:
  - `jq . <file> > /dev/null`

### 2. Deployment
Configurations are managed via symlinks. Refer to `install.sh` for the mapping logic.
- **Dry Run Symlinks**: `ls -la ~/.config/` to verify where links point.
- **Manual Reloads**:
  - Zsh: `source ~/.zshrc`
  - Tmux: `tmux source-file ~/.tmux.conf`
  - i3: `i3-msg reload`
  - Niri: `niri msg action reload-config`

## 📏 Code Style & Standards

### 1. Formatting (Non-Negotiable)
- **Indentation**: 2 spaces. PERIOD. No tabs. No 4 spaces. Look at `nvimlua/lua/settings.lua` or `.vimrc`.
- **Line Length**: Keep it readable. If a command is too long, use `\` for line breaks in shell scripts.
- **EOF**: Ensure files end with a single newline.

### 2. Naming Conventions
- **Shell Scripts**: `kebab-case.sh` (e.g., `focus.sh`, `install-workspace.sh`).
- **Lua Modules**: `snake_case.lua`.
- **Variables**: Descriptive names. Avoid `temp`, `var1`. Use `target_dir`, `config_path`.

### 3. Imports & Structure
- **Neovim (Lua)**: Use the `lua/config/` and `lua/plugins/` structure. Do not bloat `init.lua`.
- **Zsh/Bash**: Use `.bash_aliases` for aliases. Don't pollute the main `.zshrc`.
- **Modularization**: If a config grows over 200 lines, split it (e.g., `niri/dms/binds.kdl`).

### 4. Error Handling & Safety
- **Shell**: Use `set -e` in installation scripts to stop on failure.
- **Idempotency**: Scripts like `install.sh` must be runnable multiple times without breaking things. Use `mkdir -p` and `ln -sf`.
- **Backups**: Before overwriting a non-symlinked file, check if it's tracked in git. If not, WARN the user.

## 🧠 Architectural Philosophy
- **KISS (Keep It Simple, Stupid)**: Don't add a plugin if a 5-line script can do it.
- **Why > What**: Comments should explain *why* a specific setting exists, especially if it's a workaround for a bug.
- **Modern Tools First**: Prefer `eza` over `ls`, `rg` over `grep`, `bat` over `cat`, and `fd` over `find`. These are already mapped in `.bash_aliases`.

## 🤖 Agent Instructions
- **Jarvis Mode**: You are a collaborative partner. If you see a configuration that contradicts another, call it out.
- **No Shortcuts**: Do not suggest "quick fixes" that leave the system in an unstable state.
- **Documentation**: If you add a new tool config, update `README.md` or this file if necessary.

---
"La calidad no es un acto, es un hábito." - No me falles, pibe.
