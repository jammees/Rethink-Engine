-- Add a "OriginalPosition" property to the ObjectData table
type ObjectData = {
    Object: GuiBase2d | { any },
    IsRigidbody: boolean,
    OriginalPosition: UDim2
}

local Scene = require(script.Parent.Scene)

local prePosition = Vector2.new(0, 0)

local Camera = {}

Camera.Position = Vector2.new(0, 0)
Camera.Objects = {}

-- Store the original position of the object when it is attached to the camera
function Camera.Attach(object: GuiBase2d | {any}) 
    local isRigidbody = Scene.IsRigidbody(object)
    table.insert(Camera.Objects, {
        Object = object,
        IsRigidbody = isRigidbody,
        OriginalPosition = isRigidbody and object:GetFrame().Position or object.Position
    })

    warn(Camera.Objects)
end

-- Calculate the new position of the object based on its original position and the camera's movement
function Camera.Render() 
    for _, objectData: ObjectData in ipairs(Camera.Objects) do
        -- Calculate the movement of the camera since the last update
        local cameraMovement = Camera.Position - prePosition

        -- Calculate the new position of the object by adding the camera movement to its original position
        local newPosition = objectData.OriginalPosition + UDim2.fromOffset(cameraMovement.X, cameraMovement.Y)

        if objectData.IsRigidbody then
            local vertexForces = {}

            for _, vertex in ipairs(objectData.Object:GetVertices()) do
                vertexForces[vertex.id] = vertex.forces
            end

            objectData.Object:SetPosition(newPosition.X.Offset, newPosition.Y.Offset)

            for _, vertex in ipairs(objectData.Object:GetVertices()) do
                vertex:ApplyForce(vertexForces[vertex.id])
            end

            objectData.OriginalPosition = newPosition

            continue
        end

        -- Use the ChangePosition method to directly set the new position for the object
        objectData.Object.Position = newPosition
        objectData.OriginalPosition = newPosition
    end

    prePosition = Camera.Position
end

function Camera.RenderRigidbodies(rigidbodies: {any})
    for _, rigidbody: any in ipairs(rigidbodies) do
         -- Calculate the movement of the camera since the last update
         local cameraMovement = Camera.Position - prePosition
         
         local object = rigidbody:GetFrame()

         -- Calculate the new position of the object by adding the camera movement to its original position
         local newPosition = object.Position + UDim2.fromOffset(cameraMovement.X, cameraMovement.Y)

         rigidbody:SetPosition(newPosition.X.Offset, newPosition.Y.Offset)
    end
end

function Camera.Detach() end

function Camera.MoveTo(x: number, y: number) 
    -- Update the prePosition variable with the current position of the camera
    prePosition = Camera.Position
    Camera.Position = Vector2.new(x, y)

    warn(x, y)
end

function Camera.Zoom() end

return Camera
