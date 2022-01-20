--[[

    Scene

    API:

    scene:Load(data: table)
    scene:GetName() -> returns the current level's name
    scene:Flush()   -> deletes the level
    scene:Add(object: Instance, tags: table) -> deletes that object when scene.flush() is called and gives the object tags based on the "tags" table
	scene:GetRigidbodyFromTag(tag: string) -> returns a rigidbody that matches with that tag
	scene:GetRigidbodiesFromTag(tag: string) -> returns all of the rigidbody classes that got tagged
	
	V: 0.5.4

	Cleaned up Scene
	Uses now metatables
	Uses now Luau for typechecking

]]

local CollectionService = game:GetService("CollectionService")

local package = script.Parent.Parent
local components = package.Components
local tools = package.Tools
local Physics = tools.Physics

--// get modules
local signal = require(components.Signal)
local wrapper = require(components.Wrapper)
local rigidBody = require(Physics.Physics.RigidBody)

-- gui object reference table for later deleting them
local sceneObjects = {}
local sceneName = "No loaded scene"

local scene = wrapper.wrap() -- This is used to give Scene some functions, instances that was created by the main module.

-- define signals
scene.Events = {
	loadStarted = signal.new(),
	loadFinished = signal.new(),
	flushStarted = signal.new(),
	flushFinished = signal.new(),
}

-- wrapped variables
local layer = scene.Layer
local canvas = scene.Canvas
local engine = scene.Engine

-- private funstions

local function addTagToInstance(instance: Instance, tags: { [number]: string })
	if tags == nil or tags ~= nil and #tags == 0 then
		return
	end

	if typeof(tags) == "table" then
		for _, tag in ipairs(tags) do
			CollectionService:AddTag(instance, tag)
		end
	else
		CollectionService:AddTag(instance, tags)
	end
end

local function addToHolder(value: Instance)
	sceneObjects[#sceneObjects + 1] = value
end

local function reconstructInstance(data: { [any]: any }, parent: Instance, name: string): Instance
	local obj = Instance.new(data.Class or "Frame")
	for property, value in pairs(data) do
		pcall(function()
			obj[property] = value
		end)
	end
	obj.Name = name

	-- add tags to the object if there is a table called Tags and it has actual strings
	addTagToInstance(obj, data.Tags or data.Tag)

	data.Tags = nil -- clear the tags table so it can be garbage collected and Nature2D wont yell that there is a property that shouldn't be there
	obj.Parent = parent

	return obj
end

-- public functions

function scene:Load(sceneTable: { [string]: any })
	local info = sceneTable.Data or {}
	local layers = sceneTable.Layers or {}
	local rigids = sceneTable.Rigidbodies or {}

	sceneName = info.Name or "Unnamed scene"

	scene.Events.loadStarted:Fire()

	-- load in the layers
	for index, group in pairs(layers) do
		for name, data in pairs(group) do
			data.ZIndex = 0 - tonumber(index)
			addToHolder(reconstructInstance(data, layer, name))
		end
	end

	-- load in the rigid bodies
	for name, arrayData in pairs(rigids) do
		for objName, data in pairs(arrayData) do
			-- check if its a hitbox, if so anchor it
			if name == "Static" then
				data["Anchored"] = true
			end

			local newObject = reconstructInstance(data, canvas, objName)

			addToHolder(engine:Create("RigidBody", {
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
			}))
		end
	end

	scene.Events.loadFinished:Fire()
end

function scene:Add(object: Instance, tags: { [number]: string } | string)
	if #sceneObjects == 0 then
		return
	end
	addTagToInstance(object, tags)
	addToHolder(object)
end

-- V: 0.5.2 - Cleaned up this function
function scene:Flush()
	if #sceneObjects == 0 then
		return warn("[Scene] Cannot flush empty scene!")
	end

	scene.Events.flushStarted:Fire()

	for _, data in ipairs(sceneObjects) do
		data:Destroy()
	end
	sceneName = "No loaded scene"

	scene.Events.flushFinished:Fire()
end

-- Some getter functions
function scene:GetName(): string
	return sceneName
end

function scene:GetObjects(): { [number]: any }
	return sceneObjects
end

-- V: 0.5.3
-- These 2 functions are very similar, however the key difference between these is that one returns a table and the other one returns a table full of tables.

function scene:GetRigidbodyFromTag(tag: string): { [number]: Instance | { [any]: any } }
	local rigidbodyFrames = CollectionService:GetTagged(tag)

	for _, frame in ipairs(rigidbodyFrames) do
		for _, sceneObject in pairs(sceneObjects) do
			if rigidBody.IsRigidbody(sceneObject) then
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

function scene:GetRigidbodiesFromTag(tag: string): { [number]: any }
	local rigidbodyFrames = CollectionService:GetTagged(tag)
	local returnedInstances = {}

	for _, frame in ipairs(rigidbodyFrames) do
		for _, sceneObject in pairs(sceneObjects) do
			if rigidBody.IsRigidbody(sceneObject) then
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

return scene
