local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Rethink = require(ReplicatedStorage.RethinkEngine)

local KeysLib = Rethink.Prototypes.Inputs.Prototype.KeysLib.new()

KeysLib:AddExecutor(Enum.KeyCode.E, function()
	print("Player pressed E ")
end, Enum.UserInputState.Begin)

local controllers = script.Parent.Controllers

local VisKey = require(script.Parent.Modules.VisKey)
--local CameraController = require(controllers.CameraController)
local SceneController = require(controllers.Scene.SceneController)

local dynamicChanger = Instance.new("StringValue")
dynamicChanger.Name = "Dynamic Scene Changer"
dynamicChanger.Parent = ReplicatedStorage

dynamicChanger:GetPropertyChangedSignal("Value"):Connect(function()
	SceneController:LoadScene(string.lower(dynamicChanger.Value))
end)

-- VisKey

VisKey.Init()

VisKey.Keybind("Cache loaded scene", Enum.KeyCode.C, function()
	SceneController:Cache()
	SceneController.Scene.Flush()
end)

VisKey.Keybind("Print cache data", Enum.KeyCode.X, function()
	print(SceneController.Scene.GetCache())
end)

VisKey.Keybind("Load scene", Enum.KeyCode.F, function()
	SceneController:LoadScene("test")
	Rethink.Physics:Stop()
	Rethink.Physics:Start()
end)

VisKey.Keybind("Flush scene", Enum.KeyCode.G, function()
	SceneController.Scene.Flush()
end)

VisKey.Keybind("Get scene data", Enum.KeyCode.H, function()
	print(SceneController.Scene.GetObjects())
end)

VisKey.Keybind("UnCache 'Test' data", Enum.KeyCode.J, function()
	SceneController.Scene:UnCache("Test")
end)

VisKey.Keybind("Move Left", Enum.KeyCode.I, function()
	local taggedObject = SceneController.Scene.GetBodyFromTag("MyRigidbody")[1].Class
	taggedObject:ApplyForce(Vector2.new(5, 0))
end)

VisKey.Keybind("Move Right", Enum.KeyCode.U, function()
	local taggedObject = SceneController.Scene.GetBodyFromTag("MyRigidbody")[1].Class
	taggedObject:ApplyForce(Vector2.new(-5, 0))
end)

-- CameraController:Init()

-- task.spawn(function()
-- 	game:GetService("RunService").RenderStepped:Connect(function()
-- 		CameraController:Update()
-- 	end)
-- end)
