type DatGuiType = {
	addFolder: (string) -> any?,
}

type DatGuiController = {
	name: (name: string) -> Controller,
	label: (visible: boolean) -> Controller,
	help: (text: string) -> Controller,
	readonly: (value: boolean) -> Controller,
	onChange: (callback: () -> nil) -> Controller,
	getValue: () -> any,
	setValue: (any) -> Controller,
	listen: () -> Controller,
	remove: () -> nil,
	onRemove: (callback: () -> nil) -> RBXScriptConnection,
}

type DatGuiClass = {
	add: (() -> (), string, any) -> DatGuiController,
}

local Rethink = require(game:GetService("ReplicatedStorage").Rethink)

local SceneController = require(script.Parent["01SceneController"])
local Debugger = SceneController.Debug

local CameraController = {}
CameraController.X = 0
CameraController.Y = 0
CameraController.Enabled = false
CameraController.XBoundsMin = -math.huge
CameraController.XBoundsMax = math.huge
CameraController.YBoundsMin = -math.huge
CameraController.YBoundsMax = math.huge

function CameraController.Init(DatGui: DatGuiType)
	local datGui: DatGuiClass = DatGui.addFolder("Camera")

	Debugger.Add("isenabled", "Camera", `IsEnabled = {CameraController.Enabled}`)
	Debugger.Add("lastupdate", "Camera", `LastUpdate = nil`)

	local conn = nil
	datGui.add(CameraController, "Enabled").onChange(function()
		if CameraController.Enabled then
			conn = game:GetService("RunService").RenderStepped:Connect(function(dt)
				local start = tick()
				Rethink.Prototypes.Camera.Render(dt)
				Debugger.Update("lastupdate", `Took {tick() - start} ms`)
			end)
		else
			conn:Disconnect()
		end

		Debugger.Update("isenabled", `IsEnabled = {CameraController.Enabled}`)
	end)

	local XController = datGui.add(CameraController, "X", -500, 500)
	XController.onChange(function()
		Rethink.Prototypes.Camera.SetPosition(CameraController.X, CameraController.Y)

		if not CameraController.Enabled then
			Rethink.Prototypes.Camera.Render()
		end
	end)

	local YController = datGui.add(CameraController, "Y", -500, 500)
	YController.onChange(function()
		Rethink.Prototypes.Camera.SetPosition(CameraController.X, CameraController.Y)

		if not CameraController.Enabled then
			Rethink.Prototypes.Camera.Render()
		end
	end)

	Rethink.Scene.Events.LoadStarted:Connect(function()
		XController.setValue(0)
		YController.setValue(0)
	end)

	datGui.add(CameraController, "GetObjectsArray")

	datGui.add(CameraController, "XBoundsMin")
	datGui.add(CameraController, "XBoundsMax")
	datGui.add(CameraController, "YBoundsMin")
	datGui.add(CameraController, "YBoundsMax")
	datGui.add(CameraController, "ApplyBounds")
	datGui.add(Rethink.Prototypes.Camera, "Start")
	datGui.add(Rethink.Prototypes.Camera, "Stop")

	Rethink.Scene.Events.ObjectAdded:Connect(function(object)
		Rethink.Prototypes.Camera.Attach(object)
	end)

	Rethink.Scene.Events.ObjectRemoved:Connect(function(object)
		Rethink.Prototypes.Camera.Detach(object)
	end)
end

function CameraController.GetObjectsArray()
	print(Rethink.Prototypes.Camera.Objects)
end

function CameraController.ApplyBounds()
	Rethink.Prototypes.Camera.SetBoundary(
		NumberRange.new(CameraController.XBoundsMin, CameraController.XBoundsMax),
		NumberRange.new(CameraController.YBoundsMin, CameraController.YBoundsMax)
	)

	print("Applied new bounds")
end

return CameraController
