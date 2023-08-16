local Types = require(script.Parent.Types)

type SceneConfig = {
	Name: string?,
	CompileMode: string?,
}

type AttachedSymbolsHolder = { [any]: () -> nil? }

type ChunkObject = {
	ObjectIdentifier: string?,
	ObjectData: { any },
	GroupData: { any },
	SavedProperties: { any },
	ObjectType: string,
	SymbolsAttached: AttachedSymbolsHolder,
}

local ContentProvider = game:GetService("ContentProvider")

local Promise = require(script.Parent.Parent.Parent.Vendors.Promise)
local Symbols = require(script.Parent.Symbols)
local Log = require(script.Parent.Parent.Parent.Library.Log)

local CompilerObjects = {
	Rigidbody = require(script.Parent.Objects.Rigidbody),
	UIBase = require(script.Parent.Objects.UIBase),
}

local sceneCaches = {}
local scenePointers = {}

local Compiler = {}

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
					if Symbols.IsSymbol(propertyName) then
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
		-- if objectData.Properties.Class then
		-- 	objectData.ObjectClass = objectData.Properties.Class
		-- 	objectData.Properties.Class = nil
		-- end

		local classSymbol, attachedValue = Symbols.FindSymbol(objectData.Symbols, "Class")

		if classSymbol then
			objectData.ObjectClass = attachedValue
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
			if Symbols.IsSymbol(objectName) then
				continue
			end

			table.insert(chunkObjects, ProcessAndMerge(object, savedProperties, objectType, objectName))
		end
	end

	return chunkObjects
end

function Compiler.CacheScene(sceneData: { [string]: any })
	-- local sceneChunk = TaskDistributor.GenerateChunk(Compiler.MapSceneData(sceneData), Settings.CompilerChunkSize)
	local sceneChunk = Compiler.MapSceneData(sceneData)

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
function Compiler.Compile(sceneData: { [string]: any }): Types.Promise
	local Scene = require(script.Parent)

	return Promise.new(function(resolve)
		for _, object: Types.Prototype_ChunkObject in Compiler.GetScene(sceneData) do
			Promise.try(function()
				-- Default to UIBase if it is not present
				if object.ObjectType == nil then
					object.ObjectType = "UIBase"
					Log.Warn(`{object}.ObjectType not found, defaulted to UIBase!`)
				end

				return CompilerObjects[object.ObjectType](object)
			end)
				:andThen(function(cObject: GuiBase2d | Types.Rigidbody)
					Promise.async(function()
						ContentProvider:PreloadAsync({
							if Scene.IsRigidbody(cObject) then cObject:GetFrame() else cObject,
						})
					end)

					Scene.Add(cObject, object.Symbols)
				end)
				:catch(Log.Warn)
				:await()
		end

		resolve()
	end):catch(Log.Warn)
end

-- function Compiler.CompileV2<DATA>(sceneData: { DATA }): Types.Promise
-- 	local Scene = require(script.Parent)

-- 	local function GetChildrenSymbols(symbols: { [Types.Symbol]: any })
-- 		local children = {}

-- 		for symbolIndex, symbolValue in symbols do
-- 			if not (symbolIndex.Name == "Children") then
-- 				continue
-- 			end

-- 			table.insert(children, symbolValue)
-- 		end

-- 		return children
-- 	end

-- 	local function CompileChildren(children, parent)
-- 		print(children, parent)

-- 		local mappedData = Compiler.MapSceneData(children)
-- 		warn(mappedData)

-- 		for _, object in mappedData do
-- 			object.ObjectType = "UIBase"

-- 			local cObject = CompilerObjects[object.ObjectType](object)
-- 			cObject.Parent = parent

-- 			Scene.Add(cObject, object.Symbols)

-- 			local childrenSymbols = GetChildrenSymbols(object.Symbols)

-- 			if childrenSymbols then
-- 				CompileChildren(childrenSymbols, cObject)
-- 			end
-- 		end
-- 	end

-- 	return Promise.new(function(resolve)
-- 		TaskDistributor:Distribute(Compiler.GetScene(sceneData), function(object: Types.Prototype_ChunkObject)
-- 			Promise.try(function()
-- 				-- Default to UIBase if it is not present
-- 				if object.ObjectType == nil then
-- 					object.ObjectType = "UIBase"
-- 					warn(`[Compiler] {object}.ObjectType not found, defaulted to UIBase!`)
-- 				end

-- 				local cObject = CompilerObjects[object.ObjectType](object)

-- 				local childrenSymbols = GetChildrenSymbols(object.Symbols)

-- 				if childrenSymbols then
-- 					CompileChildren(childrenSymbols, cObject)
-- 				end

-- 				return cObject
-- 			end)
-- 				:andThen(function(cObject: GuiBase2d | Types.Rigidbody)
-- 					ContentProvider:PreloadAsync({ typeof(cObject) == "table" and cObject.frame or cObject })

-- 					Scene.Add(cObject, object.Symbols)
-- 				end)
-- 				:catch(warn)
-- 				:await()
-- 		end):await()

-- 		resolve()
-- 	end):catch(warn)
-- end

return Compiler
