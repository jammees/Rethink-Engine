local ReplicatedStorageService = game:GetService("ReplicatedStorage")
local StarerPlayerService = game:GetService("StarterPlayer")
local StarterGuiService = game:GetService("StarterGui")
local WorkspaceService = game:GetService("Workspace")
local LightningService = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local ChatService = game:GetService("Chat")

local player = game:GetService("Players").LocalPlayer
local camera = workspace.CurrentCamera

-- edit this:
local settings = {
	["Lightning"] = {
		["Ambient"] = Color3.fromRGB(0, 0, 0),
		["Brightness"] = 0,
		["ColorShift_Bottom"] = Color3.fromRGB(0, 0, 0),
		["ColorShift_Top"] = Color3.fromRGB(0, 0, 0),
		["GlobalShadows"] = false,
		["OutdoorAmbient"] = Color3.fromRGB(0, 0, 0),
		["FogColor"] = Color3.fromRGB(0, 0, 0),
	},
	["Workspace"] = {
		["noGravity"] = true,
		["deleteCharacter"] = true,

		["Camera"] = {
			["scriptableCamera"] = true,
			["setMatrixTo0"] = true,
			["fovTo1"] = true,
		},
	},
	["StarterGui"] = {
		["CoreGui"] = {
			["Inventory"] = false,
			["PlayerList"] = false,
			["Chat"] = false,
			["EmotesMenu"] = false,
			["Backpack"] = false,
			["Health"] = false,
		},
		["RobloxInserted"] = {
			["Chat"] = true,
			["Freecam"] = true,
		},
	},
	["Chat"] = {
		["deleteScripts"] = true,
	},
	["RobloxScripts"] = {
		"BubbleChat",
		"PlayerModule",
		"ChatScript",
		"PlayerScriptsLoader",
		"RbxCharacterSounds",
	},
	["StarterPlayerScripts"] = {
		["deleteScripts"] = true,
	},
	["PlayerScripts"] = {
		["deleteScripts"] = true,
	},
}

-- some utility functions
local function RunInNewThread(description: string, statement: boolean, func: () -> ())
	if statement then
		task.spawn(func)
	end
end

local function FindScriptName(scriptName: string)
	for _, robloxScript in ipairs(settings.RobloxScripts) do
		if scriptName == robloxScript then
			return true
		end
	end
	return false
end

function applySettings()
	if RunService:IsServer() then
		return
	end

	-- APPLY LIGHTNING SETTINGS
	RunInNewThread("apply properties", true, function()
		for propName, propVal in pairs(settings.Lightning) do
			pcall(function()
				LightningService[propName] = propVal
			end)
		end
	end)

	-- APPLY WORKSPACE SETTINGS
	RunInNewThread("disable gravity", settings.Workspace.noGravity, function()
		WorkspaceService.Gravity = 0
	end)

	RunInNewThread("delete character", settings.Workspace.deleteCharacter, function()
		if player.Character then
			player.Character:Destroy()
		else
			-- local connection = nil
			player.CharacterAdded:Connect(function(char)
				char:Destroy()
				-- connection:Disconnect()
			end)
		end
	end)

	-- APPLY WORKSPACE SETTINGS // APPLY CAMERA SETTINGS

	RunInNewThread("set camera FOV to 1", settings.Workspace.Camera.fovTo1, function()
		camera.FieldOfView = 1
	end)

	RunInNewThread("set cameratype to SCRIPTABLE", settings.Workspace.Camera.scriptableCamera, function()
		repeat
			task.wait()
			camera.CameraType = Enum.CameraType.Scriptable
		until camera.CameraType == Enum.CameraType.Scriptable
	end)

	RunInNewThread("set camera's CFRAME to all 0", settings.Workspace.Camera.setMatrixTo0, function()
		RunService.Heartbeat:Connect(function()
			camera.CFrame = CFrame.new(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
		end)
	end)

	-- APPLY STARTERGUI SETTINGS

	RunInNewThread("set core gui enabled", true, function()
		for enumName, enumVal in pairs(settings.StarterGui) do
			pcall(function()
				StarterGuiService:SetCoreGuiEnabled(Enum.CoreGuiType[enumName], enumVal)
			end)
		end
	end)

	RunInNewThread("delete roblox inserted gui elements", true, function()
		for _, instance in ipairs(player.PlayerGui:GetChildren()) do
			if settings.StarterGui.RobloxInserted[instance.Name] then
				instance:Destroy()
			end
		end
	end)

	-- APPLY CHAT SETTINGS

	RunInNewThread("delete every child of chat", settings.Chat.deleteScripts, function()
		for _, instance in ipairs(ChatService:GetChildren()) do
			instance:Destroy()
		end
	end)

	-- APPLY STARTER PLAYER SCRIPTS SETTINGS

	RunInNewThread("delete roblox inserted scripts", settings.StarterPlayerScripts.deleteScripts, function()
		for _, instance in ipairs(StarerPlayerService.StarterPlayerScripts:GetChildren()) do
			if FindScriptName(instance.Name) then
				instance:Destroy()
			end
		end

		ReplicatedStorageService:WaitForChild("DefaultChatSystemChatEvents"):Destroy()
	end)

	-- APPLY PLAYER SCRIPTS SETTINGS

	RunInNewThread("delete roblox inserted scripts", settings.PlayerScripts.deleteScripts, function()
		for _, instance in ipairs(player.PlayerScripts:GetChildren()) do
			if FindScriptName(instance.Name) then
				instance:Destroy()
			end
		end
	end)
end

return applySettings
