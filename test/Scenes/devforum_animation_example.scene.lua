---@module src.init
local Rethink = require(game:GetService("ReplicatedStorage").Rethink)
local Modules = Rethink.GetModules()
local Scene = Modules.Scene
local Symbols = Scene.Symbols
local Animator = Modules.Animator

-- Load in a scene
-- Create a layer container, inside that create a Box
-- Scene.Load({
-- 	Name = "awetawetawet",
-- 	My_Container = {
-- 		[Symbols.Type] = "Layer",

-- 		Box = {
-- 			Class = "ImageButton",
-- 			AnchorPoint = Vector2.new(0.5, 0.5),
-- 			Position = UDim2.fromScale(0.5, 0.5),
-- 			Size = UDim2.fromOffset(100, 100),
-- 			Image = "rbxassetid://30115084",

-- 			[Symbols.Tag] = "Box",
-- 		},
-- 	},
-- })

-- Scene.Load(require(script.Parent["Test.scene"]))

Scene.Load({
	Name = "Animation",
	{
		[Symbols.Type] = "UIBase",

		MyAnimatedObject = {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(100, 100),

			[Symbols.Class] = "ImageLabel",
			[Symbols.Tag] = "Animated",
		},
	},
})

-- Create our animation class
local MyAnimation = Animator.new(Scene.GetFromTag("Animated"))

-- Create a new animation with a spriteshett
-- MyAnimation:AddSpritesheet(YOUR_IMAGE_ID_HERE, Vector2.new(73, 73), {})
-- 							  ~~~~~~~~~~~~~~~~~~  ~~~~~~~~~~~~~~~~~~~  ~~~
--							  image id		      cell size	           animations
MyAnimation:AddSpritesheet("10773638196", Vector2.new(73, 73), {
	["MyAnimation"] = {
		MyAnimation.Tools.PopulateColumn(13, 13, 6),
	},
})

MyAnimation:ChangeAnimation("MyAnimation")
MyAnimation:SetFramerate(24)
MyAnimation:Play()

return { Name = "AnimationThingy" }
