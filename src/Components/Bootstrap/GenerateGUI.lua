local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local isGenerated = false

local function CreateFrame(name: string, parent: Instance)
	local object = Instance.new("Frame")

	object = Instance.new("Frame")
	object.Name = name
	object.AnchorPoint = Vector2.new(0.5, 0.5)
	object.Position = UDim2.fromScale(0.5, 0.5)
	object.Size = UDim2.fromScale(1, 1)
	object.Transparency = 1
	object.BorderSizePixel = 0
	object.Parent = parent

	return object
end

local function setup()
	if isGenerated then
		return
	end

	isGenerated = true

	local gameFrame = Instance.new("ScreenGui")
	gameFrame.Name = "GameFrame"
	gameFrame.IgnoreGuiInset = true
	gameFrame.ResetOnSpawn = false
	gameFrame.Parent = playerGui

	local renderFrame = CreateFrame("Render Frame", gameFrame)
	local viewport = CreateFrame("Viewport", renderFrame)
	local userInterface = CreateFrame("User Interface", renderFrame)

	return {
		GameFrame = gameFrame,
		RenderFrame = renderFrame,
		Viewport = viewport,
		Ui = userInterface,
	}
end

return setup
