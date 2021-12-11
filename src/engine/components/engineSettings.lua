local StarterGui = game:GetService("StarterGui")
local player = game:GetService("Players").LocalPlayer

-- edit this:
local data = {
    ["Inventory"] = false,
    ["PlayerList"] = false,
    ["Chat"] = false,
    ["EmotesMenu"] = false,
    ["Backpack"] = false,
    ["Health"] = false,

    ["disablePlayerMovement"] = true,
    ["deleteCharacter"] = true,
}










-- loop trough the settings
for enumName, value in pairs(data) do 
    -- attempt to change the core gui's visibility
    pcall(function()
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType[enumName], value)
    end)

    -- character settings
    if enumName == "disablePlayerMovement" and value == true then
        local playerScripts = player:WaitForChild("PlayerScripts")
        require(playerScripts:WaitForChild("PlayerModule")):GetControls():Disable()
    end
    if enumName == "deleteCharacter" and value == true then
        if player.Character then
            player.Character:Destroy()
        else
            local connection = nil
            connection = player.CharacterAdded:Connect(function(char)
                char:Destroy()
                connection:Disconnect()
            end)
        end
    end
end

return true