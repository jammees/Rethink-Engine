-- deprecated

local UserInputService = game:GetService("UserInputService")

local controlManager = {}
controlManager.__index = controlManager


function controlManager.new(KEY)
    if not typeof(KEY) == "string" then return end
    
    local self = setmetatable({}, controlManager)

    self.callbacks = {}
    self.disabled = false
    self.keyEvent = UserInputService.InputBegan:Connect(function(key)
        if self.disabled then return end

        if key.KeyCode == Enum.KeyCode[KEY] then
            for _, callback in ipairs(self.callbacks) do
                callback("begin", KEY)
            end
        end
    end)

    return self
end


function controlManager:OnKeyPress(callbackFunction)
    if not typeof(callbackFunction) == "function" then return end

    self.callbacks[#self.callbacks + 1] = callbackFunction
    return self
end

function controlManager:SetState(boolean)
    if not typeof(boolean) == "boolean" then return end

    print("Disabled")
    self.disabled = true
    return self
end

function controlManager:Destroy()
    table.clear(self.callbacks)
    self.keyEvent:Disconnect()
end


return controlManager
