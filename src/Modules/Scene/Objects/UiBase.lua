local Types = require(script.Parent.Parent.Types)
local Template = require(script.Parent.Parent.Parent.Template)

local Promise = require(script.Parent.Parent.Parent.Parent.Vendors.Promise)
local Log = require(script.Parent.Parent.Parent.Parent.Library.Log)

function ApplyProperties(object: Instance, properties: { [string]: any })
	for propertyKey, propertyValue in properties do
		Promise.try(function()
			object[propertyKey] = propertyValue
		end):catch(Log.Warn)
	end
end

--[[
    Creates an object by the given arguments, then returns it
]]
local function CompileStatic(data: Types.Prototype_ChunkObject)
	local UiPool = Template.FetchGlobal("__Rethink_Pool")
	local objectParent = Template.FetchGlobal("__Rethink_Ui").Viewport

	local object = UiPool:Get(data.ObjectClass)

	Promise.try(function()
		object.Parent = objectParent
		object.Name = data.ObjectClass

		ApplyProperties(object, data.Properties)
	end)
		:catch(function(errorMessage: string)
			Log.Warn(errorMessage)

			UiPool:Return(object)
		end)
		:await()

	return object
end

return CompileStatic
