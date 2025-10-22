if not isfolder("cinematic") then
    makefolder("cinematic")
end

if not isfolder("cinematic/configs") then
    makefolder("cinematic/configs")
end

if not OUTSECURE_NO_VIRTUALIZE then
    OUTSECURE_NO_VIRTUALIZE = function(...) return ... end
end

local UILibrary = {
    savings = {
        toggle = {},
        togglecolorpicker = {},
        slider = {},
        dropdown = {}
    },
    loads = {
        toggle = {},
        togglecolorpicker = {},
        slider = {},
        dropdown = {}
    }
}

local cloneref = cloneref or function(...) return ... end
local CoreGui = cloneref(game:GetService("CoreGui"))
local UserInputService = game:GetService("UserInputService")

local Players = game:GetService("Players")

local ESPFolder = Instance.new("Folder", CoreGui)
local ESPPartFolder = Instance.new("Folder", CoreGui)
local ARIMOFONT
pcall(function()
    ARIMOFONT = Font.new("rbxasset://fonts/families/Arimo.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
end)
local ESP_Part = {
    Font = ARIMOFONT or Enum.Font.Arimo,
    esp_find = function(name, part)
    for i,v in pairs(ESPPartFolder:GetChildren()) do
        if v.Name == name then
        if v.Adornee == part then
            return v
        end
        end
    end
    return nil
    end,
    esp_destroy = function(name)
    for i,v in pairs(ESPPartFolder:GetChildren()) do
        if v.Name == name then
        v:Destroy()
        end
    end
    end
}
ESP_Part.createname = function(part, name, color, maxdistance, visiblename)
    local NameHolder = ESP_Part.esp_find(name, part) or Instance.new("BillboardGui")
    local TextLabel = NameHolder:FindFirstChild("TextLabel") or Instance.new("TextLabel")

    NameHolder.Name = name
    NameHolder.Parent = ESPPartFolder
    NameHolder.MaxDistance = maxdistance
    NameHolder.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    NameHolder.Adornee = part
    NameHolder.AlwaysOnTop = true
    NameHolder.Size = UDim2.new(0, 1, 0, 1)
    NameHolder.SizeOffset = Vector2.new(0, 6)

    TextLabel.Parent = NameHolder
    TextLabel.BackgroundTransparency = 1
    TextLabel.BorderSizePixel = 0
    TextLabel.Size = UDim2.new(1, 0, 1, 0)
    TextLabel.FontFace = ESP_Part.Font
    TextLabel.Text = tostring(visiblename or name)
    TextLabel.TextColor3 = color
    TextLabel.TextSize = 12
    TextLabel.TextStrokeTransparency = 0

    part.AncestryChanged:Connect(function(_, parent)
    if parent == nil then
        NameHolder:Destroy()
    end
    end)
end
ESP_Part.createdistance = function(part, name, color, maxdistance)
    local OldDistanceHolder = ESP_Part.esp_find(name, part)
    local DistanceHolder = OldDistanceHolder or Instance.new("BillboardGui")
    local TextLabel_2 = DistanceHolder:FindFirstChild("TextLabel") or Instance.new("TextLabel")

    DistanceHolder.Name = name
    DistanceHolder.Parent = ESPPartFolder
    DistanceHolder.MaxDistance = maxdistance
    DistanceHolder.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    DistanceHolder.Adornee = part
    DistanceHolder.AlwaysOnTop = true
    DistanceHolder.Size = UDim2.new(0, 1, 0, 1)
    DistanceHolder.SizeOffset = Vector2.new(0, -6)

    TextLabel_2.Parent = DistanceHolder
    TextLabel_2.BackgroundTransparency = 1
    TextLabel_2.BorderSizePixel = 0
    TextLabel_2.Size = UDim2.new(1, 0, 1, 0)
    TextLabel_2.FontFace = ESP_Part.Font
    TextLabel_2.Text = "[9999 studs]"
    TextLabel_2.TextColor3 = color
    TextLabel_2.TextSize = 12
    TextLabel_2.TextStrokeTransparency = 0

    if OldDistanceHolder then return end

    task.spawn(function()
    local hrp = part:IsA("Part") and part or part.PrimaryPart or part:FindFirstChild("HumanoidRootPart")
    while DistanceHolder.Parent and DistanceHolder.Adornee and hrp do
        if Players.LocalPlayer.Character then
        local distance = math.round((Players.LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude)
        if distance > (DistanceHolder.MaxDistance + 200) then
            task.wait(0.5)
        end
        TextLabel_2.Text = "[" .. tostring(distance) .. " studs]"
        end
        task.wait(0.05)
    end
    if DistanceHolder then
        DistanceHolder:Destroy()
    end
    end)
end
local ESP_Player = {
    Font = ARIMOFONT,
    Enabled = false,
    DistanceLimit = 10000,
    Boxes = false,
    BoxesColor = Color3.fromRGB(255, 255, 255),
    Names = false,
    NamesColor = Color3.fromRGB(255, 255, 255),
    Healthbar = false,
    HealthbarColor = Color3.fromRGB(255, 255, 255),
    Health = false,
    HealthColor = Color3.fromRGB(255, 255, 255),
    Weapons = false,
    WeaponsColor = Color3.fromRGB(255, 255, 255),
    Distance = false,
    DistanceColor = Color3.fromRGB(255, 255, 255),
    TeamEnabled = false,
    TeamDistanceLimit = 10000,
    TeamBoxes = false,
    TeamBoxesColor = Color3.fromRGB(255, 255, 255),
    TeamNames = false,
    TeamNamesColor = Color3.fromRGB(255, 255, 255),
    TeamHealthbar = false,
    TeamHealthbarColor = Color3.fromRGB(255, 255, 255),
    TeamHealth = false,
    TeamHealthColor = Color3.fromRGB(255, 255, 255),
    TeamWeapons = false,
    TeamWeaponsColor = Color3.fromRGB(255, 255, 255),
    TeamDistance = false,
    TeamDistanceColor = Color3.fromRGB(255, 255, 255)
}

function ESP_Player:findesptype(character, espname)
    for _, esp in pairs(ESPFolder:GetChildren()) do
    if esp:IsA("BillboardGui") then
        if esp.Name == espname and esp.Adornee.Parent == character then
        return esp
        elseif esp.Adornee == nil then
        esp:Destroy()
        end
    end
    end
    return nil
end

function ESP_Player:createbox(player)
    local isTeammate = global.Teammates[player] ~= nil and true or false
    if isTeammate and not ESP_Player.TeamBoxes or not isTeammate and not ESP_Player.Boxes then return end
    local character = player and player.Character
    if character then
    local HumanoidRootPart = character:WaitForChild("HumanoidRootPart", 10)
    if HumanoidRootPart then
        local lajzahook_box = ESP_Player:findesptype(character, "BoxHolder") or Instance.new("BillboardGui")
        local Down = lajzahook_box:FindFirstChild("Down") or Instance.new("Frame")
        local Left = lajzahook_box:FindFirstChild("Left") or Instance.new("Frame")
        local Right = lajzahook_box:FindFirstChild("Right") or Instance.new("Frame")
        local Up = lajzahook_box:FindFirstChild("Up") or Instance.new("Frame")
        local RightBorder = lajzahook_box:FindFirstChild("RightBorder") or Instance.new("Frame")
        local LeftBorder = lajzahook_box:FindFirstChild("LeftBorder") or Instance.new("Frame")
        local UpBorder = lajzahook_box:FindFirstChild("UpBorder") or Instance.new("Frame")
        local DownBorder = lajzahook_box:FindFirstChild("DownBorder") or Instance.new("Frame")
        local OuterBorders = lajzahook_box:FindFirstChild("OuterBorders") or Instance.new("Frame")
        local UIStroke = OuterBorders:FindFirstChild("UIStroke") or Instance.new("UIStroke")

        lajzahook_box.Name = "BoxHolder"
        lajzahook_box.MaxDistance = isTeammate and ESP_Player.TeamDistanceLimit or ESP_Player.DistanceLimit
        lajzahook_box.Parent = ESPFolder
        lajzahook_box.Adornee = HumanoidRootPart
        lajzahook_box.AlwaysOnTop = true
        lajzahook_box.Size = UDim2.new(4, 5, 6, 6)
        lajzahook_box.StudsOffset = Vector3.new(0, -0.1, 0)

        Down.Name = "Down"
        Down.Parent = lajzahook_box
        Down.BackgroundColor3 = isTeammate and ESP_Player.TeamBoxesColor or ESP_Player.BoxesColor
        Down.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Down.BorderSizePixel = 0
        Down.Position = UDim2.new(0, 0, 1, -1)
        Down.Size = UDim2.new(1, 0, 0, 1)

        Left.Name = "Left"
        Left.Parent = lajzahook_box
        Left.BackgroundColor3 = isTeammate and ESP_Player.TeamBoxesColor or ESP_Player.BoxesColor
        Left.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Left.BorderSizePixel = 0
        Left.Size = UDim2.new(0, 1, 1, 0)

        Right.Name = "Right"
        Right.Parent = lajzahook_box
        Right.BackgroundColor3 = isTeammate and ESP_Player.TeamBoxesColor or ESP_Player.BoxesColor
        Right.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Right.BorderSizePixel = 0
        Right.Position = UDim2.new(1, -1, 0, 0)
        Right.Size = UDim2.new(0, 1, 1, 0)

        Up.Name = "Up"
        Up.Parent = lajzahook_box
        Up.BackgroundColor3 = isTeammate and ESP_Player.TeamBoxesColor or ESP_Player.BoxesColor
        Up.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Up.BorderSizePixel = 0
        Up.Size = UDim2.new(1, 0, 0, 1)

        RightBorder.Name = "RightBorder"
        RightBorder.Parent = lajzahook_box
        RightBorder.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        RightBorder.BorderColor3 = Color3.fromRGB(0, 0, 0)
        RightBorder.BorderSizePixel = 0
        RightBorder.Position = UDim2.new(1, -2, 0, 1)
        RightBorder.Size = UDim2.new(0, 1, 1, -2)

        LeftBorder.Name = "LeftBorder"
        LeftBorder.Parent = lajzahook_box
        LeftBorder.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        LeftBorder.BorderColor3 = Color3.fromRGB(0, 0, 0)
        LeftBorder.BorderSizePixel = 0
        LeftBorder.Position = UDim2.new(0, 1, 0, 1)
        LeftBorder.Size = UDim2.new(0, 1, 1, -2)

        UpBorder.Name = "UpBorder"
        UpBorder.Parent = lajzahook_box
        UpBorder.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        UpBorder.BorderColor3 = Color3.fromRGB(0, 0, 0)
        UpBorder.BorderSizePixel = 0
        UpBorder.Position = UDim2.new(0, 1, 0, 1)
        UpBorder.Size = UDim2.new(1, -2, 0, 1)

        DownBorder.Name = "DownBorder"
        DownBorder.Parent = lajzahook_box
        DownBorder.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        DownBorder.BorderColor3 = Color3.fromRGB(0, 0, 0)
        DownBorder.BorderSizePixel = 0
        DownBorder.Position = UDim2.new(0, 1, 1, -2)
        DownBorder.Size = UDim2.new(1, -2, 0, 1)

        OuterBorders.Name = "OuterBorders"
        OuterBorders.Parent = lajzahook_box
        OuterBorders.BackgroundTransparency = 1
        OuterBorders.BorderColor3 = Color3.fromRGB(0, 0, 0)
        OuterBorders.ClipsDescendants = true
        OuterBorders.Size = UDim2.new(1, 0, 1, 0)

        UIStroke.Parent = OuterBorders

        local connection
        connection = player.CharacterRemoving:Connect(function()
        connection:Disconnect()
        lajzahook_box:Destroy()
        end)
    end
    end
end

function ESP_Player:createname(player)
    local isTeammate = global.Teammates[player] ~= nil and true or false
    if isTeammate and not ESP_Player.TeamNames then return end
    if not isTeammate and not ESP_Player.Names then return end
    local character = player and player.Character
    if character then
    local HumanoidRootPart = character:WaitForChild("HumanoidRootPart", 10)
    if HumanoidRootPart then
        local NameHolder = ESP_Player:findesptype(character, "NameHolder") or Instance.new("BillboardGui")
        local TextLabel = NameHolder:FindFirstChild("TextLabel") or Instance.new("TextLabel")
        local UIGradient = TextLabel:FindFirstChild("UIGradient") or Instance.new("UIGradient")

        NameHolder.Name = "NameHolder"
        NameHolder.MaxDistance = isTeammate and ESP_Player.TeamDistanceLimit or ESP_Player.DistanceLimit
        NameHolder.Parent = ESPFolder
        NameHolder.AlwaysOnTop = true
        NameHolder.Size = UDim2.new(0, 1, 0, 1)
        NameHolder.ClipsDescendants = false
        NameHolder.Adornee = HumanoidRootPart
        NameHolder.SizeOffset = Vector2.new(0, 10.6)
        NameHolder.StudsOffset = Vector3.new(0, 2.8, 0)

        TextLabel.Parent = NameHolder
        TextLabel.Size = UDim2.new(1, 0, 1, 0)
        TextLabel.BackgroundTransparency = 1
        TextLabel.TextStrokeTransparency = 0
        TextLabel.TextColor3 = isTeammate and ESP_Player.TeamNamesColor or ESP_Player.NamesColor
        TextLabel.Text = tostring(player.Name)
        TextLabel.FontFace = ESP_Player.Font
        TextLabel.TextSize = 12
        
        local connection
        connection = player.CharacterRemoving:Connect(function()
        connection:Disconnect()
        NameHolder:Destroy()
        end)
    end
    end
end

function ESP_Player:createdistance(player)
    local isTeammate = global.Teammates[player] ~= nil and true or false
    if isTeammate and not ESP_Player.TeamDistance or not isTeammate and not ESP_Player.Distance then return end
    local character = player and player.Character
    if character then
    local HumanoidRootPart = character:WaitForChild("HumanoidRootPart", 10)
    if HumanoidRootPart then
        local OldDistanceHolder = ESP_Player:findesptype(character, "DistanceHolder")
        local DistanceHolder = OldDistanceHolder or Instance.new("BillboardGui")
        local TextLabel = DistanceHolder:FindFirstChild("TextLabel") or Instance.new("TextLabel")

        DistanceHolder.Name = "DistanceHolder"
        DistanceHolder.MaxDistance = isTeammate and ESP_Player.TeamDistanceLimit or ESP_Player.DistanceLimit
        DistanceHolder.Parent = ESPFolder
        DistanceHolder.AlwaysOnTop = true
        DistanceHolder.Size = UDim2.new(0, 1, 0, 1)
        DistanceHolder.ClipsDescendants = false
        DistanceHolder.Adornee = HumanoidRootPart
        DistanceHolder.SizeOffset = Vector2.new(0, -10.6)
        DistanceHolder.StudsOffset = Vector3.new(0, -3.3, 0)

        TextLabel.Name = "TextLabel"
        TextLabel.Parent = DistanceHolder
        TextLabel.Size = UDim2.new(1, 0, 1, 0)
        TextLabel.BackgroundTransparency = 1
        TextLabel.TextStrokeTransparency = 0
        TextLabel.TextColor3 = isTeammate and ESP_Player.TeamDistanceColor or ESP_Player.DistanceColor
        TextLabel.Text = "[9999 studs]"
        TextLabel.TextSize = 12
        TextLabel.FontFace = ESP_Player.Font

        if OldDistanceHolder then return end

        task.spawn(function()
        if isTeammate then
            while DistanceHolder.Parent and DistanceHolder.Adornee and ESP_Player.TeamDistance do
            local hrp = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp and HumanoidRootPart then
                local distance = math.round((hrp.Position - HumanoidRootPart.Position).Magnitude)
                if distance > (DistanceHolder.MaxDistance + 200) then
                task.wait(0.5)
                end
                TextLabel.Text = "[" .. tostring(distance) .. " studs]"
            end
            task.wait(0.05)
            end
        else
            while DistanceHolder.Parent and DistanceHolder.Adornee and ESP_Player.Distance do
            local hrp = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp and HumanoidRootPart then
                local distance = math.round((hrp.Position - HumanoidRootPart.Position).Magnitude)
                if distance > (DistanceHolder.MaxDistance + 200) then
                task.wait(0.5)
                end
                TextLabel.Text = "[" .. tostring(distance) .. " studs]"
            end
            task.wait(0.05)
            end
        end
        DistanceHolder:Destroy()
        end)
    end
    end
end

function ESP_Player:createweapon(player)
    local isTeammate = global.Teammates[player] ~= nil and true or false
    if isTeammate and not ESP_Player.TeamWeapons or not isTeammate and not ESP_Player.Weapons then return end
    local character = player and player.Character
    if character then
    local HumanoidRootPart = character:WaitForChild("HumanoidRootPart", 10)
    if HumanoidRootPart then
        local WeaponHolder = ESP_Player:findesptype(character, "WeaponHolder") or Instance.new("BillboardGui")
        local TextLabel = WeaponHolder:FindFirstChild("TextLabel") or Instance.new("TextLabel")

        WeaponHolder.Name = "WeaponHolder"
        WeaponHolder.MaxDistance = isTeammate and ESP_Player.TeamDistanceLimit or ESP_Player.DistanceLimit
        WeaponHolder.Parent = ESPFolder
        WeaponHolder.AlwaysOnTop = true
        WeaponHolder.Size = UDim2.new(0, 1, 0, 1)
        WeaponHolder.ClipsDescendants = false
        WeaponHolder.Adornee = HumanoidRootPart
        WeaponHolder.SizeOffset = Vector2.new(0, -21)
        WeaponHolder.StudsOffsetWorldSpace = Vector3.new(0, 0, 0)
        WeaponHolder.StudsOffset = Vector3.new(0, -3.3, 0)

        TextLabel.Name = "TextLabel"
        TextLabel.Parent = WeaponHolder
        TextLabel.Size = UDim2.new(1, 0, 1, 0)
        TextLabel.ClipsDescendants = false
        TextLabel.BackgroundTransparency = 1
        TextLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
        TextLabel.TextStrokeTransparency = 0
        TextLabel.TextColor3 = isTeammate and ESP_Player.TeamWeaponsColor or ESP_Player.WeaponsColor
        TextLabel.TextSize = 12
        TextLabel.FontFace = ESP_Player.Font

        TextLabel.Text = #character.Equipped:GetChildren() ~= 0 and character.Equipped:GetChildren()[1].Name or (Players.LocalPlayer.Character and Players.LocalPlayer.Character.PrimaryPart and (Players.LocalPlayer.Character.PrimaryPart.Position-character.PrimaryPart.Position).Magnitude < 2200) and "Hands" or ""

        local connection
        connection = character.Equipped.ChildAdded:Connect(function()
        TextLabel.Text = #character.Equipped:GetChildren() ~= 0 and character.Equipped:GetChildren()[1].Name or (Players.LocalPlayer.Character and Players.LocalPlayer.Character.PrimaryPart and (Players.LocalPlayer.Character.PrimaryPart.Position-character.PrimaryPart.Position).Magnitude < 2200) and "Hands" or ""
        end)

        local connection2
        connection2 = player.CharacterRemoving:Connect(function()
        WeaponHolder:Destroy()
        connection:Disconnect()
        connection2:Disconnect()
        end)
    end
    end
end
function ESP_Player:createhealthbar(player)
    local isTeammate = global.Teammates[player] ~= nil and true or false
    if isTeammate and not ESP_Player.TeamHealthbar or not isTeammate and not ESP_Player.Healthbar then return end
    local character = player and player.Character
    if character then
    local HumanoidRootPart = character:WaitForChild("HumanoidRootPart", 10)
    if HumanoidRootPart then
        local HealthbarHolder = ESP_Player:findesptype(character, "HealthbarHolder") or Instance.new("BillboardGui")
        local Frame = HealthbarHolder:FindFirstChild("Frame") or Instance.new("Frame")
        local UIGradient = Frame:FindFirstChild("UIGradient") or Instance.new("UIGradient")

        HealthbarHolder.Name = "HealthbarHolder"
        HealthbarHolder.MaxDistance = isTeammate and ESP_Player.TeamDistanceLimit or ESP_Player.DistanceLimit
        HealthbarHolder.Parent = ESPFolder
        HealthbarHolder.LightInfluence = 1
        HealthbarHolder.Brightness = 1
        HealthbarHolder.AlwaysOnTop = true
        HealthbarHolder.Size = UDim2.new(0, 2, 6, 6)
        HealthbarHolder.ClipsDescendants = false
        HealthbarHolder.Adornee = HumanoidRootPart
        HealthbarHolder.SizeOffset = Vector2.new(-3, 0)
        HealthbarHolder.StudsOffset = Vector3.new(-2.25, -0.25, 0)

        Frame.Parent = HealthbarHolder
        Frame.Visible = true
        Frame.Size = UDim2.new(1, 0, 1, 0)
        Frame.ClipsDescendants = false
        Frame.BorderColor3 = Color3.new(0, 0, 0)
        Frame.BorderSizePixel = 1
        Frame.Rotation = 0
        Frame.BackgroundTransparency = 0
        Frame.Position = UDim2.new(0, 0, 0, 0)
        Frame.BorderMode = Enum.BorderMode.Outline
        Frame.BackgroundColor3 = isTeammate and ESP_Player.TeamHealthbarColor or ESP_Player.HealthbarColor

        UIGradient.Name = "UIGradient"
        UIGradient.Parent = Frame
        UIGradient.Offset = Vector2.new(0, 0)
        UIGradient.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 0)})
        local health = math.clamp(player.Stats.Health.Value / 100, 0.002, 0.999)
        if health == 0.999 then
        UIGradient.Color = ColorSequence.new(Color3.new(1, 1, 1))
        elseif health == 0.002 then
        UIGradient.Color = ColorSequence.new(Color3.new(0, 0, 0))
        else
        UIGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
            ColorSequenceKeypoint.new(health, Color3.new(1, 1, 1)),
            ColorSequenceKeypoint.new(health + 0.001, Color3.new(0, 0, 0)),
            ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0))
        })
        end
        UIGradient.Enabled = true
        UIGradient.Rotation = -90

        local connection1
        connection1 = player.Stats.Health:GetPropertyChangedSignal("Value"):Connect(function()
        local health = math.clamp(player.Stats.Health.Value / 100, 0.002, 0.999)

        if health == 0.999 then
            UIGradient.Color = ColorSequence.new(Color3.new(1, 1, 1))
        elseif health == 0.002 then
            UIGradient.Color = ColorSequence.new(Color3.new(0, 0, 0))
        else
            UIGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
            ColorSequenceKeypoint.new(health, Color3.new(1, 1, 1)),
            ColorSequenceKeypoint.new(health + 0.001, Color3.new(0, 0, 0)),
            ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0))
            })
        end
        end)

        local connection2
        connection2 = player.CharacterRemoving:Connect(function()
        connection2:Disconnect()
        HealthbarHolder:Destroy()
        end)
    end
    end
end
function ESP_Player:createhealth(player)
    local isTeammate = global.Teammates[player] ~= nil and true or false
    if isTeammate and not ESP_Player.TeamHealth or not isTeammate and not ESP_Player.Health then return end
    local character = player and player.Character
    if character then
    local HumanoidRootPart = character:WaitForChild("HumanoidRootPart", 10)
    if HumanoidRootPart then
        local HealthHolder = ESP_Player:findesptype(character, "HealthHolder") or Instance.new("BillboardGui")
        local TextLabel = HealthHolder:FindFirstChild("TextLabel") or Instance.new("TextLabel")
        
        HealthHolder.Name = "HealthHolder"
        HealthHolder.MaxDistance = isTeammate and ESP_Player.TeamDistanceLimit or ESP_Player.DistanceLimit
        HealthHolder.Parent = ESPFolder
        HealthHolder.LightInfluence = 1
        HealthHolder.Brightness = 1
        HealthHolder.AlwaysOnTop = true
        HealthHolder.Size = UDim2.new(0, 1, 6, 6)
        HealthHolder.ClipsDescendants = false
        HealthHolder.Adornee = HumanoidRootPart
        HealthHolder.SizeOffset = Vector2.new(-18.6, 0)
        HealthHolder.StudsOffsetWorldSpace = Vector3.new(0, 0, 0)
        HealthHolder.StudsOffset = Vector3.new(-2.25, 0, 0)
        
        TextLabel.Parent = HealthHolder
        TextLabel.Size = UDim2.new(1, 0, 1, 0)
        TextLabel.BackgroundTransparency = 1
        TextLabel.TextStrokeTransparency = 0
        TextLabel.TextColor3 = isTeammate and ESP_Player.TeamHealthColor or ESP_Player.HealthColor
        TextLabel.Text = tostring(math.round(player.Stats.Health.Value))
        TextLabel.FontFace = ESP_Player.Font
        TextLabel.TextSize = 10
        
        local connection1
        connection1 = player.Stats.Health:GetPropertyChangedSignal("Value"):Connect(function()
        TextLabel.Text = tostring(math.round(player.Stats.Health.Value))
        end)

        local connection2
        connection2 = player.CharacterRemoving:Connect(function()
        connection2:Disconnect()
        HealthHolder:Destroy()
        end)
    end
    end
end

function ESP_Player:refresh(player)
    if ESP_Player.Enabled or ESP_Player.TeamEnabled then
    task.spawn(function()
        if ESP_Player.Boxes or ESP_Player.TeamBoxes then
        ESP_Player:createbox(player)
        end
        if ESP_Player.Names or ESP_Player.TeamNames then
        ESP_Player:createname(player)
        end
        if ESP_Player.Distance or ESP_Player.TeamDistance then
        ESP_Player:createdistance(player)
        end
        if ESP_Player.Weapons or ESP_Player.TeamWeapons then
        ESP_Player:createweapon(player)
        end
    end)
    end
end

for _, player in pairs(Players:GetPlayers()) do
    if player ~= Players.LocalPlayer then
    player.CharacterAdded:Connect(function()
        task.wait(1)
        ESP_Player:refresh(player)
    end)
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
    task.wait(1)
    ESP_Player:refresh(player)
    end)
end)

if OUTSECURE_DISCORD_PFPURL then
    pcall(function() writefile("lajzahook/pfp.png", game:HttpGet(OUTSECURE_DISCORD_PFPURL)) end)
end

function UILibrary:Window()
    local neverlose_ui = game:GetObjects("rbxassetid://102211681905928")[1]
    
    neverlose_ui.Parent = CoreGui

    local pgui = protectgui or protect_gui or function() end

    pgui(neverlose_ui)

    local PFP_ASSET
    pcall(function() PFP_ASSET = getcustomasset("lajzahook/pfp.png") end)

    neverlose_ui.Frame.Profile.Frame.Frame.name.Text = OUTSECURE_DISCORD_USERNAME or "root"
    if PFP_ASSET then
        neverlose_ui.Frame.Profile.Frame.ImageLabel.Image = PFP_ASSET
    end

    local TweenService = game:GetService("TweenService")
    
    local window = {
        mainui = neverlose_ui,
        lastcolorpicker = nil,
        lastcolorpickerSide = nil,
        lastcolorpickerSF = nil,
        examples = neverlose_ui.EXAMPLES,
        dragbar = neverlose_ui.Frame.DragBar,
        dragging = false,
        dragstart = false,
        startpos = false,
        tweeninfo = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        tweeninfo2 = TweenInfo.new(0.15, Enum.EasingStyle.Linear, Enum.EasingDirection.Out),
        tweeninfo3 = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
        currenttween = nil,
        switchingtab = false
    }

    UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Delete then
        neverlose_ui.Frame.Visible = not neverlose_ui.Frame.Visible
    end
    end)

    local function ColorToHex(color, transparency)
    transparency = math.clamp(transparency, 0, 1)
    
    local r = math.round(color.R * 255 + 0.5)
    local g = math.round(color.G * 255 + 0.5)
    local b = math.round(color.B * 255 + 0.5)
    
    local a = math.round((1 - transparency) * 255 + 0.5)
    
    return string.format("#%02X%02X%02X%02X", r, g, b, a)
    end

    window.dragbar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        window.dragging = true
        window.dragstart = input.Position
        window.startpos = neverlose_ui.Frame.Position
    end
    end)

    UserInputService.InputChanged:Connect(function(input)
    if window.dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - window.dragstart
        local targetPos = UDim2.new(
        window.startpos.X.Scale,
        window.startpos.X.Offset + delta.X,
        window.startpos.Y.Scale,
        window.startpos.Y.Offset + delta.Y
        )
    
        if window.currentTween then
        window.currentTween:Cancel()
        end
    
        window.currentTween = TweenService:Create(neverlose_ui.Frame, window.tweeninfo, { Position = targetPos })
        window.currentTween:Play()
    end
    end)

    window.dragbar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        window.dragging = false
    end
    end)

    function window:SaveConfig(name)
    local xd = "return {\n['toggle'] = {"
    for option, value in pairs(UILibrary.savings.toggle) do
        xd = xd .. "\n['" .. option .. "'] = " .. tostring(value) .. ","
    end
    xd = xd .. "\n},\n['slider'] = {"
    for option, value in pairs(UILibrary.savings.slider) do
        xd = xd .. "\n['" .. option .. "'] = " .. tostring(value) .. ","
    end
    xd = xd .. "\n},\n['dropdown'] = {"
    for option, value in pairs(UILibrary.savings.dropdown) do
        xd = xd .. "\n['" .. option .. "'] = '" .. tostring(value) .. "',"
    end
    xd = xd .. "\n},\n['togglecolorpicker'] = {"
    for option, value in pairs(UILibrary.savings.togglecolorpicker) do
        xd = xd .. "\n['" .. option .. "'] = {[1] = " .. tostring(value[1]) .. ", [2] = Color3.new(" .. tostring(value[2]) .. "), [3] = " .. tostring(value[3]) .. "},"
    end
    xd = xd .. "\n}\n}"
    writefile("lajzahook/configs/"..name..".cfg", xd)
    end

    function window:LoadConfig(name)
    if isfile("lajzahook/configs/"..name..".cfg") then
        local cfg = readfile("lajzahook/configs/"..name..".cfg")
        local config = loadstring(cfg)()
    
        for typee, tbl in pairs(config) do
        for option, value in pairs(tbl) do
            task.spawn(function() UILibrary.loads[typee][option](value) end)
        end
        end
    else
        warn("[lajzahook] Config named "..name.." doesn't exist")
    end
    end

    function window:TabGroup(name)
    local grouptab = {}
    
    local tabgroup = window.examples.tabgroup.TabGroup:Clone()
    tabgroup.TextLabel.Text = name
    tabgroup.Parent = neverlose_ui.Frame.Tabs
    
    function grouptab:Tab(tabname)
        local tab = window.examples.tab.Tab:Clone()
        tab.TextLabel.Text = tabname
        tab.Parent = tabgroup.Folder

        local content = window.examples.content.Frame:Clone()
        content.Parent = neverlose_ui.Frame.MAIN

        local tab_content = {
        content = content
        }

        function tab_content:Section(info)
        local section = {}

        local name, side = info.name or info.Name, info.side or info.Side

        if side ~= "Left" and side ~= "Right" then
            side = "Left"
        end

        local sectionframe = window.examples.section.section:Clone()
        sectionframe.Frame.sectionname.Text = name
        sectionframe.Parent = content[side]
        
        function section:Toggle(info)
            local toggle = {
            name = info.name or info.Name or "",
            callback = info.callback or info.Callback or function() end,
            state = false,
            mouseon = false
            }

            UILibrary.savings.toggle[tabname.."_"..name.."_"..toggle.name] = false
        
            local frame = window.examples.main.Toggle:Clone()
            frame.TextLabel.Text = toggle.name
            frame.Parent = sectionframe.Frame.Content
        
            local innerFrame = frame.Frame
            local circleFrame = innerFrame.Frame
        
            local function tweenToggle()
            local colorGoal = toggle.state and Color3.fromRGB(0, 25, 50) or Color3.fromRGB(0, 5, 10)
            TweenService:Create(innerFrame, window.tweeninfo3, {
                BackgroundColor3 = colorGoal
            }):Play()

            local colorGoal2 = toggle.state and Color3.fromRGB(0, 140, 255) or Color3.fromRGB(80, 90, 100)
            TweenService:Create(circleFrame, window.tweeninfo3, {
                BackgroundColor3 = colorGoal2
            }):Play()
        
            local posGoal = toggle.state and UDim2.new(1, -12, 0, -1) or UDim2.new(0, 0, 0, -1)
            TweenService:Create(circleFrame, window.tweeninfo3, {
                Position = posGoal
            }):Play()

            if not toggle.mouseon then
                local colorGoal3 = toggle.state and Color3.fromRGB(225, 230, 235) or Color3.fromRGB(180, 185, 190)
                TweenService:Create(frame.TextLabel, window.tweeninfo2, {
                TextColor3 = colorGoal3
                }):Play()
            end
            end
        
            local function toggleRun()
            tweenToggle()
            UILibrary.savings.toggle[tabname.."_"..name.."_"..toggle.name] = toggle.state
            pcall(toggle.callback, toggle.state)
            end

            frame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                toggle.state = not toggle.state
                toggleRun()
            end
            end)

            frame.MouseEnter:Connect(function()
            toggle.mouseon = true
            local colorGoal = Color3.fromRGB(225, 230, 235)
            TweenService:Create(frame.TextLabel, window.tweeninfo, {
                TextColor3 = colorGoal
            }):Play()
            end)

            frame.MouseLeave:Connect(function()
            toggle.mouseon = false
            local colorGoal = toggle.state and Color3.fromRGB(225, 230, 235) or Color3.fromRGB(180, 185, 190)
            TweenService:Create(frame.TextLabel, window.tweeninfo, {
                TextColor3 = colorGoal
            }):Play()
            end)

            UILibrary.loads.toggle[tabname.."_"..name.."_"..toggle.name] = function(bool)
            if toggle.state ~= bool then
                toggle.state = bool
                UILibrary.savings.toggle[tabname.."_"..name.."_"..toggle.name] = bool
                toggleRun()
            end
            end
        
            return toggle
        end
        
        function section:ToggleColorpicker(info)
            local togglecolorpicker = {
            name = info.name or info.Name or "",
            togglecallback = info.togglecallback or info.ToggleCallback or function() end,
            colorpickercallback = info.colorpickercallback or info.ColorpickerCallback or info.ColorPickerCallback or function() end,
            transparencycallback = info.transparencycallback or info.TransparencyCallback or function() end,
            state = false,
            mouseon = false,
            draggingslider = false,
            draggingtransparency = false,
            draggingsquare = false,
            squaresaturation = 0,
            squarebrightness = 1,
            transparencyslider = 0,
            slidercolor = Color3.fromRGB(255, 0, 0)
            }

            UILibrary.savings.togglecolorpicker[tabname.."_"..name.."_"..togglecolorpicker.name] = {false, Color3.fromRGB(255, 255, 255), 0}
        
            local frame = window.examples.main.ToggleColorpicker:Clone()
            frame.TextLabel.Text = togglecolorpicker.name
            frame.Parent = sectionframe.Frame.Content
        
            local innerFrame = frame.Frame
            local circleFrame = innerFrame.Frame
        
            local function tweenToggle()
            local colorGoal = togglecolorpicker.state and Color3.fromRGB(0, 25, 50) or Color3.fromRGB(0, 5, 10)
            TweenService:Create(innerFrame, window.tweeninfo3, {
                BackgroundColor3 = colorGoal
            }):Play()

            local colorGoal2 = togglecolorpicker.state and Color3.fromRGB(0, 140, 255) or Color3.fromRGB(80, 90, 100)
            TweenService:Create(circleFrame, window.tweeninfo3, {
                BackgroundColor3 = colorGoal2
            }):Play()
        
            local posGoal = togglecolorpicker.state and UDim2.new(1, -12, 0, -1) or UDim2.new(0, 0, 0, -1)
            TweenService:Create(circleFrame, window.tweeninfo3, {
                Position = posGoal
            }):Play()

            if not togglecolorpicker.mouseon then
                local colorGoal3 = togglecolorpicker.state and Color3.fromRGB(225, 230, 235) or Color3.fromRGB(180, 185, 190)
                TweenService:Create(frame.TextLabel, window.tweeninfo2, {
                TextColor3 = colorGoal3
                }):Play()
            end
            end
        
            frame.Frame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                togglecolorpicker.state = not togglecolorpicker.state
                UILibrary.savings.togglecolorpicker[tabname.."_"..name.."_"..togglecolorpicker.name][1] = togglecolorpicker.state
                tweenToggle()
                pcall(togglecolorpicker.togglecallback, togglecolorpicker.state)
            end
            end)

            frame.MouseEnter:Connect(function()
            togglecolorpicker.mouseon = true
            local colorGoal = Color3.fromRGB(225, 230, 235)
            TweenService:Create(frame.TextLabel, window.tweeninfo, {
                TextColor3 = colorGoal
            }):Play()
            end)

            frame.MouseLeave:Connect(function()
            togglecolorpicker.mouseon = false
            local colorGoal = togglecolorpicker.state and Color3.fromRGB(225, 230, 235) or Color3.fromRGB(180, 185, 190)
            TweenService:Create(frame.TextLabel, window.tweeninfo, {
                TextColor3 = colorGoal
            }):Play()
            end)

            frame.Colorpicker.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                local visible = not frame.Main.Visible

                if window.lastcolorpicker and window.lastcolorpicker ~= frame.Colorpicker then
                local lastMain = window.lastcolorpicker.Main
                if lastMain then
                    lastMain.TextButton.ColorText.TextLabel.Visible = false
                    lastMain.TextButton.Copy.TextLabel.Visible = false
                    lastMain.TextButton.Paste.TextLabel.Visible = false
                    lastMain.Size = UDim2.new(0, 195, 0, 190)
                    local tween = TweenService:Create(lastMain, window.tweeninfo, {
                        Size = UDim2.new(0, 0, 0, 0)
                    })
                    tween:Play()
                    tween.Completed:Wait()
                    lastMain.Visible = false
                    window.lastcolorpickerSF.ZIndex = 1
                    window.lastcolorpicker.ZIndex = 3
                    window.lastcolorpickerSide.ZIndex = 1
                end
                end
                if visible then
                window.lastcolorpicker = frame
                window.lastcolorpickerSide = content[side]
                window.lastcolorpickerSF = sectionframe
                sectionframe.ZIndex = 3
                frame.ZIndex = 4
                content[side].ZIndex = 2
                frame.Main.Visible = true
                frame.Main.TextButton.ColorText.TextLabel.Visible = true
                frame.Main.TextButton.Copy.TextLabel.Visible = true
                frame.Main.TextButton.Paste.TextLabel.Visible = true
                frame.Main.Size = UDim2.new(0, 0, 0, 0)
                TweenService:Create(frame.Main, window.tweeninfo, {
                    Size = UDim2.new(0, 195, 0, 190)
                }):Play()
                else
                window.lastcolorpicker = nil
                frame.Main.TextButton.ColorText.TextLabel.Visible = false
                frame.Main.TextButton.Copy.TextLabel.Visible = false
                frame.Main.TextButton.Paste.TextLabel.Visible = false
                frame.Main.Size = UDim2.new(0, 195, 0, 190)
                local tween = TweenService:Create(frame.Main, window.tweeninfo, {
                    Size = UDim2.new(0, 0, 0, 0)
                })
                tween:Play()
                tween.Completed:Wait()
                frame.Main.Visible = false
                sectionframe.ZIndex = 1
                frame.ZIndex = 3
                content[side].ZIndex = 1
                end
            end
            end)

            -- colorpicker shit

            local function updateslider(input)
            local barWidth = frame.Main.TextButton.RGBSlider.AbsoluteSize.Y
            local relativeY = math.clamp(input.Position.Y - frame.Main.TextButton.RGBSlider.AbsolutePosition.Y, 0, barWidth)
            local percent = relativeY / barWidth
            
            TweenService:Create(frame.Main.TextButton.RGBSlider.Arrows, window.tweeninfo, { Position = UDim2.new(0, -2, percent, -4) }):Play()
            
            frame.Main.TextButton.RGBSquare.UIGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                ColorSequenceKeypoint.new(1, Color3.fromHSV(1 - percent, 1, 1))
            })
            
            togglecolorpicker.slidercolor = Color3.fromHSV(1 - percent, 1, 1)
            local newcolor = Color3.fromHSV(1 - percent, togglecolorpicker.squaresaturation, togglecolorpicker.squarebrightness)

            frame.Colorpicker.BackgroundColor3 = newcolor
            frame.Main.TextButton.RGBSquare.Frame.BackgroundColor3 = newcolor
            frame.Main.TextButton.ColorText.TextLabel.Text = ColorToHex(newcolor, togglecolorpicker.transparencyslider)

            UILibrary.savings.togglecolorpicker[tabname.."_"..name.."_"..togglecolorpicker.name][2] = newcolor

            pcall(togglecolorpicker.colorpickercallback, newcolor)
            end
            
            local function updatetransparency(input)
            local barWidth = frame.Main.TextButton.RGBTransparency.AbsoluteSize.Y

            local relativeY = math.clamp(input.Position.Y - frame.Main.TextButton.RGBTransparency.AbsolutePosition.Y, 0, barWidth)
            local percent = relativeY / barWidth

            TweenService:Create(frame.Main.TextButton.RGBTransparency.Arrows, window.tweeninfo, { Position = UDim2.new(0, -2, percent, -4) }):Play()

            togglecolorpicker.transparencyslider = percent

            local newcolor = Color3.fromHSV(togglecolorpicker.slidercolor, togglecolorpicker.squaresaturation, togglecolorpicker.squarebrightness)

            frame.Main.TextButton.ColorText.TextLabel.Text = ColorToHex(newcolor, togglecolorpicker.transparencyslider)

            UILibrary.savings.togglecolorpicker[tabname.."_"..name.."_"..togglecolorpicker.name][3] = percent

            pcall(togglecolorpicker.transparencycallback, percent)
            end
            local function updatesquare(input)
            local square = frame.Main.TextButton.RGBSquare
            local barWidthX = square.AbsoluteSize.X
            local barWidthY = square.AbsoluteSize.Y
            
            local relativeX = math.clamp(input.Position.X - square.AbsolutePosition.X, 0, barWidthX)
            local relativeY = math.clamp(input.Position.Y - square.AbsolutePosition.Y, 0, barWidthY)
            
            local percentX = relativeX / barWidthX
            local percentY = relativeY / barWidthY
            
            TweenService:Create(square.Frame, window.tweeninfo, { Position = UDim2.new(percentX, -5, percentY, -5) }):Play()
            
            togglecolorpicker.squaresaturation = percentX
            togglecolorpicker.squarebrightness = 1 - percentY
            
            local h, _, _ = Color3.toHSV(togglecolorpicker.slidercolor)
            local newcolor = Color3.fromHSV(h, percentX, 1 - percentY)

            frame.Colorpicker.BackgroundColor3 = newcolor
            frame.Main.TextButton.RGBSquare.Frame.BackgroundColor3 = newcolor
            frame.Main.TextButton.ColorText.TextLabel.Text = ColorToHex(newcolor, togglecolorpicker.transparencyslider)

            UILibrary.savings.togglecolorpicker[tabname.."_"..name.."_"..togglecolorpicker.name][2] = newcolor
            
            pcall(togglecolorpicker.colorpickercallback, newcolor)
            end
            frame.Main.TextButton.RGBSlider.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                togglecolorpicker.draggingslider = true
                updateslider(input)
            end
            end)
            frame.Main.TextButton.RGBTransparency.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                togglecolorpicker.draggingtransparency = true
                updatetransparency(input)
            end
            end)
            frame.Main.TextButton.RGBSquare.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                togglecolorpicker.draggingsquare = true
                updatesquare(input)
            end
            end)
            UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                togglecolorpicker.draggingslider = false
                togglecolorpicker.draggingtransparency = false
                togglecolorpicker.draggingsquare = false
            end
            end)
            UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                if togglecolorpicker.draggingslider then
                updateslider(input)
                elseif togglecolorpicker.draggingtransparency then
                updatetransparency(input)
                elseif togglecolorpicker.draggingsquare then
                updatesquare(input)
                end
            end
            end)

            UILibrary.loads.togglecolorpicker[tabname.."_"..name.."_"..togglecolorpicker.name] = function(tbl)
            local oldstate = togglecolorpicker.state
            togglecolorpicker.state = tbl[1]
            local color = tbl[2]
            local transparency = tbl[3]

            UILibrary.savings.togglecolorpicker[tabname.."_"..name.."_"..togglecolorpicker.name] = tbl
            
            local h, s, v = Color3.toHSV(color)
            togglecolorpicker.slidercolor = Color3.fromHSV(h, 1, 1)
            togglecolorpicker.squaresaturation = s
            togglecolorpicker.squarebrightness = v
            togglecolorpicker.transparencyslider = transparency
            
            frame.Main.TextButton.RGBSlider.Arrows.Position = UDim2.new(0, -2, 1 - h, -4)
            frame.Main.TextButton.RGBSquare.Frame.Position = UDim2.new(s, -5, 1 - v, -5)
            frame.Main.TextButton.RGBTransparency.Arrows.Position = UDim2.new(0, -2, transparency, -4)
            
            frame.Main.TextButton.RGBSquare.UIGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                ColorSequenceKeypoint.new(1, togglecolorpicker.slidercolor)
            })
            
            frame.Colorpicker.BackgroundColor3 = color
            frame.Main.TextButton.RGBSquare.Frame.BackgroundColor3 = color
            frame.Main.TextButton.ColorText.TextLabel.Text = ColorToHex(color, transparency)
            
            tweenToggle()
            
            pcall(togglecolorpicker.colorpickercallback, color)
            pcall(togglecolorpicker.transparencycallback, transparency)
            if tbl[1] ~= oldstate then
                pcall(togglecolorpicker.togglecallback, togglecolorpicker.state)
            end
            end
        
            return togglecolorpicker
        end
        
        function section:Slider(info)
            local slider = {
            name = info.name or info.Name or "slider",
            min = info.min or info.Min or 1,
            max = info.max or info.Max or 10,
            callback = info.callback or info.Callback or function() end,
            dragging = false,
            mouseon = false,
            tween = nil
            }

            slider.default = info.default or info.Default or slider.min
            slider.lastvalue = slider.default
            
            UILibrary.savings.slider[tabname.."_"..name.."_"..slider.name] = slider.default

            local frame = window.examples.main.Slider:Clone()
            frame.TextLabel.Text = slider.name
            frame.Parent = sectionframe.Frame.Content

            frame.Box.TextLabel.Text = slider.min

            frame.MouseEnter:Connect(function()
            slider.mouseon = true
            TweenService:Create(frame.TextLabel, window.tweeninfo, {
                TextColor3 = Color3.fromRGB(225, 230, 235)
            }):Play()
            end)

            frame.MouseLeave:Connect(function()
            slider.mouseon = false
            if not slider.dragging then
                TweenService:Create(frame.TextLabel, window.tweeninfo, {
                TextColor3 = Color3.fromRGB(180, 185, 190)
                }):Play()
            end
            end)

            local barWidth = frame.Frame.Frame.AbsoluteSize.X - 3

            frame.Box.TextLabel.Text = slider.default
            local percent = (slider.default - slider.min) / (slider.max - slider.min)
            local uigradientpercent = math.round(math.clamp(percent * 1000, 2, 999)) / 1000
            frame.Frame.Frame.UIGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 80, 120)),
            ColorSequenceKeypoint.new(uigradientpercent - 0.001, Color3.fromRGB(40, 80, 120)),
            ColorSequenceKeypoint.new(uigradientpercent, Color3.fromRGB(30, 35, 40)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 35, 40))
            })
            frame.Frame.Frame.Frame.Position = UDim2.new(0, percent * barWidth - frame.Frame.Frame.Frame.Size.X.Offset / 2, 0.5, -frame.Frame.Frame.Frame.Size.Y.Offset / 2)

            local function updateslider(input)
            local relativeX = math.clamp(input.Position.X - frame.Frame.Frame.AbsolutePosition.X, 0, barWidth)
            local percent = relativeX / barWidth
            
            local value = math.round(percent * (slider.max - slider.min) + slider.min)
            
            frame.Box.TextLabel.Text = value
            
            local uigradientpercent = math.round(math.clamp(percent * 1000, 2, 999)) / 1000
            frame.Frame.Frame.UIGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 80, 120)),
                ColorSequenceKeypoint.new(uigradientpercent - 0.001, Color3.fromRGB(40, 80, 120)),
                ColorSequenceKeypoint.new(uigradientpercent, Color3.fromRGB(30, 35, 40)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 35, 40))
            })

            if slider.tween then
                slider.tween:Cancel()
                slider.tween = nil
            end
            slider.tween = TweenService:Create(frame.Frame.Frame.Frame, window.tweeninfo, {
                Position = UDim2.new(0, relativeX - frame.Frame.Frame.Frame.Size.X.Offset / 2, 0.5, -frame.Frame.Frame.Frame.Size.Y.Offset / 2)
            })
            slider.tween:Play()

            if slider.lastvalue ~= value then
                slider.lastvalue = value
                UILibrary.savings.slider[tabname.."_"..name.."_"..slider.name] = value
                pcall(slider.callback, value)
            end
            end

            frame.Frame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                slider.dragging = true
                updateslider(input)
            end
            end)
            UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                slider.dragging = false
            end
            end)
            UserInputService.InputChanged:Connect(function(input)
            if slider.dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                updateslider(input)
            end
            end)

            local function updateFromValue(value)
            UILibrary.savings.slider[tabname.."_"..name.."_"..slider.name] = value
            
            local percent = (value - slider.min) / (slider.max - slider.min)
            local uigradientpercent = math.round(math.clamp(percent * 1000, 2, 999)) / 1000
            
            frame.Frame.Frame.UIGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 80, 120)),
                ColorSequenceKeypoint.new(uigradientpercent - 0.001, Color3.fromRGB(40, 80, 120)),
                ColorSequenceKeypoint.new(uigradientpercent, Color3.fromRGB(30, 35, 40)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 35, 40))
            })
            local tween = TweenService:Create(frame.Frame.Frame.Frame, window.tweeninfo, {
                Position = UDim2.new(0, percent * barWidth - frame.Frame.Frame.Frame.Size.X.Offset / 2, 0.5, -frame.Frame.Frame.Frame.Size.Y.Offset / 2)
            })
            tween:Play()
            
            frame.Box.TextLabel.Text = tostring(value)
            
            pcall(slider.callback, value)
            end

            frame.Box.TextLabel.FocusLost:Connect(function()
            local value = tonumber(frame.Box.TextLabel.Text)
            if value then 
                if value ~= slider.lastvalue then
                value = math.floor(math.clamp(value, slider.min, slider.max))
                slider.lastvalue = value
                updateFromValue(value)
                end
            else
                frame.Box.TextLabel.Text = slider.lastvalue
            end
            end)
            
            UILibrary.loads.slider[tabname.."_"..name.."_"..slider.name] = function(value)
            if value ~= slider.lastvalue then
                value = math.clamp(value, slider.min, slider.max)
                slider.lastvalue = value
                updateFromValue(value)
            end
            end

            return slider
        end
        
        function section:Dropdown(info)
            local dropdown = {
            name = info.name or info.Name or "dropdown",
            items = info.items or info.Items or {"Default"},
            callback = info.callback or info.Callback or function() end,
            multi = info.multi or info.Multi or false,
            mouseon = false,
            selected = {}
            }
        
            if dropdown.multi then
            dropdown.selected = { [dropdown.items[1]] = true }
            UILibrary.savings.dropdown[tabname.."_"..name.."_"..dropdown.name] = { dropdown.items[1] }
            else
            UILibrary.savings.dropdown[tabname.."_"..name.."_"..dropdown.name] = dropdown.items[1]
            end
        
            local frame = window.examples.main.Dropdown:Clone()
            frame.TextLabel.Text = dropdown.name
            frame.Parent = sectionframe.Frame.Content
        
            frame.MAIN.TextLabel.Text = dropdown.multi and dropdown.items[1] or dropdown.items[1]
            frame.MAIN.Content.TextTransparency = 1

            if dropdown.multi then
            frame.MAIN.TextLabel.TextTruncate = Enum.TextTruncate.AtEnd
            frame.MAIN.TextLabel.TextWrapped = false
            end
        
            local function updateDisplayText()
            if dropdown.multi then
                local selected = {}
                for item, selectedState in pairs(dropdown.selected) do
                if selectedState then
                    table.insert(selected, item)
                end
                end
                frame.MAIN.TextLabel.Text = table.concat(selected, ", ")
            end
            end
        
            local function showhidecontent()
            local visible = not frame.MAIN.Content.Visible
            if visible then
                sectionframe.ZIndex = 3
                frame.ZIndex = 3
                frame.MAIN.Content.Visible = true
            end
            for _, item in pairs(frame.MAIN.Content.Frame:GetChildren()) do
                if not item:IsA("UIListLayout") then
                local transparencyGoal
                if visible then
                    item.TextTransparency = 1
                    transparencyGoal = 0
                else
                    item.TextTransparency = 0
                    transparencyGoal = 1
                end
                TweenService:Create(item, window.tweeninfo2, {
                    TextTransparency = transparencyGoal
                }):Play()
                end
            end
            task.wait(0.2)
            if not visible then
                sectionframe.ZIndex = 1
                frame.ZIndex = 1
                frame.MAIN.Content.Visible = false
                if not dropdown.mouseon then
                TweenService:Create(frame.TextLabel, window.tweeninfo, {
                    TextColor3 = Color3.fromRGB(180, 185, 190)
                }):Play()
                TweenService:Create(frame.MAIN, window.tweeninfo2, {
                    BackgroundColor3 = Color3.fromRGB(5, 10, 15)
                }):Play()
                end
            end
            end
        
            for _, itemname in pairs(dropdown.items) do
            local option = window.examples.dropdownitem.TextLabel:Clone()
            option.Text = itemname
            option.Parent = frame.MAIN.Content.Frame

            if _ == 1 then
                option.TextColor3 = Color3.fromRGB(200, 210, 220)
            end
        
            option.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                if dropdown.multi then
                    
                    dropdown.selected[itemname] = not dropdown.selected[itemname]

                    local count = 0
                    for _, v in pairs(dropdown.selected) do
                    if v then count += 1 end
                    end
                    if count == 0 then
                    dropdown.selected[itemname] = true
                    return
                    end
                    
                    option.TextColor3 = dropdown.selected[itemname] and Color3.fromRGB(200, 210, 220) or Color3.fromRGB(170, 175, 180)
                    
                    updateDisplayText()
                    
                    local selected = {}
                    for i, v in pairs(dropdown.selected) do
                    if v then table.insert(selected, i) end
                    end
                    UILibrary.savings.dropdown[tabname.."_"..name.."_"..dropdown.name] = selected
                    pcall(dropdown.callback, selected)
                else
                    for i,v in pairs(frame.MAIN.Content.Frame:GetChildren()) do
                    if v:IsA("TextLabel") then
                        v.TextColor3 = Color3.fromRGB(170, 175, 180)
                    end
                    end
                    option.TextColor3 = Color3.fromRGB(200, 210, 220)
                    frame.MAIN.TextLabel.Text = itemname
                    UILibrary.savings.dropdown[tabname.."_"..name.."_"..dropdown.name] = itemname
                    pcall(dropdown.callback, itemname)
                    showhidecontent()
                end
                end
            end)
            end
        
            frame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                showhidecontent()
            end
            end)
        
            frame.MouseEnter:Connect(function()
            dropdown.mouseon = true
            TweenService:Create(frame.TextLabel, window.tweeninfo, {
                TextColor3 = Color3.fromRGB(225, 230, 235)
            }):Play()
            TweenService:Create(frame.MAIN, window.tweeninfo2, {
                BackgroundColor3 = Color3.fromRGB(15, 20, 25)
            }):Play()
            end)
        
            frame.MouseLeave:Connect(function()
            dropdown.mouseon = false
            if not frame.MAIN.Content.Visible then
                TweenService:Create(frame.TextLabel, window.tweeninfo, {
                TextColor3 = Color3.fromRGB(180, 185, 190)
                }):Play()
                TweenService:Create(frame.MAIN, window.tweeninfo2, {
                BackgroundColor3 = Color3.fromRGB(5, 10, 15)
                }):Play()
            end
            end)
        
            UILibrary.loads.dropdown[tabname.."_"..name.."_"..dropdown.name] = function(option)
            if dropdown.multi then
                local option = type(option) == 'table' and option or { option }
                local newSelection = {}
                for _, item in pairs(dropdown.items) do
                newSelection[item] = false
                end
                for _, opt in pairs(option) do
                newSelection[opt] = true
                end
                dropdown.selected = newSelection
                updateDisplayText()
                UILibrary.savings.dropdown[tabname.."_"..name.."_"..dropdown.name] = option
                pcall(dropdown.callback, option)
                for _, child in pairs(frame.MAIN.Content.Frame:GetChildren()) do
                if child:IsA("TextLabel") then
                    child.TextColor3 = dropdown.selected[child.Text] and Color3.fromRGB(200, 210, 220) or Color3.fromRGB(170, 175, 180)
                end
                end
            else
                if option ~= frame.MAIN.TextLabel.Text then
                for _, item in pairs(dropdown.items) do
                    if item == option then
                    frame.MAIN.TextLabel.Text = option
                    UILibrary.savings.dropdown[tabname.."_"..name.."_"..dropdown.name] = option
                    pcall(dropdown.callback, option)
                    for _, child in pairs(frame.MAIN.Content.Frame:GetChildren()) do
                        if child:IsA("TextLabel") then
                        child.TextColor3 = (child.Text == option) and Color3.fromRGB(200, 210, 220) or Color3.fromRGB(170, 175, 180)
                        end
                    end
                    end
                end
                end
            end
            end
        
            return dropdown
        end

        return section
        end

        tab.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and window.switchingtab == false and not content.Visible then
            window.switchingtab = true
            local tween = TweenService:Create(neverlose_ui.Frame.SMOOTHMAIN, window.tweeninfo2, {BackgroundTransparency = 0})
            tween:Play()
            for _, tabgroup in pairs(neverlose_ui.Frame.Tabs:GetChildren()) do
            if not tabgroup:IsA("UIListLayout") then
                for i, tabb in pairs(tabgroup.Folder:GetChildren()) do
                if not tabb:IsA("UIListLayout") and tabb.BackgroundTransparency ~= 1 then
                    local tween = TweenService:Create(tabb, window.tweeninfo, {BackgroundTransparency = 1})
                    tween:Play()
                    break
                end
                end
            end
            end
            local tween2 = TweenService:Create(tab, window.tweeninfo, {BackgroundTransparency = 0.75})
            tween2:Play()
            tween.Completed:Wait()
            for _, contentt in pairs(neverlose_ui.Frame.MAIN:GetChildren()) do
            contentt.Visible = false
            end
            content.Visible = true
            neverlose_ui.Frame.CreateConfigButton.Visible = name == "Configs"
            local tween3 = TweenService:Create(neverlose_ui.Frame.SMOOTHMAIN, window.tweeninfo2, {BackgroundTransparency = 1})
            tween3:Play()
            tween3.Completed:Wait()
            window.switchingtab = false
        end
        end)

        return tab_content
    end

    function grouptab:CreateConfigTab()
        local configs = {}

        local tab = grouptab:Tab("Configs")
        local frame = tab.content
        frame.Right.UIListLayout.Parent = frame
        frame.Right:Destroy()
        frame.Left:Destroy()
        frame.UIListLayout.Padding = UDim.new(0, 0)

        function configs:CreateConfig(info)
        local name, modified, author, callback = info.name or info.Name, info.modified or info.Modified, info.author or info.Author, info.callback or info.Callback
        local newconfig = window.examples.config.Frame:Clone()
        newconfig.Frame.ConfigName.Text = name
        newconfig.Parent = frame

        newconfig.Frame.ModifiedAuthor.Text = [==[<font color="rgb(140, 145, 155)">Modified:</font> ]==]..modified..[==[  <font color="rgb(140, 145, 155)">Author:</font> ]==]..author
        
        local loadButton = newconfig.Frame:FindFirstChild("Load")

        loadButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
            loadButton.BackgroundColor3 = Color3.fromRGB(0, 80, 200)
            end
        end)
        loadButton.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
            loadButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
            window:LoadConfig(name)
            end
        end)

        newconfig.Frame.Save.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
            newconfig.Frame.Save.ImageColor3 = Color3.fromRGB(0, 100, 200)
            end
        end)
        newconfig.Frame.Save.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
            newconfig.Frame.Save.ImageColor3 = Color3.fromRGB(200, 200, 200)
            window:SaveConfig(name)
            end
        end)
        end

        return configs
        end
    
    function grouptab:CreateScriptTab()
        local scripts = {}

        local tab = grouptab:Tab("Scripts")
        local frame = tab.content
        frame.Right.UIListLayout.Parent = frame
        frame.Right:Destroy()
        frame.Left:Destroy()
        frame.UIListLayout.Padding = UDim.new(0, 0)

        function scripts:CreateScript(info)
        local name, modified, author, callback = info.name or info.Name, info.modified or info.Modified, info.author or info.Author, info.callback or info.Callback
        local newscript = window.examples.script.Frame:Clone()
        newscript.Frame.ScriptName.Text = name
        newscript.Parent = frame

        newscript.Frame.TextLabel.Text = [==[<font color="rgb(140, 145, 155)">Modified:</font> ]==]..modified..[==[  <font color="rgb(140, 145, 155)">Author:</font> ]==]..author
        
        local loadButton = newscript.Frame:FindFirstChild("Load")

        loadButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
            loadButton.BackgroundColor3 = Color3.fromRGB(0, 80, 200)
            end
        end)
        loadButton.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
            loadButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
            pcall(callback)
            end
        end)
        end

        return scripts
    end
        
    return grouptab
    end
    
    neverlose_ui.Enabled = true

    return window
end

local window = UILibrary:Window()
local visuals_tabgroup = window:TabGroup("Visuals")
local players_tab = visuals_tabgroup:Tab("Players")
local players_enemies_section = players_tab:Section({
    Name = "Enemies ESP",
    Side = "Left"
})
players_enemies_section:Toggle({
    Name = "Enabled",
    Callback = function(bool)
    ESP_Player.Enabled = bool
    if bool and ESP_Player.Enabled then
        for _, player in pairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer then
            ESP_Player:refresh(player)
        end
        end
    else
        for _, item in pairs(ESPFolder:GetChildren()) do
        if not global.Teammates[Players:GetPlayerFromCharacter(item.Adornee.Parent)] then
            item:Destroy()
        end
        end
    end
    end
})
players_enemies_section:Slider({
    Name = "Max Distance",
    Min = 100,
    Max = 9999,
    Default = 9999,
    Callback = function(value)
    ESP_Player.DistanceLimit = value
    for i,v in pairs(ESPFolder:GetChildren()) do
        if not global.Teammates[Players:GetPlayerFromCharacter(v.Adornee.Parent)] then
        v.MaxDistance = value
        end
    end
    end
})
players_enemies_section:ToggleColorpicker({
    Name = "Boxes",
    ToggleCallback = function(bool)
    ESP_Player.Boxes = bool
    if bool and ESP_Player.Enabled then
        for _, player in pairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer then
            task.spawn(function()
            ESP_Player:createbox(player)
            end)
        end
        end
    else
        for _, item in pairs(ESPFolder:GetChildren()) do
        if item.Name == "BoxHolder" then
            if not global.Teammates[Players:GetPlayerFromCharacter(item.Adornee.Parent)] then
            item:Destroy()
            end
        end
        end
    end
    end,
    ColorpickerCallback = function(color)
    ESP_Player.BoxesColor = color
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
players_enemies_section:ToggleColorpicker({
    Name = "Names",
    ToggleCallback = function(bool)
    ESP_Player.Names = bool
    if bool and ESP_Player.Enabled then
        for _, player in pairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer then
            task.spawn(function()
            ESP_Player:createname(player)
            end)
        end
        end
    else
        for _, item in pairs(ESPFolder:GetChildren()) do
        if item.Name == "NameHolder" and not global.Teammates[Players:GetPlayerFromCharacter(item.Adornee.Parent)] then
            item:Destroy()
        end
        end
    end
    end,
    ColorpickerCallback = function(color)
    ESP_Player.NamesColor = color
    for _, item in pairs(ESPFolder:GetChildren()) do
        if item.Name == "NameHolder" and not global.Teammates[Players:GetPlayerFromCharacter(item.Adornee.Parent)] then
        item.TextLabel.TextColor3 = color
        end
    end
    end
})
players_enemies_section:ToggleColorpicker({
    Name = "Distance",
    ToggleCallback = function(bool)
    ESP_Player.Distance = bool
    if bool and ESP_Player.Enabled then
        for _, player in pairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer then
            task.spawn(function()
            ESP_Player:createdistance(player)
            end)
        end
        end
    else
        for _, item in pairs(ESPFolder:GetChildren()) do
        if item.Name == "DistanceHolder" and not global.Teammates[Players:GetPlayerFromCharacter(item.Adornee.Parent)] then
            item:Destroy()
        end
        end
    end
    end,
    ColorpickerCallback = function(color)
    ESP_Player.DistanceColor = color
    for _, item in pairs(ESPFolder:GetChildren()) do
        if item.Name == "DistanceHolder" and not global.Teammates[Players:GetPlayerFromCharacter(item.Adornee.Parent)] then
        item.TextLabel.TextColor3 = color
        end
    end
    end
})
players_enemies_section:ToggleColorpicker({
    Name = "Weapons",
    ToggleCallback = function(bool)
    ESP_Player.Weapons = bool
    if bool and ESP_Player.Enabled then
        for _, player in pairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer then
            task.spawn(function()
            ESP_Player:createweapon(player)
            end)
        end
        end
    else
        for _, item in pairs(ESPFolder:GetChildren()) do
        if item.Name == "WeaponHolder" and not global.Teammates[Players:GetPlayerFromCharacter(item.Adornee.Parent)] then
            item:Destroy()
        end
        end
    end
    end,
    ColorpickerCallback = function(color)
    ESP_Player.WeaponsColor = color
    for _, item in pairs(ESPFolder:GetChildren()) do
        if item.Name == "WeaponHolder" and not global.Teammates[Players:GetPlayerFromCharacter(item.Adornee.Parent)] then
        item.TextLabel.TextColor3 = color
        end
    end
    end
})
local players_teammates_section = players_tab:Section({
    Name = "Teammates ESP",
    Side = "Right"
})
players_teammates_section:Toggle({
    Name = "Enabled",
    Callback = function(bool)
    ESP_Player.TeamEnabled = bool
    if bool and ESP_Player.TeamEnabled then
        for _, player in pairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer then
            ESP_Player:refresh(player)
        end
        end
    else
        for _, item in pairs(ESPFolder:GetChildren()) do
        if global.Teammates[Players:GetPlayerFromCharacter(item.Adornee.Parent)] then
            item:Destroy()
        end
        end
    end
    end
})
players_teammates_section:Slider({
    Name = "Max Distance",
    Min = 100,
    Max = 9999,
    Default = 9999,
    Callback = function(value)
    ESP_Player.TeamDistanceLimit = value
    for i,v in pairs(ESPFolder:GetChildren()) do
        if global.Teammates[Players:GetPlayerFromCharacter(v.Adornee.Parent)] then
        v.MaxDistance = value
        end
    end
    end
})
players_teammates_section:ToggleColorpicker({
    Name = "Boxes",
    ToggleCallback = function(bool)
    ESP_Player.TeamBoxes = bool
    if bool and ESP_Player.TeamEnabled then
        for _, player in pairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer then
            task.spawn(function()
            ESP_Player:createbox(player)
            end)
        end
        end
    else
        for _, item in pairs(ESPFolder:GetChildren()) do
        if item.Name == "BoxHolder" and global.Teammates[Players:GetPlayerFromCharacter(item.Adornee.Parent)] then
            item:Destroy()
        end
        end
    end
    end,
    ColorpickerCallback = function(color)
    ESP_Player.TeamBoxesColor = color
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
players_teammates_section:ToggleColorpicker({
    Name = "Names",
    ToggleCallback = function(bool)
    ESP_Player.TeamNames = bool
    if bool and ESP_Player.TeamEnabled then
        for _, player in pairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer then
            task.spawn(function()
            ESP_Player:createname(player)
            end)
        end
        end
    else
        for _, item in pairs(ESPFolder:GetChildren()) do
        if item.Name == "NameHolder" and global.Teammates[Players:GetPlayerFromCharacter(item.Adornee.Parent)] then
            item:Destroy()
        end
        end
    end
    end,
    ColorpickerCallback = function(color)
    ESP_Player.TeamNamesColor = color
    for _, item in pairs(ESPFolder:GetChildren()) do
        if item.Name == "NameHolder" and global.Teammates[Players:GetPlayerFromCharacter(item.Adornee.Parent)] then
        item.TextLabel.TextColor3 = color
        end
    end
    end
})
players_teammates_section:ToggleColorpicker({
    Name = "Distance",
    ToggleCallback = function(bool)
    ESP_Player.TeamDistance = bool
    if bool and ESP_Player.TeamEnabled then
        for _, player in pairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer then
            task.spawn(function()
            ESP_Player:createdistance(player)
            end)
        end
        end
    else
        for _, item in pairs(ESPFolder:GetChildren()) do
        if item.Name == "DistanceHolder" and global.Teammates[Players:GetPlayerFromCharacter(item.Adornee.Parent)] then
            item:Destroy()
        end
        end
    end
    end,
    ColorpickerCallback = function(color)
    ESP_Player.TeamDistanceColor = color
    for _, item in pairs(ESPFolder:GetChildren()) do
        if item.Name == "DistanceHolder" and global.Teammates[Players:GetPlayerFromCharacter(item.Adornee.Parent)] then
        item.TextLabel.TextColor3 = color
        end
    end
    end
})
players_teammates_section:ToggleColorpicker({
    Name = "Weapons",
    ToggleCallback = function(bool)
    ESP_Player.TeamWeapons = bool
    if bool and ESP_Player.TeamEnabled then
        for _, player in pairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer then
            task.spawn(function()
            ESP_Player:createweapon(player)
            end)
        end
        end
    else
        for _, item in pairs(ESPFolder:GetChildren()) do
        if item.Name == "WeaponHolder" and global.Teammates[Players:GetPlayerFromCharacter(item.Adornee.Parent)] then
            item:Destroy()
        end
        end
    end
    end,
    ColorpickerCallback = function(color)
    ESP_Player.TeamWeaponsColor = color
    for _, item in pairs(ESPFolder:GetChildren()) do
        if item.Name == "WeaponHolder" and global.Teammates[Players:GetPlayerFromCharacter(item.Adornee.Parent)] then
        item.TextLabel.TextColor3 = color
        end
    end
    end
})

local ChamsFolder = Instance.new("Folder", CoreGui)
function findchams(name, model)
    for _, chams in pairs(ChamsFolder:GetChildren()) do
    if chams.Name == name and chams.Adornee == model then
        return chams
    end
    end
    return nil
end
function updatechams(enabled, name, model, color, filltransparency, outlinetransparency, visibilitycheck)
    local highlight = findchams(name, model) or Instance.new("Highlight", ChamsFolder)
    highlight.Enabled = enabled
    highlight.Name = name
    highlight.Adornee = model
    highlight.FillColor = color
    highlight.OutlineColor = color
    highlight.FillTransparency = filltransparency
    highlight.OutlineTransparency = outlinetransparency
    highlight.DepthMode = visibilitycheck and Enum.HighlightDepthMode.Occluded or Enum.HighlightDepthMode.AlwaysOnTop
    model.AncestryChanged:Connect(function()
    highlight:Destroy()
    end)
end
local players_enemies_chams_section = players_tab:Section({
    Name = "Enemies Chams",
    Side = "Left"
})
local players_enemies_chams = {
    Enabled = false,
    ChamsColor = Color3.fromRGB(255, 255, 255),
    FillTransparency = 0,
    OutlineTransparency = 0,
    VisibilityCheck = false
}
players_enemies_chams_section:ToggleColorpicker({
    Name = "Enable Chams",
    ToggleCallback = function(bool)
    players_enemies_chams.Enabled = bool
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer and player.Character and not global.Teammates[player] then
        updatechams(players_enemies_chams.Enabled, "EnemyPlayer", player.Character, players_enemies_chams.ChamsColor, players_enemies_chams.FillTransparency / 100, players_enemies_chams.OutlineTransparency / 100, players_enemies_chams.VisibilityCheck)
        end
    end
    end,
    ColorpickerCallback = function(color)
    players_enemies_chams.ChamsColor = color
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer and player.Character and not global.Teammates[player] then
        updatechams(players_enemies_chams.Enabled, "EnemyPlayer", player.Character, players_enemies_chams.ChamsColor, players_enemies_chams.FillTransparency / 100, players_enemies_chams.OutlineTransparency / 100, players_enemies_chams.VisibilityCheck)
        end
    end
    end
})
players_enemies_chams_section:Slider({
    Name = "Fill Alpha",
    Min = 0,
    Max = 100,
    Callback = function(value)
    players_enemies_chams.FillTransparency = value
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer and player.Character and not global.Teammates[player] then
        updatechams(players_enemies_chams.Enabled, "EnemyPlayer", player.Character, players_enemies_chams.ChamsColor, players_enemies_chams.FillTransparency / 100, players_enemies_chams.OutlineTransparency / 100, players_enemies_chams.VisibilityCheck)
        end
    end
    end
})
players_enemies_chams_section:Slider({
    Name = "Outline Alpha",
    Min = 0,
    Max = 100,
    Callback = function(value)
    players_enemies_chams.OutlineTransparency = value
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer and player.Character and not global.Teammates[player] then
        updatechams(players_enemies_chams.Enabled, "EnemyPlayer", player.Character, players_enemies_chams.ChamsColor, players_enemies_chams.FillTransparency / 100, players_enemies_chams.OutlineTransparency / 100, players_enemies_chams.VisibilityCheck)
        end
    end
    end
})
players_enemies_chams_section:Toggle({
    Name = "Visibility Check",
    Callback = function(bool)
    players_enemies_chams.VisibilityCheck = bool
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer and player.Character and not global.Teammates[player] then
        updatechams(players_enemies_chams.Enabled, "EnemyPlayer", player.Character, players_enemies_chams.ChamsColor, players_enemies_chams.FillTransparency / 100, players_enemies_chams.OutlineTransparency / 100, players_enemies_chams.VisibilityCheck)
        end
    end
    end
})

local players_teammates_chams_section = players_tab:Section({
    Name = "Teammates Chams",
    Side = "Right"
})
local players_teammates_chams = {
    Enabled = false,
    ChamsColor = Color3.fromRGB(255, 255, 255),
    FillTransparency = 0,
    OutlineTransparency = 0,
    VisibilityCheck = false
}
players_teammates_chams_section:ToggleColorpicker({
    Name = "Enable Chams",
    ToggleCallback = function(bool)
    players_teammates_chams.Enabled = bool
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer and player.Character and global.Teammates[player] then
        updatechams(players_teammates_chams.Enabled, "TeamPlayer", player.Character, players_teammates_chams.ChamsColor, players_teammates_chams.FillTransparency / 100, players_teammates_chams.OutlineTransparency / 100, players_teammates_chams.VisibilityCheck)
        end
    end
    end,
    ColorpickerCallback = function(color)
    players_teammates_chams.ChamsColor = color
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer and player.Character and global.Teammates[player] then
        updatechams(players_teammates_chams.Enabled, "TeamPlayer", player.Character, players_teammates_chams.ChamsColor, players_teammates_chams.FillTransparency / 100, players_teammates_chams.OutlineTransparency / 100, players_teammates_chams.VisibilityCheck)
        end
    end
    end
})
players_teammates_chams_section:Slider({
    Name = "Fill Alpha",
    Min = 0,
    Max = 100,
    Callback = function(value)
    players_teammates_chams.FillTransparency = value
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer and player.Character and global.Teammates[player] then
        updatechams(players_teammates_chams.Enabled, "TeamPlayer", player.Character, players_teammates_chams.ChamsColor, players_teammates_chams.FillTransparency / 100, players_teammates_chams.OutlineTransparency / 100, players_teammates_chams.VisibilityCheck)
        end
    end
    end
})
players_teammates_chams_section:Slider({
    Name = "Outline Alpha",
    Min = 0,
    Max = 100,
    Callback = function(value)
    players_teammates_chams.OutlineTransparency = value
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer and player.Character and global.Teammates[player] then
        updatechams(players_teammates_chams.Enabled, "TeamPlayer", player.Character, players_teammates_chams.ChamsColor, players_teammates_chams.FillTransparency / 100, players_teammates_chams.OutlineTransparency / 100, players_teammates_chams.VisibilityCheck)
        end
    end
    end
})
players_teammates_chams_section:Toggle({
    Name = "Visibility Check",
    Callback = function(bool)
    players_teammates_chams.VisibilityCheck = bool
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer and player.Character and global.Teammates[player] then
        updatechams(players_teammates_chams.Enabled, "TeamPlayer", player.Character, players_teammates_chams.ChamsColor, players_teammates_chams.FillTransparency / 100, players_teammates_chams.OutlineTransparency / 100, players_teammates_chams.VisibilityCheck)
        end
    end
    end
})

for _, player in pairs(Players:GetPlayers()) do
    if player ~= Players.LocalPlayer then
    player.CharacterAdded:Connect(function(character)
        task.wait(1)
        if global.Teammates[player] then
        updatechams(players_teammates_chams.Enabled, "TeamPlayer", character, players_teammates_chams.ChamsColor, players_teammates_chams.FillTransparency / 100, players_teammates_chams.OutlineTransparency / 100, players_teammates_chams.VisibilityCheck)
        else
        updatechams(players_enemies_chams.Enabled, "EnemyPlayer", character, players_enemies_chams.ChamsColor, players_enemies_chams.FillTransparency / 100, players_enemies_chams.OutlineTransparency / 100, players_enemies_chams.VisibilityCheck)
        end  
    end)
    end
end
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
    task.wait(1)
    if global.Teammates[player] then
        updatechams(players_teammates_chams.Enabled, "TeamPlayer", character, players_teammates_chams.ChamsColor, players_teammates_chams.FillTransparency / 100, players_teammates_chams.OutlineTransparency / 100, players_teammates_chams.VisibilityCheck)
    else
        updatechams(players_enemies_chams.Enabled, "EnemyPlayer", character, players_enemies_chams.ChamsColor, players_enemies_chams.FillTransparency / 100, players_enemies_chams.OutlineTransparency / 100, players_enemies_chams.VisibilityCheck)
    end
    end)
end)

local players_self_chams_section = players_tab:Section({
    Name = "Self Chams",
    Side = "Left"
})
local players_self_chams = {
    Enabled = false,
    ChamsColor = Color3.fromRGB(255, 255, 255),
    LastSkinColor = nil
}
local MAIN_MENU_GUI = Players.LocalPlayer.PlayerGui.MainMenu
local TAB_INVENTORY_GUI = MAIN_MENU_GUI.Content
players_self_chams.update_forcefield_chams = function(enabled)
    local characters = { Players.LocalPlayer.Character }
    for _, character in pairs(characters) do
    if enabled then
        if not players_self_chams.LastSkinColor then
        players_self_chams.LastSkinColor = character.Head.Color
        end
        for i,v in pairs(character:GetChildren()) do
        if v:IsA("BasePart") then
            v.Color = players_self_chams.ChamsColor
            v.Material = Enum.Material.ForceField
        end
        end
    else
        if players_self_chams.LastSkinColor then
        for i,v in pairs(character:GetChildren()) do
            if v:IsA("BasePart") then
            v.Color = players_self_chams.LastSkinColor
            v.Material = Enum.Material.Fabric
            end
        end
        end
    end
    end
    if not enabled then
    players_self_chams.LastSkinColor = nil
    end
end
Players.LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if players_self_chams.Enabled then
        players_self_chams.LastSkinColor = nil
        players_self_chams.update_forcefield_chams(true)
    end
end)
players_self_chams_section:ToggleColorpicker({
    Name = "Enable Chams",
    ToggleCallback = function(bool)
        players_self_chams.Enabled = bool
        if Players.LocalPlayer.Character then
            players_self_chams.update_forcefield_chams(bool)
        end
    end,
    ColorpickerCallback = function(color)
        players_self_chams.ChamsColor = color
        if players_self_chams.Enabled then
            if Players.LocalPlayer.Character then
                players_self_chams.update_forcefield_chams(true)
            end
        end
    end

})

