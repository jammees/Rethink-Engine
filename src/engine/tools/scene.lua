--[[

    Scene
    A gui object reconstructor/deconstructor from tables

    ________________________________________________________________________________________________________

    [!] Disclaimer: Recommended to use the level editor plugin for RethinkEngine!
    As it makes it way much easier to create levels, that are after exporting ready to play!

    However, you're not forced to use it.
    ________________________________________________________________________________________________________



    API:

    scene.load(JSON LEVEL DATA)
    scene.onLoad() -> signal class -> fires when it finished loading
    scene.onFlush() -> signal class -> fires when it flushed the map
    scene.getCurrent() -> returns the current level's name
    scene.flush() -> deletes the level
    scene.deleteOnFlush(object) -> deletes that object when scene.flush() is called
]]

local package = script.Parent.Parent
local components = package.components
local tools = package.tools

local signal = require(components.Signal)
local rigid = require(tools.rigid)
local globals = require(package.globals)

-- get globals
local layer = globals.get("layer")

-- gui object reference table for later deleting them
local sceneObjects = {}
local sceneName = "null"

local scene = {}

-- signals
scene.onLoad = signal.new()
scene.onFlush = signal.new()

-- funstions

--[[
    
    JSON architecture

    JSON TABLE {
        layers {
            design
        } 
        rigids {
            collider {
                rigid bodies tha are anchored
            }
            body {
                rigid bodies that are unanchored
            }
        }
        misc {
            hitboxes
        }
    }



]]

local function reconstructInstance(data)
    local editedData = data
    local obj = Instance.new(data.Type)
    data.type = nil
    for property, value in pairs(data) do
        pcall(function()
            obj[property] = value
            editedData[property] = nil
        end)
    end
    obj.Parent = layer

    return {
        inst = obj,
        is = function()
            return "layer"
        end
    }
end

local function addToHolder(value)
    sceneObjects[#sceneObjects + 1] = value
end


function scene.load(json)
    local info = json.data
    local layers = json.layers
    local rigids = json.rigids

    sceneName = info.name

    -- load in the layers
    for _, data in ipairs(layers) do
        addToHolder(reconstructInstance(data))
    end

    -- load in the rigid bodies
    for name, arrayData in pairs(rigids) do
        for _, data in ipairs(arrayData) do
            -- check if its a collider, if so anchor it
            if name == "hitbox" then
                data["Anchored"] = true
            end

            addToHolder(rigid.defineNew(nil, data, true))
        end
    end

    scene.onLoad:Fire()
end

function scene.deleteOnFlush(object)
    if sceneName == "null" then return end
    addToHolder(object)
end

function scene.flush()
    if #sceneObjects == 0 then return print("Cannot flush empty table!") end

    for _, table in ipairs(sceneObjects) do
        if typeof(table) == "table" then
            local tableIs = table.is()
            if tableIs == "rigidbody" then
                table:Destroy()
            elseif tableIs == "layer" then
                table.inst:Destroy()
            else
                -- assumes, that the 'table' is a gui object
                table:Destroy()
            end
        end
    end
    sceneName = "null"
    table.clear(sceneObjects)

    scene.onFlush:Fire()
end

-- getter
function scene.getCurrent()
    return sceneName
end

return scene