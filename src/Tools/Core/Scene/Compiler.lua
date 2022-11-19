local StarterPack = game:GetService("StarterPack")
local protocols = script.Parent.Protocols
local package = script.Parent.Parent.Parent.Parent
local components = package.Components

--local Wrapper = require(components.Wrapper)
local Util = require(components.Util)
local Types = require(components.Debug.Types)
local Promise = require(components.Lib.Promise)
local Symbols = require(script.Parent.Symbols)
local Template = require(package.Tools.Utility.Template)

local Compiler = {}

local standardProtocols = protocols.Standard
local savedProperties = {}

local function ValidateProtocol(object: ModuleScript, fallbackName: string): ModuleScript
	if typeof(object) == "Instance" and object:IsA("ModuleScript") then
		return require(object)
	else
		return require(standardProtocols[fallbackName])
	end
end

local function CompileData(protocolHandlers: Folder, objectArray: { [number]: any }, protocolId: string)
	local compiledObjects = {}

	for _, compilerData in ipairs(objectArray) do
		for groupIndex, groupData in pairs(compilerData) do
			-- Try and optimize/speedup the compiling process with threads?

			--[[
				Benchmarking results:

				Without using task.spawn

				(50/50 cycles // 100.0 %):
				Avarage: 0.499642 μs
				Maximum: 0.765146 μs
				Minimum: 0.255104 μs
				Elapsed: 24.982083 μs

				With using task.spawn

				(50/50 cycles // 100.0 %):
				Avarage: 0.477752 μs
				Maximum: 0.779514 μs
				Minimum: 0.264649 μs
				Elapsed: 23.887622 μs
			]]

			Util.Compiler.IsValidSymbol(compilerData, Symbols.Property.Name, function(result)
				savedProperties = result
			end)

			if typeof(groupData) == "table" and typeof(groupIndex) ~= "table" then
				for layerIndex, layerData in pairs(groupData) do
					if typeof(layerData) == "table" and typeof(layerIndex) ~= "table" then
						-- find the compile mode
						local handler = ValidateProtocol(protocolHandlers[protocolId], protocolId)

						local lData = { Index = layerIndex, Data = layerData }
						local gData = { Index = groupIndex, Data = groupData }
						local parent =
							Template.FetchGlobal("__Rethink_Ui")[protocolId == "Layer" and "Layer" or "Canvas"]

						-- create the obhect
						local object = handler(lData, gData, savedProperties, parent)

						-- save it
						table.insert(compiledObjects, object)
					end
				end
			end
		end
	end

	return compiledObjects
end

function Compiler.Compile(sceneConfig: Types.SceneConfig, sceneData: { any })
	--table.clear(savedProperties)

	return Promise.new(function(resolve)
		local protocolHandlers = protocols:FindFirstChild(sceneConfig.CompileMode or "Standard")

		savedProperties = {}

		resolve(
			CompileData(protocolHandlers, Util.SearchForType(sceneData, "Layer"), "Layer"),
			CompileData(protocolHandlers, Util.SearchForType(sceneData, "Rigidbody"), "Rigidbody")
		)
	end):catch(warn)
end

return Compiler.Compile
