# SH Utils

Personal Godot Utilities plugin.

## Installation

1. Copy the `/sh_utils` folder to your project's `addons/` directory.
2. Go to **Project > Project Settings > Plugins**.
3. Enable **SH Utils**.

The plugin will automatically add `Debug` and `Utils` autoload singletons.

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
- **Performance**: FPS, CPU/GPU Time, Object Count, Draw Calls, VRAM/RAM Usage.
- **System**: OS, CPU/GPU Info, Display Info, DPI.
- **Config**: View current project settings configuration.

### Utility Functions (`Utils`)
A collection of static helper functions for common tasks.

- **Smoothing**: `exp_decay()`, `move_towards_smooth()` for frame-rate independent smoothing.
- **String Conversion**:
    - `str_from_array()`: Pretty print arrays.
    - `str_from_dict()`: Pretty print dictionaries.
    - `str_from_vec()`: Pretty print vectors with custom separators.
    - `str_from_bool()`: specific strings for true/false.

### Configuration (`Config`)
Handles persistent settings management.

- **Storage**: Automatically loads/saves settings to `user://settings.cfg`.
- **Features**:
    - `set_fullscreen(bool)`: Toggles fullscreen mode.
    - `set_vsync(bool)`: Toggles VSync.
    - `set_locale(string)`: Updates game locale.
    - `config_changed` signal: Emitted when any setting changes.


** The LSP will report missing references during import, but only until you enable the plugin. Writing junk just to quiet down LSP is dumb. **