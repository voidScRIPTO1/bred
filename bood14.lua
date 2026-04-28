local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local gui = Instance.new("ScreenGui")
gui.Name = "VisualMenu"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = playerGui

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(250, 150)
main.Position = UDim2.new(0.5, -125, 0.5, -75)
main.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
main.BorderSizePixel = 0
main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = main

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(55, 55, 70)
mainStroke.Thickness = 1
mainStroke.Parent = main

local topbar = Instance.new("Frame")
topbar.Size = UDim2.new(1, 0, 0, 28)
topbar.BackgroundTransparency = 1
topbar.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.fromOffset(10, 0)
title.BackgroundTransparency = 1
title.Text = "TRADE SCUM (by @VOID_SCRIPT)"
title.Font = Enum.Font.GothamBold
title.TextSize = 12
title.TextColor3 = Color3.fromRGB(235, 235, 245)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topbar

local minimize = Instance.new("TextButton")
minimize.Size = UDim2.fromOffset(18, 18)
minimize.Position = UDim2.new(1, -42, 0, 5)
minimize.BackgroundColor3 = Color3.fromRGB(55, 55, 70)
minimize.Text = "_"
minimize.TextSize = 14
minimize.TextColor3 = Color3.fromRGB(255, 255, 255)
minimize.Font = Enum.Font.GothamBold
minimize.BorderSizePixel = 0
minimize.Parent = topbar
Instance.new("UICorner", minimize).CornerRadius = UDim.new(0, 4)

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(18, 18)
close.Position = UDim2.new(1, -20, 0, 5)
close.BackgroundColor3 = Color3.fromRGB(180, 55, 55)
close.Text = "X"
close.TextSize = 13
close.TextColor3 = Color3.fromRGB(255, 255, 255)
close.Font = Enum.Font.GothamBold
close.BorderSizePixel = 0
close.Parent = topbar
Instance.new("UICorner", close).CornerRadius = UDim.new(0, 4)

local showBtn = Instance.new("TextButton")
showBtn.Size = UDim2.fromOffset(40, 40)
-- Центрируем по середине экрана
showBtn.Position = UDim2.new(0.5, -20, 0.5, -20)
showBtn.AnchorPoint = Vector2.new(0, 0)
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

local function createRow(text, y)
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, -20, 0, 36)
	row.Position = UDim2.fromOffset(10, y)
	row.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
	row.BorderSizePixel = 0
	row.Parent = main
	Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -60, 1, 0)
	label.Position = UDim2.fromOffset(10, 0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.Font = Enum.Font.Gotham
	label.TextSize = 13
	label.TextColor3 = Color3.fromRGB(210, 210, 220)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = row

	local toggle = Instance.new("TextButton")
	toggle.Size = UDim2.fromOffset(42, 20)
	toggle.Position = UDim2.new(1, -52, 0.5, -10)
	toggle.BackgroundColor3 = Color3.fromRGB(75, 75, 95)
	toggle.BorderSizePixel = 0
	toggle.Text = ""
	toggle.Parent = row
	Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)

	local knob = Instance.new("Frame")
	knob.Size = UDim2.fromOffset(14, 14)
	knob.Position = UDim2.fromOffset(3, 3)
	knob.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
	knob.BorderSizePixel = 0
	knob.Parent = toggle
	Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

	local state = false
	local function update()
		if state then
			TweenService:Create(toggle, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(100, 90, 220)}):Play()
			TweenService:Create(knob, TweenInfo.new(0.15), {Position = UDim2.fromOffset(25, 3)}):Play()
		else
			TweenService:Create(toggle, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(75, 75, 95)}):Play()
			TweenService:Create(knob, TweenInfo.new(0.15), {Position = UDim2.fromOffset(3, 3)}):Play()
		end
	end

	toggle.MouseButton1Click:Connect(function()
		state = not state
		update()
		print(text, state)
	end)

	update()
end

createRow("Freeze", 38)
createRow("Force Accept", 80)

close.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

minimize.MouseButton1Click:Connect(function()
	main.Visible = false
	hiddenIcon.Visible = true
end)

hiddenIcon.MouseButton1Click:Connect(function()
	main.Visible = true
	hiddenIcon.Visible = false
end)

-- Dragging
local dragging = false
local dragStart
local startPos

topbar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = main.Position
	end
end)

topbar.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		main.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)
