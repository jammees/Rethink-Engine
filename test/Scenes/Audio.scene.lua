---@module src.init
local Rethink = require(game:GetService("ReplicatedStorage").Rethink)
local Modules = Rethink.GetModules()
local Scene = Modules.Scene
local Symbols = Scene.Symbols
local Audio = Modules.Audio
local Value = require(Rethink.Self.Modules.Scene.Symbols.Handlers.ValueSymbol.Value)

-- cool music to listen to: rbxassetid://1845756489 :)
local mySound = Audio.Sound.new("rbxassetid://1845756489")
local mySound2D = Audio.Sound2D.new("rbxassetid://1845756489")

return {
	Name = "audio.scene",

	{
		[Symbols.Type] = "UIBase",

		Emitter = {
			Position = UDim2.fromScale(0.5, 0.5),

			[Symbols.Tag] = "Emitter",
			[Symbols.Value("isW")] = false,
			[Symbols.Value("isS")] = false,
			[Symbols.Value("isA")] = false,
			[Symbols.Value("isD")] = false,
			[Symbols.OnReady] = function(thisObject: Frame)
				local UserInputService = game:GetService("UserInputService")
				local RunService = game:GetService("RunService")

				local thisSceneObject = Scene.GetSceneObjectFrom(thisObject)
				local values = thisSceneObject.Symbols.Values :: { [string]: Value.Value }
				local isW = values.isW
				local isS = values.isS
				local isA = values.isA
				local isD = values.isD

				thisSceneObject.Janitor:Add(
					UserInputService.InputBegan:Connect(function(input: InputObject, gameProcessed: boolean)
						if gameProcessed then
							return
						end

						if input.KeyCode == Enum.KeyCode.W then
							isW:Set(true)
						elseif input.KeyCode == Enum.KeyCode.S then
							isS:Set(true)
						end

						if input.KeyCode == Enum.KeyCode.A then
							isA:Set(true)
						elseif input.KeyCode == Enum.KeyCode.D then
							isD:Set(true)
						end
					end)
				)

				thisSceneObject.Janitor:Add(
					UserInputService.InputEnded:Connect(function(input: InputObject, gameProcessed: boolean)
						if gameProcessed then
							return
						end

						if input.KeyCode == Enum.KeyCode.W then
							isW:Set(false)
						end

						if input.KeyCode == Enum.KeyCode.S then
							isS:Set(false)
						end

						if input.KeyCode == Enum.KeyCode.A then
							isA:Set(false)
						end

						if input.KeyCode == Enum.KeyCode.D then
							isD:Set(false)
						end
					end)
				)

				thisSceneObject.Janitor:Add(RunService.RenderStepped:Connect(function(deltaTime: number)
					local speed = 25
					local speedDelta = speed + speed * deltaTime

					local xDirection = if isA:Get() and not isD:Get()
						then -1
						elseif isD:Get() and not isA:Get() then 1
						else 0
					local yDirection = if isW:Get() and not isS:Get()
						then -1
						elseif isS:Get() and not isW:Get() then 1
						else 0

					thisObject.Position += UDim2.fromOffset(speedDelta * xDirection, speedDelta * yDirection)
				end))
			end,
		},

		FunctionContainer = {
			Parent = Modules.Ui.Ui,
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.9),
			Size = UDim2.fromScale(0.5, 0.1),

			[Symbols.Children] = {
				Toggle = {
					Text = "Toggle",
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.9),
					Size = UDim2.fromScale(0.25, 1),

					[Symbols.Value("playMethod")] = "Sound",
					[Symbols.Tag] = "Toggle",
					[Symbols.Class] = "TextButton",
					[Symbols.Children] = {
						State = {
							Text = `Currently selected class: Sound`,
							Position = UDim2.fromOffset(0, -30),
							Size = UDim2.new(1, 0, 0, 25),
							BackgroundTransparency = 1,
							TextScaled = true,

							[Symbols.Class] = "TextLabel",
							[Symbols.LinkTag] = "State",
						},
					},
					[Symbols.LinkGet({ "State" })] = function(this: TextButton, state: TextLabel)
						local thisSceneObject = Scene.GetSceneObjectFrom(this)
						local Janitor = thisSceneObject.Janitor
						local Values = thisSceneObject.Symbols.Values

						local playMethodValue = Values.playMethod

						Janitor:Add(this.MouseButton1Click:Connect(function()
							playMethodValue:Set(if playMethodValue:Get() == "Sound" then "Sound2D" else "Sound")
							state.Text = `Currently selected class: {playMethodValue:Get()}`
						end))
					end,
				},

				Stop = {
					Text = "Stop",
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.9),
					Size = UDim2.fromScale(0.25, 1),

					[Symbols.Class] = "TextButton",
					[Symbols.Event("MouseButton1Click")] = function()
						mySound:Stop()
						mySound2D:Stop()
					end,
				},

				Start = {
					Text = "Start",
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.9),
					Size = UDim2.fromScale(0.25, 1),

					[Symbols.Class] = "TextButton",
					[Symbols.Event("MouseButton1Click")] = function()
						local toggle = Scene.GetSceneObjectFrom(Scene.GetFromTag("Toggle")[1])
						local playMethodValue = toggle.Symbols.Values.playMethod

						if playMethodValue:Get() == "Sound" then
							mySound:Play()
						else
							local emitter = Scene.GetFromTag("Emitter")[1]
							mySound2D:Play(emitter.AbsolutePosition)
						end
					end,
				},

				UseAsEmitter = {
					Text = "Use as Emitter",
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.9),
					Size = UDim2.fromScale(0.25, 1),
					BackgroundColor3 = Color3.new(1, 0, 0),

					[Symbols.Value("State")] = false,
					[Symbols.Class] = "TextButton",
					[Symbols.Event("MouseButton1Click")] = function(this: TextButton)
						local stateValue = Scene.GetSceneObjectFrom(this).Symbols.Values.State
						stateValue:Set(not stateValue._Value)

						this.BackgroundColor3 = if stateValue._Value then Color3.new(0, 1, 0) else Color3.new(1, 0, 0)

						if stateValue._Value then
							mySound2D:SetEmitter(Scene.GetFromTag("Emitter")[1])
						else
							mySound2D:SetEmitter(nil)
						end
					end,
				},

				List = {
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					Padding = UDim.new(0, 5),

					[Symbols.Class] = "UIListLayout",
				},
			},
		},
	},
}
