--[[
    Static protocol handler // Standard

    Used to cunstruct an object from dictionaries, and assigning properties/tags with symbols with no
	interaction with the physics engine.
]]

type CompileType = {
	Index: string | number | { any }?,
	Data: {
		Class: string?,
	}?,
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
	return ApplyProperties(UiPool:Get(className), properties)
end

local function ReturnClass(
	objectProperties: CompileType,
	groupProperties: { any },
	savedProperties: CompileType
): string
	if typeof(objectProperties.Data.Class) == "string" then
		return objectProperties.Data.Class
	elseif typeof(groupProperties.Class) == "string" then
		return groupProperties.Class
	elseif typeof(savedProperties.Class) == "string" then
		return savedProperties.Class
	end

	return "Frame"
end

local function AddTag(object: Instance, tags: { [number]: string } | string?)
	if typeof(tags) == "table" then
		for _, tag in ipairs(tags) do
			CollectionService:AddTag(object, tag)
		end
	elseif typeof(tags) == "string" then
		CollectionService:AddTag(object, tags)
	end
end

function ApplyProperties(object: Instance, properties: { [string]: any }): Instance
	if typeof(properties) ~= "table" then
		return
	end

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
	local object = GetFromPool(ReturnClass(objectProperties, groupData, savedProperties), objectProperties.Data)
	object.Name = objectProperties.Index

	-- apply default properties if they're not present
	for i, v in pairs(DefaultProperties[object.ClassName]) do
		if objectProperties.Data[i] ~= nil and groupData[i] ~= nil then
			continue
		end

		object[i] = v
	end

	-- apply properties
	if savedProperties ~= nil then
		ApplyProperties(object, savedProperties)
	end

	ApplyProperties(object, select(2, Symbols.FindSymbol(groupData, "Property")))
	AddTag(object, select(2, Symbols.FindSymbol(groupData, "Tag")))
	AddTag(object, select(2, Symbols.FindSymbol(objectProperties.Data, "Tag")))

	object.Parent = objectParent

	return object
end

return CompileStatic
