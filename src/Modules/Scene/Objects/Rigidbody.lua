--[[
	Properties:

	Collidable
	Anchored
	KeepInCanvas
	CanRotate
	Structure
	LifeSpan
	Gravity
	Friction
	AirFriction
	Mass
]]

type Properties = { [string]: any }
type CompileType = {
	Class: string?,
	Index: string | number | { any },
	Data: {
		Class: string?,
	},
}

local Types = require(script.Parent.Parent.Types)
local Template = require(script.Parent.Parent.Parent.Template)
local UIBase = require(script.Parent.UIBase)
local Promise = require(script.Parent.Parent.Parent.Parent.Vendors.Promise)
local Log = require(script.Parent.Parent.Parent.Parent.Library.Log)

local function CompileDynamic(data: Types.Prototype_ChunkObject)
	local UiPool = Template.FetchGlobal("__Rethink_Pool")
	local Physics = Template.FetchGlobal("__Rethink_Physics")

	local rigidbodyData = {
		Object = UIBase(data),
	}

	-- Add symbols related to rigidbodies
	-- For now, this Object will handle the `Rigidbody` symbol, but in the future that
	-- might change
	for symbol, value in pairs(data.Symbols) do
		-- It's a Rigidbody symbol add all of the properties
		if symbol.Name == "Rigidbody" then
			for propertyName, propertyValue in pairs(value) do
				rigidbodyData[propertyName] = propertyValue
			end
		end
	end

	local object = nil

	Promise.new(function(resolve)
		object = Physics:Create("RigidBody", rigidbodyData)

		resolve()
	end)
		:catch(function(errorMessage: string)
			Log.Warn("Encountered an error whilst trying to create a Rigidbody:\n\n" .. errorMessage)

			UiPool:Return(rigidbodyData.Object)
			table.clear(rigidbodyData)
		end)
		:await()

	return object
end

return CompileDynamic
