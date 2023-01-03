--[[
    Rigidbody protocol handler // Standard

    Used to construct a rigidbody from a set of tables, while also assigning tags and properties

    Notes:

    Using wrapper to grant access to physicsHandler

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
		Class: string?
	},
}

local package = script:FindFirstAncestor("Tools").Parent

local Template = require(package.Tools.Utility.Template)
local Symbols = require(package.Tools.Core.Scene.Symbols)
local UiBase = require(script.Parent.UiBase)

local Physics = Template.FetchGlobal("__Rethink_Physics")

local function AddProperties(target: { [string]: any }, values: { any })
	for propertyName, propertyValue in pairs(values) do
		target[propertyName] = propertyValue
	end
end

local function CompileDynamic(objectProperties: CompileType, groupData: any, savedProperties: CompileType)
	local rigidbodyData = {
		Object = UiBase(objectProperties, groupData, savedProperties),
	}

	-- Check saved properties for a Rigidbody symbol
	Symbols.FindSymbol(savedProperties, "Rigidbody", function(value: { any })
		AddProperties(rigidbodyData, value)
	end)

	-- Check for properties symbol and inside attempt to find a Rigidbody symbol
	Symbols.FindSymbol(groupData, "Property", function(value: any)
		Symbols.FindSymbol(value, "Rigidbody", function(subValue: { any })
			AddProperties(rigidbodyData, subValue)
		end)
	end)

	Symbols.FindSymbol(objectProperties.Data, "Rigidbody", function(subValue: { any })
		AddProperties(rigidbodyData, subValue)
	end)

	return Physics:Create("RigidBody", rigidbodyData)
end

return CompileDynamic
