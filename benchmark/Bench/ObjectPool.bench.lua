--[[

|WARNING| THESE TESTS RUN IN YOUR REAL ENVIRONMENT. |WARNING|

If your tests alter a DataStore, it will actually alter your DataStore.

This is useful in allowing your tests to move Parts around in the workspace or something,
but with great power comes great responsibility. Don't mess up your stuff!

---------------------------------------------------------------------

Documentation and Change Log:
https://devforum.roblox.com/t/benchmarker-plugin-compare-function-speeds-with-graphs-percentiles-and-more/829912/1

--------------------------------------------------------------------]]

local Rethink = require(game:GetService("ReplicatedStorage").Rethink)
local ObjectPool = require(Rethink.Components.Library.ObjectPool)
local ObjectPoolUnmodifed = require(script.Parent.old_ObjectPool)

return {

	ParameterGenerator = function() end,

	Functions = {
		["Default"] = function(Profiler) -- You can change 'Sample A' to a descriptive name for your function
			-- The first argument passed is always our Profiler tool, so you can put
			-- Profiler.Begin('UNIQUE_LABEL_NAME') ... Profiler.End() around portions of your code
			-- to break your function into labels that are viewable under the results
			-- histogram graph to see what parts of your function take the most time.

			-- Your code here
			Profiler.Begin("Init")

			local pool = ObjectPoolUnmodifed.new({
				Frame = 1000,
			})

			Profiler.End()

			local objs = {}

			Profiler.Begin("Get objects")

			for i = 1000, 1, -1 do
				objs[i] = pool:Get("Frame")
			end

			Profiler.End()

			Profiler.Begin("Return objects")

			for _, v in ipairs(objs) do
				pool:Return(v)
			end

			Profiler.End()
		end,

		["Optimized"] = function(Profiler)
			Profiler.Begin("Init")

			local pool = ObjectPool.new({
				Frame = 1000,
			})

			Profiler.End()

			local objs = {}

			Profiler.Begin("Get objects")

			for i = 1000, 1, -1 do
				objs[i] = pool:Get("Frame")
			end

			Profiler.End()

			Profiler.Begin("Return objects")

			for _, v in ipairs(objs) do
				pool:Return(v)
			end

			Profiler.End()
		end,

		-- You can add as many functions as you like!
	},
}
