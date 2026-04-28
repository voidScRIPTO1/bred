local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Создаем ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "DraggableToggleMenu"
gui.ResetOnSpawn = false
gui.Parent = playerGui

-- Основной фрейм меню
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 300, 0, 180)
main.Position = UDim2.new(0.5, -150, 0.5, -90)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
main.Active = true -- Чтобы ловить ввод для DragSwitch
main.Draggable = false -- мы реализуем перетаскивание вручную
main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = main

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(80, 80, 110)
mainStroke.Thickness = 1
mainStroke.Parent = main

-- Заголовок (для перетаскивания)
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 0, 30)
title.Position = UDim2.new(0, 10, 0, 8)
title.BackgroundTransparency = 1
title.Text = "Visual Menu"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(235, 235, 245)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

-- Кнопка Закрыть (X)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 26, 0, 26)
closeBtn.Position = UDim2.new(1, -36, 0, 6)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.AutoButtonColor = false
closeBtn.Parent = main

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

closeBtn.MouseEnter:Connect(function()
    closeBtn.BackgroundColor3 = Color3.fromRGB(220, 70, 70)
end)
closeBtn.MouseLeave:Connect(function()
    closeBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
end)

-- Кнопка Скрыть ( - )
local hideBtn = Instance.new("TextButton")
hideBtn.Size = UDim2.new(0, 26, 0, 26)
hideBtn.Position = UDim2.new(1, -70, 0, 6)
hideBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 150)
hideBtn.Text = "–"
hideBtn.Font = Enum.Font.GothamBold
hideBtn.TextSize = 22
hideBtn.TextColor3 = Color3.fromRGB(230, 230, 255)
hideBtn.AutoButtonColor = false
hideBtn.Parent = main

local hideCorner = Instance.new("UICorner")
hideCorner.CornerRadius = UDim.new(0, 6)
hideCorner.Parent = hideBtn

hideBtn.MouseEnter:Connect(function()
    hideBtn.BackgroundColor3 = Color3.fromRGB(130, 130, 180)
end)
hideBtn.MouseLeave:Connect(function()
    hideBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 150)
end)

-- Кнопка Показать (круг на экране)
local showBtn = Instance.new("TextButton")
showBtn.Size = UDim2.new(0, 40, 0, 40)
showBtn.Position = UDim2.new(0, 20, 0.95, -50)
showBtn.AnchorPoint = Vector2.new(0, 1)
showBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 140)
showBtn.Text = "▶"
showBtn.Font = Enum.Font.GothamBold
showBtn.TextSize = 28
showBtn.TextColor3 = Color3.fromRGB(230, 230, 255)
showBtn.Visible = false
showBtn.AutoButtonColor = false
showBtn.Parent = gui

local showCorner = Instance.new("UICorner")
showCorner.CornerRadius = UDim.new(1, 0)
showCorner.Parent = showBtn

showBtn.MouseEnter:Connect(function()
    TweenService:Create(showBtn, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(100, 100, 200)}):Play()
end)
showBtn.MouseLeave:Connect(function()
    TweenService:Create(showBtn, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(70, 70, 140)}):Play()
end)

-- Функция закрытия меню
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Функция скрытия
hideBtn.MouseButton1Click:Connect(function()
    main.Visible = false
    showBtn.Visible = true
end)

-- Показать обратно
showBtn.MouseButton1Click:Connect(function()
    main.Visible = true
    showBtn.Visible = false
end)

-- Перетаскивание окна
-- Перетаскивать будем по заголовку (title)
local dragging = false
local dragInput
local dragStart
local startPos

title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = main.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

title.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        local delta = input.Position - dragStart
        local newPos = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
        main.Position = newPos
    end
end)

-- Функция для создания переключателя (toggle)
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
        print(text .. ": " .. tostring(state)) -- Можно менять сюда любую логику
    end)

    updateToggle()
end

createToggle("Freeze", 50)
createToggle("Force Accept", 102)
