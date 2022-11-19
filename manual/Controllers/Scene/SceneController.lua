local Rethink = require(game:GetService("ReplicatedStorage").RethinkEngine)
local Scene = Rethink.Scene

local sceneFolder = script.Parent:WaitForChild("Scenes")

local SceneController = {}
SceneController.Scene = Scene

function SceneController:LoadScene(name: string)
	for _, v in ipairs(sceneFolder:GetChildren()) do
		pcall(function()
			if v.Name:lower() == name then
				Scene.Flush()
				local sceneData = require(v)
				Scene.Load(sceneData[1], sceneData[2])

				return
			end
		end)
	end
end

function SceneController:Cache(cacheName: string)
	if Scene.GetName() then
		Scene.Prototype_1v_Cache(cacheName or Scene.GetName())
		--Scene:Cache(cacheName or Scene:GetName())
	end
end

function SceneController:PrintCache()
	print(Scene.GetCache())
end

return SceneController
