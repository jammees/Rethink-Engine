local Types = require(script.Parent.Types)

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

local ContentProvider = game:GetService("ContentProvider")
local HttpService = game:GetService("HttpService")

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

local sceneCaches = {}
local scenePointers = {}

local function IsSymbol(tableIndex: any): boolean
	if typeof(tableIndex) == "table" and tableIndex.Name ~= nil then
		return true
	end

	return false
end

local Compiler = {}

Compiler.CompilerDistributor = TaskDistributor

-- TODO: Reduce size by referencing properties multiple times for objects that have the same properties
function Compiler.MapSceneData<TBL>(sceneData: { TBL }): { Types.Prototype_ChunkObject }
	local chunkObjects = {}
	local savedProperties = {}
	local objectType = nil

	local function ProcessAndMerge(object, saved, type, name): { Types.Prototype_ChunkObject }
		local objectData = {
			Properties = {},
			Symbols = {},
			ObjectType = type,
			ObjectClass = "Frame",
		}

		local function Process<TBL>(propertyTable: { TBL })
			local typeIndex, typeValue = Symbols.FindSymbol(propertyTable, "Type")

			if typeIndex then
				objectData.ObjectType = typeValue
			end

			if propertyTable then
				for propertyName, value in propertyTable do
					if IsSymbol(propertyName) then
						objectData.Symbols[propertyName] = value

						continue
					end

					objectData.Properties[propertyName] = value
				end
			end
		end

		-- Order is very important
		Process(saved)
		Process(object)

		-- Re-allocate the Class property
		if objectData.Properties.Class then
			objectData.ObjectClass = objectData.Properties.Class
			objectData.Properties.Class = nil
		end

		-- Apply index as name if it is not present in the properties table
		if objectData.Properties.Name == nil then
			objectData.Properties.Name = name
		end

		return objectData
	end

	for _, sceneCategory in sceneData do
		if typeof(sceneCategory) ~= "table" then
			continue
		end

		-- Check if we can find a table with a [property] symbol attached
		-- As well as find the type of the category
		savedProperties = select(2, Symbols.FindSymbol(sceneCategory, "Property"))
		objectType = select(2, Symbols.FindSymbol(sceneCategory, "Type"))

		for objectName, object in sceneCategory do
			if IsSymbol(objectName) then
				continue
			end

			table.insert(chunkObjects, ProcessAndMerge(object, savedProperties, objectType, objectName))
		end
	end

	return chunkObjects
end

function Compiler.CacheScene(sceneData: { [string]: any })
	local sceneChunk = TaskDistributor.GenerateChunk(Compiler.MapSceneData(sceneData), Settings.CompilerChunkSize)

	print(`Estimated cache size for {sceneData.Name} is ~{math.floor(#HttpService:JSONEncode(sceneData) / 1024)}KB`)

	local reservedId = #sceneCaches + 1
	sceneCaches[reservedId] = sceneChunk
	scenePointers[sceneData.Name] = reservedId

	return sceneChunk
end

-- Used to get a scene's data
-- If it does not exist, it gets cached for later to skip
-- having to iterate all over the data again
function Compiler.GetScene(sceneData: { [string]: any })
	if scenePointers[sceneData.Name] == nil then
		return Compiler.CacheScene(sceneData)
	end

	return sceneCaches[scenePointers[sceneData.Name]]
end

-- TODO: Add function to compile an object by itself
function Compiler.Prototype_Compile(sceneData: { [string]: any }): Types.Promise
	local compiledObjects = {}

	-- Simplified the data
	return Promise.new(function(resolve)
		TaskDistributor:Distribute(Compiler.GetScene(sceneData), function(object: Types.Prototype_ChunkObject)
			Promise.try(function()
				-- Default to UiBase if it is not present
				if object.ObjectType == nil then
					object.ObjectType = "UiBase"
					warn(`[Compiler] {object}.ObjectType not found, defaulted to UiBase!`)
				end

				return CompilerObjects[ALIAS_OBJECTS_NAMES[object.ObjectType]](object)
			end)
				:andThen(function(cObject: GuiBase2d | Types.Rigidbody)
					ContentProvider:PreloadAsync({ typeof(cObject) == "table" and cObject.frame or cObject })

					table.insert(compiledObjects, {
						Symbols = object.Symbols,
						Object = cObject,
					})
				end)
				:catch(warn)
				:await()
		end):await()

		resolve(compiledObjects)
	end):catch(warn)
end

return Compiler
