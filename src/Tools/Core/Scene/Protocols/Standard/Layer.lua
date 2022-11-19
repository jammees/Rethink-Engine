--[[
    Layer protocol handler // Standard

    Used to cunstruct an object from dictionaries, and assigning properties/tags with symbols
]]

type compileType = {
	Index: string | number | { any },
	Data: { any },
}

local scenePackage = script.Parent.Parent.Parent
local package = scenePackage.Parent.Parent.Parent
local components = package.Components

local DefaultProperties = require(scenePackage.DefaultProperties)
local Util = require(components.Util)
local Symbols = require(scenePackage.Symbols)

--[[
    Creates an object by the given arguments, then returns it
]]
local function compileLayer(layer: compileType, group: compileType, savedProperties: { any }, parent: Frame)
	local object = Util.Compiler.Instantiate(savedProperties.Class or layer.Data.Class, layer.Data) --> TODO: fix error regarding "Attempt to index nil: Class"
	object.Name = layer.Index or "Undefined"

	-- apply default properties if they're not present
	for i, v in pairs(DefaultProperties[object.ClassName]) do
		if layer.Data[i] == nil and group.Data[i] == nil then
			object[i] = v
		end
	end

	-- apply properties
	if savedProperties ~= nil then
		Util.Compiler.ApplyProperties(object, savedProperties)
	end

	-- check for symbols in group and in layer data, also this looks much cleaner in my opinion than using if statements
	-- and assigning a value the the result
	Util.Compiler.IsValidSymbol(group.Data, Symbols.Property.Name, function(result)
		Util.Compiler.ApplyProperties(object, result)
	end)

	Util.Compiler.IsValidSymbol(group.Data, Symbols.Tag.Name, function(result)
		Util.AddTagToInstance(object, result)
	end)

	Util.Compiler.IsValidSymbol(layer.Data, Symbols.Tag.Name, function(result)
		Util.AddTagToInstance(object, result)
	end)

	object.Parent = parent

	return object
end

return compileLayer
