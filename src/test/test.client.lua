local rethinkEngine = require(game:GetService("ReplicatedStorage").RethinkEngine)
local rigid = rethinkEngine.rigid
local sceneManager = rethinkEngine.scene
local engine = rethinkEngine.physics

local inputs = rethinkEngine.inputs
local current = inputs.current


current:Connect(function(inputType)
    warn(inputType)
end)



-- test out rigid bodies
local mouse = game.Players.LocalPlayer:GetMouse()
mouse.Button2Down:Connect(function()
    sceneManager.deleteOnFlush(rigid.defineNew(game:GetService("HttpService"):GenerateGUID(false), {
        Size = UDim2.fromOffset(100, 100),
        Position = UDim2.fromOffset(mouse.X, mouse.Y),
        BackgroundColor3 = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
    }))
end)


-- test scene
sceneManager.load(
{
    data = {
        name = "myTestMap"
    },
    layers = {
        {
            BackgroundColor3 = Color3.fromRGB(25, 158, 2),
            Position = UDim2.fromScale(0.5, 1),
            AnchorPoint = Vector2.new(0.5, 0),
            Size = UDim2.fromScale(0.3,0.3),
            Type = "Frame",
        }
    },
    rigids = {
        hitbox = {
            {
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Position = UDim2.fromScale(0.5, 0.9),
                AnchorPoint = Vector2.new(0.5, 1),
                Size = UDim2.new(1, 0, 0, 36),
            },
            {
                BackgroundColor3 = Color3.fromRGB(159, 159, 159),
                Position = UDim2.fromScale(0.5, 0.5),
                AnchorPoint = Vector2.new(0.5, 1),
                Size = UDim2.fromScale(0.3,0.2),
            }
        },
        body = {
            {
                BackgroundColor3 = Color3.fromRGB(234,123,231),
                Position = UDim2.fromOffset(50, 60),
                Size = UDim2.fromOffset(100, 100),

                --inCanvas = false
            }
        },
    },
    misc = {},
})

game:GetService("UserInputService").InputBegan:Connect(function(key)
    if key.KeyCode == Enum.KeyCode.S then
        print("Pressed: 'S' | started engine!")
        engine:Start()
    elseif key.KeyCode == Enum.KeyCode.D then
        print("Flushed level!")
        sceneManager.flush()
    end
end)