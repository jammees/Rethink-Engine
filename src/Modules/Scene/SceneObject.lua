local HTTPService = game:GetService("HttpService")

local Janitor = require(script.Parent.Parent.Parent.Vendors.Janitor)
local Log = require(script.Parent.Parent.Parent.Library.Log)
local t = require(script.Parent.Parent.Parent.Vendors.t)
local RigidBody = require(script.Parent.Parent.Nature2D.Physics.RigidBody)
local Template = require(script.Parent.Parent.Template)
local Value = require(script.Parent.Symbols.Handlers.ValueSymbol.Value)

local SceneObject = {}
SceneObject.__index = SceneObject

SceneObject.Interface = t.strictInterface({
	Object = t.union(t.Instance, t.table),
	Janitor = t.table,
	SymbolJanitor = t.table,
	ID = t.string,
	IsRigidbody = t.boolean,
	Symbols = t.interface({
		IDs = t.optional(t.table),
		Permanent = t.optional(t.boolean),
		LinkIDs = t.optional(t.table),
	}),
})

function SceneObject.new(object)
	local Scene = require(script.Parent)

	local self = {}

	self.Object = object
	self.Janitor = Janitor.new()
	self.SymbolJanitor = Janitor.new()
	self.ID = HTTPService:GenerateGUID(false)
	self.IsRigidbody = getmetatable(typeof(object) == "table" and object or nil) == RigidBody
	self.Symbols = {}

	-- Add cleanup function
	self.Janitor:Add(self.SymbolJanitor, "Destroy", "SymbolJanitor")
	self.Janitor:Add(function()
		Scene.Events.ObjectRemoved:Fire(self.Object)

		if self.IsRigidbody then
			self.Object:Destroy()
		else
			Template.FetchGlobal("__Rethink_Pool"):Return(self.Object)
		end

		Scene.GetObjects()[self.ID] = nil
		setmetatable(self, nil)
		table.clear(self)
	end, true, self.ID)

	return setmetatable(self, SceneObject)
end

function SceneObject:GetInstance()
	return self.IsRigidbody and self.Object:GetFrame() or self.Object
end

function SceneObject:GetValue(valueName: string): Value.Value
	Log.TAssert(t.string(valueName))

	if t.none(self.Symbols.Values) then
		return nil
	end

	return self.Symbols.Values[valueName]
end

function SceneObject:CleanUp()
	self.Janitor:Destroy()
end

export type SceneObject = typeof(SceneObject.new())

return SceneObject
