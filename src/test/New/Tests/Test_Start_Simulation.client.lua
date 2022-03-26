local RunService = game:GetService("RunService")

local rethinkEngine = require(game:GetService("ReplicatedStorage").RethinkEngine)
local sceneManager = rethinkEngine.Scene
local engine = rethinkEngine.Physics
local camera = rethinkEngine.Camera

local renderStepped = nil

game:GetService("UserInputService").InputBegan:Connect(function(key)
	if key.KeyCode == Enum.KeyCode.S then
		engine:Start()

		--renderStepped = RunService.RenderStepped:Connect(function(dt)
		--	camera:Render(dt)
		--end)
	elseif key.KeyCode == Enum.KeyCode.D then
		sceneManager:Flush()
		renderStepped:Disconnect()
	end
end)
