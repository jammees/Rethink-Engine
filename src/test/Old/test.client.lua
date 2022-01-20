local UserInputService = game:GetService("UserInputService")
local rethinkEngine = require(game:GetService("ReplicatedStorage").RethinkEngine)
--local rigid = rethinkEngine.Rigid
local sceneManager = rethinkEngine.Scene
local engine = rethinkEngine.Physics
local template = rethinkEngine.Template

local inputs = rethinkEngine.Inputs
local current = inputs.Current

-- test current from inputs
current:Connect(function(inputType)
	warn(inputType)
end)

local started = false

local frame = Instance.new("Frame")
frame.BackgroundColor3 = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
frame.Size = UDim2.fromOffset(50, 50)
frame.AnchorPoint = Vector2.new(0.5, 0.5)

local myFrameTemplate = template.new(frame)

-- test scene
sceneManager:load({
	data = {
		name = "myTestMap",
	},
	layers = {},
	rigids = {
		hitbox = {
			{
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				Position = UDim2.fromScale(0.5, 0.9),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.new(1, 0, 0, 36),
			},
			{
				BackgroundColor3 = Color3.fromRGB(159, 159, 159),
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.fromScale(0.3, 0.2),
			},
		},
		body = {
			{
				BackgroundColor3 = Color3.fromRGB(234, 123, 231),
				Position = UDim2.fromOffset(50, 60),
				Size = UDim2.fromOffset(100, 100),

				FixedPos = true,
			},
		},
	},
	misc = {},
})

game:GetService("UserInputService").InputBegan:Connect(function(key)
	if key.KeyCode == Enum.KeyCode.S then
		engine:Start()
		started = true
	elseif key.KeyCode == Enum.KeyCode.D then
		sceneManager:flush()
	end
end)
