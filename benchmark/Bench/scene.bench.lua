local Rethink = require(script.Parent.Parent.Parent.RethinkEngine)
local Scene = Rethink.Scene

local sceneName = "Stess_test"

return function(Benchmark)
	Benchmark({
			["load in a scene"] = function()
				local sceneData =
					require(game.Players.LocalPlayer.PlayerScripts["Manual tests"].Controllers.Scene.Scenes[sceneName])
				Scene.Load(sceneData[1], sceneData[2])
			end,
		})
		:Function(function()
			print("Started benchmarking")
		end)
		:BeforeEach({
			["load in a scene"] = function()
				Scene.Flush()
				print(
					#Scene:GetObjects() > 0 and #Scene:GetObjects() .. " objects left in memory after flush!"
						or "No objects left in memory after flush!"
				)
			end,
		})
		:Run(50)
end
