# Agent Reference Guide

This document provides context for AI coding agents working in this dotfiles repository. Read this to understand the environment, conventions, and constraints you'll be operating under.

## Repository Context

This is a personal dotfiles repository for a Linux/macOS development environment. The primary user (XavierChanth) uses:
- **Version Control:** Jujutsu (jj) colocated with git
- **Terminal:** Ghostty
- **Multiplexer:** tmux
- **Editor:** Neovim with custom lazy-loading
- **Window Manager:** Sway (Wayland) on Linux, Aerospace on macOS
- **Shell:** zsh

## Critical Constraints

### Protected Directories
**NEVER modify these paths** (enforced by Claude Code settings):
- `.jj/` - Jujutsu version control state
- `.git/` - Git version control state
- `.env` and `.env.*` - Environment secrets
- `secrets/**` - Credential storage
- `config/credentials.json` - API keys

### Version Control Workflow
- Main branch is called `trunk()` not main/master
- User creates changes from trunk: `jj new trunk()`
- Private commits use `wip:*` or `private:*` description prefixes
- Git push creates bookmarks like `xc-<change_id>`
- Commits are signed with SSH key
- **NEVER use**: `jj op undo`, `jj op restore`, `jj op abandon` (operation log is sacred)

### File Organization
The repository uses GNU Stow naming convention:
- `dotfiles/dot-config/` → `~/.config/`
- `dotfiles/dot-local/` → `~/.local/`
- `dotfiles/dot-zshrc` → `~/.zshrc`

Subdirectories:
- `dotfiles/` - User configuration files (stowed to $HOME)
- `scripts/` - Server/deployment scripts (not stowed)
- `linux/` - Linux system files (installed to /, not stowed)
- `macos/` - macOS system files
- `keyboards/` - QMK keyboard firmware
- `.work/` - JJ workspaces for isolated development
- `graveyard/` - Deprecated configurations

## Development Environment

### Neovim Configuration

**Location:** `dotfiles/dot-config/nvim/`

**Architecture:**
- Custom package manager at `lua/utils/pack.lua`
- Plugin specs in `lua/assets/pack-spec.lua`
- Lazy-loading by filetype for performance
- LSP loads on `VimEnter` event

**Key bindings:**
- Leader: `<Space>`
- Local leader: `\`
- Window commands: `<leader>w` + standard Vim keys
- Split shortcuts: `<leader>-` (horizontal), `<leader>\` (vertical)

**Plugin highlights:**
- `harpoon`: Auto-tracks buffers (excludes `oil://`, `.jjdescription`, `/tmp/`)
- `oil.nvim`: File explorer (replaces netrw)
- `conform.nvim`: Code formatting
- `nvim-lint`: Linting
- LSP: Language-specific servers
- `mini.nvim`: Multiple utilities (ai, diff, icons)

**When editing Neovim config:**
- Respect the lazy-loading architecture
- Place plugin configs in `lua/config/<plugin>.lua`
- Update `lua/assets/pack-spec.lua` for new plugins
- Don't load heavy plugins at startup

### Ghostty Terminal

**Location:** `dotfiles/dot-config/ghostty/`

**Key settings:**
- Auto-launches: `tmux new -A -s main`
- Theme: Auto-switches dark/light (tokyonight-storm / Flexoki Light)
- Font: CommitMono Nerd Font with features +cv07,+ss03,+ss04,+ss05
- Super+1-9: Maps to tmux window switching
- Hyper key (Ctrl+Alt+Super+Shift): Maps to tmux prefix commands

**Integration:**
Ghostty is tightly integrated with tmux. Most keybindings pass through to tmux. See `tmux-binds` file for terminal-to-tmux mappings.

### Tmux Configuration

**Location:** `dotfiles/dot-config/tmux/`

**Structure:**
```
tmux.conf      # Main entry (sources everything)
├── env.conf       # Environment variables
├── opts.conf      # Tmux options
├── vim.conf       # Vim-style navigation
├── keymaps.conf   # Custom keybindings
├── history.conf   # History settings
├── plugins.conf   # TPM plugins
├── server.conf    # Server options
└── theme.conf     # Visual theme (must load last)
```

**Important keybindings:**
- `prefix+l` - Launches Claude Code agent window
- `prefix+g` - Launches jj-term window
- `prefix+a` - Opens fzf session selector popup
- `prefix+w` - Opens fzf jj workspace creator popup
- `prefix+e` - Equal layout distribution

**When modifying:**
- Keep modular structure (separate .conf files)
- Theme must load after plugins
- Maintain 85% popup size for consistency
- Window positioning: jj-term and agent-term have specific positions

### Sway Window Manager

**Location:** `dotfiles/dot-config/sway/config`

**Key information:**
- Primary mod: Alt
- Secondary mod: Super
- Terminal: ghostty
- Browser: helium-browser (primary), google-chrome-stable (fallback)
- Display: Built-in is eDP-1 at 2880x1920@120Hz, scale 2
- Gaps: 8px inner and outer
- No window borders by default

**Auto-behavior:**
- Locks after 5 minutes idle
- Suspends after 30 minutes
- Clamshell mode (turns off built-in display when lid closed)
- Idle inhibit when fullscreen

**When modifying:**
- Vim-style hjkl navigation is standard
- External displays default to scale 2, positioned at 1440,0
- Built-in display config must come after wildcard config
- Use waybar for status bar (not swaybar)

## Automation Scripts

### Key Scripts in `dotfiles/dot-local/bin/`

**agent**
- Wrapper for Claude Code
- Sets EDITOR=nvim
- Usage: `agent` or `agent <args>`

**agent-term**
- Tmux integration for Claude Code
- Creates/switches to "agent-" window
- Opens at git repo root
- Positions after jj-term if present, else at position 2

**fzf_session**
- Fuzzy project selector
- Searches: `$projects_dir`, `~/.dotfiles`, `.work/` directories
- Platform-aware: checks `/Volumes/xcdata/src`, `/mnt/xcdata/src`, `~/src`

**fzf_jj_session**
- Creates new jj workspace in `.work/<name>`
- Interactive project selection + workspace naming
- Automatically creates tmux session for new workspace

**jj-term**
- Dedicated tmux window for jj operations
- Similar to agent-term but for version control

### When Writing Scripts

Follow existing patterns:
- Use `#!/usr/bin/env bash` shebang
- Source `include.d/tmux_session.sh` for session helpers
- Platform detection: check for `/Volumes/` (macOS) vs `/mnt/` (Linux)
- Use fzf with `--scheme=path --tiebreak=end,index` for consistency
- Error handling with meaningful messages

## Claude Code Integration

### Settings

**Location:** `dotfiles/dot-claude/settings.json`

- Uses opus-4-5, sonnet-4-5, haiku-4-5 models
- Builtin ripgrep disabled (uses system rg)
- Non-essential traffic disabled
- Project MCP servers disabled

### Available Agents

**jj-operator** (`dotfiles/dot-claude/agents/jj-operator.md`)
- Specialized for jj VCS operations
- Has context about user's jj config and aliases
- Enforces safety rules (never modify operation log)
- Requires confirmation for destructive operations

### Available Slash Commands

**/jj_create_pr_body**
- Generates PR descriptions from `trunk()..@` diff
- Uses Opus model for quality
- Analyzes commits and diffs for comprehensive summary

**/jj_workspace_create**
- Creates isolated jj workspace
- Validates workspace names
- Reports absolute paths for file operations

### When Operating as Claude Code

You have these special capabilities:
1. Can launch specialized agents (like jj-operator) for complex tasks
2. Can use slash commands for common workflows
3. EDITOR is set to nvim - use it for file editing in interactive contexts
4. You're running inside tmux - can create windows/panes if needed

## Development Patterns

### Workspace Isolation

When working on features:
1. Create workspace: `jj workspace add .work/<feature-name>`
2. Workspace starts at trunk() by default
3. Each workspace has independent working copy
4. Use absolute paths when referencing files across workspaces

### Configuration Changes

**For dotfiles:**
1. Edit files in `dotfiles/` directory
2. Files are stowed to `$HOME` (happens outside this repo)
3. Test changes before committing
4. Consider both Linux and macOS compatibility

**For system files:**
- Linux: `linux/etc/`, `linux/usr/`
- macOS: `macos/etc/`, `macos/Library/`
- These require manual installation (see `install` script)

### Commit Workflow

1. Make changes in working directory
2. Changes are automatically tracked by jj
3. Use descriptive commit messages (present tense)
4. Private work: prefix with `wip:` or `private:`
5. Ready for PR: use `/jj_create_pr_body` to generate description

## Common Tasks

### Adding a New Tool Configuration

1. Create config in `dotfiles/dot-config/<tool>/`
2. Follow stow naming: `dot-config` → `.config`
3. Test with: `stow -d dotfiles -t ~ <package>` (if using stow directly)
4. Add to `.gitignore` any generated files

### Modifying Neovim Plugins

1. Add/modify plugin spec in `lua/assets/pack-spec.lua`
2. Create config file in `lua/config/<plugin>.lua`
3. Respect lazy-loading: use `ft` table for filetype-specific plugins
4. Source config in plugin spec if needed at load time

### Creating New Automation Script

1. Place in `dotfiles/dot-local/bin/`
2. Make executable: `chmod +x`
3. Follow existing patterns (see fzf_session as template)
4. Use helper functions from `include.d/` if available

### Working with JJ Workspaces

1. List workspaces: `jj workspace list`
2. Create: `jj workspace add <path>`
3. Convention: create in `.work/<name>` directory
4. Each workspace is isolated but shares repo history
5. Can work on multiple features simultaneously without branch switching

## Testing Considerations

### Before Committing

- Test on target platform (Linux/macOS if applicable)
- Check that stow paths are correct (dot-* naming)
- Verify no secrets or credentials are included
- Ensure scripts are executable
- Test lazy-loading if modifying neovim config

### Platform Differences

- Display config: Linux uses eDP-1, macOS uses different identifiers
- Paths: `/Volumes/` (macOS) vs `/mnt/` (Linux)
- Package managers: Different between platforms (not in this repo)
- Window manager: Sway (Linux), Aerospace (macOS)

## Getting Help

### Understanding Existing Config

1. **Neovim:** Check `lua/assets/pack-spec.lua` for plugin list
2. **Tmux:** Check `tmux/keymaps.conf` for bindings
3. **Sway:** Search for `bindsym` in config
4. **Scripts:** Read comments in `dotfiles/dot-local/bin/`

### Related Documentation

- `README.md` - Installation instructions
- `LOCAL_CONFIG.md` - Local machine-specific setup
- `TODO.md` - Planned improvements
- `scripts/README.md` - Server scripts documentation

## Working Effectively

### Do:
- Respect the modular structure (separate config files)
- Maintain consistency with existing patterns
- Test changes before committing
- Use descriptive commit messages
- Follow the lazy-loading architecture in neovim
- Check both Linux and macOS paths when relevant
- Use jj workspaces for isolated feature work

### Don't:
- Modify `.jj/` or `.git/` directories
- Add secrets or credentials
- Break lazy-loading by loading plugins at startup
- Modify operation log in jj
- Assume single platform (check Linux vs macOS)
- Force push to main/trunk
- Commit without testing

## Quick Reference

### Key Directories
- `dotfiles/dot-config/` - XDG config files
- `dotfiles/dot-local/bin/` - User scripts
- `dotfiles/dot-claude/` - Claude Code configuration
- `.work/` - JJ workspaces (gitignored)

### Key Commands
- `jj log -r 'trunk()..@'` - See current changes
- `jj new trunk()` - Start new change from trunk
- `fzf_session` - Switch projects
- `agent` - Launch Claude Code
- `prefix+l` - Open agent window in tmux

### Key Files
- `dotfiles/dot-claude/settings.json` - Claude Code config
- `dotfiles/dot-config/nvim/init.lua` - Neovim entry point
- `dotfiles/dot-config/tmux/tmux.conf` - Tmux entry point
- `dotfiles/dot-config/ghostty/config` - Terminal config
- `dotfiles/dot-config/sway/config` - Window manager config

---

**Remember:** This is a personal development environment optimized for a specific workflow. When making changes, consider the user's established patterns and preferences. When in doubt, ask before making significant architectural changes.
