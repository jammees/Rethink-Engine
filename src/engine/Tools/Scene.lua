--[[

    Scene
	Last updated: 13/03/2022

    API:

    scene:Load(data: table)
	scene:NewLoad(data: table) 
    scene:GetName() -> returns the currently compiled scene's name
    scene:Flush()   -> deletes the scene
    scene:Add(object: Instance, tags: table) -> deletes that object when scene.flush() is called and gives the object tags based on the "tags" table
	scene:GetRigidbodyFromTag(tag: string) -> returns a rigidbody that matches with that tag
	scene:GetRigidbodiesFromTag(tag: string) -> returns all of the rigidbodies that matches with that tag

]]

local CollectionService = game:GetService("CollectionService")
local HttpService = game:GetService("HttpService")

local package = script.Parent.Parent
local components = package.Components
local tools = package.Tools
local physics = tools.Physics

-- get some modules
local signal = require(components.Signal)
local wrapper = require(components.Wrapper)
local janitor = require(components.Janitor)
local rigidBody = require(physics.Physics.RigidBody)

-- gui object reference table for later deleting them
local sceneObjects = {}
local sceneName = nil

local Scene = wrapper.Wrap() -- This is used to give Scene some functions, instances that was created by the main module.

-- [!] scene.janitor

-- define signals
Scene.Events = {
	loadStarted = signal.new(),
	loadFinished = signal.new(),
	flushStarted = signal.new(),
	flushFinished = signal.new(),
}

-- create a janitor class
Scene._janitor = janitor.new()

-- wrapped variables
local layer = Scene.Layer
local canvas = Scene.Canvas
local engine = Scene.Engine

-- private functions

local function addTagToInstance(instance: Instance, tags: { [number]: string } | string?)
	if tags ~= nil then
		if typeof(tags) == "table" then
			for _, tag in ipairs(tags) do
				CollectionService:AddTag(instance, tag)
			end
		else
			CollectionService:AddTag(instance, tags)
		end
	end
end

local function applyProperties(object: GuiBase2d, properties: { [string]: any })
	for propName, propVal in pairs(properties) do
		pcall(function()
			object[propName] = propVal
		end)
	end
end

-- huge list of elseifs, that I'm not proud of
local function applyRigidbodyProperties(rigidbody: any, universalProperties: { any })
	if universalProperties["Mass"] ~= nil then
		rigidbody:SetMass(universalProperties["Mass"])
	elseif universalProperties["Gravity"] ~= nil then
		rigidbody:SetGravity(universalProperties["Gravity"])
	elseif universalProperties["AirFriction"] ~= nil then
		rigidbody:SetAirFriction(universalProperties["AirFriction"])
	elseif universalProperties["Friction"] ~= nil then
		rigidbody:SetFriction(universalProperties["Friction"])
	elseif universalProperties["KeepInCanvas"] ~= nil then
		rigidbody:KeepInCanvas(universalProperties["KeepInCanvas"])
	elseif universalProperties["LifeSpan"] ~= nil then
		rigidbody:SetLifeSpan(universalProperties["LifeSpan"])
	elseif universalProperties["CanRotate"] ~= nil then
		rigidbody:CanRotate(universalProperties["CanRotate"])
	elseif universalProperties["CanCollide"] ~= nil then
		rigidbody:CanCollide(universalProperties["CanCollide"])
	elseif universalProperties["Scale"] ~= nil then
		rigidbody:SetScale(universalProperties["Scale"])
	elseif universalProperties["Size"] ~= nil then
		rigidbody:SetSize(universalProperties["Size"])
	elseif universalProperties["Position"] ~= nil then
		rigidbody:SetPosition(universalProperties["Position"])
	elseif universalProperties["Rotation"] ~= nil then
		rigidbody:Rotate(universalProperties["Eotation"])
	elseif universalProperties["Anchored"] ~= nil then
		if universalProperties["Anchored"] == true then
			rigidbody:Anchor()
		else
			rigidbody:Unanchor()
		end
	end
end

local function reconstructInstance(data: { [any]: any }, parent: Instance, name: string): Instance
	local obj = Instance.new(data.Class or "Frame")
	applyProperties(obj, data)

	-- add tags to the object if there is a table called Tags and it has actual strings
	--addTagToInstance(obj, data.Tags or data.Tag) <- moved to scene:Add()

	--data.Tags = nil -- clear the tags table so it can be garbage collected and Nature2D wont yell that there is a property that shouldn't be there
	obj.Name = name
	obj.Parent = parent

	return obj
end

local function loopTroughTable(parent, toLoop: { any }, self)
	for objName, data in pairs(toLoop) do
		local newObject = reconstructInstance(data, canvas, objName)
		newObject.Parent = parent

		if data.Class == "Rigidbody" then
			self:Add(
				engine:Create("RigidBody", {
					Object = newObject,
					KeepInCanvas = data.KeepInCanvas or true,
					Collidable = data.Collidable or true,
					Anchored = data.Anchored or false,

					Structure = data.Structure,

					Mass = data.Mass,
					LifeSpan = data.LifeSpan,
					Gravity = data.Gravity,
					Friction = data.Friction,
					AirFriction = data.AirFriction,
				}),
				data.Tags or data.Tag
			)
		else
			self:Add(newObject)
		end

		-- recursion
		if data.Children then
			loopTroughTable(newObject, data.Children, self)
		end
	end
end

local function findTableWithType(array, targetType)
	local foundTables = {}
	for _, data in pairs(array) do
		if data["_Config"] then
			if data["_Config"]["Type"] == targetType then
				foundTables[#foundTables + 1] = data
			end
		else
			for _, dataType in pairs(data) do
				if typeof(dataType) == "table" then
					if dataType["_Config"] then
						if dataType["_Config"]["Type"] == targetType then
							foundTables[#foundTables + 1] = dataType
						end
					else
						findTableWithType(dataType, targetType)
					end
				end
			end
		end
	end
	return foundTables
end

local function applyUniversalProperties(object: Instance, rigidbody: any, universalProperties: { [string]: any })
	applyProperties(object, universalProperties)
	applyRigidbodyProperties(rigidbody, universalProperties)

	if universalProperties.Tag or universalProperties.Tags then
		addTagToInstance(object, universalProperties.Tag or universalProperties.Tags)
	end
end

-- public functions

--[[
	A new implementation of loading in a scene from tables. This new implementation let's you name/build the scene's
	hierarchy any way you want. The only exception is that now, you have to provide a _Config table!

	It also let's you create groups, and in the _Config table there can now be an UniversalPorperty! (In groups it's _UniversalProperty)
]]
function Scene:Load(sceneTable: { [string | number]: any })
	local universalProperties = {}
	local layers = findTableWithType(sceneTable, "Layer")
	local rigidbodies = findTableWithType(sceneTable, "Rigidbody")
	local sceneConfig = findTableWithType(sceneTable, "SceneConfig")[1] or {
		Name = "Unnamed scene",
	}

	Scene.Events.loadStarted:Fire()

	-- set the name
	sceneName = sceneConfig.Name

	-- load in all of the layers

	for _, layerGroups in pairs(layers) do
		for layerZIndex, layerDataGroup in pairs(layerGroups) do
			-- make sure to not scan the config

			if layerZIndex == "_Config" then
				if layerDataGroup["UniversalProperty"] ~= nil then
					universalProperties = layerDataGroup["UniversalProperty"]
				end
			end

			if layerZIndex ~= "_Config" then
				for layerName, layerData in pairs(layerDataGroup) do
					if typeof(layerZIndex) == "string" then
						layerData.ZIndex = tonumber(string.split(layerZIndex, ":")[2])
					end

					local reconstructedInstance = reconstructInstance(layerData, layer, layerName)

					if universalProperties ~= nil then
						applyProperties(reconstructedInstance, universalProperties)
					end

					if layerDataGroup["_UniversalProperty"] then
						universalProperties = layerDataGroup["_UniversalProperty"]
						applyProperties(reconstructedInstance, universalProperties)
					end

					self:Add(reconstructedInstance)
				end
			end
		end
	end

	-- load in all of the rigidbodies
	universalProperties = {} -- reset it, to prevent the engine to apply properties that were meant to LAYERS!
	for _, rigidTable in pairs(rigidbodies) do
		for rigidGroupIndex, rigidGroupData in pairs(rigidTable) do
			-- Check if there is a Config, UniversalProperties if so copy it's content
			if rigidTable["_Config"] then
				if rigidGroupData["UniversalProperty"] ~= nil then
					universalProperties = rigidGroupData["UniversalProperty"]
				end
			end

			-- make sure to not scan config
			if rigidGroupIndex ~= "_Config" then
				for rigidName, rigidData in pairs(rigidGroupData) do
					local reconstructedInstance = reconstructInstance(rigidData, canvas, rigidName)
					local newRigidbody = engine:Create("RigidBody", {
						Object = reconstructedInstance,
						KeepInCanvas = rigidData.KeepInCanvas or true,
						Collidable = rigidData.Collidable or true,
						Anchored = rigidData.Anchored or false,

						Structure = rigidData.Structure,
						CanRotate = rigidData.CanRotate,

						Mass = rigidData.Mass,
						LifeSpan = rigidData.LifeSpan,
						Gravity = rigidData.Gravity,
						Friction = rigidData.Friction,
						AirFriction = rigidData.AirFriction,
					})

					if universalProperties ~= nil then
						applyUniversalProperties(reconstructedInstance, newRigidbody, universalProperties)
					end

					if rigidGroupData["_UniversalProperty"] then
						universalProperties = rigidGroupData["_UniversalProperty"]
						applyUniversalProperties(reconstructedInstance, newRigidbody, universalProperties)
					end

					self:Add(newRigidbody, rigidData.Tags or rigidData.Tag)

					if rigidData.Children then
						loopTroughTable(reconstructedInstance, rigidData.Children, self)
					end
				end
			end
		end
	end

	Scene.Events.loadFinished:Fire()
end

--[[
	Can be used to add an instance into the scene, after it has been compiled.
	As an addition, tags can be added to the instance.
]]
function Scene:Add(object: Instance, tags: { [number]: string } | string, destroyAfterFlush: boolean)
	if rigidBody.is(object) then
		local objectInstance = object:GetFrame()
		addTagToInstance(objectInstance, tags)
	else
		addTagToInstance(object, tags)
	end

	local objectId = HttpService:GenerateGUID(false)

	sceneObjects[#sceneObjects + 1] = {
		Object = object,
		Id = objectId,
		DAF = destroyAfterFlush,
	} -- object dictionary for scene:GetRigidobydFromTag() and scene:Remove()

	if destroyAfterFlush == nil or destroyAfterFlush == true then
		self._janitor:Add(object, "Destroy", objectId)
	end
end

--[[
	Can be used to remove an object from the scene dictionary.
	By default it removes it from the janitor too.

	IT DOES NOT DELETE THE OBJECT
]]
function Scene:Remove(object: Instance)
	local objectId = nil

	-- remove it from the scene dictionary
	for index, sceneObject in ipairs(sceneObjects) do
		if sceneObject.Object == object then
			objectId = sceneObject.Id
			table.remove(sceneObjects, index)
		end
	end

	-- remove it from janitor
	self._janitor:RemoveFromSelf(objectId)
end

--[[
	Can be used to clear the currently compiled scene.
	If the scene is empty and the function is called, it will throw a warning and abort.
]]
function Scene:Flush()
	if sceneName == nil then
		return warn("[Scene] Attempted to flush an empty scene! Aborting...")
	end

	Scene.Events.flushStarted:Fire()

	sceneName = nil

	self._janitor:Cleanup()

	for index, sceneObject in ipairs(sceneObjects) do
		if sceneObject.DAF == true or sceneObject.DAF == nil then
			sceneObjects[index] = nil
		end
	end

	Scene.Events.flushFinished:Fire()
end

-- Some getter functions

--[[
	Can be used to retrieve the currently compiled scene's name, specified in the sceneTable.
]]
function Scene:GetName(): string
	return sceneName
end

--[[
	Can be used to retrieve all of the scene objects, that make the currently compiled scene.
]]
function Scene:GetObjects(): { [number]: any }
	return sceneObjects
end

--[[
	Can be used to retrieve a rigidbody, from it's tag.
	The function returns a table, with: {Class: rigidbody metatable, Object: ui instance}
]]
function Scene:GetRigidbodyFromTag(tag: string): { [number]: Instance | { [any]: any } }
	local rigidbodyFrames = CollectionService:GetTagged(tag)

	for _, frame in ipairs(rigidbodyFrames) do
		for _, sceneObject in pairs(sceneObjects) do
			if rigidBody.is(sceneObject) then
				if sceneObject:GetFrame() == frame then
					return {
						Class = sceneObject,
						Object = frame,
					}
				end
			end
		end
	end
end

--[[
	Can be used to retrieve a table full of rigidbodies, from it's tag.
	The function returns a table, with: {Class: rigidbody metatable, Object: ui instance}
--]]
function Scene:GetRigidbodiesFromTag(tag: string): { [number]: any }
	local rigidbodyFrames = CollectionService:GetTagged(tag)
	local returnedInstances = {}

	for _, frame in ipairs(rigidbodyFrames) do
		for _, sceneObject in pairs(sceneObjects) do
			if rigidBody.is(sceneObject) then
				if sceneObject:GetFrame() == frame then
					returnedInstances[frame.Name] = {
						Class = sceneObject,
						Object = frame,
					}
				end
			end
		end
	end

	return returnedInstances
end

return Scene
