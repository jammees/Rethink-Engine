--[[

    LevelManager
    Loads in the levels from JSON, so the level data is much shorter and takes less memory, than a normal
    table.

    ________________________________________________________________________________________________________
    [!] Disclaimer: You have to use the level editor plugin for RethinkEngine!
    As it uses JSON instead of tables. It also makes it a whole lot easier to create levels, edit colliders,
    properties.

    However, if you can't use the plugin here's a workaround for that:

    In the module there is a function called defineNew(level name, level gui)

        the level gui's hierarchy should look like this:

            myMainGame
                > rigids: frame
                    > all of the guis that are rigid, or can collide with rigid bodies
                > laters: fra,e
                    > layer1: frame
                        > contains every gui that are on the same zindex
                    > layer2: fra,e
                    > and so on

    ________________________________________________________________________________________________________

    

    Setup:

    1. Create a folder named Scenes in replicated storage!
        > this will be the holder of the module scripts that will have the JSON LEVEL DATA

    2. After made a level, create a module script
        > Source:
            return JSON LEVEL DATA

    3. After this, simply use this module to load the level in!


    API:

    LevelManager.load(JSON LEVEL DATA)
    LevelManager.onLoad() -> signal class -> fires when it finished loading
    LevelManager.onFlush() -> signal class -> fires when it flushed the map
    LevelManager.defineNew(level name, level data)
    LevelManager.getCurrent() -> returns the current level's name
    LevelManager.flush() -> deletes the level

]]

local HttpService = game:GetService("HttpService")

local package = script.Parent.Parent
local components = package.components
local tools = package.tools

local signal = require(components.Signal)
local rigid = require(tools.rigid)
local globals = require(package.globals)

-- globals
local canvas = globals.get("canvas")
local layer = globals.get("layer")

local LevelManager = {}

-- signals
LevelManager.onLoad = signal.new()
LevelManager.onFlush = signal.new()

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
    local obj = Instance.new(data.type)
    data.type = nil
    for property, value in pairs(data) do
        pcall(function()
            obj[property] = value
            editedData[property] = nil
        end)
    end
    obj.Parent = layer

    return obj, editedData
end

function LevelManager.load(json)
    local layers = json.layers
    local misc = json.misc
    local rigids = json.rigids

    print("Loading in: layers")
    for _, data in ipairs(layers) do
        local obj, newData = reconstructInstance(data)
    end

    print("Finished loding in: layers")
    print("Loading in: rigids")

    for name, arrayData in pairs(rigids) do
        for _, data in ipairs(arrayData) do
            -- check if its a collider, if so anchor it
            if name == "collider" then
                data["Anchored"] = true
            end

            rigid.defineNew(nil, data, false)
        end
    end
end



return LevelManager