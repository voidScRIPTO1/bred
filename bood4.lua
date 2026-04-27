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

-- ESP Section with role-based highlighting (Murder, Sheriff, Innocent)

-- (Пример вставки в ваш скрипт после создания окна и других базовых функций)

local ESPColors = {
  Default = Color3.fromRGB(0, 170, 255),   -- синий — все игроки
  Murderer = Color3.fromRGB(255, 0, 0),    -- красный — убийца
  Sheriff = Color3.fromRGB(0, 100, 255),   -- синий — шериф
  Innocent = Color3.fromRGB(0, 255, 0)     -- зеленый — невинный
}

local ESPStates = {
  All = false,
  Murderer = false,
  Sheriff = false,
  Innocent = false
}

local ESPHighlights = {}

-- Определение роли игрока (пример для MM2 — подстройте под игру)
local function getPlayerRole(player)
    if not player or not player.Character then return "Unknown" end

    local playerGui = player:FindFirstChildOfClass("PlayerGui")
    if playerGui then
        local clientGui = playerGui:FindFirstChild("Client")
        if clientGui then
            local roleValue = clientGui:FindFirstChild("Role")
            if roleValue and roleValue:IsA("StringValue") then
                local role = roleValue.Value
                -- Возвращаем одну из стандартных ролей
                if role == "Murderer" then
                    return "Murderer"
                elseif role == "Sheriff" then
                    return "Sheriff"
                elseif role == "Innocent" then
                    return "Innocent"
                end
            end
        end
    end
    return "Unknown"
end

local function clearESP(player)
  if ESPHighlights[player] then
    for _, h in pairs(ESPHighlights[player]) do
      if h and h.Parent then h:Destroy() end
    end
    ESPHighlights[player] = nil
  end
end

local function applyESP(player, color)
  if not player.Character or ESPHighlights[player] then return end
  if player == game.Players.LocalPlayer then return end

  local highlight = Instance.new("Highlight")
  highlight.Name = "ESP_Highlight"
  highlight.FillColor = color
  highlight.OutlineColor = color
  highlight.FillTransparency = 0.5
  highlight.OutlineTransparency = 0
  highlight.Parent = player.Character

  ESPHighlights[player] = {highlight}
end

local function updateESP()
  for _, player in pairs(game.Players:GetPlayers()) do
    local role = getPlayerRole(player)
    if ESPStates.All or 
       (ESPStates.Murderer and role == "Murderer") or
       (ESPStates.Sheriff and role == "Sheriff") or
       (ESPStates.Innocent and role == "Innocent") then
      local color = ESPColors.Default
      if role == "Murderer" then color = ESPColors.Murderer
      elseif role == "Sheriff" then color = ESPColors.Sheriff
      elseif role == "Innocent" then color = ESPColors.Innocent end
      applyESP(player, color)
    else
      clearESP(player)
    end
  end
end

-- Создаём вкладку ESP
local ESPTab = Window:CreateTab("ESP", 4483362458)
ESPTab:CreateSection("Player ESP")

ESPTab:CreateToggle({
  Name = "Highlight All Players",
  CurrentValue = false,
  Flag = "ESPAllToggle",
  Callback = function(value)
    ESPStates.All = value
    if value then
      ESPStates.Murderer = false
      ESPStates.Sheriff = false
      ESPStates.Innocent = false
    end
    updateESP()
  end
})

ESPTab:CreateToggle({
  Name = "Highlight Murderer",
  CurrentValue = false,
  Flag = "ESPMurdererToggle",
  Callback = function(value)
    ESPStates.Murderer = value
    if value then
      ESPStates.All = false
    end
    updateESP()
  end
})

ESPTab:CreateToggle({
  Name = "Highlight Sheriff",
  CurrentValue = false,
  Flag = "ESPSheriffToggle",
  Callback = function(value)
    ESPStates.Sheriff = value
    if value then
      ESPStates.All = false
    end
    updateESP()
  end
})

ESPTab:CreateToggle({
  Name = "Highlight Innocent",
  CurrentValue = false,
  Flag = "ESPInnocentToggle",
  Callback = function(value)
    ESPStates.Innocent = value
    if value then
      ESPStates.All = false
    end
    updateESP()
  end
})

-- Следим за новыми игроками и за обновлениями
game.Players.PlayerAdded:Connect(function(player)
  player.CharacterAdded:Connect(function()
    task.wait(1)
    updateESP()
  end)
end)

RunService.Heartbeat:Connect(function()
  updateESP()
end)
