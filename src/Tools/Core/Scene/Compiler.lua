type SceneConfig = {
	Name: string?,
	CompileMode: string?,
}

type AttachedSymbolsHolder = {
	Event: () -> nil?
}

type ChunkObject = {
	ObjectIdentifier: string?,
	ObjectData: { any },
	GroupData: { any },
	SavedProperties: { any },
	ObjectType: string,
	SymbolsAttached: AttachedSymbolsHolder,
}

type PackedSymbol = {
	Symbol: {
		Type: string,
		Name: string,
		Data: { any }?
	},
	Value: any
}

local ALIAS_OBJECTS_NAMES = {
	Layer = "UiBase",
	Static = "UiBase",
	Dynamic = "Rigidbody",

	-- Base 
	Rigidbody = "Rigidbody",
	UiBase = "UiBase",
}

local package = script.Parent.Parent.Parent.Parent
local objects = script.Parent.Objects
local components = package.Components

local Promise = require(components.Library.Promise)
local Symbols = require(script.Parent.Symbols)
local TaskDistributor = require(components.Library.TaskDistributor).new()
local Settings = require(package.Settings)

local CompilerObjects = {
	Rigidbody = require(objects.Rigidbody),
	UiBase = require(objects.UiBase),
}

local Compiler = {}
Compiler.CompilerDistributor = TaskDistributor

local function PackSymbol(symbol, value)
	if typeof(symbol) == "nil" then
		return nil
	end

	return {
		Symbol = symbol,
		Value = value
	}
end

local function IsSymbol(tableIndex: any): boolean
	if typeof(tableIndex) == "table" and tableIndex.Name ~= nil then
		return true
	end

	return false
end

local function BACKUP_MergeSceneData(sceneData: { [ number ]: any }): { [number]: ChunkObject }
	local mappedData = {}
	local savedProperties = {}
	local objectType = nil

	for _, sceneCategory in pairs(sceneData) do
		-- Check if we can find a table with a [property] symbol attacjed
		-- As well as find the type of the category
		savedProperties = select(2, Symbols.FindSymbol(sceneCategory, "Property"))
		objectType = select(2, Symbols.FindSymbol(sceneCategory, "Type"))

		for groupKey, groupData in pairs(sceneCategory) do
			if typeof(groupData) ~= "table" or typeof(groupKey) == "table" and Symbols.Types[groupKey.Name] ~= nil then
				continue
			end

			for objectKey, objectData in pairs(groupData) do
				if typeof(objectKey) == "table" and Symbols.Types[objectKey.Name] ~= nil then
					continue
				end

				-- Handle symbols
				local SymbolsAttached: AttachedSymbolsHolder = {}

				-- Loop over the attachable symbols
				-- This is here to automate this process, so every time I would add a new attachable symbol
				-- I would not have to go here and edit this
				for symbolName, _ in pairs(Symbols.AttachableSymbols) do
					SymbolsAttached[symbolName] = PackSymbol(Symbols.FindSymbol(objectData, "Event"))
				end

				-- Save every necessary informations into a single table
				-- So TaskDistributor has access to every piece of data that is required to construct an object
				table.insert(mappedData, {
					ObjectIdentifier = objectKey,
					ObjectData = objectData,
					GroupData = groupData,
					SavedProperties = savedProperties,
					ObjectType = objectType,
					SymbolsAttached = SymbolsAttached
				})
			end
		end
	end

	return mappedData
end

local function MergeSceneData(sceneData: { [ number ]: any }): { [number]: ChunkObject }
	local mappedData = {}
	local savedProperties = {}
	local objectType = nil

	for _, sceneCategory in pairs(sceneData) do
		-- Check if we can find a table with a [property] symbol attacjed
		-- As well as find the type of the category
		savedProperties = select(2, Symbols.FindSymbol(sceneCategory, "Property"))
		objectType = select(2, Symbols.FindSymbol(sceneCategory, "Type"))

		for groupKey, groupData in pairs(sceneCategory) do
			if IsSymbol(groupKey) then
				continue
			end

			for objectKey, objectData in pairs(groupData) do
				if IsSymbol(objectKey) then
					continue
				end

				-- Handle symbols
				local SymbolsAttached: AttachedSymbolsHolder = {}

				-- Loop over the attachable symbols
				-- This is here to automate this process, so every time I would add a new attachable symbol
				-- I would not have to go here and edit this
				for symbolName, _ in pairs(Symbols.AttachableSymbols) do
					SymbolsAttached[symbolName] = PackSymbol(Symbols.FindSymbol(objectData, "Event"))
				end

				-- Save every necessary informations into a single table
				-- So TaskDistributor has access to every piece of data that is required to construct an object
				table.insert(mappedData, {
					ObjectIdentifier = objectKey,
					ObjectData = objectData,
					GroupData = groupData,
					SavedProperties = savedProperties,
					ObjectType = objectType,
					SymbolsAttached = SymbolsAttached
				})
			end
		end
	end

	return mappedData
end

function Compiler.Compile(sceneData: { any }): { [number]: Instance }
	local compiledObjects = {}

	-- New and improved compiling method
	-- In this method TaskDistributor is being used, that is a simple utility module
	-- that is great for processing large amounts of data by utilizing Promises
	-- this is kind of like using task.synchronize I think
	return Promise.new(function(resolve)
		TaskDistributor:Distribute(TaskDistributor.GenerateChunk(MergeSceneData(sceneData), Settings.CompilerChunkSize), function(object: ChunkObject)
			-- Compile the object			
			local compiledObject = CompilerObjects[ALIAS_OBJECTS_NAMES[object.ObjectType]]({ 
				Index = object.ObjectIdentifier,
				Data = object.ObjectData,
			}, object.GroupData, object.SavedProperties)

			-- Try to attach symbols defined in the `object.SymbolsAttached` table
			-- This needs to happen in this time, because when these actually get groupped together,
			-- the object does not exist yet
			Symbols.AttachToInstance(compiledObject, object.SymbolsAttached)

			table.insert(compiledObjects, compiledObject)
		end):await()

		resolve(compiledObjects)
	end):catch(warn)
end

return Compiler
