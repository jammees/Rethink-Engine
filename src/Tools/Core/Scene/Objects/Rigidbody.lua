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
		Class: string?,
	},
}

local package = script:FindFirstAncestor("Tools").Parent

local Template = require(package.Tools.Utility.Template)
local Symbols = require(package.Tools.Core.Scene.Symbols)
local UiBase = require(script.Parent.UiBase)
local Promise = require(package.Components.Library.Promise)
local UiPool = Template.FetchGlobal("__Rethink_Pool")

local Physics = Template.FetchGlobal("__Rethink_Physics")

local function AddProperties(target: { [string]: any }, values: { any })
	if typeof(values) ~= "table" then
		return
	end

	for propertyName, propertyValue in pairs(values) do
		target[propertyName] = propertyValue
	end
end

local function CompileDynamic(objectProperties: CompileType, groupData: any, savedProperties: CompileType)
	debug.profilebegin("Get UI object")
	local rigidbodyData = {
		Object = UiBase(objectProperties, groupData, savedProperties),
	}
	debug.profileend()

	debug.profilebegin("Add properties")
	AddProperties(rigidbodyData, select(2, Symbols.FindSymbol(savedProperties, "Rigidbody")))
	AddProperties(rigidbodyData, select(2, Symbols.FindSymbol(Symbols.FindSymbol(groupData, "Property"), "Rigidbody")))
	AddProperties(rigidbodyData, select(2, Symbols.FindSymbol(objectProperties.Data, "Rigidbody")))
	debug.profileend()

	local object = nil

	debug.profilebegin("Create Rigidbody")
	Promise.new(function(resolve)
		object = Physics:Create("RigidBody", rigidbodyData)

		resolve()
	end)
		:catch(function(errorMessage: string)
			warn(errorMessage)

			UiPool:Return(rigidbodyData.Object)
			table.clear(rigidbodyData)
		end)
		:await()
	debug.profileend()

	return object
end

return CompileDynamic
