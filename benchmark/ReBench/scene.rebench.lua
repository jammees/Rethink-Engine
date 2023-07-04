local scenes = game.Players.LocalPlayer.PlayerScripts["Tests"].Scenes

local Rethink = require(game:GetService("ReplicatedStorage").Rethink)
local Scene = Rethink.Scene

return function(Benchmark)
	Benchmark({
			["load 2000"] = function()
				Scene.Load(table.unpack(require(scenes.Stess_test)))
			end,

			["load 10000"] = function()
				Scene.Load(table.unpack(require(scenes.Stess_test)))
			end,
		})
		:Function(function()
			print("Started benchmarking scene")
		end)
		:BeforeEach({
			["load 2000"] = function()
				Scene.Flush()
				scenes.objectsNumber.Value = 2000
			end,

			["load 10000"] = function()
				Scene.Flush()
				scenes.objectsNumber.Value = 10000
			end,
		})
		:Run(100)
end
