# Usage Examples

This document provides comprehensive examples of how to use the Roblox UI Library in various scenarios.

## Basic Setup

### Simple Window Creation

```lua
-- Initialize the library
local UILibrary = require(path.to.library)

-- Create a window
local window = UILibrary:Window()

-- The window is now ready to use
```

### Complete UI Structure

```lua
-- Create the main window
local window = UILibrary:Window()

-- Create tab groups
local visuals_tabgroup = window:TabGroup("Visuals")
local settings_tabgroup = window:TabGroup("Settings")

-- Create tabs within tab groups
local players_tab = visuals_tabgroup:Tab("Players")
local world_tab = visuals_tabgroup:Tab("World")
local config_tab = settings_tabgroup:Tab("Configuration")

-- Create sections within tabs
local esp_section = players_tab:Section({
    Name = "ESP Settings",
    Side = "Left"
})

local chams_section = players_tab:Section({
    Name = "Chams Settings", 
    Side = "Right"
})
```

## ESP Examples

### Basic ESP Setup

```lua
-- Create ESP section
local esp_section = players_tab:Section({
    Name = "ESP Settings",
    Side = "Left"
})

-- Enable ESP toggle
esp_section:Toggle({
    Name = "Enable ESP",
    Callback = function(enabled)
        ESP_Player.Enabled = enabled
        if enabled then
            -- Refresh ESP for all players
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= Players.LocalPlayer then
                    ESP_Player:refresh(player)
                end
            end
        else
            -- Clear all ESP elements
            for _, item in pairs(ESPFolder:GetChildren()) do
                item:Destroy()
            end
        end
    end
})

-- Distance slider
esp_section:Slider({
    Name = "Max Distance",
    Min = 100,
    Max = 10000,
    Default = 5000,
    Callback = function(value)
        ESP_Player.DistanceLimit = value
        -- Update existing ESP elements
        for _, item in pairs(ESPFolder:GetChildren()) do
            item.MaxDistance = value
        end
    end
})
```

### Advanced ESP with Color Customization

```lua
-- Enemy ESP section
local enemy_esp_section = players_tab:Section({
    Name = "Enemy ESP",
    Side = "Left"
})

-- Enemy boxes with color picker
enemy_esp_section:ToggleColorpicker({
    Name = "Enemy Boxes",
    ToggleCallback = function(enabled)
        ESP_Player.Boxes = enabled
        if enabled and ESP_Player.Enabled then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= Players.LocalPlayer and not global.Teammates[player] then
                    ESP_Player:createbox(player)
                end
            end
        else
            -- Remove enemy boxes
            for _, item in pairs(ESPFolder:GetChildren()) do
                if item.Name == "BoxHolder" and not global.Teammates[Players:GetPlayerFromCharacter(item.Adornee.Parent)] then
                    item:Destroy()
                end
            end
        end
    end,
    ColorpickerCallback = function(color)
        ESP_Player.BoxesColor = color
        -- Update existing enemy boxes
        for _, item in pairs(ESPFolder:GetChildren()) do
            if item.Name == "BoxHolder" and not global.Teammates[Players:GetPlayerFromCharacter(item.Adornee.Parent)] then
                item.Up.BackgroundColor3 = color
                item.Down.BackgroundColor3 = color
                item.Left.BackgroundColor3 = color
                item.Right.BackgroundColor3 = color
            end
        end
    end
})

-- Enemy names with color picker
enemy_esp_section:ToggleColorpicker({
    Name = "Enemy Names",
    ToggleCallback = function(enabled)
        ESP_Player.Names = enabled
        if enabled and ESP_Player.Enabled then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= Players.LocalPlayer and not global.Teammates[player] then
                    ESP_Player:createname(player)
                end
            end
        else
            -- Remove enemy names
            for _, item in pairs(ESPFolder:GetChildren()) do
                if item.Name == "NameHolder" and not global.Teammates[Players:GetPlayerFromCharacter(item.Adornee.Parent)] then
                    item:Destroy()
                end
            end
        end
    end,
    ColorpickerCallback = function(color)
        ESP_Player.NamesColor = color
        -- Update existing enemy names
        for _, item in pairs(ESPFolder:GetChildren()) do
            if item.Name == "NameHolder" and not global.Teammates[Players:GetPlayerFromCharacter(item.Adornee.Parent)] then
                item.TextLabel.TextColor3 = color
            end
        end
    end
})
```

### Team ESP Setup

```lua
-- Team ESP section
local team_esp_section = players_tab:Section({
    Name = "Team ESP",
    Side = "Right"
})

-- Team boxes
team_esp_section:ToggleColorpicker({
    Name = "Team Boxes",
    ToggleCallback = function(enabled)
        ESP_Player.TeamBoxes = enabled
        if enabled and ESP_Player.TeamEnabled then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= Players.LocalPlayer and global.Teammates[player] then
                    ESP_Player:createbox(player)
                end
            end
        else
            -- Remove team boxes
            for _, item in pairs(ESPFolder:GetChildren()) do
                if item.Name == "BoxHolder" and global.Teammates[Players:GetPlayerFromCharacter(item.Adornee.Parent)] then
                    item:Destroy()
                end
            end
        end
    end,
    ColorpickerCallback = function(color)
        ESP_Player.TeamBoxesColor = color
        -- Update existing team boxes
        for _, item in pairs(ESPFolder:GetChildren()) do
            if item.Name == "BoxHolder" and global.Teammates[Players:GetPlayerFromCharacter(item.Adornee.Parent)] then
                item.Up.BackgroundColor3 = color
                item.Down.BackgroundColor3 = color
                item.Left.BackgroundColor3 = color
                item.Right.BackgroundColor3 = color
            end
        end
    end
})
```

## Chams Examples

### Enemy Chams

```lua
-- Enemy chams section
local enemy_chams_section = players_tab:Section({
    Name = "Enemy Chams",
    Side = "Left"
})

-- Enemy chams configuration
local enemy_chams = {
    Enabled = false,
    ChamsColor = Color3.new(1, 0, 0),  -- Red
    FillTransparency = 0,
    OutlineTransparency = 0,
    VisibilityCheck = false
}

-- Enable enemy chams
enemy_chams_section:ToggleColorpicker({
    Name = "Enable Enemy Chams",
    ToggleCallback = function(enabled)
        enemy_chams.Enabled = enabled
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Character and not global.Teammates[player] then
                updatechams(
                    enemy_chams.Enabled,
                    "EnemyPlayer",
                    player.Character,
                    enemy_chams.ChamsColor,
                    enemy_chams.FillTransparency / 100,
                    enemy_chams.OutlineTransparency / 100,
                    enemy_chams.VisibilityCheck
                )
            end
        end
    end,
    ColorpickerCallback = function(color)
        enemy_chams.ChamsColor = color
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Character and not global.Teammates[player] then
                updatechams(
                    enemy_chams.Enabled,
                    "EnemyPlayer",
                    player.Character,
                    enemy_chams.ChamsColor,
                    enemy_chams.FillTransparency / 100,
                    enemy_chams.OutlineTransparency / 100,
                    enemy_chams.VisibilityCheck
                )
            end
        end
    end
})

-- Fill transparency slider
enemy_chams_section:Slider({
    Name = "Fill Alpha",
    Min = 0,
    Max = 100,
    Default = 0,
    Callback = function(value)
        enemy_chams.FillTransparency = value
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Character and not global.Teammates[player] then
                updatechams(
                    enemy_chams.Enabled,
                    "EnemyPlayer",
                    player.Character,
                    enemy_chams.ChamsColor,
                    enemy_chams.FillTransparency / 100,
                    enemy_chams.OutlineTransparency / 100,
                    enemy_chams.VisibilityCheck
                )
            end
        end
    end
})

-- Outline transparency slider
enemy_chams_section:Slider({
    Name = "Outline Alpha",
    Min = 0,
    Max = 100,
    Default = 0,
    Callback = function(value)
        enemy_chams.OutlineTransparency = value
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Character and not global.Teammates[player] then
                updatechams(
                    enemy_chams.Enabled,
                    "EnemyPlayer",
                    player.Character,
                    enemy_chams.ChamsColor,
                    enemy_chams.FillTransparency / 100,
                    enemy_chams.OutlineTransparency / 100,
                    enemy_chams.VisibilityCheck
                )
            end
        end
    end
})

-- Visibility check toggle
enemy_chams_section:Toggle({
    Name = "Visibility Check",
    Callback = function(enabled)
        enemy_chams.VisibilityCheck = enabled
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Character and not global.Teammates[player] then
                updatechams(
                    enemy_chams.Enabled,
                    "EnemyPlayer",
                    player.Character,
                    enemy_chams.ChamsColor,
                    enemy_chams.FillTransparency / 100,
                    enemy_chams.OutlineTransparency / 100,
                    enemy_chams.VisibilityCheck
                )
            end
        end
    end
})
```

### Self Chams

```lua
-- Self chams section
local self_chams_section = players_tab:Section({
    Name = "Self Chams",
    Side = "Left"
})

-- Self chams configuration
local self_chams = {
    Enabled = false,
    ChamsColor = Color3.new(0, 0, 1),  -- Blue
    LastSkinColor = nil
}

-- Self chams toggle with color picker
self_chams_section:ToggleColorpicker({
    Name = "Enable Self Chams",
    ToggleCallback = function(enabled)
        self_chams.Enabled = enabled
        if Players.LocalPlayer.Character then
            self_chams.update_forcefield_chams(enabled)
        end
    end,
    ColorpickerCallback = function(color)
        self_chams.ChamsColor = color
        if self_chams.Enabled and Players.LocalPlayer.Character then
            self_chams.update_forcefield_chams(true)
        end
    end
})
```

## Configuration Management

### Config Tab Setup

```lua
-- Create config tab
local configs = tabgroup:CreateConfigTab()

-- Add configuration entries
configs:CreateConfig({
    Name = "Default Config",
    Modified = "2024-01-01",
    Author = "User",
    Callback = function()
        print("Default config loaded!")
        -- Load default settings here
    end
})

configs:CreateConfig({
    Name = "PvP Config",
    Modified = "2024-01-02", 
    Author = "User",
    Callback = function()
        print("PvP config loaded!")
        -- Load PvP settings here
    end
})

configs:CreateConfig({
    Name = "Stealth Config",
    Modified = "2024-01-03",
    Author = "User", 
    Callback = function()
        print("Stealth config loaded!")
        -- Load stealth settings here
    end
})
```

### Script Tab Setup

```lua
-- Create script tab
local scripts = tabgroup:CreateScriptTab()

-- Add script entries
scripts:CreateScript({
    Name = "Auto Farm",
    Modified = "2024-01-01",
    Author = "User",
    Callback = function()
        print("Auto Farm script executed!")
        -- Your auto farm logic here
    end
})

scripts:CreateScript({
    Name = "Speed Hack",
    Modified = "2024-01-02",
    Author = "User", 
    Callback = function()
        print("Speed Hack script executed!")
        -- Your speed hack logic here
    end
})
```

## Advanced Examples

### Dynamic Team Management

```lua
-- Team management section
local team_section = settings_tab:Section({
    Name = "Team Management",
    Side = "Left"
})

-- Add player to team
team_section:Button({
    Name = "Add to Team",
    Callback = function()
        local playerName = "PlayerName"  -- Get from input
        local player = Players:FindFirstChild(playerName)
        if player then
            global.Teammates[player] = true
            print("Added", playerName, "to team")
            -- Refresh ESP for the player
            ESP_Player:refresh(player)
        end
    end
})

-- Remove player from team
team_section:Button({
    Name = "Remove from Team", 
    Callback = function()
        local playerName = "PlayerName"  -- Get from input
        local player = Players:FindFirstChild(playerName)
        if player then
            global.Teammates[player] = nil
            print("Removed", playerName, "from team")
            -- Clear team ESP for the player
            for _, item in pairs(ESPFolder:GetChildren()) do
                if item.Adornee and item.Adornee.Parent == player.Character then
                    item:Destroy()
                end
            end
        end
    end
})
```

### Weapon Filtering

```lua
-- Weapon filter section
local weapon_section = players_tab:Section({
    Name = "Weapon Filter",
    Side = "Right"
})

-- Weapon filter dropdown
weapon_section:Dropdown({
    Name = "Weapon Type",
    Items = {"All", "Rifles", "Pistols", "Snipers", "Melee"},
    Multi = false,
    Callback = function(selection)
        print("Weapon filter set to:", selection)
        -- Implement weapon filtering logic
        if selection == "All" then
            -- Show all weapons
        elseif selection == "Rifles" then
            -- Show only rifles
        elseif selection == "Pistols" then
            -- Show only pistols
        elseif selection == "Snipers" then
            -- Show only snipers
        elseif selection == "Melee" then
            -- Show only melee weapons
        end
    end
})
```

### Performance Settings

```lua
-- Performance section
local performance_section = settings_tab:Section({
    Name = "Performance",
    Side = "Left"
})

-- FPS limit slider
performance_section:Slider({
    Name = "FPS Limit",
    Min = 30,
    Max = 300,
    Default = 60,
    Callback = function(value)
        print("FPS limit set to:", value)
        -- Set FPS limit
        game:GetService("RunService"):SetFPS(value)
    end
})

-- Update rate slider
performance_section:Slider({
    Name = "Update Rate (ms)",
    Min = 16,
    Max = 100,
    Default = 50,
    Callback = function(value)
        print("Update rate set to:", value, "ms")
        -- Adjust ESP update rate
        ESP_Player.UpdateRate = value / 1000
    end
})
```

### Custom ESP Elements

```lua
-- Custom ESP section
local custom_section = players_tab:Section({
    Name = "Custom ESP",
    Side = "Right"
})

-- Custom text ESP
custom_section:Toggle({
    Name = "Custom Text",
    Callback = function(enabled)
        if enabled then
            -- Create custom text ESP
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= Players.LocalPlayer and player.Character then
                    local character = player.Character
                    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                    if humanoidRootPart then
                        ESP_Part.createname(
                            humanoidRootPart,
                            "CustomText_" .. player.Name,
                            Color3.new(1, 1, 0),  -- Yellow
                            1000,  -- Max distance
                            "Custom: " .. player.Name
                        )
                    end
                end
            end
        else
            -- Remove custom text ESP
            for _, item in pairs(ESPPartFolder:GetChildren()) do
                if item.Name:find("CustomText_") then
                    item:Destroy()
                end
            end
        end
    end
})
```

## Error Handling

### Safe Callback Implementation

```lua
-- Safe callback wrapper
local function safeCallback(callback, ...)
    local success, result = pcall(callback, ...)
    if not success then
        warn("Callback error:", result)
    end
    return success, result
end

-- Usage in controls
esp_section:Toggle({
    Name = "Safe ESP",
    Callback = function(enabled)
        safeCallback(function()
            ESP_Player.Enabled = enabled
            -- Your ESP logic here
        end)
    end
})
```

### Configuration Validation

```lua
-- Validate configuration before loading
local function validateConfig(config)
    local required = {"toggle", "slider", "dropdown", "togglecolorpicker"}
    for _, key in pairs(required) do
        if not config[key] then
            warn("Missing required config section:", key)
            return false
        end
    end
    return true
end

-- Safe config loading
function window:LoadConfig(name)
    if isfile("lajzahook/configs/"..name..".cfg") then
        local success, config = pcall(function()
            local cfg = readfile("lajzahook/configs/"..name..".cfg")
            return loadstring(cfg)()
        end)
        
        if success and validateConfig(config) then
            -- Load configuration
            for typee, tbl in pairs(config) do
                for option, value in pairs(tbl) do
                    task.spawn(function() 
                        safeCallback(UILibrary.loads[typee][option], value) 
                    end)
                end
            end
        else
            warn("Invalid configuration file:", name)
        end
    else
        warn("Configuration file not found:", name)
    end
end
```

## Best Practices

1. **Always use pcall() for callbacks** to prevent errors from breaking the UI
2. **Validate user input** before processing
3. **Use appropriate distance limits** to balance visibility and performance
4. **Clean up resources** when disabling features
5. **Test thoroughly** with different scenarios
6. **Use meaningful names** for controls and sections
7. **Group related controls** in the same section
8. **Provide user feedback** for important actions
9. **Handle edge cases** like missing players or characters
10. **Optimize performance** by limiting update rates and distances
