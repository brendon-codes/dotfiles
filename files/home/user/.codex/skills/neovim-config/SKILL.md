---
name: neovim-config
description: Use when working on Neovim configuration, especially Kickstart.nvim customization, init.lua changes, lua/custom/settings.lua edits, custom Lua settings, keymaps, plugins, LSP, diagnostics, UI tweaks, or project-agent behavior for preserving upstream Kickstart.nvim updateability.
---

# Neovim Project Agent

Use this skill when making or reviewing changes in `~/.config/nvim/`.

## Workflow

- Read the local `AGENTS.md` before changing the Neovim config.
- Inspect the existing custom module style before adding new functions or patterns.
- Prefer extending `lua/custom/settings.lua` for custom settings, keymaps, autocmds, diagnostics, UI tweaks, LSP customizations, plugin behavior, and other local behavior changes.
- Avoid modifying `init.lua` unless the change cannot reasonably be reached from the custom config.
- If `init.lua` must change, keep the edit minimal and focused on requiring or calling functions defined in `lua/custom/settings.lua`.
- Preserve Kickstart.nvim updateability: avoid broad refactors, formatting churn, or rewrites of upstream-owned sections.
- Keep verification scoped to the change, and confirm whether any Neovim config files were modified.
