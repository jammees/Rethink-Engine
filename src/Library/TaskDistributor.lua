--[[
    TaskDistributor is a module created for handling tasks in a large scale using
	Promises.
]]

type PromiseClass = { [any]: any }

type CachedChunk = {
	Chunk: { [number]: { [number]: any } },
	DataSize: number,
}

local Promise = require(script.Parent.Promise)
local DebugStrings = require(script.Parent.Parent.Strings)
local TypeCheck = require(script.Parent.TypeCheck)

local TaskDistributor = {}
TaskDistributor.__index = TaskDistributor

--[=[
    Constructs a new TaskDistributor class
]=]
function TaskDistributor.new()
	return setmetatable({
		ProcessingChunks = false,
		Processed = 0,
		ProcessedMax = 0,

		_Distributors = {},
	}, TaskDistributor)
end

--[=[
    Creates chunks based on the data
    The size of the chunks can be configured with chunkSize

    Instead of adding the chunks to a queue it will return it instead

    @param {array} data - data that should get split up into smaller chunks
    @param {number} chunkSize - amount of objects a chunk can have
    @yields
]=]
function TaskDistributor.GenerateChunk<T>(data: { T }, chunkSize: number): CachedChunk
	TypeCheck.Is("data", data, "table")
	TypeCheck.Is("chunkSize", chunkSize, "number")

	local dataChunk = {}
	local iteration = 1
	local chunkIteration = 1

	dataChunk[chunkIteration] = {}

	for _, objectData in data do
		if iteration > chunkSize then
			chunkIteration += 1
			iteration = 1
			dataChunk[chunkIteration] = {}
		end

		dataChunk[chunkIteration][iteration] = objectData

		iteration += 1
	end

	return {
		Chunk = dataChunk,
		DataSize = #data,
	}
end

--[=[
    Loops trough the `chunkData` to assign each chunk it's own `Promise` for asynchronous behaviour.
	Using the `processor` callback, tasks can be done efficiently and asynchronously.

    ```lua
    local Rethink = require(game:GetService("ReplicatedStorage").RethinkEngine)
    local TaskDistributor = require(Rethink.Components.Library.TaskDistributor)
    
    local folderDistributor = TaskDistributor.new()

    local function CreateFolders(amount: number)
        local folders = {}

        for i = 1, amount, 1 do
            local folderInstance = Instance.new("Folder")
            folderInstance.Parent = Lighting
            table.insert(folders, folderInstance)
        end

        return folders
    end

    local folderChunks = TaskDistributor.GenerateChunk(CreateFolders(1000), 50)

    folderDistributor:Distribute(folderChunks, function(object)
        object.Name = "Hello, world!"
        object.Parent = workspace
    end)
    ```

    @param {CachedChunk} chunkData
    @param {function} processor
    @yields
    @returns {Promise}
]=]
function TaskDistributor:Distribute<T>(chunkData: { T }, processor: (T) -> nil): PromiseClass
	if self.ProcessingChunks == true then
		return warn(DebugStrings.TaskDistributor.AlreadyProcessing)
	end

	TypeCheck.Is("chunkData", chunkData, "table")
	TypeCheck.Is("processor", processor, "function")

	-- Distribute the work of compiling objects into asynchronous functions
	local cachedChunk: CachedChunk = chunkData
	self.ProcessingChunks = true
	self.Processed = 0
	self.ProcessedMax = cachedChunk.DataSize
	self._Distributors = {}

	for _, chunk in ipairs(cachedChunk.Chunk) do
		-- Create a new Promise and immediately insert it into the Distributors table
		self._Distributors[#self._Distributors + 1] = Promise.new(function(resolve)
			for _, chunkObject: any in ipairs(chunk) do
				-- Call the processor function that takes in a chunk object as an argument
				processor(chunkObject)

				self.Processed += 1

				task.wait()
			end

			resolve()
		end):catch(warn)
	end

	return Promise.all(self._Distributors)
		:andThen(function()
			-- After all of the Promises successfully resolved, set the ProcessingChunks to false
			self.ProcessingChunks = false
		end)
		:catch(warn)
end

--[=[
    Cancels the processing of the set of chunks

    ```lua
    local Rethink = require(game:GetService("ReplicatedStorage").RethinkEngine)
    local TaskDistributor = require(Rethink.Components.Library.TaskDistributor)
    
    local folderDistributor = TaskDistributor.new()

    local function CreateFolders(amount: number)
        local folders = {}

        for i = 1, amount, 1 do
            local folderInstance = Instance.new("Folder")
            folderInstance.Parent = Lighting
            table.insert(folders, folderInstance)
        end

        return folders
    end

    local folderChunks = folderDistributor.GenerateChunk(CreateFolders(1000), 50)

    folderDistributor:Distribute(folderChunks, function(object)
        object.Name = "Hello, world!"
        object.Parent = workspace
    end)

    task.wait(1)

    -- Will stop the execution resulting in the
    -- folders not getting renamed and moved to the workspace
    folderDistributor:Cancel()
    ```
]=]
function TaskDistributor:Cancel()
	-- Make sure we don't try to loop over an empty table
	for _, promise: PromiseClass in ipairs(self._Distributors) do
		promise:cancel()
	end

	table.clear(self._Distributors)

	self.ProcessingChunks = false
	self.Processed = 0
	self.ProcessedMax = 0
end

function TaskDistributor:Destroy()
	self:Cancel()
	table.clear(self)
	setmetatable(self, nil)
end

return TaskDistributor
