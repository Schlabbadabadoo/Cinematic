# ESP System Documentation

The ESP (Extra Sensory Perception) system provides comprehensive player tracking and visualization features for Roblox games.

## Overview

The ESP system consists of several components that work together to provide visual information about players:

- **Boxes**: Rectangular outlines around players
- **Names**: Player name tags
- **Distance**: Distance indicators
- **Weapons**: Currently equipped weapon display
- **Health Bars**: Visual health representation
- **Health Text**: Numeric health display
- **Chams**: Wall-hack style highlighting

## ESP_Player Object

The main ESP controller that manages all player tracking functionality.

### Configuration Properties

#### Global Settings
```lua
ESP_Player.Enabled = true              -- Enable/disable ESP globally
ESP_Player.DistanceLimit = 10000      -- Maximum render distance
```

#### Enemy ESP Settings
```lua
ESP_Player.Boxes = true               -- Show enemy boxes
ESP_Player.BoxesColor = Color3.new(1, 0, 0)  -- Red boxes for enemies
ESP_Player.Names = true               -- Show enemy names
ESP_Player.NamesColor = Color3.new(1, 1, 1)  -- White names
ESP_Player.Healthbar = true           -- Show enemy health bars
ESP_Player.HealthbarColor = Color3.new(0, 1, 0)  -- Green health bars
ESP_Player.Health = true              -- Show enemy health text
ESP_Player.HealthColor = Color3.new(1, 1, 0)  -- Yellow health text
ESP_Player.Weapons = true             -- Show enemy weapons
ESP_Player.WeaponsColor = Color3.new(1, 0.5, 0)  -- Orange weapons
ESP_Player.Distance = true            -- Show enemy distance
ESP_Player.DistanceColor = Color3.new(0.5, 0.5, 1)  -- Blue distance
```

#### Team ESP Settings
```lua
ESP_Player.TeamEnabled = true          -- Enable team ESP
ESP_Player.TeamDistanceLimit = 10000   -- Team render distance
ESP_Player.TeamBoxes = true            -- Show team boxes
ESP_Player.TeamBoxesColor = Color3.new(0, 1, 0)  -- Green for team
ESP_Player.TeamNames = true            -- Show team names
ESP_Player.TeamNamesColor = Color3.new(0, 1, 1)  -- Cyan team names
ESP_Player.TeamHealthbar = true        -- Show team health bars
ESP_Player.TeamHealthbarColor = Color3.new(0, 0.5, 1)  -- Blue team health
ESP_Player.TeamHealth = true           -- Show team health text
ESP_Player.TeamHealthColor = Color3.new(0, 1, 0.5)  -- Green team health
ESP_Player.TeamWeapons = true          -- Show team weapons
ESP_Player.TeamWeaponsColor = Color3.new(0, 1, 0)  -- Green team weapons
ESP_Player.TeamDistance = true         -- Show team distance
ESP_Player.TeamDistanceColor = Color3.new(0, 1, 1)  -- Cyan team distance
```

## ESP Components

### Boxes

Rectangular outlines that surround players, providing clear visual boundaries.

**Features:**
- Customizable colors for enemies and teammates
- Distance-based rendering
- Automatic cleanup when players leave
- Border effects for better visibility

**Implementation:**
```lua
-- Enable enemy boxes
ESP_Player.Boxes = true
ESP_Player.BoxesColor = Color3.new(1, 0, 0)  -- Red

-- Enable team boxes
ESP_Player.TeamBoxes = true
ESP_Player.TeamBoxesColor = Color3.new(0, 1, 0)  -- Green
```

### Names

Player name tags displayed above characters.

**Features:**
- Real-time name updates
- Color customization
- Distance-based visibility
- Font customization (Arimo Bold)

**Implementation:**
```lua
-- Enable enemy names
ESP_Player.Names = true
ESP_Player.NamesColor = Color3.new(1, 1, 1)  -- White

-- Enable team names
ESP_Player.TeamNames = true
ESP_Player.TeamNamesColor = Color3.new(0, 1, 1)  -- Cyan
```

### Distance

Real-time distance indicators showing how far players are from you.

**Features:**
- Live distance calculation
- Performance optimized updates
- Customizable colors
- Automatic formatting (e.g., "[1500 studs]")

**Implementation:**
```lua
-- Enable enemy distance
ESP_Player.Distance = true
ESP_Player.DistanceColor = Color3.new(0.5, 0.5, 1)  -- Blue

-- Enable team distance
ESP_Player.TeamDistance = true
ESP_Player.TeamDistanceColor = Color3.new(0, 1, 1)  -- Cyan
```

### Weapons

Displays currently equipped weapons for each player.

**Features:**
- Real-time weapon detection
- "Hands" display when no weapon equipped
- Color customization
- Automatic updates on weapon changes

**Implementation:**
```lua
-- Enable enemy weapons
ESP_Player.Weapons = true
ESP_Player.WeaponsColor = Color3.new(1, 0.5, 0)  -- Orange

-- Enable team weapons
ESP_Player.TeamWeapons = true
ESP_Player.TeamWeaponsColor = Color3.new(0, 1, 0)  -- Green
```

### Health Bars

Visual health representation using gradient bars.

**Features:**
- Real-time health updates
- Gradient color transitions
- Customizable colors
- Automatic scaling based on health percentage

**Implementation:**
```lua
-- Enable enemy health bars
ESP_Player.Healthbar = true
ESP_Player.HealthbarColor = Color3.new(0, 1, 0)  -- Green

-- Enable team health bars
ESP_Player.TeamHealthbar = true
ESP_Player.TeamHealthbarColor = Color3.new(0, 0.5, 1)  -- Blue
```

### Health Text

Numeric health display showing exact health values.

**Features:**
- Real-time health updates
- Rounded health values
- Color customization
- Automatic positioning

**Implementation:**
```lua
-- Enable enemy health text
ESP_Player.Health = true
ESP_Player.HealthColor = Color3.new(1, 1, 0)  -- Yellow

-- Enable team health text
ESP_Player.TeamHealth = true
ESP_Player.TeamHealthColor = Color3.new(0, 1, 0.5)  -- Green
```

## Chams System

Wall-hack style highlighting that makes players visible through walls.

### Enemy Chams

```lua
local players_enemies_chams = {
    Enabled = false,                    -- Enable/disable chams
    ChamsColor = Color3.new(1, 0, 0),  -- Red chams for enemies
    FillTransparency = 0,               -- Fill transparency (0-100)
    OutlineTransparency = 0,            -- Outline transparency (0-100)
    VisibilityCheck = false             -- Check if player is visible
}
```

### Team Chams

```lua
local players_teammates_chams = {
    Enabled = false,                    -- Enable/disable team chams
    ChamsColor = Color3.new(0, 1, 0),   -- Green chams for team
    FillTransparency = 0,                -- Fill transparency (0-100)
    OutlineTransparency = 0,             -- Outline transparency (0-100)
    VisibilityCheck = false              -- Check if player is visible
}
```

### Self Chams

Special chams for your own character using forcefield material.

```lua
local players_self_chams = {
    Enabled = false,                    -- Enable/disable self chams
    ChamsColor = Color3.new(0, 0, 1),   -- Blue chams for self
    LastSkinColor = nil                 -- Stores original skin color
}
```

## Team Management

### Adding Players to Team

```lua
-- Add a player to your team
global.Teammates[player] = true

-- Remove a player from your team
global.Teammates[player] = nil
```

### Team Detection

The ESP system automatically detects team members using the `global.Teammates` table:

```lua
local isTeammate = global.Teammates[player] ~= nil and true or false
```

## Performance Optimization

### Distance-Based Rendering

ESP elements are automatically hidden when players are beyond the distance limit:

```lua
ESP_Player.DistanceLimit = 10000  -- 10,000 studs maximum
ESP_Player.TeamDistanceLimit = 10000  -- Team distance limit
```

### Update Throttling

Distance calculations are throttled to prevent performance issues:

```lua
-- Distance updates every 0.05 seconds
task.wait(0.05)

-- Reduced updates for distant players
if distance > (DistanceHolder.MaxDistance + 200) then
    task.wait(0.5)
end
```

### Memory Management

ESP elements are automatically cleaned up when:
- Players leave the game
- Characters are removed
- ESP is disabled

## Usage Examples

### Basic ESP Setup

```lua
-- Enable basic ESP for enemies
ESP_Player.Enabled = true
ESP_Player.Boxes = true
ESP_Player.Names = true
ESP_Player.Distance = true

-- Set colors
ESP_Player.BoxesColor = Color3.new(1, 0, 0)  -- Red boxes
ESP_Player.NamesColor = Color3.new(1, 1, 1)  -- White names
ESP_Player.DistanceColor = Color3.new(0, 1, 1)  -- Cyan distance
```

### Team ESP Setup

```lua
-- Enable team ESP
ESP_Player.TeamEnabled = true
ESP_Player.TeamBoxes = true
ESP_Player.TeamNames = true

-- Set team colors
ESP_Player.TeamBoxesColor = Color3.new(0, 1, 0)  -- Green boxes
ESP_Player.TeamNamesColor = Color3.new(0, 1, 1)  -- Cyan names
```

### Chams Setup

```lua
-- Enable enemy chams
players_enemies_chams.Enabled = true
players_enemies_chams.ChamsColor = Color3.new(1, 0, 0)  -- Red
players_enemies_chams.FillTransparency = 50  -- 50% transparent
players_enemies_chams.OutlineTransparency = 0  -- Solid outline

-- Enable team chams
players_teammates_chams.Enabled = true
players_teammates_chams.ChamsColor = Color3.new(0, 1, 0)  -- Green
```

### Dynamic ESP Updates

```lua
-- Refresh ESP for all players
for _, player in pairs(Players:GetPlayers()) do
    if player ~= Players.LocalPlayer then
        ESP_Player:refresh(player)
    end
end
```

## Troubleshooting

### ESP Not Showing

1. Check if `ESP_Player.Enabled` is true
2. Verify distance limits are appropriate
3. Ensure players have characters spawned
4. Check if specific ESP components are enabled

### Performance Issues

1. Increase distance limits to reduce rendered elements
2. Disable unnecessary ESP components
3. Use team filtering to reduce ESP count
4. Check for memory leaks in custom code

### Chams Not Working

1. Verify chams are enabled
2. Check transparency values (0-100)
3. Ensure models exist and are valid
4. Verify team detection is working correctly

## Best Practices

1. **Use appropriate distance limits** to balance visibility and performance
2. **Enable only necessary ESP components** to reduce overhead
3. **Use team filtering** to separate enemy and teammate ESP
4. **Monitor performance** and adjust settings accordingly
5. **Clean up custom ESP elements** when no longer needed
6. **Use color coding** to distinguish between different player types
7. **Test thoroughly** with different player counts and scenarios
