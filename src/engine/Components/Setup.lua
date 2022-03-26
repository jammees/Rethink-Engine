local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local gameFrame = nil
local renderFrame = nil
local ui = nil

local camera = nil
local canvas = nil
local layer = nil

local function checkIfAlreadyExists(frame)
	if gameFrame and playerGui:WaitForChild(frame) then
		return true
	end
	return false
end

local function setup()
	if not checkIfAlreadyExists(gameFrame) then
		gameFrame = Instance.new("ScreenGui")
		gameFrame.Name = "GameFrame"
		gameFrame.IgnoreGuiInset = true
		gameFrame.ResetOnSpawn = false
		gameFrame.Parent = playerGui

		-- set up a scrolling frame for the whole level
		renderFrame = Instance.new("Frame")
		renderFrame.Name = "RenderFrame"
		renderFrame.AnchorPoint = Vector2.new(0.5, 0.5)
		renderFrame.Position = UDim2.fromScale(0.5, 0.5)
		renderFrame.Size = UDim2.fromScale(1, 1)
		renderFrame.Transparency = 1
		renderFrame.BorderSizePixel = 0
		renderFrame.Parent = gameFrame

		-- for camera to move the uis
		camera = Instance.new("Frame")
		camera.Name = "CameraContainer"
		camera.AnchorPoint = Vector2.new(0.5, 0.5)
		camera.Position = UDim2.fromScale(0.5, 0.5)
		camera.Size = UDim2.fromScale(1, 1)
		camera.Transparency = 1
		camera.Parent = renderFrame

		-- set up canvas for Nature2D
		canvas = Instance.new("Frame")
		canvas.Name = "Canvas"
		canvas.AnchorPoint = Vector2.new(0.5, 0.5)
		canvas.Position = UDim2.fromScale(0.5, 0.5)
		canvas.Size = UDim2.fromScale(1, 1)
		canvas.Transparency = 1
		canvas.Parent = camera

		-- set up a frame for holding the parts that don't interact with Nature2D
		layer = Instance.new("Frame")
		layer.Name = "Layer"
		layer.AnchorPoint = Vector2.new(0.5, 0.5)
		layer.Position = UDim2.fromScale(0.5, 0.5)
		layer.Size = UDim2.fromScale(1, 1)
		layer.Transparency = 1
		layer.Parent = camera

		-- setup a frame to hold ui elements
		ui = Instance.new("Frame")
		ui.Name = "Ui"
		ui.AnchorPoint = Vector2.new(0.5, 0.5)
		ui.Position = UDim2.fromScale(0.5, 0.5)
		ui.Size = UDim2.fromScale(1, 1)
		ui.Transparency = 1
		ui.Parent = renderFrame
	end

	return {
		GameFrame = gameFrame,
		RenderFrame = renderFrame,
		Canvas = canvas,
		Layer = layer,
		Ui = ui,
		CameraCont = camera,
	}
end

return setup
