-- Universal Roblox Script Hub using Rayfield UI Library
-- Library: https://docs.sirius.menu/rayfield

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

-- Variables
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- States
local States = {
    SpeedHack = false,
    JumpHack = false,
    Noclip = false,
    Fly = false,
    InfiniteJump = false,
    GodMode = false,
    ESP = false,
    Freecam = false
}

-- Values
local Values = {
    WalkSpeed = 16,
    JumpPower = 50,
    FlySpeed = 50,
    Gravity = 196.2
}

-- Connections
local Connections = {}

-- Helper Functions
local function getCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function getHumanoid()
    local char = getCharacter()
    return char:FindFirstChildOfClass("Humanoid")
end

local function getRoot()
    local char = getCharacter()
    return char:FindFirstChild("HumanoidRootPart")
end

local function disconnect(name)
    if Connections[name] then
        Connections[name]:Disconnect()
        Connections[name] = nil
    end
end

-- Notify
local function notify(title, content)
    Rayfield:Notify({
        Title = title,
        Content = content,
        Duration = 3,
        Image = nil
    })
end

-- Create Window
local Window = Rayfield:CreateWindow({
    Name = "Universal Hub",
    LoadingTitle = "Universal Hub",
    LoadingSubtitle = "by ScriptHub",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "UniversalHub",
        FileName = "Config"
    },
    Discord = {
        Enabled = false
    },
    KeySystem = false
})

-- ========== PLAYER TAB ==========
local PlayerTab = Window:CreateTab("Player", 4483362458)

PlayerTab:CreateSection("Movement")

local SpeedSlider = PlayerTab:CreateSlider({
    Name = "Walk Speed",
    Range = {16, 500},
    Increment = 1,
    Suffix = " studs",
    CurrentValue = 16,
    Flag = "WalkSpeed",
    Callback = function(Value)
        Values.WalkSpeed = Value
        local hum = getHumanoid()
        if hum and States.SpeedHack then
            hum.WalkSpeed = Value
        end
    end
})

PlayerTab:CreateToggle({
    Name = "Speed Hack",
    CurrentValue = false,
    Flag = "SpeedHackToggle",
    Callback = function(Value)
        States.SpeedHack = Value
        disconnect("SpeedHack")
        if Value then
            Connections.SpeedHack = RunService.Heartbeat:Connect(function()
                local hum = getHumanoid()
                if hum then
                    hum.WalkSpeed = Values.WalkSpeed
                end
            end)
            notify("Speed Hack", "Enabled")
        else
            local hum = getHumanoid()
            if hum then hum.WalkSpeed = 16 end
            notify("Speed Hack", "Disabled")
        end
    end
})

local JumpSlider = PlayerTab:CreateSlider({
    Name = "Jump Power",
    Range = {50, 500},
    Increment = 1,
    Suffix = "",
    CurrentValue = 50,
    Flag = "JumpPower",
    Callback = function(Value)
        Values.JumpPower = Value
        local hum = getHumanoid()
        if hum and States.JumpHack then
            hum.JumpPower = Value
            hum.UseJumpPower = true
        end
    end
})

PlayerTab:CreateToggle({
    Name = "Jump Hack",
    CurrentValue = false,
    Flag = "JumpHackToggle",
    Callback = function(Value)
        States.JumpHack = Value
        disconnect("JumpHack")
        if Value then
            Connections.JumpHack = RunService.Heartbeat:Connect(function()
                local hum = getHumanoid()
                if hum then
                    hum.UseJumpPower = true
                    hum.JumpPower = Values.JumpPower
                end
            end)
            notify("Jump Hack", "Enabled")
        else
            local hum = getHumanoid()
            if hum then hum.JumpPower = 50 end
            notify("Jump Hack", "Disabled")
        end
    end
})

PlayerTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Flag = "InfiniteJumpToggle",
    Callback = function(Value)
        States.InfiniteJump = Value
        disconnect("InfiniteJump")
        if Value then
            Connections.InfiniteJump = UserInputService.JumpRequest:Connect(function()
                local hum = getHumanoid()
                if hum then
                    hum:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        end
    end
})

PlayerTab:CreateSlider({
    Name = "Gravity",
    Range = {0, 500},
    Increment = 1,
    Suffix = "",
    CurrentValue = 196,
    Flag = "Gravity",
    Callback = function(Value)
        Workspace.Gravity = Value
    end
})

PlayerTab:CreateSection("Abilities")

PlayerTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "NoclipToggle",
    Callback = function(Value)
        States.Noclip = Value
        disconnect("Noclip")
        if Value then
            Connections.Noclip = RunService.Stepped:Connect(function()
                local char = getCharacter()
                if char then
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") and part.CanCollide then
                            part.CanCollide = false
                        end
                    end
                end
            end)
            notify("Noclip", "Enabled - You can walk through walls")
        else
            notify("Noclip", "Disabled")
        end
    end
})

local FlySpeedSlider = PlayerTab:CreateSlider({
    Name = "Fly Speed",
    Range = {10, 300},
    Increment = 5,
    Suffix = "",
    CurrentValue = 50,
    Flag = "FlySpeed",
    Callback = function(Value)
        Values.FlySpeed = Value
    end
})

PlayerTab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Flag = "FlyToggle",
    Callback = function(Value)
        States.Fly = Value
        disconnect("Fly")
        disconnect("FlyInput")
        
        local root = getRoot()
        local hum = getHumanoid()
        if not root or not hum then return end
        
        if Value then
            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bv.Velocity = Vector3.new(0, 0, 0)
            bv.Name = "FlyBV"
            bv.Parent = root
            
            local bg = Instance.new("BodyGyro")
            bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            bg.P = 10000
            bg.Name = "FlyBG"
            bg.Parent = root
            
            Connections.Fly = RunService.RenderStepped:Connect(function()
                if not root.Parent then return end
                local cam = Camera
                local moveDir = Vector3.new()
                
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    moveDir = moveDir + cam.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    moveDir = moveDir - cam.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    moveDir = moveDir - cam.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    moveDir = moveDir + cam.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    moveDir = moveDir + Vector3.new(0, 1, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                    moveDir = moveDir - Vector3.new(0, 1, 0)
                end
                
                bv.Velocity = moveDir * Values.FlySpeed
                bg.CFrame = cam.CFrame
            end)
            notify("Fly", "Enabled - WASD/Space/Shift to fly")
        else
            if root:FindFirstChild("FlyBV") then root.FlyBV:Destroy() end
            if root:FindFirstChild("FlyBG") then root.FlyBG:Destroy() end
            notify("Fly", "Disabled")
        end
    end
})

PlayerTab:CreateSection("Health")

PlayerTab:CreateButton({
    Name = "Heal",
    Callback = function()
        local hum = getHumanoid()
        if hum then
            hum.Health = hum.MaxHealth
            notify("Heal", "Health restored")
        end
    end
})

PlayerTab:CreateButton({
    Name = "Reset Character",
    Callback = function()
        local hum = getHumanoid()
        if hum then hum.Health = 0 end
    end
})

PlayerTab:CreateToggle({
    Name = "God Mode (Re-Anchor Method)",
    CurrentValue = false,
    Flag = "GodModeToggle",
    Callback = function(Value)
        States.GodMode = Value
        disconnect("GodMode")
        if Value then
            Connections.GodMode = RunService.Heartbeat:Connect(function()
                local hum = getHumanoid()
                if hum then
                    hum.Health = hum.MaxHealth
                end
            end)
            notify("God Mode", "Enabled")
        else
            notify("God Mode", "Disabled")
        end
    end
})

-- ========== TELEPORT TAB ==========
local TeleportTab = Window:CreateTab("Teleport", 4483362458)

TeleportTab:CreateSection("Player Teleport")

local SelectedPlayer = nil
local function getPlayerList()
    local list = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(list, p.Name)
        end
    end
    return list
end

local PlayerDropdown = TeleportTab:CreateDropdown({
    Name = "Select Player",
    Options = getPlayerList(),
    CurrentOption = {},
    MultipleOptions = false,
    Flag = "PlayerSelect",
    Callback = function(Option)
        SelectedPlayer = Option[1]
    end
})

TeleportTab:CreateButton({
    Name = "Refresh Players",
    Callback = function()
        PlayerDropdown:Refresh(getPlayerList())
        notify("Players", "List refreshed")
    end
})

TeleportTab:CreateButton({
    Name = "Teleport to Player",
    Callback = function()
        if not SelectedPlayer then notify("Error", "No player selected") return end
        local target = Players:FindFirstChild(SelectedPlayer)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local root = getRoot()
            if root then
                root.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 0, 3)
                notify("Teleport", "Teleported to " .. SelectedPlayer)
            end
        end
    end
})

TeleportTab:CreateSection("Position")

local SavedPosition = nil

TeleportTab:CreateButton({
    Name = "Save Current Position",
    Callback = function()
        local root = getRoot()
        if root then
            SavedPosition = root.CFrame
            notify("Position", "Position saved")
        end
    end
})

TeleportTab:CreateButton({
    Name = "Teleport to Saved Position",
    Callback = function()
        if SavedPosition then
            local root = getRoot()
            if root then
                root.CFrame = SavedPosition
                notify("Teleport", "Teleported to saved position")
            end
        else
            notify("Error", "No saved position")
        end
    end
})

TeleportTab:CreateInput({
    Name = "Teleport to XYZ (format: x,y,z)",
    PlaceholderText = "0,50,0",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        local x, y, z = Text:match("(-?%d+%.?%d*),(-?%d+%.?%d*),(-?%d+%.?%d*)")
        if x and y and z then
            local root = getRoot()
            if root then
                root.CFrame = CFrame.new(tonumber(x), tonumber(y), tonumber(z))
                notify("Teleport", "Teleported to " .. Text)
            end
        else
            notify("Error", "Invalid format")
        end
    end
})

-- ========== VISUALS TAB ==========
local VisualsTab = Window:CreateTab("Visuals", 4483362458)

VisualsTab:CreateSection("ESP")

local ESPObjects = {}

local function createESP(player)
    if player == LocalPlayer then return end
    if ESPObjects[player] then return end
    
    local function applyESP(char)
        if not char then return end
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESP_Highlight"
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.Parent = char
        ESPObjects[player] = highlight
    end
    
    if player.Character then
        applyESP(player.Character)
    end
    
    player.CharacterAdded:Connect(function(char)
        if States.ESP then
            task.wait(0.5)
            applyESP(char)
        end
    end)
end

local function removeESP()
    for player, highlight in pairs(ESPObjects) do
        if highlight then highlight:Destroy() end
    end
    ESPObjects = {}
    
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character then
            local h = p.Character:FindFirstChild("ESP_Highlight")
            if h then h:Destroy() end
        end
    end
end

VisualsTab:CreateToggle({
    Name = "Player ESP",
    CurrentValue = false,
    Flag = "ESPToggle",
    Callback = function(Value)
        States.ESP = Value
        if Value then
            for _, player in pairs(Players:GetPlayers()) do
                createESP(player)
            end
            Connections.ESPAdded = Players.PlayerAdded:Connect(function(p)
                p.CharacterAdded:Connect(function()
                    task.wait(0.5)
                    if States.ESP then createESP(p) end
                end)
            end)
            notify("ESP", "Enabled")
        else
            disconnect("ESPAdded")
            removeESP()
            notify("ESP", "Disabled")
        end
    end
})

VisualsTab:CreateSection("Camera")

VisualsTab:CreateSlider({
    Name = "Field of View",
    Range = {1, 120},
    Increment = 1,
    Suffix = "°",
    CurrentValue = 70,
    Flag = "FOV",
    Callback = function(Value)
        Camera.FieldOfView = Value
    end
})

VisualsTab:CreateToggle({
    Name = "Freecam (B to toggle)",
    CurrentValue = false,
    Flag = "FreecamToggle",
    Callback = function(Value)
        States.Freecam = Value
        if Value then
            notify("Freecam", "Enabled")
        else
            notify("Freecam", "Disabled")
        end
    end
})

-- ========== MISC TAB ==========
local MiscTab = Window:CreateTab("Misc", 4483362458)

MiscTab:CreateSection("Server")

MiscTab:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        local TS = game:GetService("TeleportService")
        TS:Teleport(game.PlaceId, LocalPlayer)
    end
})

MiscTab:CreateButton({
    Name = "Server Hop",
    Callback = function()
        local TS = game:GetService("TeleportService")
        local HttpService = game:GetService("HttpService")
        local servers = game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")
        local data = HttpService:JSONDecode(servers)
        for _, server in ipairs(data.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                TS:TeleportToPlaceInstance(game.PlaceId, server.id, LocalPlayer)
                return
            end
        end
        notify("ServerHop", "No servers found")
    end
})

MiscTab:CreateSection("Info")

MiscTab:CreateLabel("Place ID: " .. game.PlaceId)
MiscTab:CreateLabel("Player: " .. LocalPlayer.Name)

MiscTab:CreateSection("Reset")

MiscTab:CreateButton({
    Name = "Disable All Features",
    Callback = function()
        for name, _ in pairs(Connections) do
            disconnect(name)
        end
        for k in pairs(States) do
            States[k] = false
        end
        local hum = getHumanoid()
        if hum then
            hum.WalkSpeed = 16
            hum.JumpPower = 50
        end
        Workspace.Gravity = 196.2
        Camera.FieldOfView = 70
        local root = getRoot()
        if root then
            if root:FindFirstChild("FlyBV") then root.FlyBV:Destroy() end
            if root:FindFirstChild("FlyBG") then root.FlyBG:Destroy() end
        end
        removeESP()
        notify("Reset", "All features disabled")
    end
})

-- ========== SETTINGS TAB ==========
local SettingsTab = Window:CreateTab("Settings", 4483362458)

SettingsTab:CreateSection("UI")

SettingsTab:CreateButton({
    Name = "Destroy UI",
    Callback = function()
        Rayfield:Destroy()
    end
})

SettingsTab:CreateKeybind({
    Name = "Toggle UI",
    CurrentKeybind = "K",
    HoldToInteract = false,
    Flag = "ToggleUI",
    Callback = function()
        Rayfield:Toggle()
    end
})

-- Reapply on character respawn
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
    if States.SpeedHack then
        local hum = char:WaitForChild("Humanoid")
        hum.WalkSpeed = Values.WalkSpeed
    end
    if States.JumpHack then
        local hum = char:WaitForChild("Humanoid")
        hum.JumpPower = Values.JumpPower
    end
end)

Rayfield:LoadConfiguration()

notify("Universal Hub", "Loaded successfully!")
