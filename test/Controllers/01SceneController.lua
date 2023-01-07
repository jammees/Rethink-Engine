type DatGuiType = {
	addFolder: (string) -> (any)?,
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

-- Settings
SceneController.SelectedScene = "Test"

function SceneController.Init(DatGui: DatGuiType)
	-- Add all of the connections
	local datGui: DatGuiClass = DatGui.addFolder("Scene")

	datGui.add(SceneController, "SelectedScene", GenerateSceneTable())
	datGui.add(SceneController, "Load")
	datGui.add(Rethink.Scene, "Flush")
end

function SceneController.Load()
	Rethink.Scene.Load(table.unpack(require(scenesFolder[SceneController.SelectedScene])))
end

return SceneController
