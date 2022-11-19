local pacakge = script.Parent.Parent.Parent
local tools = pacakge:WaitForChild("Tools")

local Template = require(tools.Utility.Template)
local Settings = require(script.Settings)

local procedures = script.Procedures

local SettingsController = {}

function SettingsController.Run()
	for category, values in pairs(Settings) do
		if typeof(procedures[category]) == "Instance" and procedures[category]:IsA("ModuleScript") then
			for procName, procCallback in pairs(require(procedures[category])) do
				if values[procName] ~= nil then
					task.spawn(function()
						procCallback(values[procName], Template)
					end)
				end
			end
		end
	end

	return 0
end

return SettingsController.Run()
