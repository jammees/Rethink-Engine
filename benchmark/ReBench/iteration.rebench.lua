return function(Benchmark)
	--[[
        Benchmark results:
            For (100/100 cycles // 100.0 %):
                Avarage: 0.000013 μs
                Maximum: 0.000016 μs
                Minimum: 0.000010 μs
                Elapsed: 0.001250 μs
            For pairs (100/100 cycles // 100.0 %):
                Avarage: 0.000011 μs
                Maximum: 0.000019 μs
                Minimum: 0.000008 μs
                Elapsed: 0.001105 μs
            For ipairs (100/100 cycles // 100.0 %):
                Avarage: 0.000010 μs
                Maximum: 0.000016 μs
                Minimum: 0.000008 μs
                Elapsed: 0.001023 μs
    ]]

	Benchmark({
			["For ipairs"] = function(iterationTable)
				for i, v in ipairs(iterationTable) do
					iterationTable[v] = i
				end
			end,

			["For pairs"] = function(iterationTable)
				for i, v in pairs(iterationTable) do
					iterationTable[v] = i
				end
			end,

			["For"] = function(iterationTable)
				for i = 1, #iterationTable do
					local value = iterationTable[i]
					iterationTable[value] = i
				end
			end,
		})
		:Function(function()
			print("Started benchmarking for iteration!")
		end)
		:BeforeEach({
			["For ipairs"] = function()
				return table.create(1000, "Hello world!")
			end,

			["For pairs"] = function()
				return table.create(1000, "Hello world!")
			end,

			["For"] = function()
				return table.create(1000, "Hello world!")
			end,
		})
		:Run(100, false)
end
