local HTTPService = game:GetService("HttpService")

local Rigidbody = require(script.Parent.Parent.Parent.Nature2D.Physics.RigidBody)
local Types = require(script.Parent.Parent.Types)
local Log = require(script.Parent.Parent.Parent.Parent.Library.Log)
local t = require(script.Parent.Parent.Parent.Parent.Vendors.t)
local SceneObject = require(script.Parent.Parent.SceneObject)

local Utility = {}

function Utility.IsSymbol(tableIndex: any): boolean
	if typeof(tableIndex) == "table" and tableIndex.Name == "Symbol" then
		return true
	end

	return false
end

function Utility.IsRigidbody(object: any): boolean
	return getmetatable(typeof(object) == "table" and object or nil) == Rigidbody
end

function Utility.CreateUUID(object: SceneObject.SceneObject)
	local uuid = HTTPService:GenerateGUID(false)

	if not object.Symbols.IDs then
		object.Symbols.IDs = {}
	end

	object.Symbols.IDs[#object.Symbols.IDs + 1] = uuid

	return uuid
end

function Utility.GetVisualObject(object: GuiBase2d | Types.Rigidbody)
	return Utility.IsRigidbody(object.Object) and object.Object:GetFrame() or object.Object
end

function Utility.CheckSymbolData(object: SceneObject.SceneObject, symbol: Types.Symbol)
	Log.TAssert(SceneObject.Interface(object))

	Log.TAssert(t.strictInterface({
		__identifier = t.string,
		Type = t.string,
		Name = t.string,
		SymbolData = t.strictInterface({
			Symbol = t.optional(t.any),
			Attached = t.any,
		}),
	})(symbol))
end

return Utility
