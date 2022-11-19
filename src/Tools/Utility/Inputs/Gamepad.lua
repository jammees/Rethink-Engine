--[[

    Gamepad

    API:

    gamepad:onConnect(callback)
    gamepad:onDisconnect(callback)
    gamepad:enabled()
    gamepad:onPress(key, callback)
    gamepad:destroy()
        
]]

local KEYS = {
	["a"] = Enum.KeyCode.ButtonA,
	["b"] = Enum.KeyCode.ButtonB,
	["l1"] = Enum.KeyCode.ButtonL1,
	["l2"] = Enum.KeyCode.ButtonL2,
	["l3"] = Enum.KeyCode.ButtonL3,
	["r1"] = Enum.KeyCode.ButtonR1,
	["r2"] = Enum.KeyCode.ButtonR2,
	["r3"] = Enum.KeyCode.ButtonR3,
	["se"] = Enum.KeyCode.ButtonSelect,
	["st"] = Enum.KeyCode.ButtonStart,
	["x"] = Enum.KeyCode.ButtonX,
	["y"] = Enum.KeyCode.ButtonY,
}

local UserInputService = game:GetService("UserInputService")

local package = script.Parent.Parent.Parent.Parent
local components = package.Components

local Janitor = require(components.Lib.Janitor)

local gamepad = {}
gamepad.__index = gamepad
gamepad.keys = KEYS

function gamepad._new()
	local self = setmetatable({}, gamepad)

	self.JanitorClass = Janitor.new()

	-- events
	-- when gamepad connected
	--[[self.connectEvent = UserInputService.GamepadConnected:Connect(function(...)
		for _, callback in ipairs(self.connectCallbacks) do
			callback(...)
		end
	end)

	-- when gamepad disconnected
	self.disconnectEvent = UserInputService.GamepadDisconnected:Connect(function(...)
		for _, callback in ipairs(self.disconnectCallbacks) do
			callback(...)
		end
	end)

	-- when a key got pressed on the gamepad
	self.pressEvent = UserInputService.InputBegan:Connect(function(key)
		for _, array in ipairs(self.pressCallbacks) do
			if array[1] == key.KeyCode then
				array[2]()
			end
		end
	end)]]

	return self
end

function gamepad:onConnect(callback)
	assert(typeof(callback) == "function", ("Expected function, got; "):format(typeof(callback)))
	self.connectCallbacks[#self.connectCallbacks + 1] = callback
end

function gamepad:onDisconnect(callback)
	assert(typeof(callback) == "function", ("Expected function, got; "):format(typeof(callback)))
	self.disconnectCallbacks[#self.disconnectCallbacks + 1] = callback
end

function gamepad:onPress(key: Enum, callback)
	if KEYS[string.lower(key)] then
		self.pressCallbacks[#self.pressCallbacks + 1] = { key, callback }
	end
end

function gamepad:destroy()
	disconnectFrom(self.connectCallbacks)
	disconnectFrom(self.disconnectCallbacks)
	disconnectFrom(self.pressCallbacks)
	disconnectFrom(self.connectEvent)
	disconnectFrom(self.pressEvent)
end

return gamepad._new()
