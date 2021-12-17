--[[

    RethinkEngine                                      @JamRBX

    Version: 0.5.0 - ALPHA
    Description: A simple yet useful 2D game engine for roblox

    Recommened to use a ui library for creating uis for your game, such as Roact or Fusion

]] 

-- get tools
local started = false

local components = script:WaitForChild("components")

local tools = script:WaitForChild("tools")
local nature2D = require(tools.physics)

-- get player gui
local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- SET UP NATURE 2D
--------------------------------------------------------------------------------------------
-- set up game frame
local gameFrame = nil
local renderFrame = nil
local canvas = nil
local layer = nil
local hud = nil

--// modules
local engine = nil
local rigid = nil
local globals = require(script.globals)

if not playerGui:FindFirstChild("gameFrame") then
    gameFrame = Instance.new("ScreenGui")
    gameFrame.Name = "gameFrame"
    gameFrame.IgnoreGuiInset = true
    gameFrame.ResetOnSpawn = false
    gameFrame.Parent = playerGui

    -- set up a scrolling frame for the whole level
    renderFrame = Instance.new("ScrollingFrame")
    renderFrame.Name = "renderFrame"
    renderFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    renderFrame.Position = UDim2.fromScale(0.5, 0.5)
    renderFrame.Size = UDim2.fromScale(1, 1)
    renderFrame.CanvasSize = UDim2.new(0, 0, 0, 0) -- [!] Not to self: Remove this after testing level loading!
    renderFrame.Transparency = 1
    renderFrame.BorderSizePixel = 0
    renderFrame.Parent = gameFrame

    -- set up canvas for Nature2D
    canvas = Instance.new("Frame")
    canvas.Name = "canvas"
    canvas.AnchorPoint = Vector2.new(0.5, 0.5)
    canvas.Position = UDim2.fromScale(0.5, 0.5)
    canvas.Size = UDim2.fromScale(1, 1)
    canvas.Transparency = 1
    canvas.Parent = renderFrame

    -- setup a frame to hold ui elements
    hud = Instance.new("Frame")
    hud.Name = "ui"
    hud.AnchorPoint = Vector2.new(0.5, 0.5)
    hud.Position = UDim2.fromScale(0.5, 0.5)
    hud.Size = UDim2.fromScale(1, 1)
    hud.Transparency = 1
    hud.Parent = renderFrame

    -- set up a frame for holding the parts that don't interact with Nature2D
    layer = Instance.new("Frame")
    layer.Name = "layer"
    layer.AnchorPoint = Vector2.new(0.5, 0.5)
    layer.Position = UDim2.fromScale(0.5, 0.5)
    layer.Size = UDim2.fromScale(1, 1)
    layer.Transparency = 1
    layer.Parent = renderFrame
end

if not started then
    started = true

    -- initiate it
    engine = nature2D.init(gameFrame)
    engine.canvas.frame = canvas
    --------------------------------------------------------------------------------------------

    -- run the engineSettings
    require(components.engineSettings)
    
    -- setup some tools
    rigid = require(tools.rigid)
    rigid:_setEngine(engine, canvas)

    -- setup some globals
    globals.set("window", gameFrame)
    globals.set("render", renderFrame)
    globals.set{"canvas", canvas}
    globals.set("layer", layer)
    globals.set("hud", hud)
    globals.set("physics", engine)
end

return {
    physics = engine,
    rigid = rigid,
    scene = require(tools.scene),
    inputs = require(tools.inputs),

    gameWindow = gameFrame,
    gameRender = renderFrame,
    canvas = canvas,
    layer = layer,
    hud = hud,
}
