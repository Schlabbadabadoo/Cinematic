# Roblox UI Library Documentation

A comprehensive Roblox UI library featuring a modern interface with ESP (Extra Sensory Perception) capabilities, config management, and advanced visual effects.

## Features

- **Modern UI System**: Clean, draggable interface with smooth animations
- **ESP System**: Player tracking with boxes, names, distance, weapons, and health bars
- **Chams System**: Wall-hack style highlighting for players
- **Config Management**: Save and load configurations
- **Team Support**: Separate settings for teammates and enemies
- **Color Customization**: Full color picker integration
- **Smooth Animations**: TweenService-based animations throughout

## Quick Start

```lua
-- Initialize the library
local UILibrary = require(path.to.library)

-- Create a window
local window = UILibrary:Window()

-- Create a tab group
local visuals_tabgroup = window:TabGroup("Visuals")

-- Create a tab
local players_tab = visuals_tabgroup:Tab("Players")

-- Create a section
local esp_section = players_tab:Section({
    Name = "ESP Settings",
    Side = "Left"
})

-- Add controls
esp_section:Toggle({
    Name = "Enable ESP",
    Callback = function(enabled)
        -- Your ESP logic here
    end
})
```

## Table of Contents

- [API Reference](./api-reference.md)
- [ESP System](./esp-system.md)
- [Configuration Management](./config-management.md)
- [Examples](./examples.md)
- [Changelog](./changelog.md)

## Requirements

- Roblox Studio or Roblox Client
- Lua 5.1+ environment
- TweenService (built-in Roblox service)
- UserInputService (built-in Roblox service)

## Installation

1. Copy the library code to your Roblox environment
2. Require the library in your script
3. Initialize with `UILibrary:Window()`

## Basic Usage

The library follows a hierarchical structure:
- **Window** → **TabGroup** → **Tab** → **Section** → **Controls**

Each level provides specific functionality and organization for your UI.

## Key Components

### Window
The main container that holds all UI elements. Features:
- Draggable interface
- Toggle with Delete key
- Profile integration
- Config management

### TabGroup
Organizes related tabs together with a group label.

### Tab
Individual pages within a tab group containing sections.

### Section
Groups related controls with left/right side placement.

### Controls
- **Toggle**: On/off switches
- **ToggleColorpicker**: Toggle with color selection
- **Slider**: Numeric value selection
- **Dropdown**: Single or multi-selection lists

## ESP System

The library includes a comprehensive ESP system with:
- Player boxes
- Name tags
- Distance indicators
- Weapon display
- Health bars
- Team differentiation

## License

This library is provided as-is for educational and development purposes.
