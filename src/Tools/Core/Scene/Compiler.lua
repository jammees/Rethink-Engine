type SceneConfig = {
	Name: string?,
	CompileMode: string?,
}

type AttachedSymbolsHolder = { any: () -> nil? }

type ChunkObject = {
	ObjectIdentifier: string?,
	ObjectData: { any },
	GroupData: { any },
	SavedProperties: { any },
	ObjectType: string,
	SymbolsAttached: AttachedSymbolsHolder,
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

local function IsSymbol(tableIndex: any): boolean
	if typeof(tableIndex) == "table" and tableIndex.Name ~= nil then
		return true
	end

	return false
end

local function AddSymbol(container: { any }, symbol, attachedValue)
	if IsSymbol(symbol) == false then
		return
	end

	container[symbol] = attachedValue
end

local function GetSymbols(objectData, groupData, savedProperties): AttachedSymbolsHolder
	local symbolsAttached = {}

	-- Loop over the attachable symbols
	-- This is here to automate this process, so every time I would add a new attachable symbol
	-- I would not have to go here and edit this
	for symbolName, _ in pairs(Symbols.AttachableSymbols) do
		-- Check in three locations for an attachable symbol
		AddSymbol(symbolsAttached, Symbols.FindSymbol(savedProperties, symbolName))
		AddSymbol(symbolsAttached, Symbols.FindSymbol(groupData, symbolName))
		AddSymbol(symbolsAttached, Symbols.FindSymbol(objectData, symbolName))
	end

	return symbolsAttached
end

local Compiler = {}

Compiler.CompilerDistributor = TaskDistributor

function Compiler.MapSceneData(sceneData: { [number]: any }): { [number]: ChunkObject }
	local chunkObjects = {}
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

				-- Save every necessary informations into a single table
				-- So TaskDistributor has access to every piece of data that is required to construct an object
				chunkObjects[#chunkObjects + 1] = {
					ObjectIdentifier = objectKey,
					ObjectData = objectData,
					GroupData = groupData,
					SavedProperties = savedProperties,
					ObjectType = objectType,

					SymbolsAttached = GetSymbols(objectData, groupData, savedProperties),
				}
			end
		end
	end

	return chunkObjects
end

function Compiler.Compile(sceneData: { any }): { [number]: Instance }
	local compiledObjects = {}

	-- New and improved compiling method
	-- In this method TaskDistributor is being used, that is a simple utility module
	-- that is great for processing large amounts of data by utilizing Promises
	-- this is kind of like using task.synchronize I think
	return Promise.new(function(resolve)
		TaskDistributor:Distribute(
			TaskDistributor.GenerateChunk(Compiler.MapSceneData(sceneData), Settings.CompilerChunkSize),
			function(object: ChunkObject)
				-- Compile the object
				compiledObjects[#compiledObjects + 1] = {
					Symbols = object.SymbolsAttached,
					Object = CompilerObjects[ALIAS_OBJECTS_NAMES[object.ObjectType]]({
						Index = object.ObjectIdentifier,
						Data = object.ObjectData,
					}, object.GroupData, object.SavedProperties),
				}
			end
		):await()

		resolve(compiledObjects)
	end):catch(warn)
end

return Compiler
