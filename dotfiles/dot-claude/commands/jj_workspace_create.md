---
description: Create new jj workspace and prepare it for Claude to work in
model: sonnet
---

You are tasked with creating a new jj workspace for isolated work.

The user will provide a workspace name as an argument to this command. For example: `/jj_workspace_create feature-auth`

Follow these steps:

1. **Validate the workspace name:**
   - Ensure the name contains only alphanumeric characters, hyphens, and underscores
   - If invalid, explain the issue and ask for a valid name
   - DO NOT proceed if the name is invalid

2. **Check current workspace status:**
   - Run `jj workspace list` to see existing workspaces
   - Run `jj status` to understand the current state

3. **Create the new workspace:**
   - Run `jj workspace add <workspace-name>`
   - This will create a new workspace directory alongside the current workspace

4. **Determine the absolute path:**
   - Run `jj workspace list` again to confirm creation
   - Identify the absolute path to the new workspace directory
   - The path will typically be `../<workspace-name>` relative to current workspace

5. **Initialize the workspace:**
   - The workspace is created at trunk() by default
   - Run `jj new trunk()` in the new workspace to create a fresh change to work in

6. **Report to the user:**
   - Confirm successful creation
   - Provide the absolute path to the new workspace
   - Explain that Claude Code will need to use absolute paths when working in this workspace
   - Suggest next steps (e.g., "You can now use this workspace for isolated development")

**Important notes:**
- jj workspaces share the same repository but have independent working copies
- Changes made in one workspace don't affect others until explicitly moved/rebased
- Each workspace has its own @ (current change)
- The Bash tool's working directory resets between calls, so always use absolute paths when referencing files in the new workspace

**Example output format:**
```
Workspace 'feature-auth' created successfully!

Location: /home/chant/.dotfiles/feature-auth
Current change: New change at trunk()

You can now work in this isolated workspace. All file operations should use absolute paths like:
- /home/chant/.dotfiles/feature-auth/dot-config/nvim/init.lua

To switch back to the main workspace, use another workspace or run commands with `jj -R /home/chant/.dotfiles/dotfiles`.
```

Begin by asking the user for the workspace name if not already provided.
