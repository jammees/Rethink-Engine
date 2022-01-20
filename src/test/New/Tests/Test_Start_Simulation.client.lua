local rethinkEngine = require(game:GetService("ReplicatedStorage").RethinkEngine)
local sceneManager = rethinkEngine.Scene
local engine = rethinkEngine.Physics

game:GetService("UserInputService").InputBegan:Connect(function(key)
	if key.KeyCode == Enum.KeyCode.S then
		engine:Start()
	elseif key.KeyCode == Enum.KeyCode.D then
		sceneManager:Flush()
	end
end)
