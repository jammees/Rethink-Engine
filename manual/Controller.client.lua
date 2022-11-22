local controllers = script.Parent:FindFirstChild("Controllers")
local modules = script.Parent:FindFirstChild("Modules")

local Rethink = require(game:GetService("ReplicatedStorage").RethinkEngine)
local DatGui = require(modules:WaitForChild("DatGui"))

local scenes = controllers.Scene:WaitForChild("Scenes")

local function GenerateSceneTable()
	local lookup = {}

	for _, scene in ipairs(scenes:GetDescendants()) do
		table.insert(lookup, scene.Name)
	end

	print(lookup)

	return lookup
end

-- Scene
local container = DatGui.new({
	closeable = false,
	width = 150,
})
container.addLogo("rbxassetid://9799761830", 50)

local sceneFolder = container.addFolder("Scene")

-- Scene settings
local sceneSettings = {
	SelectedScene = scenes.Test,
}

local sceneFunctions = {
	FlushScene = function()
		Rethink.Scene.Flush()
	end,

	LoadScene = function()
		Rethink.Scene.Load(table.unpack(require(scenes[sceneSettings.SelectedScene])))
	end,
}

sceneFolder.add(sceneSettings, "SelectedScene", GenerateSceneTable()).listen().onChange(function(value, text)
	if scenes[text] then
		sceneSettings.SelectedScene = value
	end
end)

sceneFolder.add(sceneFunctions, "LoadScene").name("Load Scene")
sceneFolder.add(sceneFunctions, "FlushScene").name("Flush Scene")
