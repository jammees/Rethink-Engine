--[=[
	Simple object pool implementation.

	This implementation supports multiple objects being in the pool, by indexing the pool by it's classname.
]=]

local HttpService = game:GetService("HttpService")

local package = script.Parent.Parent.Parent
local Settings = require(package.Settings)
local Signal = require(script.Parent.Signal)

local function PopulatePool(self, objectList)
	local objects = {}

	for objectType, amount in pairs(objectList) do
		objects[objectType] = {}

		for _ = 1, amount do
			local poolObject = Instance.new(objectType)
			poolObject.Parent = self.ObjectContainer

			table.insert(objects[objectType], poolObject)
		end
	end

	return objects
end

local function CreateContainer()
	local folder = Instance.new("Folder")
	folder.Name = HttpService:GenerateGUID(false)
	folder.Parent = script

	return folder
end

local ObjectPool = {}
ObjectPool.__index = ObjectPool

function ObjectPool.new(objectList)
	local self = setmetatable({}, ObjectPool)

	self.ObjectContainer = CreateContainer()
	self.Objects = PopulatePool(self, objectList)
	self.BusyObjects = {}

	self.ObjectReturned = Signal.new()

	return self
end

function ObjectPool:Get(type: string)
	-- Check if there is an available object in the pool
	local object = self.Objects[type][1]

	if object then
		-- Remove the object from the pool
		table.remove(self.Objects[type], 1)
		self.BusyObjects[#self.BusyObjects + 1] = object

		return object
	else
		-- Create a new object if the pool is empty
		for _ = 1, Settings.Pool.ExtensionSize do
			table.insert(self.Objects[type], Instance.new(type))
		end

		return self:Get(type)
	end
end

function ObjectPool:Return(object)
	-- Return the object to the pool
	local objectIndex = table.find(self.BusyObjects, object)
	
	if objectIndex then
		object.Parent = self.ObjectContainer
		
		table.remove(self.BusyObjects, objectIndex)
		self.Objects[object.ClassName][#self.Objects[object.ClassName] + 1] = object
		
		self.ObjectReturned:Fire(object)
	end
end

function ObjectPool:Destroy()
	-- Return all objects
	for _, object in ipairs(self.BusyObjects) do
		self:Return(object)
	end

	-- Destroy the container, and every object with it
	self.ObjectContainer:Destroy()
end

return ObjectPool
