--[=[
	Simple object pool implementation for Rethink.
	This means that this module is not viable anywhere else without some editing.

	This implementation supports multiple objects being in the pool, by indexing the pool by it's classname.
]=]

type PoolObject = {
	Object: any,
	BusyRegistry: number,
}

local Rethink = script.Parent.Parent.Parent

local DefaultSettings = require(Rethink.Tools.Core.Scene.DefaultProperties)
local Signal = require(script.Parent.Signal)
local DebugStrings = require(Rethink.Components.Debug.Strings)

local function ResetProperties(object: Instance)
	for propertyName, propertyValue in pairs(DefaultSettings[object.ClassName]) do
		object[propertyName] = propertyValue
	end

	return object
end

local function CreateInstance(self: { [string]: any }, objectType: string)
	local poolObject = ResetProperties(Instance.new(objectType))
	poolObject.Parent = self.ObjectContainer

	return {
		Object = poolObject,
		BusyRegistry = 0,
	}
end

local function PopulatePool(self: { [string]: any }, objectList: { [string]: number }): { PoolObject }
	local objects = {}

	for objectType, amount in pairs(objectList) do
		objects[objectType] = {}

		for _ = 1, amount do
			objects[objectType][#objects[objectType] + 1] = CreateInstance(self, objectType)
		end
	end

	return objects
end

local function CreateContainer()
	local folder = Instance.new("Folder")
	folder.Name = "ObjectPool-ObjectContainer"
	folder.Parent = game:GetService("RunService"):IsStudio() and workspace or nil

	return folder
end

local ObjectPool = {}
ObjectPool.__index = ObjectPool

function ObjectPool.new(objectList)
	local self = setmetatable({}, ObjectPool)

	self.ObjectContainer = CreateContainer()
	self.Objects = PopulatePool(self, objectList)
	self.ObjectLookup = {}
	self.AvailableObjects = self.Objects
	self.BusyObjects = {}

	-- Events
	self.ObjectReturned = Signal.new()

	-- Populate object lookup
	for _, objectType: { [number]: PoolObject } in pairs(self.Objects) do
		for _, object in ipairs(objectType) do
			self.ObjectLookup[object.Object] = object.BusyRegistry
		end
	end

	return self
end

function ObjectPool:Get(type: string)
	local object: PoolObject = self.AvailableObjects[type][#self.AvailableObjects[type]]

	if object then
		object.BusyRegistry = #self.BusyObjects + 1

		self.AvailableObjects[type][#self.AvailableObjects[type]] = nil
		self.BusyObjects[object.BusyRegistry] = object

		return object.Object
	end

	for _ = 1, 10 do
		local newObject = CreateInstance(self, type)

		self.Objects[type][#self.Objects[type] + 1] = newObject
		self.ObjectLookup[newObject.Object] = newObject.BusyRegistry
	end

	return self:Get(type)
end

function ObjectPool:Return(object)
	-- Return the object to the pool
	local objectIndex = self.ObjectLookup[object]

	if objectIndex then
		object.Parent = self.ObjectContainer

		-- Reset the object's properties to default
		ResetProperties(object)

		self.BusyObjects[objectIndex] = nil
		self.AvailableObjects[object.ClassName][#self.AvailableObjects[object.ClassName] + 1] =
			self.Objects[self.ObjectLookup[object]]

		self.ObjectReturned:Fire()

		return
	end

	return error((DebugStrings.ObjectPoolReturnFail):format(tostring(object)))
end

function ObjectPool:Destroy()
	-- Return all objects
	for _, object in ipairs(self.BusyObjects) do
		self:Return(object)
	end

	-- Destroy the container, and every object with it
	self.ObjectContainer:Destroy()

	table.clear(self.AvailableObjects)
	table.clear(self.BusyObjects)
	table.clear(self.ObjectLookup)
	setmetatable(self, nil)
end

return ObjectPool
