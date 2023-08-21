local Types = require(script.Parent.Parent.Parent.Types)
local Utility = require(script.Parent.Parent.Utility)
local Log = require(script.Parent.Parent.Parent.Parent.Parent.Library.Log)
local t = require(script.Parent.Parent.Parent.Parent.Parent.Vendors.t)

return function(object: Types.ObjectReference, symbol: Types.Symbol)
	Utility.CheckSymbolData(object, symbol)
	Log.TAssert(t.table(symbol.SymbolData.Attached))

	local Symbol = require(script.Parent.Parent)
	local Scene = require(script.Parent.Parent.Parent)
	local Template = require(script.Parent.Parent.Parent.Parent.Template)
	---@module src.Library.ObjectPool
	local ObjectPool = Template.FetchGlobal("__Rethink_Pool")
	---@module src.Modules.Nature2D
	local Nature2D = Template.FetchGlobal("__Rethink_Physics")

	for name, objectData in symbol.SymbolData.Attached do
		objectData.Name = if objectData.Name then objectData.Name else name
		objectData.Parent = if Scene.IsRigidbody(object.Object) then object.Object:GetFrame() else object.Object

		local childObject: GuiBase2d? = ObjectPool:Get(select(2, Symbol.FindSymbol(objectData, "Class")) or "Frame")
		local symbols = {}

		for propName, propData in objectData do
			if Symbol.IsSymbol(propName) then
				symbols[propName] = propData

				continue
			end

			childObject[propName] = propData
		end

		local _, typeSymbol = Symbol.FindSymbol(symbols, "Type")

		if t.string(typeSymbol) and typeSymbol == "Rigidbody" then
			local rigidbodyData = {
				Object = childObject,
			}

			for collectedSymbol, symbolValue in symbols do
				if collectedSymbol.Name == "Rigidbody" then
					for propertyName, propertyValue in symbolValue do
						rigidbodyData[propertyName] = propertyValue
					end
				end
			end

			Scene.Add(Nature2D:Create("RigidBody", rigidbodyData), symbols)

			continue
		end

		Scene.Add(childObject, symbols)
	end
end
