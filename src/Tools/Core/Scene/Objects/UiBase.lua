local package = script.Parent.Parent.Parent.Parent.Parent

local Types = require(script.Parent.Parent.Types)
local Template = require(package.Tools.Utility.Template)
local UiPool = Template.FetchGlobal("__Rethink_Pool")

local objectParent = Template.FetchGlobal("__Rethink_Ui").Viewport

function ApplyProperties(object: Instance, properties: { [string]: any })
	for propertyKey, propertyValue in pairs(properties) do
		object[propertyKey] = propertyValue
	end
end

--[[
    Creates an object by the given arguments, then returns it
]]
local function CompileStatic(data: Types.Prototype_ChunkObject)
	local object = UiPool:Get(data.ObjectClass)

	-- Apply all of the properties at once
	ApplyProperties(object, data.Properties)

	-- Apply name if not specified
	object.Name = typeof(data.Properties.Name) and data.Properties.Name or data.ObjectClass

	object.Parent = objectParent

	return object
end

return CompileStatic
