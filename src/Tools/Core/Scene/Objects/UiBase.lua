--[[
    Static protocol handler // Standard

    Used to cunstruct an object from dictionaries, and assigning properties/tags with symbols with no
	interaction with the physics engine.
]]

type CompileType = {
	Class: string?,
	Index: string | number | { any }?,
	Data: {
		Class: string?
	},
}

local IGNORED_KEYS = {
	Class = 0,
}

local CollectionService = game:GetService("CollectionService")

local package = script:FindFirstAncestor("Tools").Parent
local scenePackage = script.Parent.Parent

local DefaultProperties = require(scenePackage.DefaultProperties)
local Promise = require(package.Components.Library.Promise)
local Symbols = require(scenePackage.Symbols)
local Template = require(package.Tools.Utility.Template)
local UiPool = Template.FetchGlobal("__Rethink_Pool")
local Settings = Template.FetchGlobal("__Rethink_Settings")

local objectParent = Template.FetchGlobal("__Rethink_Ui").Viewport

local function GetFromPool(className: string, properties: { [string]: any }): Instance
	return ApplyProperties(UiPool:Get(className or "Frame"), properties)
end

local function AddTag(object: Instance, tags: { [number]: string } | string?)
	if typeof(tags) == "table" then
		for _, tag in ipairs(tags) do
			CollectionService:AddTag(object, tag)
		end
	else
		CollectionService:AddTag(object, tags)
	end
end

function ApplyProperties(object: Instance, properties: { [string]: any }): Instance
	for propertyKey, propertyValue in pairs(properties) do
		Promise.try(function()
			-- Check if the key is a symbol
			if typeof(propertyKey) == "table" and propertyKey.Type == "Symbol" and propertyKey.Name == "Tag" then
				AddTag(object, propertyValue)
			else
				if IGNORED_KEYS[propertyKey] == nil and propertyKey.Type == nil then --> ignore Class and Symbols
					object[propertyKey] = propertyValue
				end
			end
		end):catch(function()
			if Settings.Console.LogOnPropertyFail then
				warn(
					propertyKey,
					"(",
					propertyValue,
					") is not a valid property of; ",
					object,
					"stacktrace:\n",
					debug.traceback()
				)
			end
		end)
	end
	return object
end

--[[
    Creates an object by the given arguments, then returns it
]]
local function CompileStatic(objectProperties: CompileType, groupData: any, savedProperties: CompileType)
	local object = GetFromPool(savedProperties.Class or objectProperties.Data.Class, objectProperties.Data)
	object.Name = objectProperties.Index

	-- apply default properties if they're not present
	for i, v in pairs(DefaultProperties[object.ClassName]) do
		if objectProperties.Data[i] == nil and groupData[i] == nil then
			object[i] = v
		end
	end

	-- apply properties
	if savedProperties ~= nil then
		ApplyProperties(object, savedProperties)
	end

	-- check for symbols in group and in layer data, also this looks much cleaner in my opinion than using if statements
	-- and assigning a value the the result
	Symbols.FindSymbol(groupData, "Property", function(result)
		ApplyProperties(object, result)
	end)

	Symbols.FindSymbol(groupData, "Tag", function(result)
		AddTag(object, result)
	end)

	Symbols.FindSymbol(objectProperties.Data, "Tag", function(result)
		AddTag(object, result)
	end)

	object.Parent = objectParent

	return object
end

return CompileStatic
