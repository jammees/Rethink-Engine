type DatGuiType = {
	addFolder: (string) -> (any)?,
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
	add: (() -> (), string, any) -> (DatGuiController),
}

local TestEZ = require(game:GetService("ReplicatedStorage")["Unit tests"].TestEZ)

local MiscController = {}

function MiscController.Init(DatGui: DatGuiType)
	local datGui: DatGuiClass = DatGui.addFolder("Scene")

	datGui.add(MiscController, "RunTestEZ").name("Run .spec modules")
end

function MiscController.RunTestEZ()
	local m = {}
	for _, v in ipairs(game:GetDescendants()) do
		if v:IsA("ModuleScript") and v.Name:match(".spec$") then
			table.insert(m, v)
		end
	end

	TestEZ.TestBootstrap:run(m)
end

return MiscController
