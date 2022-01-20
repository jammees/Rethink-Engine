local CollectionService = game:GetService("CollectionService")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local localPlayer = Players.LocalPlayer
local canvas = localPlayer
	:WaitForChild("PlayerGui")
	:WaitForChild("gameFrame")
	:WaitForChild("renderFrame")
	:WaitForChild("canvas")

local rethink = require(game:GetService("ReplicatedStorage").RethinkEngine)
local physics = rethink.Physics
local scene = rethink.Scene

local playerObject = Instance.new("Frame")
playerObject.Name = "Player Hitbox"
playerObject.BackgroundColor3 = Color3.fromRGB(255, 33, 44)
playerObject.AnchorPoint = Vector2.new(0.5, 0.5)
playerObject.Position = UDim2.fromOffset(500, 150)
playerObject.Size = UDim2.fromOffset(75, 75)
playerObject.Parent = canvas

local player = physics:Create("RigidBody", {
	Object = playerObject,
	CanRotate = false,
})

local lastInputs = {}

local function updateVelocity(x, y)
	player:ApplyForce(Vector2.new(x, y))
end

local function checkKey(key, fireIfKey, value)
	if key == fireIfKey then
		lastInputs.x = value
	end
end

-- listen for space
UserInputService.InputBegan:Connect(function(key)
	if key.KeyCode == Enum.KeyCode.Up then
		lastInputs.y = -10
	end
end)

spawn(function()
	RunService.Heartbeat:Connect(function()
		-- get kets pressed
		local keysDown = UserInputService:GetKeysPressed()

		-- loop trough the pressed keys
		for _, key in ipairs(keysDown) do
			key = key.KeyCode
			checkKey(key, Enum.KeyCode.Left, -1)
			checkKey(key, Enum.KeyCode.Right, 1)

			if key == Enum.KeyCode.M then
				local box1 = scene:GetRigidbodyFromTag("box1")
				box1.Object.BackgroundColor3 = Color3.fromRGB(
					math.random(0, 255),
					math.random(0, 255),
					math.random(0, 255)
				)
			end
		end
		-- apply velocity to player
		if lastInputs.x or lastInputs.y then
			updateVelocity(lastInputs.x, lastInputs.y or 0)
			table.clear(lastInputs)
		end
	end)
end)

local coin = scene:GetRigidbodyFromTag("coin")

warn(coin.Object:GetFullName())
warn(coin.Class:GetFrame():GetFullName())

coin.Class.Touched:Connect(function(touchingId)
	if touchingId == player:GetId() then
		coin.Class:Destroy()
		print("Coin collected!")
	end
end)
