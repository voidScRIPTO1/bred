local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "VisualTogglesGui"
gui.ResetOnSpawn = false
gui.Parent = playerGui

-- Main frame
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 300, 0, 180)
main.Position = UDim2.new(0.5, -150, 0.5, -90)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = main

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(80, 80, 110)
mainStroke.Thickness = 1
mainStroke.Parent = main

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 30)
title.Position = UDim2.new(0, 10, 0, 8)
title.BackgroundTransparency = 1
title.Text = "Visual Menu"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(235, 235, 245)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

local function createToggle(text, yPos)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -20, 0, 44)
    container.Position = UDim2.new(0, 10, 0, yPos)
    container.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    container.Parent = main

    local cCorner = Instance.new("UICorner")
    cCorner.CornerRadius = UDim.new(0, 10)
    cCorner.Parent = container

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -70, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.Gotham
    label.TextSize = 15
    label.TextColor3 = Color3.fromRGB(230, 230, 240)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 46, 0, 24)
    toggleBtn.Position = UDim2.new(1, -58, 0.5, -12)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
    toggleBtn.Text = ""
    toggleBtn.AutoButtonColor = false
    toggleBtn.Parent = container

    local tbCorner = Instance.new("UICorner")
    tbCorner.CornerRadius = UDim.new(1, 0)
    tbCorner.Parent = toggleBtn

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 18, 0, 18)
    knob.Position = UDim2.new(0, 3, 0.5, -9)
    knob.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
    knob.Parent = toggleBtn

    local kCorner = Instance.new("UICorner")
    kCorner.CornerRadius = UDim.new(1, 0)
    kCorner.Parent = knob

    local state = false

    local function updateToggle()
        if state then
            TweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(100, 90, 220)}):Play()
            TweenService:Create(knob, TweenInfo.new(0.2), {Position = UDim2.new(1, -21, 0.5, -9)}):Play()
        else
            TweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(70, 70, 90)}):Play()
            TweenService:Create(knob, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -9)}):Play()
        end
    end

    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        updateToggle()
        print(text .. ": " .. tostring(state))
    end)

    updateToggle()
end

createToggle("Freeze", 50)
createToggle("Force Accept", 102)
