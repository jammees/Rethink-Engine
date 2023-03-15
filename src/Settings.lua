--[[
	Here are the settings that you can configure to your liking.
	Some are recommended to leave as is, if you are unsure about it. Such as the InitialilCache of
	the pool.

	I's recommended to change the lighting technology to compatibility!
]]

return {
	-- Here are all of the settings that are related to rendering
	-- CoreGuis can be disabled here as well as some optimizations related to the camera and lighting
	Rendering = {
		Disable3DRendering = true, -- Minimizes the time ROBLOX takes rendering the 3D world
		DisablePlayerCharacters = true, -- Deletes all players's characters
		OptimizeLighting = true, -- Disables lighting as mush as possible and changes time to have a more pleasent natural background
		EnableCoreGuis = {
			EmotesMenu = false,
			PlayerList = false,
			SelfView = false,
			Backpack = false,
			Health = false,
			Chat = false,
		},

		-- PROTOTYPE
		-- RECOMMENDED TO KEEP IT ON FALSE
		CullGuiElements = false, -- Culls out every object that is out of the screen or is obstructed prototype V1 // finished but laggy and unefficient
		Prototype_GuiCulling_v2 = false, -- Culls out every object that is out of the screen or is obstructed prototype V2
	},

	-- Here are all of the settings that are related to the pool
	-- Pool is a module that pre-creates objects for scene for example
	-- This is another optimization becase creating and destroying objects are really inefficient
	Pool = {
		-- How many objects will be created and added to the pool on start
		InitialCache = {
			ImageLabel = 100,
			TextLabel = 100,
			TextButton = 50,
			ImageButton = 50,
			TextBox = 50,
			ScrollingFrame = 5,
			ViewportFrame = 5,
			Frame = 100,
		},

		ExtensionSize = 10, -- How many objects should be created to refill the pool if there are no available ones
	},

	CompilerChunkSize = 100,
	ViewportColor = Color3.fromRGB(35, 68, 139),

	-- Here are all of the settings related to the physics engine
	-- The physics engine is Nature2D by jaipack17
	Physics = {
		-- Optimization to more efficiently find rigidbodies
		QuadTreesEnabled = true,
		-- How accure the collision detection should be.
		-- Higher value results in more precise collisions but at the cost of framerate
		-- Value can be between 1 to 10
		CollisionIteration = 4,
		-- How many times should constraints get updated
		-- Value can be between 1 to 10
		-- Higher value results in better responding constraints but at the cost of framerate
		ConstraintIteration = 3,

		-- TODO: add setting to toggle dynamic Iteration based on the number of rigidbodies
	},

	-- Here are all of the settings related to the console
	-- These settings are mostly here for debugging purposes
	Console = {
		LogHeader = true, -- Print the big header to the console that states that you are using Rethink
		LogOnPropertyFail = true, -- Warn if a property can not be applied to an object
	},

	-- after done rendering the camera
	-- Unsure if it should be kept in
	prototype_EnablePhysicsCameraLoop = true,
}
