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

local RunService = game:GetService("RunService")

local Rethink = require(game:GetService("ReplicatedStorage").Rethink)
local Janitor = require(Rethink.Components.Library.Janitor)

local updateJanitor = Janitor.new()
local renderJanitor = Janitor.new()

local CameraController = {}
CameraController.Update = false
CameraController.Render = false

function CameraController.Init(DatGui: DatGuiType)
	local datGui: DatGuiClass = DatGui.addFolder("Camera Rewrite")

	datGui.add(CameraController, "Update").listen().onChange(function(value)
		if value == true then
			updateJanitor:Add(RunService.RenderStepped:Connect(function()
				Rethink.Prototypes.PCamera.Update()
			end))

			return
		end

		updateJanitor:Cleanup()
	end)

	datGui.add(CameraController, "Render").listen().onChange(function(value)
		if value == true then
			renderJanitor:Add(RunService.RenderStepped:Connect(function()
				Rethink.Prototypes.PCamera.Render()
			end))

			return
		end

		renderJanitor:Cleanup()
	end)
end

function CameraController.Enable() end

return CameraController
