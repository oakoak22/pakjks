local Players = game:GetService("Players")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "MaintenanceUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Parent = gui
main.Size = UDim2.fromScale(0.38, 0.32)
main.Position = UDim2.fromScale(0.31, 0.34)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
main.BorderSizePixel = 0
main.AnchorPoint = Vector2.new(0, 0)

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 14)
corner.Parent = main

local title = Instance.new("TextLabel")
title.Parent = main
title.Size = UDim2.fromScale(1, 0.25)
title.Position = UDim2.fromScale(0, 0)
title.BackgroundTransparency = 1
title.Text = "Maintenance Mode"
title.Font = Enum.Font.GothamBold
title.TextSize = 26
title.TextColor3 = Color3.fromRGB(255, 255, 255)

local desc = Instance.new("TextLabel")
desc.Parent = main
desc.Size = UDim2.fromScale(0.9, 0.35)
desc.Position = UDim2.fromScale(0.05, 0.25)
desc.BackgroundTransparency = 1
desc.TextWrapped = true
desc.TextYAlignment = Enum.TextYAlignment.Top
desc.Text = "This script is currently under maintenance and is being updated.\n\nPlease check back later for improvements and new features."
desc.Font = Enum.Font.Gotham
desc.TextSize = 16
desc.TextColor3 = Color3.fromRGB(200, 200, 200)

local discordBtn = Instance.new("TextButton")
discordBtn.Parent = main
discordBtn.Size = UDim2.fromScale(0.6, 0.18)
discordBtn.Position = UDim2.fromScale(0.2, 0.68)
discordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
discordBtn.Text = "Join our Discord"
discordBtn.Font = Enum.Font.GothamBold
discordBtn.TextSize = 16
discordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
discordBtn.BorderSizePixel = 0

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 10)
btnCorner.Parent = discordBtn

discordBtn.MouseButton1Click:Connect(function()
	if setclipboard then
		setclipboard("https://discord.gg/P7pCDAhf")
	end
end)

local closeBtn = Instance.new("TextButton")
closeBtn.Parent = main
closeBtn.Size = UDim2.fromScale(0.08, 0.18)
closeBtn.Position = UDim2.fromScale(0.9, 0.02)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 22
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

closeBtn.MouseButton1Click:Connect(function()
	gui:Destroy()
end)