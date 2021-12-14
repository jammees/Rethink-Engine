--[[

    CurrentInput

    Useful to let the game respond to input type change.
    
    Took inspiration from Sletinkick's version of PreferredInput

]]

local UserInputService = game:GetService("UserInputService")

local package = script.Parent.Parent.Parent
local components = package.components
local signal = require(components.Signal)
local currentActive = nil


-- signal events
local onChange = signal.new()


local function switchCurrent(inputType)
    if inputType ~= currentActive then
        currentActive = inputType
        onChange:Fire(inputType)
    end
end

local function checkInput(inputType)
    if inputType == Enum.UserInputType.Touch then
        switchCurrent("Touch")
    elseif string.sub(inputType.Name, 1, 7) == "Gamepad" then
        switchCurrent("Gamepad")    
    elseif string.sub(inputType.Name, 1, 5) == "Mouse" or UserInputService.KeyboardEnabled then
        switchCurrent("MouseKeyboard")
    end
end




checkInput(UserInputService:GetLastInputType())
UserInputService.LastInputTypeChanged:Connect(checkInput)

return onChange