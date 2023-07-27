local UserInputService = game:GetService("UserInputService")

---@module src.init
local Rethink = require(game:GetService("ReplicatedStorage").Rethink)
local Iris = require(script["Iris-2.0.2"]).Init()
local Tbl = require(script.tbl)
local Janitor = require(Rethink.Self.Library.Janitor).new()

-- States
local isToggled = Iris.State(true)
local showDemoWindow = Iris.State(false)
local windowsizeY = Iris.State(workspace.CurrentCamera.ViewportSize.Y - 36)
local windowsizeX = Iris.State(350)
local windowSize = Iris.State(Vector2.new(windowsizeX.value, windowsizeY.value))

local sceneModules = {}
local scenePointer = {}
local sceneObjects = {}

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
	local scene = Rethink.GetModules().Scene

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
			{ scene.IsRigidbody(object) and object:GetFrame().Name or object.Name, index },
			{ index = objectIndex }
		)
	end

	Iris.End()

	local selectedObject = sceneObjects[objectIndex.value]
	local frame = selectedObject and (scene.IsRigidbody(selectedObject) and selectedObject:GetFrame() or selectedObject)

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
		Iris.TextWrapped({
			`Position: {frame.Position}\nIsRigidbody: {scene.IsRigidbody(selectedObject)}\nTags: {table.concat(frame:GetTags(), ", ")}`,
		})

		local reference = scene.GetObjectReference(selectedObject)

		Iris.PushConfig({ TextColor = Color3.fromRGB(109, 109, 109) })
		Iris.TextWrapped({ `\nReference data:` })
		Iris.PopConfig()

		Iris.TextWrapped({
			`UUID: {reference.ID}\nObject: {reference.Object}\nJanitor: {reference.Janitor}\nSymbolJanitor: {reference.SymbolJanitor}\nSymbols: {Tbl.Concat(
				reference.Symbols,
				"\n\t[%s] = %s"
			)}`,
		})

		Iris.Separator()

		Iris.SameLine()
		if Iris.Button({ "Remove" }).clicked() then
			scene.Remove(selectedObject, stripSymbols.value)
		end
		Iris.Checkbox({ "stripSymbols" }, { isChecked = stripSymbols })
		Iris.End()
	end

	Iris.End()

	Iris.Separator()
end

local function RenderScene()
	local Scene = Rethink.GetModules().Scene
	local sceneIndex = Iris.State("Test.scene")
	local ignoreShouldFlush = Iris.State(true)

	Iris.Text({ "Scene" })

	Iris.TextWrapped({ `Objects: {Tbl.GetLenght(Scene.GetObjects())}\nIsLoading: {Scene.IsLoading}\n` })

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
		Scene.Flush(ignoreShouldFlush.value)
	end
	Iris.Checkbox("Ignore ShouldFlush", { isChecked = ignoreShouldFlush })
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

	Janitor:Add(Rethink.GetModules().Scene.Events.ObjectAdded:Connect(function(object)
		table.insert(sceneObjects, object)
	end))

	Janitor:Add(Rethink.GetModules().Scene.Events.ObjectRemoved:Connect(function(object)
		table.remove(sceneObjects, table.find(sceneObjects, object))
	end))

	Janitor:Add(UserInputService.InputBegan:Connect(function(key)
		if key.KeyCode == Enum.KeyCode.M then
			isToggled:set(not isToggled.value)
		end
	end))

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
