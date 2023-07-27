--[[

|WARNING| THESE TESTS RUN IN YOUR REAL ENVIRONMENT. |WARNING|

If your tests alter a DataStore, it will actually alter your DataStore.

This is useful in allowing your tests to move Parts around in the workspace or something,
but with great power comes great responsibility. Don't mess up your stuff!

---------------------------------------------------------------------

Documentation and Change Log:
https://devforum.roblox.com/t/benchmarker-plugin-compare-function-speeds-with-graphs-percentiles-and-more/829912/1

--------------------------------------------------------------------]]

-- Measure the speed of loading in scenes and flushing them.
-- Flushing scenes is super fast, relative to loading them.
-- This is not surprising, because when loading the compiler has to get each object, symbol, data, then use Scene.Add to create
-- a scene object, add a cleanup method, add symbols then finally allocate a space in the sceneObjects table.

---@module src.init
local Rethink = require(game:GetService("ReplicatedStorage").Rethink).Init()
local Scene = Rethink.GetModules().Scene

return {

	ParameterGenerator = function() end,

	Functions = {
		["Load/Flush Scene"] = function(Profiler) -- You can change 'Sample A' to a descriptive name for your function
			-- The first argument passed is always our Profiler tool, so you can put
			-- Profiler.Begin('UNIQUE_LABEL_NAME') ... Profiler.End() around portions of your code
			-- to break your function into labels that are viewable under the results
			-- histogram graph to see what parts of your function take the most time.

			-- Your code here

			Profiler.Begin("Prepare scene module")
			local sceneModule = require(game:FindFirstChild("Test.scene", true))
			Profiler.End()

			Profiler.Begin("Load")
			Scene.Load(sceneModule)
			Profiler.End()

			Profiler.Begin("Flush")
			Scene.Flush(true)
			Profiler.End()
		end,

		-- You can add as many functions as you like!
	},
}
