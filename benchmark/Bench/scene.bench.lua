local Rethink = require(script.Parent.Parent.Parent.Rethink)
local Scene = Rethink.Scene

local sceneName = "Stess_test"

return function(Benchmark)
	Benchmark({
			["load in a scene"] = function()
				local sceneData = require(game.Players.LocalPlayer.PlayerScripts["Manual tests"].Scenes[sceneName])
				Scene.Load(sceneData[1], sceneData[2])
			end,
		})
		:Function(function()
			print("Started benchmarking")
		end)
		:BeforeEach({
			["load in a scene"] = function()
				Scene.Flush()
			end,
		})
		:Run(50)
end
