local Types = require(script.Parent.Parent.Types)
local Template = require(script.Parent.Parent.Parent.Template)
local UiPool = Template.FetchGlobal("__Rethink_Pool")
local Promise = require(script.Parent.Parent.Parent.Parent.Library.Promise)

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

	Promise.try(function()
		-- Apply all of the properties at once
		ApplyProperties(object, data.Properties)

		-- Apply name if not specified
		object.Name = typeof(data.Properties.Name) and data.Properties.Name or data.ObjectClass

		object.Parent = objectParent
	end)
		:catch(function(errorMessage: string)
			warn("Encountered an error whilst trying to create an UiBase:\n\n" .. errorMessage)

			UiPool:Return(object)
		end)
		:await()

	return object
end

return CompileStatic
