type DatGuiType = typeof(require(script.Parent.Modules.DatGui).new())
type ControllerModuleType = {
    Init: ( any ) -> ()?
}

local controllers: Folder = script.Parent.Controllers

local DatGui: DatGuiType = require(script.Parent.Modules.DatGui)

local datGui: DatGuiType = DatGui.new({
	closeable = false,
	width = 150,
})
datGui.addLogo("rbxassetid://9799761830", 50)

--[[
for _, controllerModule in ipairs(controllers:GetChildren()) do
    print(string.match(controllerModule.Name, "Controller$"))
    if string.match(controllerModule.Name, "Controller$") then
        local module: ControllerModuleType = require(controllerModule)

        if typeof(module.Init) == "function" then
            module.Init(datGui)
        end
    end
end]]

for i = 1, #controllers:GetChildren(), 1 do
    local controllerModule = nil

    -- Find the right controller based on I and the controller's header
    for _, controller in ipairs(controllers:GetChildren()) do
        if tonumber(string.sub(controller.Name, 0, 2)) == i then
            controllerModule = require(controller)
            break
        end
    end

    -- Check if it has a Init function
    -- If it has call Init and pass datGui as an argument with it
    if typeof(controllerModule.Init) == "function" then
        controllerModule.Init(datGui)
    end
end