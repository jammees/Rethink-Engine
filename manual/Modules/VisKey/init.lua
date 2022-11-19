--[[
    VisKey

    An easy-to-use utility library used for visulizing keybinds.
]]

local UserInputService = game:GetService("UserInputService")

local Frame = require(script.Frame)
local KeybindContainer = require(script.KeybindContainer)
local Fusion = require(script.Fusion)
local New = Fusion.New
local Children = Fusion.Children

local inputConnection = nil

local container = nil
local keybindContainers = {}
local connections = {}

local VisKey = {}
VisKey.Initiating = false
VisKey.Started = false
connections = {}
container = nil

function VisKey.Init()
	if VisKey.Initiating or VisKey.Started then
		return warn("[VisKey] Already initialized!")
	end

	VisKey.Initiated = true

	container = New("ScreenGui")({
		DisplayOrder = 99999999999,
		IgnoreGuiInset = true,
		ResetOnSpawn = false,
		Name = "VisualizedKeybinds",
		Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui"),

		[Children] = {
			Container = Frame({
				Size = UDim2.fromScale(1, 1),
				Name = "Container",

				[Children] = {
					List = New("UIListLayout")({
						HorizontalAlignment = Enum.HorizontalAlignment.Right,
						VerticalAlignment = Enum.VerticalAlignment.Bottom,
						Name = "List",
					}),

					Padding = New("UIPadding")({
						PaddingRight = UDim.new(0, 2),
						Name = "Padding",
					}),
				},
			}),
		},
	})

	inputConnection = UserInputService.InputBegan:Connect(function(key)
		if connections[key.KeyCode] then
			for _, v in ipairs(connections[key.KeyCode].Callbacks) do
				v()
			end
		end
	end)

	VisKey.Started = true
end

function VisKey.Keybind(description: string, key: Enum.KeyCode, callback: () -> ())
	if not VisKey.Started then
		return warn("[VisKey] Not started!")
	end

	if connections[key] then
		local oldTitle = connections[key].Ui.Title.Text
		connections[key].Ui.Title.Text = oldTitle .. " / " .. description

		table.insert(connections[key].Callbacks, callback)
	else
		local Ui = KeybindContainer({
			Key = key,
			FrameName = tostring(key),
			LabelText = description,
		})

		Ui.Parent = container.Container

		connections[key] = { Ui = Ui, Callbacks = { callback } }
	end
end

function VisKey.DisconnectKey(key: Enum.KeyCode)
	if connections[key] then
		connections[key].Ui:Destroy()
		connections[key].Callbacks = nil
		connections[key] = nil
	end
end

function VisKey.DisconnetAll()
	if VisKey.Started then
		for _, v in pairs(connections) do
			v.Ui:Destroy()
		end
		table.clear(connections)
	end
end

function VisKey.Destroy()
	if VisKey.Started then
		VisKey.DisconnetAll()
		container:Destroy()
		inputConnection:Disconnect()
	end
end

return VisKey
