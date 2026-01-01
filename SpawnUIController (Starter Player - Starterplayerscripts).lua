local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local spawnRequestEvent = ReplicatedStorage:WaitForChild("SpawnRequestEvent")

local spawnButton = Workspace:WaitForChild("SpawnButton")
local proximityPrompt = spawnButton:WaitForChild("SpawnPrompt")

local COOLDOWN_TIME = 30
local lastSpawnTime = 0

local function createConfirmationUI()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "SpawnConfirmationUI"
	screenGui.ResetOnSpawn = false
	screenGui.Enabled = false
	screenGui.Parent = playerGui

	local frame = Instance.new("Frame")
	frame.Name = "MainFrame"
	frame.Size = UDim2.fromOffset(300, 150)
	frame.Position = UDim2.fromScale(0.5, 0.5)
	frame.AnchorPoint = Vector2.new(0.5, 0.5)
	frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	frame.BorderSizePixel = 0
	frame.Parent = screenGui
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = frame

	local message = Instance.new("TextLabel")
	message.Name = "Message"
	message.Size = UDim2.new(1, 0, 0.4, 0)
	message.Position = UDim2.fromScale(0, 0.1)
	message.BackgroundTransparency = 1
	message.Text = "Spawn object?"
	message.TextColor3 = Color3.new(1, 1, 1)
	message.Font = Enum.Font.SourceSansBold
	message.TextSize = 24
	message.Parent = frame

	local yesButton = Instance.new("TextButton")
	yesButton.Name = "YesButton"
	yesButton.Size = UDim2.fromOffset(100, 40)
	yesButton.Position = UDim2.fromScale(0.25, 0.7)
	yesButton.AnchorPoint = Vector2.new(0.5, 0.5)
	yesButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
	yesButton.Text = "Yes"
	yesButton.TextColor3 = Color3.new(1, 1, 1)
	yesButton.Font = Enum.Font.SourceSans
	yesButton.TextSize = 20
	yesButton.Parent = frame
	
	local yesCorner = Instance.new("UICorner")
	yesCorner.CornerRadius = UDim.new(0, 4)
	yesCorner.Parent = yesButton

	local noButton = Instance.new("TextButton")
	noButton.Name = "NoButton"
	noButton.Size = UDim2.fromOffset(100, 40)
	noButton.Position = UDim2.fromScale(0.75, 0.7)
	noButton.AnchorPoint = Vector2.new(0.5, 0.5)
	noButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
	noButton.Text = "Nono"
	noButton.TextColor3 = Color3.new(1, 1, 1)
	noButton.Font = Enum.Font.SourceSans
	noButton.TextSize = 20
	noButton.Parent = frame

	local noCorner = Instance.new("UICorner")
	noCorner.CornerRadius = UDim.new(0, 4)
	noCorner.Parent = noButton

	return screenGui, yesButton, noButton
end

local confirmationUI, yesBtn, noBtn = createConfirmationUI()

local function updateCooldown()
	while true do
		local now = os.time()
		local timePassed = now - lastSpawnTime
		
		if timePassed < COOLDOWN_TIME then
			local remaining = COOLDOWN_TIME - timePassed
			proximityPrompt.Enabled = false
			proximityPrompt.ActionText = "Cooldown (" .. math.ceil(remaining) .. "s)"
		else
			proximityPrompt.Enabled = true
			proximityPrompt.ActionText = "Spawn Object"
		end
		task.wait(1)
	end
end

task.spawn(updateCooldown)

proximityPrompt.Triggered:Connect(function()
	if os.time() - lastSpawnTime >= COOLDOWN_TIME then
		confirmationUI.Enabled = true
	end
end)

yesBtn.MouseButton1Click:Connect(function()
	spawnRequestEvent:FireServer()
	lastSpawnTime = os.time()
	confirmationUI.Enabled = false
end)

noBtn.MouseButton1Click:Connect(function()
	confirmationUI.Enabled = false
end)
