# <img src="icon.svg" width="42" height="42" align="top" /> SH Utils

Personal Godot Utilities plugin. A lightweight, drop-in solution providing essential utility helpers to streamline initial development and eliminate the need to rewrite boilerplate for every new project.

## Installation

1. Copy the `/sh_utils` folder to your project's `addons/` directory.
2. Go to **Project > Project Settings > Plugins**.
3. Enable **SH Utils**.

The plugin will automatically add `Debug`, `Utils` and `Config` autoload singletons.

## Features

### Debug Overlay (`Debug`)
Quickly toggle a debug overlay to monitor performance and system stats.

| Key | Action |
| --- | --- |
| `~` | Toggle Debug Overlays |
| `Esc` | Force Quit Application |
| `V` | Toggle VSync |
| `F` | Toggle Fullscreen |
| `P` | Capture Screenshot |
| `R` | Reload Current Scene |

*Keyboard shortcuts work only when debug overlays are visible, except for toggle.*

**Statistics:**
- **Performance**: FPS, CPU Time, Object Count, Draw Calls, VRAM/RAM Usage.
- **System**: OS, CPU/GPU Info, Display Info, DPI.
- **Config**: View current project settings configuration.

### Utility Functions (`Utils`)
A collection of static helper functions for common tasks.

> [!WARNING]
> The LSP will report missing references during import, but only until you enable the plugin. Writing junk just to quiet down LSP is dumb.
