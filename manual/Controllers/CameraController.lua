local UserInputService = game:GetService("UserInputService")
local CollectionService = game:GetService("CollectionService")

local Rethink = require(game:GetService("ReplicatedStorage").RethinkEngine)
local Camera = Rethink.Camera

local CameraController = {}
CameraController.X = 0
CameraController.Y = 0

function CameraController:ProcessInput()
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.W then
            print("W")
            self.Y += 5
        elseif input.KeyCode == Enum.KeyCode.S then
            print("S")
            self.Y -= 5
        elseif input.KeyCode == Enum.KeyCode.A then
            print("A")
            self.X -= 5
        elseif input.KeyCode == Enum.KeyCode.D then
            print("D")
            self.X += 5
        end

        warn(self.X, self.Y)
    end)
end

function CameraController:Update()
    Camera:MoveTo(Vector2.new(self.X, self.Y))
    -- Camera:MoveTo(UDim2.fromOffset(self.X, self.Y))
end

function CameraController:Init()
    local zoomAmount = Instance.new("NumberValue")
    zoomAmount.Name = "Zoom"
    zoomAmount.Parent = workspace
    
    zoomAmount:GetPropertyChangedSignal("Value"):Connect(function()
        Camera:Zoom(zoomAmount.Value)
    end)

    local box = CollectionService:GetTagged("Box")[1]
    local cone = CollectionService:GetTagged("Cone")[1]
    
    Camera:Attach(box)    

    self:ProcessInput()
end

return CameraController