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

function CameraController.Init(DatGui: DatGuiType)
	local datGui: DatGuiClass = DatGui.addFolder("Camera")

	datGui.add(Rethink.Prototypes.Camera, "ShouldRender")
	datGui.add(CameraController, "X", -500, 500).onChange(function()
		Rethink.Prototypes.Camera.MoveTo(CameraController.X, CameraController.Y)
	end)
	datGui.add(CameraController, "Y", -500, 500).onChange(function()
		Rethink.Prototypes.Camera.MoveTo(CameraController.X, CameraController.Y)
	end)
end

function CameraController.Enable() end

return CameraController
