---@module src.init
local Rethink = require(game:GetService("ReplicatedStorage").Rethink)
local Modules = Rethink.GetModules()
local Scene = Modules.Scene
local Symbols = Scene.Symbols
local Raycast = Modules.Raycast
local Camera = Modules.Prototypes.Camera

return {
	Name = "PlayerMovement.scene",

	Rigidbodies = {
		[Symbols.Type] = "Rigidbody",

		Player = {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.8, 0.5),
			BackgroundColor3 = Color3.fromRGB(16, 161, 245),
			Size = UDim2.fromOffset(101, 101),

			-- misc
			[Symbols.Rigidbody] = {
				Collidable = true,
				CanRotate = false,
			},

			-- define values
			[Symbols.Value("isJumping")] = false,
			[Symbols.Value("isLeft")] = false,
			[Symbols.Value("isRight")] = false,

			[Symbols.OnReady] = function(thisObject)
				local UserInputService = game:GetService("UserInputService")
				local RunService = game:GetService("RunService")

				local thisSceneObject = Scene.GetSceneObjectFrom(thisObject)

				-- get values from SceneObject symbol table
				-- NOTE TO SELF: consider a better way of doing this. This feels very messy
				local isJumping = thisSceneObject:GetValue("isJumping")
				local isLeft = thisSceneObject:GetValue("isLeft")
				local isRight = thisSceneObject:GetValue("isRight")

				thisSceneObject.Janitor:Add(
					UserInputService.InputBegan:Connect(function(input: InputObject, gameProcessed: boolean)
						if gameProcessed then
							return
						end

						if input.KeyCode == Enum.KeyCode.A then
							isLeft:Set(true)
						elseif input.KeyCode == Enum.KeyCode.D then
							isRight:Set(true)
						end

						if input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.Space then
							local thisFrame = thisSceneObject:GetInstance()
							local halfWidht = Vector2.xAxis * (thisFrame.AbsoluteSize.X / 2)
							local height = Vector2.yAxis * thisFrame.AbsoluteSize.Y
							local position = thisFrame.AbsolutePosition

							local origin = position + halfWidht + height
							local direction = origin + Vector2.yAxis * 1

							local hittableObjects = {}
							for _, SceneObject in Scene.GetObjects() do
								if
									SceneObject:GetInstance():IsA("GuiBase2d")
									and SceneObject:GetInstance() ~= thisFrame
								then
									table.insert(hittableObjects, SceneObject:GetInstance())
								end
							end

							local groundRaycast = Raycast.new(origin, direction)
							local hit, hitPosition = groundRaycast:Cast(hittableObjects)

							if hit and (hitPosition - origin).Magnitude < 48 then
								isJumping:Set(true)
							end
						end
					end)
				)

				thisSceneObject.Janitor:Add(
					UserInputService.InputEnded:Connect(function(input: InputObject, gameProcessed: boolean)
						if gameProcessed then
							return
						end

						if input.KeyCode == Enum.KeyCode.A then
							isLeft:Set(false)
						end

						if input.KeyCode == Enum.KeyCode.D then
							isRight:Set(false)
						end
					end)
				)

				thisSceneObject.Janitor:Add(RunService.RenderStepped:Connect(function(deltaTime: number)
					if not Rethink.GetModules().Physics.connection then
						return
					end

					local speed = 2
					local speedDelta = speed + speed * deltaTime

					local xDirection = if isLeft:Get() and not isRight:Get()
						then -1
						elseif isRight:Get() and not isLeft:Get() then 1
						else 0

					-- thisObject.Position += UDim2.fromOffset(speedDelta * xDirection, speedDelta * yDirection)
					thisSceneObject.Object:ApplyForce(
						Vector2.new(speedDelta * xDirection, isJumping:Get() and -15 or 0)
					)

					isJumping:Set(false)
				end))
			end,
		},

		Ground = {
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.new(0.5, 0, 1, -50),
			Size = UDim2.fromOffset(1500, 50),
			BackgroundColor3 = Color3.fromRGB(126, 126, 126),

			[Symbols.Class] = "Frame",
			[Symbols.Rigidbody] = {
				Anchored = true,
				Collidable = true,
			},
		},
	},
}
