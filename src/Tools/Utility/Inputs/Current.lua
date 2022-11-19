--[[

    CurrentInput

    Useful to let the game respond to input type change.
    
    Took inspiration from Sleitnick's version of PreferredInput

]]

local UserInputService = game:GetService("UserInputService")

local package = script.Parent.Parent.Parent.Parent
local components = package.Components
local signal = require(components.Lib.Signal)
local currentActive = nil

-- signal events
local onChange = signal.new()

local function switchCurrent(inputType: string)
	if inputType ~= currentActive then
		currentActive = inputType
		onChange:Fire(inputType)
	end
end

local function checkInput(inputType: Enum)
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
