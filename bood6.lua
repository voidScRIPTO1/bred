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
    CameraNoclip = false,
    UnlockCamera = false,
    Freeze = false,
    SpamJump = false,
    InstantRespawn = false
}

-- Values
local Values = {
    WalkSpeed = 16,
    JumpPower = 50,
    FlySpeed = 50,
    Gravity = 196.2
}

-- Saved camera defaults
local DefaultCameraMinZoom = LocalPlayer.CameraMinZoomDistance
local DefaultCameraMaxZoom = LocalPlayer.CameraMaxZoomDistance

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

-- ===== Movement Section =====
PlayerTab:CreateSection("Movement")

PlayerTab:CreateSlider({
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

PlayerTab:CreateSlider({
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

PlayerTab:CreateToggle({
    Name = "Spam Jump",
    CurrentValue = false,
    Flag = "SpamJumpToggle",
    Callback = function(Value)
        States.SpamJump = Value
        disconnect("SpamJump")
        if Value then
            Connections.SpamJump = RunService.Heartbeat:Connect(function()
                local hum = getHumanoid()
                if hum then
                    hum:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
            notify("Spam Jump", "Enabled")
        else
            notify("Spam Jump", "Disabled")
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

-- ===== Abilities Section =====
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

PlayerTab:CreateSlider({
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

PlayerTab:CreateToggle({
    Name = "Freeze",
    CurrentValue = false,
    Flag = "FreezeToggle",
    Callback = function(Value)
        States.Freeze = Value
        disconnect("Freeze")
        if Value then
            Connections.Freeze = RunService.Heartbeat:Connect(function()
                local root = getRoot()
                if root then
                    root.Anchored = true
                end
            end)
            notify("Freeze", "Enabled - You are frozen in place")
        else
            local root = getRoot()
            if root then
                root.Anchored = false
            end
            notify("Freeze", "Disabled")
        end
    end
})

-- ===== Camera Section =====
PlayerTab:CreateSection("Camera")

PlayerTab:CreateToggle({
    Name = "Camera Noclip",
    CurrentValue = false,
    Flag = "CameraNoclipToggle",
    Callback = function(Value)
        States.CameraNoclip = Value
        if Value then
            Camera.CameraType = Enum.CameraType.Custom
            -- Make camera ignore walls (zoom won't be blocked by parts)
            Connections.CameraNoclip = RunService.RenderStepped:Connect(function()
                for _, part in pairs(Workspace:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanQuery and not part:IsDescendantOf(getCharacter()) then
                        -- Не трогаем все части (опасно), только блокируем raycast камеры через свойство:
                    end
                end
            end)
            -- Альтернативный (стабильный) метод: отключение коллизии камеры
            disconnect("CameraNoclip")
            Connections.CameraNoclip = RunService.RenderStepped:Connect(function()
                local char = getCharacter()
                if char then
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanQuery = true
                        end
                    end
                end
            end)
            -- Простейший рабочий способ: камера проходит сквозь объекты
            LocalPlayer.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Invisicam
            notify("Camera Noclip", "Enabled")
        else
            disconnect("CameraNoclip")
            LocalPlayer.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Zoom
            notify("Camera Noclip", "Disabled")
        end
    end
})

PlayerTab:CreateToggle({
    Name = "Unlock Camera",
    CurrentValue = false,
    Flag = "UnlockCameraToggle",
    Callback = function(Value)
        States.UnlockCamera = Value
        if Value then
            DefaultCameraMinZoom = LocalPlayer.CameraMinZoomDistance
            DefaultCameraMaxZoom = LocalPlayer.CameraMaxZoomDistance
            LocalPlayer.CameraMinZoomDistance = 0.5
            LocalPlayer.CameraMaxZoomDistance = 1000
            notify("Unlock Camera", "Enabled - Free zoom range")
        else
            LocalPlayer.CameraMinZoomDistance = DefaultCameraMinZoom
            LocalPlayer.CameraMaxZoomDistance = DefaultCameraMaxZoom
            notify("Unlock Camera", "Disabled")
        end
    end
})

-- ===== Health / Respawn Section =====
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

PlayerTab:CreateToggle({
    Name = "God Mode",
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

PlayerTab:CreateToggle({
    Name = "Instant Respawn",
    CurrentValue = false,
    Flag = "InstantRespawnToggle",
    Callback = function(Value)
        States.InstantRespawn = Value
        disconnect("InstantRespawn")
        if Value then
            Connections.InstantRespawn = LocalPlayer.CharacterAdded:Connect(function(char)
                local hum = char:WaitForChild("Humanoid")
                hum.Died:Connect(function()
                    task.wait(0.1)
                    LocalPlayer:LoadCharacter()
                end)
            end)
            -- Подключаем на текущего персонажа
            local hum = getHumanoid()
            if hum then
                Connections.InstantRespawnDied = hum.Died:Connect(function()
                    task.wait(0.1)
                    if States.InstantRespawn then
                        LocalPlayer:LoadCharacter()
                    end
                end)
            end
            notify("Instant Respawn", "Enabled")
        else
            disconnect("InstantRespawnDied")
            notify("Instant Respawn", "Disabled")
        end
    end
})

PlayerTab:CreateButton({
    Name = "Respawn",
    Callback = function()
        local success, err = pcall(function()
            LocalPlayer:LoadCharacter()
        end)
        if not success then
            local hum = getHumanoid()
            if hum then hum.Health = 0 end
        end
        notify("Respawn", "Character respawned")
    end
})

-- ===== Reset =====
PlayerTab:CreateSection("Reset")

PlayerTab:CreateButton({
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
        local root = getRoot()
        if root then
            root.Anchored = false
            if root:FindFirstChild("FlyBV") then root.FlyBV:Destroy() end
            if root:FindFirstChild("FlyBG") then root.FlyBG:Destroy() end
        end
        Workspace.Gravity = 196.2
        LocalPlayer.CameraMinZoomDistance = DefaultCameraMinZoom
        LocalPlayer.CameraMaxZoomDistance = DefaultCameraMaxZoom
        LocalPlayer.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Zoom
        notify("Reset", "All features disabled")
    end
})

-- Reapply on character respawn
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
    local hum = char:WaitForChild("Humanoid")
    if States.SpeedHack then
        hum.WalkSpeed = Values.WalkSpeed
    end
    if States.JumpHack then
        hum.UseJumpPower = true
        hum.JumpPower = Values.JumpPower
    end
    if States.InstantRespawn then
        disconnect("InstantRespawnDied")
        Connections.InstantRespawnDied = hum.Died:Connect(function()
            task.wait(0.1)
            if States.InstantRespawn then
                LocalPlayer:LoadCharacter()
            end
        end)
    end
end)

local COLORS = {
    Innocent = Color3.fromRGB(50, 205, 50),   -- зелёный
    Murderer = Color3.fromRGB(220, 40, 40),   -- красный
    Sheriff = Color3.fromRGB(40, 120, 255),   -- синий
}

local FILL_ALPHA = 0.5
local OUTLINE_ALPHA = 0

local HL_TAG = "_WH"
local BB_TAG = "_WBB"

local trackedData = {}

local weaponKeywords = {
    { pattern = "gun",   priority = 2, color = COLORS.Sheriff },
    { pattern = "knife", priority = 1, color = COLORS.Murderer },
}

local ESPFlags = {
    All = false,
    Murderer = false,
    Sheriff = false,
    Innocent = false,
}

local function detectWeaponColor(character, player)
    local bestColor = nil
    local bestPriority = 0

    local function checkTool(tool)
        if not tool:IsA("Tool") then return end
        local name = tool.Name:lower()
        for _, entry in ipairs(weaponKeywords) do
            if name:find(entry.pattern) and entry.priority > bestPriority then
                bestPriority = entry.priority
                bestColor = entry.color
            end
        end
    end

    for _, child in pairs(character:GetChildren()) do
        checkTool(child)
    end

    local back = player:FindFirstChildOfClass("Backpack")
    if back then
        for _, item in pairs(back:GetChildren()) do
            checkTool(item)
        end
    end

    return bestColor or COLORS.Innocent
end

local function getOrMakeHighlight(character)
    local old = character:FindFirstChild(HL_TAG)
    if old and old:IsA("Highlight") then return old end
    if old then old:Destroy() end

    local hl = Instance.new("Highlight")
    hl.Name = HL_TAG
    hl.Adornee = character
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.FillTransparency = FILL_ALPHA
    hl.OutlineTransparency = OUTLINE_ALPHA
    hl.FillColor = COLORS.Innocent
    hl.OutlineColor = COLORS.Innocent
    hl.Parent = character

    return hl
end

local function getOrMakeBillboard(character, playerName)
    local head = character:FindFirstChild("Head")
    if not head then return nil end

    local oldBillboard = head:FindFirstChild(BB_TAG)
    if oldBillboard and oldBillboard:IsA("BillboardGui") then
        return oldBillboard:FindFirstChild("NameLabel")
    end
    if oldBillboard then
        oldBillboard:Destroy()
    end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = BB_TAG
    billboard.Adornee = head
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0, 140, 0, 26)
    billboard.StudsOffset = Vector3.new(0, 2.6, 0)
    billboard.ResetOnSpawn = false
    billboard.Parent = head

    local label = Instance.new("TextLabel")
    label.Name = "NameLabel"
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 13
    label.TextScaled = false
    label.Text = playerName
    label.TextColor3 = COLORS.Innocent
    label.TextStrokeTransparency = 1
    label.Parent = billboard

    return label
end

local function clearHighlight(player)
    local data = trackedData[player]
    if not data then return end

    if data.conn then
        data.conn:Disconnect()
    end

    if data.character then
        local hl = data.character:FindFirstChild(HL_TAG)
        if hl then hl:Destroy() end
        local head = data.character:FindFirstChild("Head")
        if head then
            local bb = head:FindFirstChild(BB_TAG)
            if bb then bb:Destroy() end
        end
    end

    trackedData[player] = nil
end

local function shouldHighlight(color)
    if ESPFlags.All then
        return true
    elseif color == COLORS.Murderer and ESPFlags.Murderer then
        return true
    elseif color == COLORS.Sheriff and ESPFlags.Sheriff then
        return true
    elseif color == COLORS.Innocent and ESPFlags.Innocent then
        return true
    end
    return false
end

local function updatePlayer(player)
    if player == LocalPlayer then
        clearHighlight(player)
        return
    end

    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        clearHighlight(player)
        return
    end

    local color = detectWeaponColor(character, player)
    if shouldHighlight(color) then
        local hl = getOrMakeHighlight(character)
        hl.FillColor = color
        hl.OutlineColor = color

        local label = getOrMakeBillboard(character, player.DisplayName)
        if label then
            label.TextColor3 = color
        end

        trackedData[player] = trackedData[player] or {}
        trackedData[player].character = character
    else
        clearHighlight(player)
    end
end

local function hookCharacter(player, character)
    character:WaitForChild("HumanoidRootPart", 10)

    local conn = RunService.Heartbeat:Connect(function()
        if not character.Parent then return end
        updatePlayer(player)
    end)

    local prev = trackedData[player]
    if prev then
        if prev.conn then prev.conn:Disconnect() end
        if prev.character then
            local oldHl = prev.character:FindFirstChild(HL_TAG)
            if oldHl then oldHl:Destroy() end

            local oldHead = prev.character:FindFirstChild("Head")
            if oldHead then
                local oldBb = oldHead:FindFirstChild(BB_TAG)
                if oldBb then oldBb:Destroy() end
            end
        end
    end

    trackedData[player] = { conn = conn, character = character }

    character.AncestryChanged:Connect(function(_, parent)
        if not parent and trackedData[player] and trackedData[player].character == character then
            conn:Disconnect()
        end
    end)
end

local function hookPlayer(player)
    if player == LocalPlayer then return end
    if player.Character then
        task.spawn(hookCharacter, player, player.Character)
    end
    player.CharacterAdded:Connect(function(character)
        task.spawn(hookCharacter, player, character)
    end)
end

Players.PlayerRemoving:Connect(clearHighlight)

for _, player in pairs(Players:GetPlayers()) do
    task.spawn(hookPlayer, player)
end

Players.PlayerAdded:Connect(hookPlayer)


-- Вспомогательная функция для включения только одного фильтра
local function setOnlyThisFlag(flagName)
    for key in pairs(ESPFlags) do
        ESPFlags[key] = false
    end
    ESPFlags[flagName] = true
end


-- === ЧАСТЬ СОЗДАНИЯ UI: ВКЛАДКА ESP ===

local ESPTab = Window:CreateTab("ESP", 4483362458)
ESPTab:CreateSection("Player ESP")

ESPTab:CreateToggle({
    Name = "Highlight All Players",
    CurrentValue = false,
    Flag = "ESPAllToggle",
    Callback = function(value)
        if value then
            setOnlyThisFlag("All")
        else
            ESPFlags.All = false
        end
    end
})

ESPTab:CreateToggle({
    Name = "Highlight Murderer",
    CurrentValue = false,
    Flag = "ESPMurdererToggle",
    Callback = function(value)
        if value then
            setOnlyThisFlag("Murderer")
        else
            ESPFlags.Murderer = false
        end
    end
})

ESPTab:CreateToggle({
    Name = "Highlight Sheriff",
    CurrentValue = false,
    Flag = "ESPSheriffToggle",
    Callback = function(value)
        if value then
            setOnlyThisFlag("Sheriff")
        else
            ESPFlags.Sheriff = false
        end
    end
})

ESPTab:CreateToggle({
    Name = "Highlight Innocent",
    CurrentValue = false,
    Flag = "ESPInnocentToggle",
    Callback = function(value)
        if value then
            setOnlyThisFlag("Innocent")
        else
            ESPFlags.Innocent = false
        end
    end
})

-- Обновление ESP каждый кадр
RunService.RenderStepped:Connect(function()
    for player, data in pairs(trackedData) do
        if data.character then
            updatePlayer(player)
        end
    end
end)
