local CollectionService = game:GetService("CollectionService")

local TestEZ = require(game:GetService("ReplicatedStorage")["Unit tests"].TestEZ)
local Iris = require(script.Parent.Modules["Iris-1.0.2"]).Init()
local Rethink = require(game:GetService("ReplicatedStorage").Rethink)

local showSceneExplorer = Iris.State(false)
local searchedTagString = Iris.State("non")
local autoAttachDetach = Iris.State(false)

local function GenerateSceneTable()
	local lookup = {}

	for _, scene in ipairs(script.Parent.Scenes:GetDescendants()) do
		table.insert(lookup, scene.Name)
	end

	return lookup
end

local function RenderSceneExplorer()
	Iris.Window({ "Scene Explorer", [Iris.Args.Window.NoClose] = true })

	Iris.Text({ `Objects: {#Rethink.Scene.GetObjects()}` })

	for _, objectReference in Rethink.Scene.GetObjects() do
		local IsRigidbody = Rethink.Scene.IsRigidbody(objectReference.Object)
		local object = IsRigidbody and objectReference.Object:GetFrame() or objectReference.Object

		Iris.Tree({ object.Name, [Iris.Args.Tree.SpanAvailWidth] = true })

		Iris.Text({ `Is Attached: {Rethink.Prototypes.Camera.IsAttached(objectReference.Object)}` })

		Iris.SameLine()

		if Iris.Button({ "Attach to Camera" }).clicked then
			Rethink.Prototypes.Camera.Attach(objectReference.Object)
		end

		if Iris.Button({ "DeAttach to Camera" }).clicked then
			Rethink.Prototypes.Camera.Detach(objectReference.Object)
		end

		Iris.End()

		Iris.Text({ `Index: {objectReference.Index}` })
		Iris.Text({ `Is Rigidbody: {IsRigidbody}` })
		Iris.TextWrapped({ `Path: {object:GetFullName()}` })

		Iris.Text({ "Symbols:" })

		Iris.Table({ 2 })

		Iris.NextColumn()
		Iris.Text({ "ShouldFlush" })
		Iris.NextColumn()
		Iris.Text({ `{objectReference.ShouldFlush}` })

		Iris.End()

		Iris.Text({ "Tags:" })

		Iris.Table({ 1 })

		for _, tag in CollectionService:GetTags(object) do
			local text = Iris.Text({ `{tag}` })
			if tag == searchedTagString:get() then
				text.Instance.TextColor3 = Color3.fromHSV(0.5, 1, 1)
			else
				text.Instance.TextColor3 = Color3.fromRGB(255, 255, 255)
			end
			Iris.NextRow()
		end

		Iris.End()

		Iris.End()
	end

	Iris.End()
end

local function RenderScene()
	local selectedSceneName = Iris.State("non")
	local ignoreSF = Iris.State(true)

	Iris.Tree({ "Scene" })

	Iris.TextWrapped({ "Loads objects/rigidbodies from nested tables and allows the use of symbols." })

	Iris.Separator()

	Iris.Text({ `Selected scene: {selectedSceneName:get()}` })

	Iris.SameLine()

	if Iris.Button({ "Load Selected Scene" }).clicked then
		Rethink.Scene.Load(require(script.Parent.Scenes[selectedSceneName:get()]))
	end

	if Iris.Button({ "Flush Scene" }).clicked then
		Rethink.Scene.Flush(ignoreSF:get())
	end

	Iris.End()

	Iris.Checkbox({ "Ignore Should Flush Symbol" }, { isChecked = ignoreSF })

	Iris.Text({ "" })

	Iris.Table({ 1 })
	for _, sceneName in GenerateSceneTable() do
		Iris.NextRow()

		Iris.SameLine()

		if Iris.Button({ "Select" }).clicked then
			selectedSceneName:set(sceneName)
		end

		Iris.Text({ sceneName })

		Iris.End()
	end
	Iris.End()

	Iris.Separator()

	local tagInput = Iris.InputText({ "Input a string to search for" })
	if Iris.Button({ "Search" }).clicked then
		searchedTagString:set(tagInput.text.value)
	end
	Iris.TextWrapped({
		"If an object has the specified tag it will be highlighted in the Scene Explorer in a light blue color.",
	})

	Iris.End()
end

local function RenderCamera()
	local X = Iris.State(0)
	local Y = Iris.State(0)
	local isRunning = Iris.State(false)
	local connection = Iris.State(nil)
	local XMin = Iris.State(-math.huge)
	local XMax = Iris.State(math.huge)
	local YMin = Iris.State(-math.huge)
	local YMax = Iris.State(math.huge)

	Iris.Tree({ "Camera" })

	Iris.Text({ `Position: [{Rethink.Prototypes.Camera.Position}]` })
	Iris.Text({ `BoundsMin: [{Rethink.Prototypes.Camera.XBounds.Min}, {Rethink.Prototypes.Camera.YBounds.Min}]` })
	Iris.Text({ `BoundsMax: [{Rethink.Prototypes.Camera.XBounds.Max}, {Rethink.Prototypes.Camera.YBounds.Max}]` })
	Iris.Text({ `Is Running: {Rethink.Prototypes.Camera.IsRunning}` })

	if Iris.InputNum({ `X Pos`, [Iris.Args.InputNum.Increment] = 10 }, { number = X }).numberChanged then
		Rethink.Prototypes.Camera.SetPosition(X:get(), Y:get())
	end

	if Iris.InputNum({ `Y Pos`, [Iris.Args.InputNum.Increment] = 10 }, { number = Y }).numberChanged then
		Rethink.Prototypes.Camera.SetPosition(X:get(), Y:get())
	end

	Iris.SameLine()

	if Iris.Checkbox({ "Is Running" }, { isChecked = isRunning }).checked then
		if isRunning:get() then
			connection:set(game:GetService("RunService").RenderStepped:Connect(function(dt)
				Rethink.Prototypes.Camera.Render(dt)
			end))
		end
	else
		if not isRunning:get() and connection:get() then
			connection:get():Disconnect()
			connection:set(nil)
		end
	end

	if Iris.Button({ "Tick" }).clicked then
		Rethink.Prototypes.Camera.Render()
	end

	Iris.End()

	Iris.Text({ "Bounds" })

	Iris.SameLine()
	Iris.Text({ "X" })
	if Iris.InputNum({ "Min", [Iris.Args.InputNum.NoButtons] = true }, { number = XMin }).numberChanged then
		Rethink.Prototypes.Camera.SetBoundary(
			NumberRange.new(XMin:get(), XMax:get()),
			NumberRange.new(YMin:get(), YMax:get())
		)
	end
	Iris.Text({ "  " })
	if Iris.InputNum({ "Max", [Iris.Args.InputNum.NoButtons] = true }, { number = XMax }).numberChanged then
		Rethink.Prototypes.Camera.SetBoundary(
			NumberRange.new(XMin:get(), XMax:get()),
			NumberRange.new(YMin:get(), YMax:get())
		)
	end
	Iris.End()

	Iris.SameLine()
	Iris.Text({ "Y" })
	if Iris.InputNum({ "Min", [Iris.Args.InputNum.NoButtons] = true }, { number = YMin }).numberChanged then
		Rethink.Prototypes.Camera.SetBoundary(
			NumberRange.new(XMin:get(), XMax:get()),
			NumberRange.new(YMin:get(), YMax:get())
		)
	end
	Iris.Text({ "  " })
	if Iris.InputNum({ "Max", [Iris.Args.InputNum.NoButtons] = true }, { number = YMax }).numberChanged then
		Rethink.Prototypes.Camera.SetBoundary(
			NumberRange.new(XMin:get(), XMax:get()),
			NumberRange.new(YMin:get(), YMax:get())
		)
	end
	Iris.End()

	Iris.End()
end

Iris:Connect(function()
	local showDemoWindow = Iris.State(false)
	local runPhysics = Iris.State(false)

	if showDemoWindow:get() then
		Iris.ShowDemoWindow()
	end

	if showSceneExplorer:get() then
		RenderSceneExplorer()
	end

	Iris.Window({ "Rethink Debug Console", [Iris.Args.Window.NoClose] = true })

	Iris.TextWrapped({ "Debug console to test most of the tools and functionalities found in Rethink." })

	RenderScene()
	RenderCamera()

	Iris.Text({ "Misc" })

	Iris.Checkbox({ "Show Demo Window" }, { isChecked = showDemoWindow })
	Iris.Checkbox({ "Show Explorer" }, { isChecked = showSceneExplorer })
	if Iris.Button({ "Run TestEZ Units" }).clicked then
		local m = {}
		for _, v in ipairs(game:GetDescendants()) do
			if v:IsA("ModuleScript") and v.Name:match(".spec$") then
				table.insert(m, v)
			end
		end

		TestEZ.TestBootstrap:run(m)
	end

	Iris.Separator()

	Iris.Checkbox({ "Auto Attach & Detach from Camera" }, { isChecked = autoAttachDetach })
	Iris.Checkbox({ "Run Physics Simulation" }, { isChecked = runPhysics })

	if runPhysics:get() then
		if not Rethink.Physics.connection then
			Rethink.Physics:Start()
		end
	else
		if Rethink.Physics.connection then
			Rethink.Physics:Stop()
		end
	end

	Iris.End()
end)

Rethink.Scene.Events.ObjectAdded:Connect(function(object)
	if not autoAttachDetach:get() then
		return
	end

	Rethink.Prototypes.Camera.Attach(object)
end)

Rethink.Scene.Events.ObjectRemoved:Connect(function(object)
	if autoAttachDetach:get() then
		return
	end

	Rethink.Prototypes.Camera.Detach(object)
end)
