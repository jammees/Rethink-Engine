local playerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

local Settings = require(script.Parent.Parent.Settings)

local isGenerated = false

local function CreateFrame(name: string, parent: Instance, zIndex: number)
	local object = Instance.new("Frame")

	object = Instance.new("Frame")
	object.Name = name
	object.AnchorPoint = Vector2.new(0.5, 0.5)
	object.Position = UDim2.fromScale(0.5, 0.5)
	object.Size = UDim2.fromScale(1, 1)
	object.Transparency = 1
	object.BorderSizePixel = 0
	object.ZIndex = zIndex
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

	local renderFrame = CreateFrame("Render Frame", gameFrame, 1)
	local viewport = CreateFrame("Viewport", renderFrame, 1)
	local userInterface = CreateFrame("User Interface", renderFrame, 101)

	-- Make the RenderFrame have a Transparency of 0
	renderFrame.Transparency = 0
	renderFrame.BackgroundColor3 = Settings.ViewportColor

	return {
		GameFrame = gameFrame,
		RenderFrame = renderFrame,
		Viewport = viewport,
		Ui = userInterface,
	}
end

return setup
