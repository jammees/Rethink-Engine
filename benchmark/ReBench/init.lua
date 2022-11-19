--[[
	ReBench
	
	An easy-to-use and light-weight benchmarking module with lots of features!

	Version: 0.3.0
	Last updated: 2022/06/22

	Credits:
	Lightlimn - Timer module
	Validark - Janitor module

]]

type class = any

type results = { [string]: { [string]: number } }

type flagToDestroy = (any) -> ()

local DEFAULT_CYCLES = 500
local ALLOWED_TYPES_TO_FLAGGED = {
	"function",
	"table",
	"thread",
	"Instance",
}

local Score = require(script.Score)
local Janitor = require(script.Janitor)
local Timer = require(script.Timer)

local ReBench = {}
ReBench.__index = ReBench

--[=[
	Creates a new ReBench class.
]=]
function ReBench.new(functions: { [string]: (any) -> () }): class
	return setmetatable({
		_functions = functions,
		_beforeEachFunctions = nil,
		_cycles = 0,

		_resultGroup = nil,
		_timeout = nil,
		_results = {},
		_cyclesAmount = {},

		_janitor = Janitor.new(),
		_timer = Timer.new(0),
		_signalHandle = nil,
		_isAbort = false,
	}, ReBench)
end

--[=[
	Requires all of the provided modules.
	After finish, it will log all of the results.

	```lua
	local ReBench = require(game:GetService("ReplicatedStorage").ReBench)
	ReBench.Run({MyModule})
	```
]=]
function ReBench.Run(benchmarkModules: { [number]: ModuleScript })
	Score.Group.ResetData()

	for _, v in ipairs(benchmarkModules) do
		require(v)(ReBench.new)
	end

	Score.Report(print, Score.Group.GetData())
end

--[=[
	Searches the whole game for `.bench` or `.rebench` modules to run them.
	After it finished it will report all of the results in one go.

	```lua
	local ReBench = require(game:GetService("ReplicatedStorage").ReBench)
	ReBench.AutoBench()
	```

	How a `.bench` file looks like:

	```lua
	return function(Benchmark)
		Benchmark({
			["Print Hello world! to console"] = function()
				print("Hello world!")
			end,

			["Warn Hello world! to console"] = function()
				warn("Hello world!")
			end,
		}):Run(25)
	end
	```
]=]
function ReBench.AutoBench(): { [number]: ModuleScript }
	local requiredModules = {}

	Score.Group.ResetData()

	for _, v in ipairs(game:GetDescendants()) do
		if v:IsA("ModuleScript") and v.Name:match(".rebench$") or v.Name:match(".bench$") then
			require(v)(ReBench.new)
			table.insert(requiredModules, v)
		end
	end

	Score.Report(print, Score.Group.GetData())

	return requiredModules
end

--[=[
	Sets a timeout for all of the benchmarks, to prevent them to run too long.
]=]
function ReBench:TimeOut(seconds: number): class
	assert(typeof(seconds) == "number", "Expected number, got;" .. typeof(seconds))

	self._timeout = seconds

	return self
end

--[=[
	Flags an object to get cleaned up after the benchmark finished.
]=]
function ReBench:Flag(object: any): any
	if not table.find(ALLOWED_TYPES_TO_FLAGGED, typeof(object)) then
		return warn("Attempted to flag an object that can't be cleaned up!")
	end

	self._janitor:Add(object)
	return object
end

--[=[
	Runs the provided functions certain amount of times.
	If not provided it will default to 500 cycles

	@arg cycles number
	@arg autoFlag boolean {optional}

	AutoFlag cleans up every instance that was returned by the :BeforeEach() functions.
]=]
function ReBench:Run(cycles: number, autoFlag: boolean): class
	assert(typeof(cycles) == "number", "Expected number, got;" .. typeof(cycles))

	local localResults = { All = 0 }
	self._cycles = cycles or DEFAULT_CYCLES
	self._results = {}

	-- if there is a timeout set, setup Sleitnick's timer module
	if self._timeout and self._timeout > 0 then
		self._timer.Duration = self._timeout

		self._signalHandle = self._timer.Completed:Connect(function()
			self._isAbort = true
			self._timer:Stop()
		end)
	end

	-- start the good stuff :)
	for label, callback in pairs(self._functions) do
		-- initialize a cycle holder
		self._cyclesAmount[label] = {
			Current = 0,
			Max = cycles,
		}

		-- reset timer
		if self._timeout and self._timeout > 0 then
			self._timer:Stop()
		end

		-- reset stuffs
		localResults = { All = 0, TimedOut = false }
		local beforeFunction = nil
		local context = {}

		if typeof(self._beforeEachFunctions) == "table" then
			if self._beforeEachFunctions[label] then
				beforeFunction = self._beforeEachFunctions[label]
			end
		end

		for i = 1, self._cycles do
			if self._isAbort then
				--[[ warn(
					("Benchmark timed out; %s (%d/%d cycles | %s %%) with %d second(s)"):format(
						label,
						self._cyclesAmount[label],
						self._cycles,
						("%0.1f"):format((self._cyclesAmount[label] / self._cycles) * 100),
						self._timer.Duration
					)
				) *]]

				localResults.TimedOut = true
				localResults.TimeOutSeconds = self._timeout

				self._isAbort = false

				break
			end

			if typeof(beforeFunction) == "function" then
				context = table.pack(beforeFunction(not autoFlag and self or nil))
				context.n = nil

				if autoFlag then
					for _, v in ipairs(context) do
						if table.find(ALLOWED_TYPES_TO_FLAGGED, typeof(v)) then
							self:Flag(v)
						end
					end
				end
			end

			if self._timeout and self._timeout > 0 then
				self._timer:Start()
			end

			local startTime = os.clock()

			callback(table.unpack(context))

			local endTime = os.clock()

			if self._timeout and self._timeout > 0 then
				self._timer:Pause()
			end

			table.insert(localResults, endTime - startTime)
			localResults["All"] += endTime - startTime

			self._cyclesAmount[label].Current = i
		end

		local localIndex = {
			Name = label,
			IsTimedOut = localResults.TimedOut,
			TimeOutLimit = self._timeout,
		}

		self._results[localIndex] = Score.CalculateScore(localResults, self._cyclesAmount[label].Current)
		Score.Group.SaveData(localIndex, self._results[localIndex], self._cyclesAmount[label])
	end

	localResults = {}
	if self._timeout then
		self._timer:Stop()
		self._signalHandle:Disconnect()
	end

	-- cleanup flagged objects;
	self._janitor:Cleanup()

	return self
end

--[=[
	Runs a function, that can be chained together with the rest of the methods.
	Useful for preparing to benchmark.
]=]
function ReBench:Function(callback: () -> ()): class
	assert(typeof(callback) == "function", "Expected function, got;" .. typeof(callback))

	callback()

	return self
end

--[=[
	Hook a function to be run before the specified benchmark.
	Variables that are returned by the pre ran function get passed to the benchmark function!

	If in the :Run method after the cycles AutoFlag is not enabled, ReBench will pass it self into the function, 
	so :Flag can be used!
		
	```lua
	return function(Benchmark)
		Benchmark({
			["rename folder to Test"] = function(folder: Folder)
				folder.Name = "Test"
			end,
		})
			:BeforeEach({
				["rename folder to Test"] = function(self)
					return self:Flag(Instance.new("Folder", workspace))
				end,
			})
			:Run(10)
	end
	```
]=]
function ReBench:BeforeEach(functions: { [string]: (flagToDestroy) -> (any) }): class
	assert(typeof(functions) == "table", "Expected function, got;" .. typeof(functions))

	self._beforeEachFunctions = functions

	return self
end

--[=[
	Prints out the results into the output.

	If needed a function can be passed into the method to later be used to log the results.
	If not present it will default to `print`.

	```lua
	return function(Benchmark)
		Benchmark({
			["rename folder to Test"] = function(folder: Folder)
				folder.Name = "Test"
			end,
		})
			:BeforeEach({
				["rename folder to Test"] = function(self)
					return self:Flag(Instance.new("Folder", workspace))
				end,
			})
			:Run(10):ToConsole(warn)
	end
	```
]=]
function ReBench:ToConsole(method): class
	Score.Report(typeof(method) == "function" and method or print, self._results, self._cyclesAmount)

	return self
end

--[=[
	Returns the results.
]=]
function ReBench:ReturnResults(): results
	return self._results
end

return ReBench
