-- Rewrite of ObjectPool
-- This rewrite aims to be less confusing and easier to use.
type ObjectData = {
	Object: Instance,
	ID: string,
}

local HTTPService = game:GetService("HttpService")
local CollectionService = game:GetService("CollectionService")

local Settings = require(script.Parent.Parent.Settings)
local DefaultSettings = require(script.Parent.Parent.Modules.Scene.DefaultProperties)

local function ResetProperties(object: Instance)
	for propertyName, propertyValue in DefaultSettings[object.ClassName] do
		object[propertyName] = propertyValue
	end

	-- Remove tags
	for _, tag in CollectionService:GetTags(object) do
		CollectionService:RemoveTag(object, tag)
	end

	-- Remove attributes
	for attributeName in object:GetAttributes() do
		object:SetAttribute(attributeName, nil)
	end

	return object
end

local function CreateContainer()
	local folder = Instance.new("Folder")
	folder.Name = "ObjectPool-ObjectContainer"
	folder.Parent = script

	return folder
end

---@class PoolClass
local PoolClass = {}
PoolClass.__index = PoolClass

function PoolClass.new(kind: string, starterAmount: number)
	local self = setmetatable({}, PoolClass)

	self.Container = CreateContainer()
	self.Kind = kind
	self.StarterAmount = starterAmount
	self.Objects = {}
	self.Available = {}
	self.Busy = {}

	for _ = 1, starterAmount do
		self:CreatePoolObject()
	end

	return self
end

---Creates a new pool object
---@within PoolClass
---@return table
function PoolClass:CreatePoolObject()
	local poolObject = Instance.new(self.Kind)
	poolObject.Parent = self.Container

	ResetProperties(poolObject)

	local data = {
		Object = poolObject,
		ID = HTTPService:GenerateGUID(false),
	}

	self.Objects[data.ID] = data
	self.Available[#self.Available + 1] = data.ID

	return data
end

---Returns an object from the pool
---@within PoolClass
---@return any
function PoolClass:Get()
	local objectID = self.Available[1]

	if objectID == nil then
		for _ = 1, Settings.Pool.ExtensionSize do
			self:CreatePoolObject()
		end

		return self:Get()
	end

	self.Busy[#self.Busy + 1] = objectID
	table.remove(self.Available, table.find(self.Available, objectID))

	return self.Objects[objectID].Object
end

---Returns the object to the pool
---@within PoolClass
---@param object any
function PoolClass:Return(object: Instance)
	for _, objectID in self.Busy do
		if not self.Objects[objectID].Object == object then
			continue
		end

		self.Available[#self.Available + 1] = objectID
		table.remove(self.Busy, table.find(self.Busy, objectID))

		local poolObject = self.Objects[objectID].Object
		poolObject.Parent = self.Container
		ResetProperties(poolObject)

		return
	end
end

---Retires the object from the pool
---@within PoolClass
---@param object Instance
function PoolClass:Retire(object: Instance)
	for index, objectID in self.Busy do
		local poolReference = self.Objects[objectID]

		if not (poolReference.Object == object) then
			continue
		end

		table.remove(self.Busy, index)
		self.Objects[objectID] = nil
	end
end

local ObjectPool = {}
ObjectPool.__index = ObjectPool
ObjectPool.Class = PoolClass

---@class ObjectPool
function ObjectPool.new(objectList: { [string]: number })
	local poolClasses = {}

	for kind, amount in objectList do
		poolClasses[kind] = PoolClass.new(kind, amount)
	end

	return setmetatable({
		PoolClasses = poolClasses,
	}, ObjectPool)
end

---Returns an object from a pool, which handles the specified kind
---@within PoolClass
---@param kind string
---@return any
function ObjectPool:Get(kind: string)
	return self.PoolClasses[kind]:Get()
end

---Returns an object to the pool, which handles the specified object
---@within PoolClass
---@param object any
function ObjectPool:Return(object: any)
	self.PoolClasses[object.ClassName]:Return(object)
end

---Retires the object from the pool, which handles the specified object
---@within PoolClass
---@param object any
function ObjectPool:Retire(object: any)
	self.PoolClasses[object.ClassName]:Retire(object)
end

return ObjectPool
