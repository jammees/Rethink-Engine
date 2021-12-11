-- local variables
local toolbar = plugin:CreateToolbar("Dev Plus")
local panel = toolbar:CreateButton("Level editor","Make levels for your 2D game!","rbxassetid://1204390771")

local widgetInfo = DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Float,false,false,750,250,450,250)
local widget = plugin:CreateDockWidgetPluginGui("widget", widgetInfo)

-- assets/ui
local assets = script.Parent.assets
local ui = assets.ui

-- modules
local core = require(ui.core)
local global = require(script.Parent.global)

-- create/setup widget
widget.Title = "Level editor"
core.main.Size = UDim2.fromScale(1, 1)
core.main.Parent = widget
panel.Click:Connect(function()
    widget.Enabled = not widget.Enabled
end)

-- create globals
global:set("coreui", core)

-- run util functions
local moveInScroll = require(ui.moveInScroll)