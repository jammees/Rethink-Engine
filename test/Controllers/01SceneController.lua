type DatGuiType = {
	addFolder: (string) -> any?,
}

type DatGuiClass = {
	add: (() -> (), string, any) -> (),
}

local scenesFolder = script.Parent.Parent.Scenes

local Rethink = require(game:GetService("ReplicatedStorage").Rethink)

local function GenerateSceneTable()
	local lookup = {}

	for _, scene in ipairs(script.Parent.Parent.Scenes:GetDescendants()) do
		table.insert(lookup, scene.Name)
	end

	return lookup
end

local SceneController = {}

-- Debug class
SceneController.Debug = {
	Tracked = {},
	Container = nil,
	SizeX = 0,
	SizeY = 0,
}

function SceneController.Debug.Init()
	local container = Instance.new("ScrollingFrame")
	container.AutomaticCanvasSize = Enum.AutomaticSize.Y
	container.Position = UDim2.fromScale(0.1, 0.5)
	container.AnchorPoint = Vector2.new(0, 0.5)
	container.BorderSizePixel = 0
	container.CanvasSize = UDim2.new()
	container.ClipsDescendants = false
	container.BackgroundTransparency = 0.5
	container.Parent = Rethink.Ui.Ui

	SceneController.Debug.Container = container

	local list = Instance.new("UIListLayout")
	list.Name = "List"
	list.VerticalAlignment = Enum.VerticalAlignment.Center
	list.Parent = container

	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, 3)
	padding.PaddingBottom = UDim.new(0, 3)
	padding.PaddingLeft = UDim.new(0, 3)
	padding.PaddingRight = UDim.new(0, 3)

	list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		SceneController.Debug.SizeX = list.AbsoluteContentSize.X
		SceneController.Debug.SizeY = list.AbsoluteContentSize.Y
	end)
end

function SceneController.Debug.CalcSize()
	SceneController.Debug.SizeX = 0
	SceneController.Debug.SizeY = 0

	for _, v: TextLabel in pairs(SceneController.Debug.Tracked) do
		local size = game:GetService("TextService"):GetTextSize(v.Text, v.TextSize, v.Font, Vector2.new(math.huge, 25))

		if size.X > SceneController.Debug.SizeX then
			SceneController.Debug.SizeX = size.X
		end
	end

	SceneController.Debug.SizeY = SceneController.Debug.Container.List.AbsoluteContentSize.Y

	SceneController.Debug.Container.Size = UDim2.fromOffset(SceneController.Debug.SizeX, SceneController.Debug.SizeY)
end

function SceneController.Debug.Add(id, object, property)
	if typeof(object) == "string" then
		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, 0, 0, 25)
		label.BackgroundTransparency = 1
		label.Text = `{object}/{property} no recorded data`
		label.TextColor3 = Color3.fromRGB(255, 255, 255)
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Parent = SceneController.Debug.Container

		SceneController.Debug.Tracked[id] = label

		return id
	end

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, 25)
	label.BackgroundTransparency = 1
	label.Text = `{object}/{property} no recorded data`
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = SceneController.Debug.Container

	print(`[SceneController/Debugger] Listening to {property}`)

	object:GetPropertyChangedSignal(property):Connect(function()
		label.Text = `{object}/{property} = {object[property]}`
		label.Size = UDim2.fromOffset(
			game:GetService("TextService")
				:GetTextSize(label.Text, label.TextSize, label.Font, Vector2.new(math.huge, math.huge)),
			25
		)

		SceneController.Debug.CalcSize()
	end)

	SceneController.Debug.Tracked[id] = label

	return id
end

function SceneController.Debug.Update(id, text)
	local label = SceneController.Debug.Tracked[id]

	if label == nil then
		return
	end

	label.Text = text
	label.Size = UDim2.fromOffset(
		game:GetService("TextService")
			:GetTextSize(label.Text, label.TextSize, label.Font, Vector2.new(math.huge, math.huge)),
		25
	)
	SceneController.Debug.CalcSize()
end

function SceneController.Debug.Remove(id)
	print(`[SceneController/Debugger] Stopped listening to {id}`)
	SceneController.Debug.Tracked[id]:Destroy()
	SceneController.Debug.Tracked[id] = nil
end

-- Settings
SceneController.SelectedScene = "Test"
SceneController.ignoreShouldFlush = false

function SceneController.Init(DatGui: DatGuiType)
	SceneController.Debug.Init()

	-- Add all of the connections
	local datGui: DatGuiClass = DatGui.addFolder("Scene")

	datGui.add(SceneController, "SelectedScene", GenerateSceneTable())
	datGui.add(SceneController, "Load")
	datGui.add(SceneController, "Flush")
	datGui.add(SceneController, "ignoreShouldFlush")

	Rethink.Scene.Events.FlushStarted:Connect(function()
		for i, v in pairs(SceneController.Debug.Tracked) do
			SceneController.Debug.Remove(i)
		end
	end)
end

function SceneController.Load()
	Rethink.Scene.Load(require(scenesFolder[SceneController.SelectedScene])):andThen(function()
		for i, v in ipairs(Rethink.Scene.GetObjects()) do
			if Rethink.Scene.IsRigidbody(v.Object) then
				SceneController.Debug.Add(i, v.Object:GetFrame(), "Position")
			end
		end
	end)
end

function SceneController.Flush()
	Rethink.Scene.Flush(SceneController.ignoreShouldFlush)
end

return SceneController
