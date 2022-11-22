type Symbol = {
	Name: string,
	Type: string,
}

local LOG_ON_PROPERTY_FAIL = true

local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")

local Promise = require(script.Parent.Lib.Promise)

local Util = {}
Util.Compiler = {}

function Util.FindInTable(array: { any }, data: any, dataIndex: string): any
	for index, value in pairs(array) do
		if typeof(dataIndex) == "string" then
			if value[dataIndex] == data then
				return true, index
			end
		else
			if value.Object == data then
				return true, index
			end
		end
	end

	return false, nil
end

function Util.ConvertToVector(value: UDim2 | Vector2): Vector2
	if typeof(value) == "Vector2" then
		return value
	end

	return Vector2.new(value.X.Offset, value.Y.Offset)
end

function Util.Assert(errorMessage: string, object: any, ...: string)
	local objectTypes = table.pack(...)
	objectTypes.n = nil

	for _, v in ipairs(objectTypes) do
		local result = typeof(object) == v
		if result then
			return v
		end
	end

	return error(string.format(errorMessage, table.concat(objectTypes, ", "), typeof(object)), 2)
end

local BlacklistedSymbols = {
	"Property",
	"Rigidbody",
}

local function IndexIsValid(index: Symbol | string, value: string, targetValue: string)
	if index.Type == "Symbol" then
		if table.find(BlacklistedSymbols, index.Name) then
			return false
		end

		if string.lower(value) == string.lower(targetValue) then
			return true
		end
	end
end

function Util.SearchForType(array: { any }, targetValue: string, saveTable: { any }?)
	local results = saveTable or {}

	for index, value in pairs(array) do
		if typeof(index) == "table" and typeof(index.Type) ~= nil then
			if IndexIsValid(index, value, targetValue) then
				table.insert(results, array)
			end
		else
			if typeof(value) == "table" then
				for subIndex, subValue in pairs(value) do
					if typeof(subIndex) == "table" and typeof(subIndex.Type) ~= nil then
						if IndexIsValid(subIndex, subValue, targetValue) then
							table.insert(results, value)
						end
					else
						if typeof(subValue) == "table" then
							Util.SearchForType(subValue, targetValue, results)
						end
					end
				end
			end
		end
	end

	return results
end

function Util.Serialize(array: { any }): string
	local results = "@symbol;"

	for i, v in pairs(array) do
		results = results .. ("%s=%s/"):format(i, v)
	end

	return results
end

function Util.Deserialize(serString: string): { [string]: string }
	local serStringFragments = string.split(serString, ";")
	local serType = serStringFragments[1]
	local tableData = serStringFragments[2]
	local tableDataFragments = string.split(tableData, "/")

	local result = {}

	if serType == "@symbol" then
		for _, v in ipairs(tableDataFragments) do
			local dataFragment = string.split(v, "=")
			result[dataFragment[1]] = dataFragment[2]
		end
	end

	return result
end

function Util.ApplyRigidbodyProperties(rigidbodyClass: { any }, properties: { any })
	if properties["Mass"] ~= nil then
		rigidbodyClass:SetMass(properties["Mass"])
	elseif properties["Gravity"] ~= nil then
		rigidbodyClass:SetGravity(properties["Gravity"])
	elseif properties["AirFriction"] ~= nil then
		rigidbodyClass:SetAirFriction(properties["AirFriction"])
	elseif properties["Friction"] ~= nil then
		rigidbodyClass:SetFriction(properties["Friction"])
	elseif properties["KeepInCanvas"] ~= nil then
		rigidbodyClass:KeepInCanvas(properties["KeepInCanvas"])
	elseif properties["LifeSpan"] ~= nil then
		rigidbodyClass:SetLifeSpan(properties["LifeSpan"])
	elseif properties["CanRotate"] ~= nil then
		rigidbodyClass:CanRotate(properties["CanRotate"])
	elseif properties["CanCollide"] ~= nil then
		rigidbodyClass:CanCollide(properties["CanCollide"])
	elseif properties["Scale"] ~= nil then
		rigidbodyClass:SetScale(properties["Scale"])
	elseif properties["Size"] ~= nil then
		rigidbodyClass:SetSize(properties["Size"])
	elseif properties["Position"] ~= nil then
		rigidbodyClass:SetPosition(properties["Position"])
	elseif properties["Rotation"] ~= nil then
		rigidbodyClass:Rotate(properties["Rotation"])
	elseif properties["Anchored"] ~= nil then
		if properties["Anchored"] == true then
			rigidbodyClass:Anchor()
		else
			rigidbodyClass:Unanchor()
		end
	end
end

function Util.AddTagToInstance(object: Instance, tags: { [number]: string } | string?)
	if typeof(tags) == "table" then
		for _, tag in ipairs(tags) do
			CollectionService:AddTag(object, tag)
		end
	else
		CollectionService:AddTag(object, tags)
	end
end

local ignoredPorperties = {
	Class = 0,
}

-- Compiler
function Util.Compiler.ApplyProperties(object: Instance, properties: { [string]: any }): Instance
	for i, v in pairs(properties) do
		Promise.try(function() --> very useful for debugging and unyielding code. :)
			if typeof(i) == "table" and i.Type == "Symbol" and i.Name == "Tag" then
				Util.AddTagToInstance(object, v)
			else
				if ignoredPorperties[i] == nil and i.Type == nil then --> ignore Class and Symbols
					object[i] = v
				end
			end
		end):catch(function()
			if RunService:IsStudio() and LOG_ON_PROPERTY_FAIL then
				print(i, "(", v, ") is not a valid property of; ", object, "stacktrace:\n", debug.traceback())
				--warn(consoleMessage)
			end
		end)
	end
	return object
end

function Util.Compiler.Instantiate(className: string, properties: { [string]: any }): Instance
	return Util.Compiler.ApplyProperties(Instance.new(className or "Frame"), properties)
end

function Util.Compiler.IsValidSymbol(array: { any }, targetSymbol: string, callback: () -> ({ any })): boolean
	if typeof(array) ~= "table" then
		return false
	end

	for index, value in pairs(array) do
		if typeof(index) == "table" and index.Type == "Symbol" then
			if index.Name == targetSymbol then
				callback(value)
				break
			end
		end
	end
end

function Util.MergeTablesIndex(...)
	local newTable = {}

	for _, mergeTable in pairs({ ... }) do
		for _, v in pairs(mergeTable) do
			table.insert(newTable, v)
		end
	end

	return newTable
end

return Util
