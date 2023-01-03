local package = script:FindFirstAncestor("Components").Parent
local Settings = require(package.Settings)

local SettingsController = {}

function SettingsController.Run()
	for category, values in pairs(Settings) do
		--if table.find(IGNORED_SETTINGS_REGISTRIES, category) then
		--	continue
		--end

		local settingController = script:FindFirstChild(category)--script[category]

		if typeof(settingController) == "Instance" and settingController:IsA("ModuleScript") then
			for procName, procCallback in pairs(require(settingController)) do
				if values[procName] ~= nil then
					task.spawn(function()
						procCallback(values[procName])
					end)
				end
			end
		end
	end

	return 0
end

return SettingsController.Run()
