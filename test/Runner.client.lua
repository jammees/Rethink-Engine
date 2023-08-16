---@module src.init
local Rethink = require(game:GetService("ReplicatedStorage").Rethink)
local Scene = Rethink.GetModules().Scene

local DebugConsole = require(script.Parent.DebugConsole)

Scene.RegisterCustomSymbol("testSymbol", 0, function(object, symbol)
	object.Symbols.testSymbol = symbol.SymbolData.Attached
end)

Scene.RegisterCustomSymbol("Children2", 0, function(object, symbol)
	local Symbol = require(Rethink.Self.Modules.Scene.Symbols)

	local function Parse(tbl, parent)
		for i, v in tbl do
			if Symbol.IsSymbol(i) then
				continue
			end

			local childObject = Instance.new(v.CLASS or "Frame")

			for propName, propData in v do
				if Symbol.IsSymbol(propName) then
					continue
				end

				childObject[propName] = propData
			end

			childObject.Parent = parent

			local childIndex, childValue = Symbol.FindSymbol(v, "Children")

			if not childIndex then
				continue
			end

			Parse(childValue)
		end
	end

	Parse(
		symbol.SymbolData.Attached,
		if Scene.IsRigidbody(object.Object) then object.Object:GetFrame() else object.Object
	)
end)

-- TODO: make childrens symbol :)
Scene.RegisterCustomSymbol("Children", 0, function() end)

Rethink.Init()
DebugConsole.Start()
