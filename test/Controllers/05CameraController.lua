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

local CameraController = {}
CameraController.X = 0
CameraController.Y = 0
CameraController.Enabled = false

function CameraController.Init(DatGui: DatGuiType)
	local datGui: DatGuiClass = DatGui.addFolder("Camera")

	local conn = nil
	datGui.add(CameraController, "Enabled").onChange(function()
		if CameraController.Enabled then
			conn = game:GetService("RunService").RenderStepped:Connect(function(dt)
				Rethink.Prototypes.Camera.Render(dt)
			end)
		else
			conn:Disconnect()
		end
	end)

	local XController = datGui.add(CameraController, "X", -500, 500)
	XController.onChange(function()
		Rethink.Prototypes.Camera.MoveTo(CameraController.X, CameraController.Y)
	end)

	local YController = datGui.add(CameraController, "Y", -500, 500)
	YController.onChange(function()
		Rethink.Prototypes.Camera.MoveTo(CameraController.X, CameraController.Y)
	end)

	Rethink.Scene.Events.LoadStarted:Connect(function()
		XController.setValue(0)
		YController.setValue(0)
	end)
end

function CameraController.Enable() end

return CameraController
