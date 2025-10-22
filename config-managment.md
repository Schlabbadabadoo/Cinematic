# Configuration Management

The Roblox UI Library includes a comprehensive configuration management system that allows users to save and load their settings.

## Overview

The configuration system automatically saves and loads:
- Toggle states
- Slider values
- Dropdown selections
- Color picker settings (color, transparency, toggle state)

## Configuration Structure

### Automatic Saving

The library automatically tracks all control states in the `UILibrary.savings` table:

```lua
UILibrary.savings = {
    toggle = {},           -- Toggle states
    togglecolorpicker = {}, -- Color picker states and colors
    slider = {},           -- Slider values
    dropdown = {}          -- Dropdown selections
}
```

### Configuration Files

Configurations are saved as Lua files in the `lajzahook/configs/` directory:

```
lajzahook/
└── configs/
    ├── default.cfg
    ├── pvp.cfg
    └── stealth.cfg
```

## Configuration Format

### Toggle Configurations

```lua
['toggle'] = {
    ['TabName_SectionName_ControlName'] = true,
    ['Visuals_ESP_EnableESP'] = false,
    ['Settings_Performance_LowFPS'] = true
}
```

### Slider Configurations

```lua
['slider'] = {
    ['Visuals_ESP_MaxDistance'] = 5000,
    ['Settings_Performance_UpdateRate'] = 50
}
```

### Dropdown Configurations

```lua
['dropdown'] = {
    ['Visuals_ESP_WeaponFilter'] = 'All',
    ['Settings_Team_TeamMode'] = 'Auto'
}
```

### Color Picker Configurations

```lua
['togglecolorpicker'] = {
    ['Visuals_ESP_EnemyBoxes'] = {true, Color3.new(1, 0, 0), 0.5},
    -- Format: {enabled, color, transparency}
}
```

## Configuration Management API

### Window Methods

#### `window:SaveConfig(name)`

Saves the current configuration to a file.

**Parameters:**
- `name` (string) - The name of the configuration file

**Example:**
```lua
-- Save current settings as "MyConfig"
window:SaveConfig("MyConfig")
```

**Generated File Structure:**
```lua
return {
    ['toggle'] = {
        ['Visuals_ESP_EnableESP'] = true,
        ['Visuals_ESP_ShowBoxes'] = false
    },
    ['slider'] = {
        ['Visuals_ESP_MaxDistance'] = 5000,
        ['Settings_Performance_UpdateRate'] = 50
    },
    ['dropdown'] = {
        ['Visuals_ESP_WeaponFilter'] = 'All'
    },
    ['togglecolorpicker'] = {
        ['Visuals_ESP_EnemyBoxes'] = {true, Color3.new(1, 0, 0), 0.5}
    }
}
```

#### `window:LoadConfig(name)`

Loads a configuration from a file.

**Parameters:**
- `name` (string) - The name of the configuration file

**Example:**
```lua
-- Load "MyConfig" settings
window:LoadConfig("MyConfig")
```

**Error Handling:**
```lua
if isfile("lajzahook/configs/"..name..".cfg") then
    local cfg = readfile("lajzahook/configs/"..name..".cfg")
    local config = loadstring(cfg)()
    
    for typee, tbl in pairs(config) do
        for option, value in pairs(tbl) do
            task.spawn(function() 
                UILibrary.loads[typee][option](value) 
            end)
        end
    end
else
    warn("[lajzahook] Config named "..name.." doesn't exist")
end
```

## Configuration Tab

### Creating Configuration Entries

```lua
-- Create config tab
local configs = tabgroup:CreateConfigTab()

-- Add configuration entries
configs:CreateConfig({
    Name = "Default Settings",
    Modified = "2024-01-01",
    Author = "User",
    Callback = function()
        window:LoadConfig("default")
    end
})

configs:CreateConfig({
    Name = "PvP Configuration", 
    Modified = "2024-01-02",
    Author = "User",
    Callback = function()
        window:LoadConfig("pvp")
    end
})
```

### Configuration Entry Properties

- `Name` (string) - Display name of the configuration
- `Modified` (string) - Last modified date
- `Author` (string) - Author of the configuration
- `Callback` (function) - Function called when configuration is loaded

## Advanced Configuration Features

### Custom Configuration Validation

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

-- Enhanced load function
function window:LoadConfig(name)
    if isfile("lajzahook/configs/"..name..".cfg") then
        local success, config = pcall(function()
            local cfg = readfile("lajzahook/configs/"..name..".cfg")
            return loadstring(cfg)()
        end)
        
        if success and validateConfig(config) then
            for typee, tbl in pairs(config) do
                for option, value in pairs(tbl) do
                    task.spawn(function() 
                        UILibrary.loads[typee][option](value) 
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

### Configuration Backup System

```lua
-- Create backup of current configuration
function window:BackupConfig(name)
    local timestamp = os.date("%Y%m%d_%H%M%S")
    local backupName = name .. "_backup_" .. timestamp
    window:SaveConfig(backupName)
    print("Configuration backed up as:", backupName)
end

-- Restore from backup
function window:RestoreConfig(backupName)
    window:LoadConfig(backupName)
    print("Configuration restored from:", backupName)
end
```

### Configuration Import/Export

```lua
-- Export configuration as JSON
function window:ExportConfig(name)
    if isfile("lajzahook/configs/"..name..".cfg") then
        local cfg = readfile("lajzahook/configs/"..name..".cfg")
        local config = loadstring(cfg)()
        
        -- Convert to JSON format
        local json = game:GetService("HttpService"):JSONEncode(config)
        
        -- Save as JSON file
        writefile("lajzahook/configs/"..name..".json", json)
        print("Configuration exported as JSON:", name..".json")
    end
end

-- Import configuration from JSON
function window:ImportConfig(jsonName)
    if isfile("lajzahook/configs/"..jsonName..".json") then
        local json = readfile("lajzahook/configs/"..jsonName..".json")
        local config = game:GetService("HttpService"):JSONDecode(json)
        
        -- Apply imported configuration
        for typee, tbl in pairs(config) do
            for option, value in pairs(tbl) do
                task.spawn(function() 
                    UILibrary.loads[typee][option](value) 
                end)
            end
        end
        
        print("Configuration imported from JSON:", jsonName)
    end
end
```

## Configuration Examples

### Basic ESP Configuration

```lua
-- Save ESP configuration
local function saveESPConfig()
    window:SaveConfig("esp_basic")
end

-- Load ESP configuration
local function loadESPConfig()
    window:LoadConfig("esp_basic")
end

-- ESP configuration with specific settings
local function createESPConfig()
    -- Set ESP settings
    ESP_Player.Enabled = true
    ESP_Player.Boxes = true
    ESP_Player.BoxesColor = Color3.new(1, 0, 0)  -- Red
    ESP_Player.Names = true
    ESP_Player.NamesColor = Color3.new(1, 1, 1)  -- White
    ESP_Player.Distance = true
    ESP_Player.DistanceColor = Color3.new(0, 1, 1)  -- Cyan
    ESP_Player.DistanceLimit = 5000
    
    -- Save configuration
    window:SaveConfig("esp_red_theme")
end
```

### Performance Configuration

```lua
-- Performance-optimized configuration
local function createPerformanceConfig()
    -- Reduce ESP distance for better performance
    ESP_Player.DistanceLimit = 2000
    ESP_Player.TeamDistanceLimit = 2000
    
    -- Disable expensive features
    ESP_Player.Healthbar = false
    ESP_Player.Weapons = false
    
    -- Save performance configuration
    window:SaveConfig("performance_optimized")
end
```

### Stealth Configuration

```lua
-- Stealth configuration for minimal visibility
local function createStealthConfig()
    -- Minimal ESP settings
    ESP_Player.Enabled = true
    ESP_Player.Boxes = false
    ESP_Player.Names = true
    ESP_Player.NamesColor = Color3.new(0.5, 0.5, 0.5)  -- Gray
    ESP_Player.Distance = true
    ESP_Player.DistanceColor = Color3.new(0.3, 0.3, 0.3)  -- Dark gray
    ESP_Player.DistanceLimit = 1000
    
    -- Disable other features
    ESP_Player.Healthbar = false
    ESP_Player.Weapons = false
    
    -- Save stealth configuration
    window:SaveConfig("stealth_minimal")
end
```

## Configuration Management UI

### Configuration List

```lua
-- Create configuration management section
local config_section = settings_tab:Section({
    Name = "Configuration Management",
    Side = "Left"
})

-- List available configurations
local function listConfigurations()
    local configs = {}
    local configFolder = "lajzahook/configs/"
    
    if isfolder("lajzahook/configs") then
        for _, file in pairs(listfiles(configFolder)) do
            if file:find("%.cfg$") then
                local name = file:match("([^/\\]+)%.cfg$")
                table.insert(configs, name)
            end
        end
    end
    
    return configs
end

-- Configuration dropdown
config_section:Dropdown({
    Name = "Available Configs",
    Items = listConfigurations(),
    Multi = false,
    Callback = function(selection)
        print("Selected configuration:", selection)
    end
})
```

### Configuration Actions

```lua
-- Load selected configuration
config_section:Button({
    Name = "Load Config",
    Callback = function()
        local selectedConfig = getSelectedConfig()  -- Get from dropdown
        if selectedConfig then
            window:LoadConfig(selectedConfig)
            print("Loaded configuration:", selectedConfig)
        end
    end
})

-- Save current configuration
config_section:Button({
    Name = "Save Config",
    Callback = function()
        local configName = getConfigName()  -- Get from input
        if configName then
            window:SaveConfig(configName)
            print("Saved configuration:", configName)
        end
    end
})

-- Delete configuration
config_section:Button({
    Name = "Delete Config",
    Callback = function()
        local selectedConfig = getSelectedConfig()
        if selectedConfig then
            delfile("lajzahook/configs/"..selectedConfig..".cfg")
            print("Deleted configuration:", selectedConfig)
        end
    end
})
```

## Best Practices

1. **Use descriptive configuration names** that indicate their purpose
2. **Include metadata** like author and modification date
3. **Validate configurations** before loading to prevent errors
4. **Create backups** of important configurations
5. **Use version control** for configuration files
6. **Test configurations** thoroughly before distribution
7. **Document configuration purposes** for users
8. **Handle missing configurations** gracefully
9. **Use consistent naming conventions** for configuration files
10. **Provide default configurations** for new users
