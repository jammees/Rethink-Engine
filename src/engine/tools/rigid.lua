--[[

    Rigid is simply a wrapper for Nature2D's rigidbodies
    It adds the ability to retreive rigid bodies from any script
    And sets some properties automatically


    Properties:

    Must have:
        Object: GuiBase2D

    Optinal:
        Class: string -> what type of instance to create
        Collidable: boolean -> if missing, default is: true
        Anchored: boolean -> if missing, default is: false
        LifeSpan: number
        KeepInCanvas: boolean
        Gravity: Vector2
        Friction: number
        AirFriction: number
        

    Functions:

        rigid.makeRigid(idx, properties)
            > makes an already existing ui part rigid

        rigid.defineNew(idx, properties)
            > creates a new ui part, that will be rigid
            > properties:
                > Must have these:
                    Collidable: boolean
                    Anchored: boolean
                > Rest of the properties can be registered like this:
                    Like you would make a new instance in a script
                    Example of a properties table:
                        {

                            -- how your instance will look like
                            Size = UDim2.fromScale(1,1)
                            Image = YOUR IMAGE URL HERE
                        }

]]

local HTTPService = game:GetService("HttpService")

local engine = nil
local canvas = nil
local savedRigidbodies = {}
local defaultSettings = {
    ["Collidable"] = true,
    ["Anchored"] = false,
}

local function applyDefaultSettings(properties)
    local array = properties

    for defName, defVal in pairs(defaultSettings) do
        for propName, _ in pairs(array) do
            if propName == defName then
                return
            end
        end
        array[defName] = defVal
    end

    return array
end

local rigid = {}


function rigid.makeRigid(idx, properties, keepInCanvas)
    assert(typeof(idx) ~= "number", "Expected number got: "..typeof(idx))
    applyDefaultSettings(properties)


    properties.Object.Parent = canvas
    local rigidBody = engine:Create("RigidBody", properties)
    rigidBody:KeepInCanvas(keepInCanvas or true)

    savedRigidbodies[#savedRigidbodies + 1] = {
        id = idx,
        rigidBody = rigidBody,
    }
end

function rigid.defineNew(idx, properties, keepInCanvas)
    if not idx then
        idx = HTTPService:GenerateGUID(false)
    end

    local newInstance = nil
    -- check if there is an image property, if so the instance will be an image label, else frame
    if properties.Class then
        newInstance = Instance.new(properties.Class)
        properties["Class"] = nil
    else
        if properties.Image then
            newInstance = Instance.new("ImageLabel")
        else
            newInstance = Instance.new("Frame")
        end
    end

    -- construct the instance
    for propertyName, value in pairs(properties) do
        pcall(function()
            newInstance[propertyName] = value
            properties[propertyName] = nil
        end)
    end

    -- set it up
    properties.Object = newInstance
    rigid.makeRigid(idx, properties, keepInCanvas)
end


function rigid:get(id)
    for _, array in ipairs(savedRigidbodies) do
        if array.id == id then
            return array.rigidBody
        end
    end
end

-- dont use this!
function rigid:_setEngine(engineInstance, canvasInstance)
    engine = engineInstance
    canvas = canvasInstance
end




return rigid