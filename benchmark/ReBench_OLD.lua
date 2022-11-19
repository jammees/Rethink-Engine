--[[
	ReBenchmark
	An easy to use and super light benchmarking module.

	Version: 0.2.1
	Created by: james_mc98
	Last update: 2022-06-09

	Credits:
	Took API ideas from Fusion's benchmarking modules. (https://github.com/Elttob/Fusion)
	Took the percent idea from boatbomber's benchmarking plugin (https://devforum.roblox.com/t/benchmarker-plugin-compare-function-speeds-with-graphs-percentiles-and-more)

	Notice: Using ReBench.BenchAuto requires that all the benchmarking modules end with .rebench or .bench
]]

local Reporter = {}
Reporter.StartModule = "\nBenchmark results:\n"
Reporter.Tree = "\t[%s]:\n"
Reporter.Result = "\t\t- %s: %s μs\n"
Reporter.ResultFunction = "\t- %s: %s μs\n"
Reporter.StartFunction = "\nBenchmark result:\n"

function Reporter.ModuleReport(benchResults: { [string]: { [string]: any } })
	local report = Reporter.StartModule

	for treeName, treeResults in pairs(benchResults) do
		report = report .. string.format(Reporter.Tree, treeName)
		for _, resultTable in ipairs(treeResults) do
			report = report .. string.format(Reporter.Result, resultTable.Name, resultTable.Value)
		end
	end

	print(report)
end

function Reporter.FunctionReport(benchResult: { [number]: { Name: string, Value: any } })
	local report = Reporter.StartFunction

	for _, resultTable in ipairs(benchResult) do
		report = report .. string.format(Reporter.ResultFunction, resultTable.Name, resultTable.Value)
	end

	print(report)
end

local Benchmarker = {}
Benchmarker.DefaultCalls = 500
Benchmarker.Decimals = 7
Benchmarker.Threads = 5

function Benchmarker.SimplifyNumber(number: number): string
	if typeof(number) ~= "number" then
		number = "Something went wrong!"
	end

	print(number)

	local stringNumber = tostring(number)

	if stringNumber:match(".") then
		local split = string.split(stringNumber, ".")
		return split[1] .. "." .. string.sub(split[2], 0, Benchmarker.Decimals)
	else
		return stringNumber
	end
end

function Benchmarker.CalculateData(times: { [number]: number }, calls: number): { [string]: string }
	local avarageTime = 0
	local maximumTime = 0
	local minimumTime = math.huge

	-- avarage time
	table.foreachi(times, function(_, b)
		avarageTime += b
	end)
	avarageTime = avarageTime / calls

	-- minimum time
	table.sort(times, function(a, b)
		return a < b
	end)
	minimumTime = times[1]

	-- maximum time
	table.sort(times, function(a, b)
		return a > b
	end)
	maximumTime = times[1]

	local percent10 = (calls / 100) * 10
	local percent50 = (calls / 100) * 50
	local percent90 = (calls / 100) * 90

	return {
		{ Name = "Avarage time", Value = Benchmarker.SimplifyNumber(avarageTime) },
		{ Name = "Maximum time", Value = Benchmarker.SimplifyNumber(maximumTime) },
		{ Name = "Minimum time", Value = Benchmarker.SimplifyNumber(minimumTime) },
		{ Name = "Elapsed time", Value = Benchmarker.SimplifyNumber(avarageTime * calls) },

		{ Name = "10%", Value = Benchmarker.SimplifyNumber(times[percent10]) },
		{ Name = "50%", Value = Benchmarker.SimplifyNumber(times[percent50]) },
		{ Name = "90%", Value = Benchmarker.SimplifyNumber(times[percent90]) },
	}
end

function Benchmarker.Module(benchmarkConfig: { any }): { [string]: { [string]: string } }
	local benchResults = {}
	local startTime = 0
	local endTime = 0
	local context = {}

	local function SetContext(...)
		context = table.pack(...)
		context.n = nil
	end

	if typeof(benchmarkConfig.atStart) == "function" then
		benchmarkConfig.atStart()
	end

	for treeName, argument in pairs(benchmarkConfig) do
		if typeof(argument) == "table" then
			-- table for holding the results
			local times = {}

			for _ = 1, argument.calls or Benchmarker.DefaultCalls do
				if typeof(argument.before) == "function" then
					argument.before(SetContext)
				end

				startTime = math.floor(os.clock())

				argument.run(SetContext, table.unpack(context))

				endTime = math.floor(os.clock())

				if typeof(argument.after) == "function" then
					argument.after(table.unpack(context))
				end

				warn(endTime - startTime)
				warn(startTime - endTime)
				warn(math.abs(startTime - endTime))
				warn("\n\n\n")

				table.insert(times, endTime - startTime)
			end

			benchResults[treeName] = Benchmarker.CalculateData(times, argument.Calls or Benchmarker.DefaultCalls)
		end
	end

	if typeof(benchmarkConfig.atEnd) == "function" then
		benchmarkConfig.atEnd()
	end

	return benchResults
end

function Benchmarker.Function(benchCode: { [string]: (any) -> (any) | number }): { [string]: { [string]: string } }
	-- table for saving the returned values from the before function, to later pass it to run
	local context = {}

	-- table for holding the results
	local times = {}

	for _ = 1, benchCode.calls or Benchmarker.DefaultCalls do
		if typeof(benchCode.before) == "function" then
			context = table.pack(benchCode.before())
			context.n = nil
		end

		local startTime = os.clock()

		benchCode.run(table.unpack(context))

		local endTime = os.clock()

		if typeof(benchCode.after) == "function" then
			benchCode.after()
		end

		table.insert(times, endTime - startTime)
	end

	return Benchmarker.CalculateData(times, benchCode.calls or Benchmarker.DefaultCalls)
end

local ReBenchmark = {}

--[[
	Runs a benchmark on a list of modules

	Returns the results

	**Example**:

	```lua
	local ReBenchmark = require(game:GetService("ReplicatedStorage").ReBench)

	local benchmarkModules = {}

	for _, v in ipairs(game:GetDescendants()) do
		if v:IsA("ModuleScript") and v.Name:match(".spec$") then
			table.insert(benchmarkModules, v)
		end
	end

	ReBenchmark.BenchModules(benchmarkModules)
	```
]]
function ReBenchmark.BenchModules(benchmarkModules: { [number]: ModuleScript })
	local benchmarkResults = {}

	for _, v in ipairs(benchmarkModules) do
		local results = Benchmarker.Module(require(v))

		for o, b in pairs(results) do
			benchmarkResults[o] = b
		end
	end

	Reporter.ModuleReport(benchmarkResults)

	return benchmarkResults
end

--[[
	Benchmarks a single function. 

	Returns the results.

	**Example**:

	```lua
	local ReBenchmark = require(game:GetService("ReplicatedStorage").ReBench)

	ReBenchmark.BenchFunction(function(myMessage)
		print(myMessage)
	end, 15, function()
		print("Before")
		return "Hello world"
	end, function()
		print("After")
	end)
	```
]]
function ReBenchmark.BenchFunction(benchCode: { [string]: (any) -> (any) | number }): { [string]: string }
	local result = Benchmarker.Function(benchCode)

	Reporter.FunctionReport(result)

	return result
end

--[[
	Scans trough the entire game, looking for benchmarking modules.

	All benchmarking modules **must end with**: `.rebench` or .`bench`.

	Returns the results.

	**Example**:

	```lua
	local ReBenchmark = require(game:GetService("ReplicatedStorage").ReBench)
	ReBenchmark.BenchAuto()
	```
]]
function ReBenchmark.BenchAuto()
	local benchModules = {}

	for _, v in ipairs(game:GetDescendants()) do
		if v:IsA("ModuleScript") and v.Name:match(".rebench$") or v.Name:match(".bench$") then
			table.insert(benchModules, v)
		end
	end

	ReBenchmark.BenchModules(benchModules)
end

return ReBenchmark
