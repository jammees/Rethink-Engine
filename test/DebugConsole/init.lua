local UserInputService = game:GetService("UserInputService")

---@module src.init
local Rethink = require(game:GetService("ReplicatedStorage").Rethink)
local Modules = Rethink.GetModules()
local Scene = Modules.Scene
local Camera = Modules.Prototypes.Camera
local Iris = require(script["Iris-2.0.2"]).Init()
local Tbl = require(script.tbl)
---@module src.Vendors.Janitor.src.init
local Janitor = require(Rethink.Self.Vendors.Janitor).new()

-- States
local isToggled = Iris.State(true)
local showDemoWindow = Iris.State(false)
local windowsizeY = Iris.State(workspace.CurrentCamera.ViewportSize.Y - 36)
local windowsizeX = Iris.State(350)
local windowSize = Iris.State(Vector2.new(windowsizeX.value, windowsizeY.value))

local sceneModules = {}
local scenePointer = {}
local sceneObjects = {}

local function RenderPeeker(selectedObject: GuiBase2d)
	local peekerWindowState = Iris.State()

	if peekerWindowState.value then
		peekerWindowState.value:Destroy()
		peekerWindowState:set(nil)
	end

	local container = Instance.new("ImageLabel")
	container.Size = UDim2.fromScale(1, 0.4)
	container.Image = "rbxassetid://14287556722"
	container.ZIndex = 99999999
	container.Name = "PeekerWindow"
	container.ClipsDescendants = true
	Iris.Append(container)

	local aspectRation = Instance.new("UIAspectRatioConstraint")
	aspectRation.AspectRatio = 1.5
	aspectRation.AspectType = Enum.AspectType.ScaleWithParentSize
	aspectRation.DominantAxis = Enum.DominantAxis.Width
	aspectRation.Parent = container

	local copy = if typeof(selectedObject) == "table" then selectedObject:GetFrame() else selectedObject
	copy = copy:Clone()
	copy.Parent = container

	if copy:IsA("GuiBase2d") then
		copy.ZIndex = 999999999

		local viewport = workspace.CurrentCamera.ViewportSize
		local containerSize = container.AbsoluteSize
		local copySize = copy.AbsoluteSize
		local ratio = (containerSize / viewport).X
		local newSize = UDim2.fromOffset(copySize.X * ratio, copySize.Y * ratio)
		copy.Size = newSize
	else
		copy:Destroy()
		local label = Instance.new("TextLabel")
		label.BackgroundTransparency = 1
		label.TextColor3 = Color3.fromRGB(255, 255, 255)
		label.TextTransparency = 0.8
		label.TextSize = 25
		label.Text = "No preview"
		label.Size = UDim2.fromOffset(100, 50)
		label.Position = UDim2.fromOffset(container.AbsoluteSize.X / 2 - 50, container.AbsoluteSize.Y / 2 - 25)
		label.ZIndex = 999999999
		label.Parent = container
	end

	peekerWindowState:set(container)
end

local function FindScenesModules()
	local function IsDuplicate(sceneModule)
		for _, module in sceneModules do
			if module.Name == sceneModule.Name then
				return true
			end
		end

		return false
	end

	for _, object: ModuleScript? in game:GetDescendants() do
		if object:IsA("ModuleScript") and object.Name:match(".scene$") and not IsDuplicate(object) then
			sceneModules[object.Name] = object
			table.insert(scenePointer, object.Name)
		end
	end
end

local function RenderExplorer()
	local objectIndex = Iris.State(1)
	local explorerWindow = Iris.State(Vector2.new(150, windowSize.value.Y))
	local odWindow = Iris.State(Vector2.new(300, windowSize.value.Y))
	local stripSymbols = Iris.State(false)

	if explorerWindow.value.Y ~= windowSize.value.Y then
		explorerWindow:set(Vector2.new(150, windowSize.value.Y))
	end

	if odWindow.value.Y ~= windowSize.value.Y then
		odWindow:set(Vector2.new(300, windowSize.value.Y))
	end

	Iris.Window({
		"Explorer",
		[Iris.Args.Window.NoClose] = true,
		[Iris.Args.Window.NoMove] = true,
		[Iris.Args.Window.NoResize] = true,
		[Iris.Args.Window.NoCollapse] = true,
	}, {
		size = explorerWindow,
		position = Vector2.new(workspace.CurrentCamera.ViewportSize.X - 150 - 300, 0),
		isOpened = isToggled,
	})

	for index, object in sceneObjects do
		Iris.Selectable(
			{ Scene.IsRigidbody(object) and object:GetFrame().Name or object.Name, index },
			{ index = objectIndex }
		)
	end

	Iris.End()

	local selectedObject = sceneObjects[objectIndex.value]
	local frame: GuiBase2d = selectedObject
		and (Scene.IsRigidbody(selectedObject) and selectedObject:GetFrame() or selectedObject)

	Iris.Window({
		`Object data {selectedObject and selectedObject.Name and `- "{frame.Name}"` or ""}`,
		[Iris.Args.Window.NoClose] = true,
		[Iris.Args.Window.NoMove] = true,
		[Iris.Args.Window.NoResize] = true,
		[Iris.Args.Window.NoCollapse] = true,
	}, {
		size = odWindow,
		position = Vector2.new(workspace.CurrentCamera.ViewportSize.X - 300, 0),
		isOpened = isToggled,
	})

	if selectedObject then
		-- Iris.TextWrapped({
		-- 	`Position: {frame.Position}\nIsRigidbody: {Scene.IsRigidbody(selectedObject)}\nTags: {table.concat(frame:GetTags(), ", ")}`,
		-- })

		local reference = Scene.GetObjectReference(selectedObject)

		Iris.PushConfig({ TextColor = Color3.fromRGB(109, 109, 109) })
		Iris.TextWrapped({ `\nReference data:` })
		Iris.PopConfig()

		-- Iris.TextWrapped({
		-- 	`UUID: {reference.ID}\nObject: {reference.Object}\nJanitor: {reference.Janitor}\nSymbolJanitor: {reference.SymbolJanitor}\nSymbols: {Tbl.Concat(
		-- 		reference.Symbols,
		-- 		"\n\t[%s] = %s"
		-- 	)}\nIsRigidbody: {Scene.IsRigidbody(
		-- 		selectedObject
		-- 	)}\nClassName: {frame.ClassName}`,
		-- })

		local info = ""
		info ..= `UUID: <font color="rgb(136, 136, 136)">{reference.ID}</font>\n`
		info ..= `Object: <font color="rgb(136, 136, 136)">{reference.Object}</font>\n`
		info ..= `ClassName: <font color="rgb(136, 136, 136)">{frame.ClassName}</font>\n`
		info ..= `IsRigidbody: <font color="rgb(136, 136, 136)">{Scene.IsRigidbody(selectedObject)}</font>\n`

		if #frame:GetTags() > 0 then
			info ..= `Tags: <font color="rgb(136, 136, 136)">{table.concat(frame:GetTags(), ", ")}</font>\n`
		end

		if Tbl.GetLenght(reference.Symbols) > 0 then
			info ..= `Symbols: {Tbl.Concat(reference.Symbols, `\n\t[%s] = <font color="rgb(136, 136, 136)">%s</font>`)}\n`
		end

		-- janky way to get RichText to work
		Iris.TextWrapped({ info }).Instance.RichText = true

		Iris.Separator()

		Iris.SameLine()
		if Iris.Button({ "Remove" }).clicked() then
			Scene.Remove(selectedObject, stripSymbols.value)
		end
		Iris.Checkbox({ "stripSymbols" }, { isChecked = stripSymbols })
		Iris.End()

		if Iris.Button({ "Cleanup" }).clicked() then
			Scene.Cleanup(selectedObject)
		end

		RenderPeeker(selectedObject)
	end

	Iris.End()

	Iris.Separator()
end

local function RenderScene()
	local sceneIndex = Iris.State("Test.scene")
	local ignorePermanent = Iris.State(true)

	Iris.Text({ "Scene" })

	Iris.TextWrapped({ `Objects: {Tbl.GetLenght(Scene.GetObjects())}\nState: {Scene.State}\n` })

	Iris.ComboArray({ "Scene" }, { index = sceneIndex }, scenePointer)

	if Iris.Button({ `Load {sceneModules[sceneIndex.value]}` }).clicked() then
		Scene.Load(require(sceneModules[sceneIndex.value]))
	end

	-- I'm really tired of Iris spamming the output with
	-- too few or too many calls with Iris.End() when I flush the scene
	-- and the funny thing is that if I add or remove an Iris.End() guess what happends!!!
	-- You guessed it! It throws an error that it's too much or not enough!!!11
	Iris.SameLine()
	if Iris.Button({ `Flush` }).clicked() then
		Scene.Flush(ignorePermanent.value)
	end
	Iris.Checkbox("Ignore Permanent", { isChecked = ignorePermanent })
	Iris.End()
end

local function RenderPool()
	---@module src.Library.ObjectPool
	local objectPool = Rethink.GetModules().Template.FetchGlobal("__Rethink_Pool")

	Iris.TextWrapped({ "\nObjectPool" })

	Iris.PushConfig({ TextColor = Color3.fromRGB(109, 109, 109) })
	Iris.TextWrapped({
		`Note: ObjectPool IDs and Scene IDs are two completely different things! Hovering over an ObjectPool ID will display the name of the object.`,
	})
	Iris.PopConfig()

	local objectAmount = 0
	local availableAmount = 0
	local busyAmount = 0

	for _, class in objectPool.PoolClasses do
		for _ in class.Objects do
			objectAmount += 1
		end

		availableAmount += #class.Available
		busyAmount += #class.Busy
	end

	Iris.Text({ `Objects: {objectAmount}` })

	Iris.Tree({ `Available objects: {availableAmount}` })
	for kind, class in objectPool.PoolClasses do
		Iris.Text(`{kind} = {#class.Available}`)
	end
	Iris.End()

	Iris.Tree({ `Busy objects: {busyAmount}` })
	for _, class in objectPool.PoolClasses do
		for _, objectID in class.Busy do
			local object = class.Objects[objectID]
			Iris.Text(objectID)
			if Iris.Events.hovered() then
				Iris.Tooltip({
					`{object.Object.Name}.Type = {object.Object.ClassName}`,
				})
			end
		end
	end
	Iris.End()
end

local function RenderCamera()
	local x = Iris.State(0)
	local lastX = Iris.State(0)
	local y = Iris.State(0)
	local lastY = Iris.State(0)

	Iris.TextWrapped({ "\nCamera" })

	-- Iris.Checkbox({ "Is running" }, { isChecked = isRunning })
	Iris.Text({ `Attached objects: {#Camera.Objects}` })

	-- if not (prevState.value == isRunning.value) then
	-- 	prevState:set(isRunning.value)

	-- 	if isRunning.value then
	-- 		Camera.Start()
	-- 	else
	-- 		Camera.Stop()
	-- 	end
	-- end

	Iris.SameLine()
	Iris.Text({ "X" })
	Iris.PushConfig({ ContentWidth = UDim.new(0, 65) })
	Iris.InputNum({ "", [Iris.Args.InputNum.NoButtons] = true }, { number = x })
	Iris.PopConfig()
	Iris.SliderNum({ "", 1, -500, 500 }, { number = x })
	Iris.End()

	Iris.SameLine()
	Iris.Text({ "Y" })
	Iris.PushConfig({ ContentWidth = UDim.new(0, 65) })
	Iris.InputNum({ "", [Iris.Args.InputNum.NoButtons] = true }, { number = y })
	Iris.PopConfig()
	Iris.SliderNum({ "", 1, -500, 500 }, { number = y })
	Iris.End()

	if lastX.value ~= x.value then
		Camera.SetPosition(x.value, y.value)
		Camera.Render()

		lastX:set(x.value)
	end

	if lastY.value ~= y.value then
		Camera.SetPosition(x.value, y.value)
		Camera.Render()

		lastY:set(x.value)
	end
end

local function RenderPhysics()
	local Physics = Rethink.GetModules().Physics

	local isRunning = Iris.State(false)
	local prevState = Iris.State(false)

	Iris.TextWrapped({ "\nPhysics" })

	Iris.Checkbox({ "isRunning" }, { isChecked = isRunning })

	if not (prevState.value == isRunning.value) then
		prevState:set(isRunning.value)

		if isRunning.value then
			Physics:Start()
		else
			Physics:Stop()
		end
	end
end

local DebugConsole = {}
DebugConsole.IsRunning = false
DebugConsole.IsInitialized = false

function DebugConsole.Start()
	if DebugConsole.IsRunning then
		return warn("already running!")
	end

	DebugConsole.IsRunning = true

	if not DebugConsole.IsInitialized then
		DebugConsole.IsInitialized = true
		FindScenesModules()
		Iris.UpdateGlobalConfig({
			WindowBgTransparency = 0,
		})
	end

	Janitor:Add(
		Scene.Events.ObjectAdded:Connect(function(object)
			table.insert(sceneObjects, object)

			if not (Scene.IsRigidbody(object)) and object:IsA("GuiBase2d") then
				Camera.Attach(object)
			end
		end),
		"Disconnect"
	)

	Janitor:Add(
		Scene.Events.ObjectRemoved:Connect(function(object)
			table.remove(sceneObjects, table.find(sceneObjects, object))

			if not (Scene.IsRigidbody(object)) and object:IsA("GuiBase2d") then
				Camera.Detach(object)
			end
		end),
		"Disconnect"
	)

	Janitor:Add(
		UserInputService.InputBegan:Connect(function(key)
			if key.KeyCode == Enum.KeyCode.M then
				isToggled:set(not isToggled.value)
			end
		end),
		"Disconnect"
	)

	Iris:Connect(function()
		-- Update window states
		if windowsizeY.value ~= workspace.CurrentCamera.ViewportSize.Y - 36 then
			windowsizeY:set(workspace.CurrentCamera.ViewportSize.Y - 36)
		end

		windowsizeY:onChange(function()
			windowSize:set(Vector2.new(windowsizeX.value, windowsizeY.value))
		end)

		windowsizeX:onChange(function()
			windowSize:set(Vector2.new(windowsizeX.value, windowsizeY.value))
		end)

		isToggled:onChange(function()
			if not isToggled.value then
				showDemoWindow:set(false)
			end
		end)

		Iris.Window({
			"Rethink Debug Console",
			[Iris.Args.Window.NoClose] = true,
			[Iris.Args.Window.NoMove] = true,
			[Iris.Args.Window.NoResize] = true,
			[Iris.Args.Window.NoCollapse] = true,
		}, { size = windowSize, position = Vector2.new(0, 0), isOpened = isToggled })

		Iris.Checkbox({ "Demo window" }, { isChecked = showDemoWindow })

		Iris.Separator()

		RenderScene()
		RenderCamera()
		RenderPhysics()
		RenderPool()
		RenderExplorer()

		Iris.End()

		if showDemoWindow.value then
			Iris.ShowDemoWindow()
		end
	end)
end

function DebugConsole.Stop()
	Janitor:Cleanup()
	table.clear(Iris._connectedFunctions)
	DebugConsole.IsRunning = false
end

return DebugConsole
