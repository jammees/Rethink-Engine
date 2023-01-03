local HttpService = game:GetService("HttpService")

local package = script.Parent.Parent.Parent
local Settings = require(package.Settings)
local DefaultProperties = require(package.Tools.Core.Scene.DefaultProperties)
local Signal = require(script.Parent.Signal)

local function ApplyProperties(object: Instance)
	for propertyName, propertyValue in pairs(DefaultProperties[object.ClassName]) do
		object[propertyName] = propertyValue
	end

	return object
end

local function PopulatePool(self)
	local objects = {}

	for objectType, amount in pairs(Settings.Pool.InitialCache) do
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

function ObjectPool.new()
	local self = setmetatable({}, ObjectPool)

	self.ObjectContainer = CreateContainer()
	self.Objects = PopulatePool(self)
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
		table.insert(self.BusyObjects, object)

		return object
	else
		-- Create a new object if the pool is empty
		for _ = 1, Settings.Pool.ExtensionSize do
			table.insert(self.Objects[type], ApplyProperties(Instance.new(type)))
		end

		return self:Get(type)
	end
end

function ObjectPool:Return(object)
	-- Return the object to the pool
	local objectIndex = table.find(self.BusyObjects, object)

	if objectIndex then
		object.Parent = self.ObjectContainer

		table.insert(self.Objects[object.ClassName], object)
		table.remove(self.BusyObjects, objectIndex)

		self.ObjectReturned:Fire(object)
	end
end

function ObjectPool:Destroy()
	-- Return all objects
	for _, object in ipairs(self.BusyObjects) do
		self:Return(object)
	end

	-- Destroy every object
	for _, object in ipairs(self.Objects) do
		object:Destroy()
	end
end

return ObjectPool
