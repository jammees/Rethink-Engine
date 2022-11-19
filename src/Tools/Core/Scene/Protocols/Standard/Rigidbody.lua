--[[
    Rigidbody protocol handler // Standard

    Used to construct a rigidbody from a set of tables, while also assigning tags and properties

    Notes:

    Using wrapper to grant access to physicsHandler
]]

type compileType = {
	Index: string | number | { any },
	Data: { any },
}

local PROPERTY_LOOKUP = {
	"Collidable",
	"Anchored",
	"KeepInCanvas",
	"CanRotate",
	"Structure",
	"LifeSpan",
	"Gravity",
	"Friction",
	"AirFriction",
	"Mass",
}

local scenePackage = script.Parent.Parent.Parent
local package = scenePackage.Parent.Parent.Parent
local components = package.Components

--local Wrapper = require(components.Wrapper)
local Template = require(package.Tools.Utility.Template)
local Layer = require(script.Parent.Layer)
local Util = require(components.Util)
local Symbols = require(scenePackage.Symbols)

local Physics = Template.FetchGlobal("__Rethink_Physics") --Wrapper.Wrap({ "Physics" }).Physics

local function AddPropertiesToTable(target: { [string]: any }, values: { any })
	for propertyName, propertyValue in pairs(values) do
		target[propertyName] = propertyValue
	end

	print("Added :)")
end

local function compileRigid(rigid: compileType, group: compileType, savedProperties: { any }, parent: Frame)
	local rigidData = rigid.Data
	local object = Layer(rigid, group, savedProperties, parent)

	local properties = {
		Object = object,

		--[[
			Collidable = rigidData.Collidable or true,
			Anchored = rigidData.Anchored or false,
			KeepInCanvas = rigidData.KeepInCanvas or true,
			CanRotate = rigidData.CanRotate or true,

			Structure = rigidData.Structure,
			LifeSpan = rigidData.LifeSpan,
			Gravity = rigidData.Gravity,
			Friction = rigidData.Friction,
			AirFriction = rigidData.AirFriction,
			Mass = rigidData.Mass,
		--]]
	}

	-- Check saved properties for a Rigidbody symbol
	Util.Compiler.IsValidSymbol(savedProperties, Symbols.Rigidbody.Name, function(value: { any })
		AddPropertiesToTable(properties, value)
	end)

	-- Check for properties symbol and inside attempt to find a Rigidbody symbol
	Util.Compiler.IsValidSymbol(group.Data, Symbols.Property.Name, function(value: any)
		Util.Compiler.IsValidSymbol(value, Symbols.Rigidbody.Name, function(subValue: { any })
			AddPropertiesToTable(properties, subValue)
		end)
	end)

	Util.Compiler.IsValidSymbol(rigid.Data, Symbols.Rigidbody.Name, function(subValue: { any })
		AddPropertiesToTable(properties, subValue)
	end)

	--[[
	-- universal properties
	Util.Compiler.IsValidSymbol(savedProperties, Symbols.Rigidbody.Name, function(value: any)
		print("applying saved props rigidbody data")
	end)

	Util.Compiler.IsValidSymbol(group.Data, Symbols.Rigidbody.Name, function(value: any)
		print("applying group rigidbody data")
		for propName, propValue in pairs(value) do
			if table.find(PROPERTY_LOOKUP, propName) then
				local oldVal = properties[propValue]
				properties[propName] = propValue

				if oldVal then
					warn("overriden", propName, "from", oldVal, "to", propValue)
				end
			end
		end
	end)
	--]]
	warn(properties)

	local rigidClass = Physics:Create("RigidBody", properties)

	return rigidClass
end

return compileRigid
