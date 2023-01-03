--[[

	    _              _                       _                  
	   / \     _ __   (_)  _ __ ___     __ _  | |_    ___    _ __
	  / _ \   | '_ \  | | | '_ ` _ \   / _` | | __|  / _ \  | '__|
	 / ___ \  | | | | | | | | | | | | | (_| | | |_  | (_) | | |
	/_/   \_\ |_| |_| |_| |_| |_| |_|  \__,_|  \__|  \___/  |_|

	Rethink version 0.1.0
	james_mc98

]]

type ArgumentData = {
	Value: any,
	Type: string,
}

type Animations = {
	ImageId: string,
	Size: Vector2,
	Animations: { [string]: { number } },
	Type: string?,
}

local RunService = game:GetService("RunService")

local package = script.Parent.Parent.Parent
local components = package.Components

local TypeCheck = require(components.Debug.TypeCheck)
local Promise = require(components.Library.Promise)
local DebugStrings = require(components.Debug.Strings)

-- This function calculates and returns a table with all of the offsets.
local function CalculateAnimationOffsets(animationData: { any }, animationSize: Vector2)
	local animation = {}

	-- loop trough rowdata
	for y, rows in ipairs(animationData) do
		-- calculate sprite Y
		local Y = animationSize.Y * (type(rows.r) == "number" and rows.r or y - 1)

		for x, state in ipairs(rows) do
			if state == 1 then
				local X = animationSize.X * (x - 1)
				table.insert(animation, Vector2.new(X, Y))
			end
		end
	end

	return animation
end

-- This function only allows ImageLabels and ImageButtons.
local function CheckObjectIsValid(object: any)
	local success, result = pcall(function()
		if object:IsA("ImageLabel") or object:IsA("ImageButton") then
			return true
		end

		return false
	end)

	return success and result or false
end

local Animator = {}
Animator.__index = Animator

--[=[
	Constructs a new animator.

	```lua
	local Animator = require(Rethink.Animator)
	local myAnimation = Animator.new()
	```

	@param {array} Objects - List of initial objects to apply animations to
	@constructs Animator
	@returns {animator}
]=]
function Animator.new(objects: { [number]: ImageLabel | ImageButton }?): typeof(Animator)
	local self = setmetatable({}, Animator)

	self._AnimationData = {}
	self._AnimationPointer = {}
	self._RenderHandle = nil
	self._RenderPromise = nil

	self.Framerate = 60
	self.Frame = 1
	self.MaxFrames = nil
	self.CurrentAnimation = nil
	self.Running = false
	self.Objects = type(objects) == "table" and objects or {}

	--[=[
		Very small but handy utility functions for mapping animations.
	]=]
	self.Tools = {
		--[=[
			Used to fill an entire row with ones meaning that in that specific animation all of those
			frames will be displayed.

			```lua
			local Animator = Rethink.Animator

			-- This will create a table with 5 indexes and their value set to 1
			print(Animator.Tools.PopulateRow(5))
			```

			How it looks like:
			```lua
			{1, 1, 1, 1, 1}
			```
		]=]
		["PopulateRow"] = function(iterations: number): { [number]: number }
			local array = {}

			for i = 1, iterations do
				array[i] = 1
			end

			return array
		end,

		--[=[
			Used to fill entire columns and rows with ones meaning that in that specific animation all of those
			frames will be displayed.

			Shorthand for using `Animator.Tools.PopulateRow()`.

			```lua
			local Animator = Rethink.Animator

			-- This will create 5 tables with 5 indexes and their value set to 1
			print(table.pack(Animator.Tools.PopulateColumn(5, 5)))
			```

			How it looks like:
			```lua
			{
				{1, 1, 1, 1, 1},
				{1, 1, 1, 1, 1},
				{1, 1, 1, 1, 1},
				{1, 1, 1, 1, 1},
				{1, 1, 1, 1, 1},
			}
			```
		]=]
		["PopulateColumn"] = function(columns: number, rows: number): { { [number]: { [number]: number } } }
			local arrayContainer = {}

			for i = 1, columns do
				arrayContainer[i] = self.Tools.PopulateRow(rows)
			end

			return table.unpack(arrayContainer)
		end,
	}

	return self
end

--[=[
	Used to add a spritesheet with it's own mapped animations.

	```lua
	local Animator = require(Rethink)
	local myAnimation = Animator.new()

	myAnimation:AddSpritesheet("6928232464", Vector2.new(100, 100), {
		["run"] = {
			{ 1, 1, 1, 1, 1 },
		},
	})
	
	```

	In case the animation does not start at the first row you can use r in the map table to offset it.

	```lua
	local Animator = require(Rethink)
	local myAnimation = Animator.new()

	myAnimation:AddSpritesheet("6928232464", Vector2.new(100, 100), {
		["run"] = {
			-- This should normally represent to 1st row but since there's an `r` key
			-- `Animator` will offset it by that amount.

			-- In our case this will represent the 2nd row, instead of the 1st row.
			{ r = 2, 1, 1, 1, 1, 1 },
		},
	})
	
	```
	
	@param (string) imageId - Spritesheet's id as a string
	@param (vector2) size - Size of one frame in the spritesheet
	@param (dictionary) animationFrames - Split up the spritesheet into animations by mappping it's frames
]=]
function Animator:AddSpritesheet(imageId: string, size: Vector2, animationFrames: { [string]: { [number]: number } })
	-- Simple and easy-to-use argument validator
	TypeCheck.IsWrongType(
		":AddSpritesheet",
		{ Value = imageId, Type = "string" },
		{ Value = size, Type = "Vector2" },
		{ Value = animationFrames, Type = "table" }
	):andThen(function() --> if the check is successful proceed
		local newAnimation = {
			ImageId = imageId,
			Size = size,
			Animations = {},
		}

		-- loop trough the animationFrames table
		-- get animation name and data
		for animationName, animationData in pairs(animationFrames) do
			local AnimationOffsets = CalculateAnimationOffsets(animationData, size)

			newAnimation.Animations[animationName] = AnimationOffsets
			self._AnimationPointer[animationName] = newAnimation
		end

		table.insert(self._AnimationData, newAnimation)
	end)
end

--[=[
	Adds a collection of images as an animation.

	```lua
	local Animator = require(Rethink)
	local myAnimation = Animator.new()
	
	myAnimation:AddCollection({
		["Example"] = {
			10590477428,
			8036970459,
			8425069718,
		}
	})
	```
	
	@param {dictionary} collection - List of all the animations' frames
]=]
function Animator:AddCollection(collection: { [string]: number })
	-- Simple and easy-to-use argument validator
	TypeCheck.IsWrongType(":AddCollection", { Value = collection, Type = "table" })
		:andThen(function() --> if the check is successful proceed
			local newAnimation = {
				Type = "Collection",
				Animations = {},
			}

			-- loop trough the map table 3 times
			-- get animation name and data
			for animationName, animationData in pairs(collection) do
				newAnimation.Animations[animationName] = animationData
				self._AnimationPointer[animationName] = newAnimation
			end

			table.insert(self._AnimationData, newAnimation)
		end)
end

--[=[
	Updates all of the hooked object's appearance relative to the current frame.

	@private
]=]
function Animator:_Render(animationData: Animations)
	for _, object: GuiBase2d & ImageLabel in ipairs(self.Objects) do
		local frameData: any = animationData.Animations[self.CurrentAnimation][math.floor(self.Frame)]

		-- If we're dealing with a Collection then we should not try and set the offset and size.
		if animationData.Type == "Collection" then
			-- Reset the offset and size if we previously used a spritesheet
			object.ImageRectSize = Vector2.new(0, 0)
			object.ImageRectOffset = Vector2.new(0, 0)
			object.Image = ("rbxassetid://%d"):format(frameData)

			continue
		end

		-- Set ImageId and Size to the animation's values
		if object.Image ~= "rbxassetid://" .. animationData.ImageId then
			object.Image = "rbxassetid://" .. animationData.ImageId
			object.ImageRectSize = animationData.Size
		end

		-- Apply the current frame now that we set up the object to the
		-- right size and image
		object.ImageRectOffset = frameData
	end
end

--[=[
	Cancels the rendering .RenderStepped created by :Play if it exists.

	@private
]=]
function Animator:_CancelRender()
	if self._RenderHandle then
		self._RenderHandle:Disconnect()
		self._RenderHandle = nil
	end
end

--[=[
	Plays the selected animation infinitely.
	The speed of the animation stays independant of the framerate of the player.

	```lua
	local Animator = require(Rethink)
	local myAnimation = Animator.new()

	myAnimation:AddSpritesheet("6928232464", Vector2.new(100, 100), {
		["run"] = {
			-- This should normally represent to 1st row but since there's an `r` key
			-- `Animator` will offset it by that amount.

			-- In our case this will represent the 2nd row, instead of the 1st row.
			{ 1, 1, 1, 1, 1 },
		},
	})

	myAnimation:AttachObject(path.to.your.object)

	myAnimation:Play()
	```

	@returns {Promise} Used to make the code asynchronous but can be synchronous using :await()
]=]
function Animator:Play(): typeof(Promise.new())
	return Promise.new(function(resolve, reject)
		-- TODO: clean this up
		-- currently this looks really messy but I'll clean it up eventaully
		if not self.CurrentAnimation then
			reject(DebugStrings.Animator.NoAnimation)
		elseif not self.Objects[1] then
			reject(DebugStrings.Animator.NoObjectsAttached)
		end

		resolve()
	end)
		:andThen(function()
			self.Running = true
			local animationData: Animations = self._AnimationPointer[self.CurrentAnimation]

			self:_CancelRender()
			self._RenderHandle = RunService.RenderStepped:Connect(function(deltaTime: number)
				-- Check if the animation changed while playing a different animation
				if animationData ~= self._AnimationPointer[self.CurrentAnimation] then
					animationData = self._AnimationPointer[self.CurrentAnimation]
				end

				-- Check all attached objects that they still exist in the game
				self:CleanupObjects()

				-- This works I'm so happy :)
				-- It's currently 1 AM and I'm still writing this but I'm just really happy
				-- That the animation here is independant of the framerate
				self.Frame += self.Framerate * deltaTime

				-- Fixed the last frame getting skipped
				-- Reset the Frame Counter if it's above the size of the Animation Data
				-- Also it's important to remove 1 from it
				if self.Frame - 1 > #animationData.Animations[self.CurrentAnimation] then
					self.Frame = 1
				end

				self:_Render(animationData)
			end)
		end)
		:catch(warn)
end

--[=[
	Stops the looping animation if previously `:Play` has been called.

	```lua
	local Animator = require(Rethink)
	local myAnimation = Animator.new()

	myAnimation:AddSpritesheet("6928232464", Vector2.new(100, 100), {
		["run"] = {
			{ 1, 1, 1, 1, 1 },
		},
	})

	myAnimation:AttachObject(path.to.your.object)

	myAnimation:Play()

	task.wait(5)

	myAnimation:Stop()
	```
]=]
function Animator:Stop()
	if self.Running then
		self.Running = false

		self:_CancelRender()
	end
end

--[=[
	Sets the framerate of the animation to the desired amount.

	```lua
	local Animator = require(Rethink)
	local myAnimation = Animator.new()

	myAnimation:AddSpritesheet("6928232464", Vector2.new(100, 100), {
		["run"] = {
			-- This should normally represent to 1st row but since there's an `r` key
			-- `Animator` will offset it by that amount.

			-- In our case this will represent the 2nd row, instead of the 1st row.
			{ 1, 1, 1, 1, 1 },
		},
	})

	myAnimation:AttachObject(path.to.your.object)

	myAnimation:Play()

	task.wait(1)

	myAnimation:SetFramerate(1)
	```

	@param {number} framerate - Speed which the animation will get played (common values are 60 or 30)
	@default {framerate} 60 FPS
]=]
function Animator:SetFramerate(framerate: number)
	TypeCheck.IsWrongType(":SetFramerate", { Value = framerate, Type = "number" }):andThen(function()
		self.Framerate = framerate
	end)
end

--[=[
	Increments the `Frame` value by 1 and updates all of the hooked objects.
	`:NextFrame` is useful if you want you animation to play a certain amount of times.

	```lua
	local Animator = require(Rethink)
	local myAnimation = Animator.new()

	myAnimation:AddSpritesheet("6928232464", Vector2.new(100, 100), {
		["run"] = {
			-- This should normally represent to 1st row but since there's an `r` key
			-- `Animator` will offset it by that amount.

			-- In our case this will represent the 2nd row, instead of the 1st row.
			{ 1, 1, 1, 1, 1 },
		},
	})

	myAnimation:AttachObject(path.to.your.object)

	myAnimation:NextFrame()
	```
]=]
function Animator:NextFrame()
	if not self.Objects[1] then
		return warn(DebugStrings.Animator.NoObjectsAttached)
	elseif self.Running then
		return warn((DebugStrings.Animator.AnimationRunning):format(":NextFrame()"))
	end

	-- Check all attached objects that they still exist in the game
	self:CleanupObjects()

	local animationData: Animations = self._AnimationPointer[self.CurrentAnimation]
	-- Increment the Frame value and if it's more than the actual frames in the
	-- animation then reset it to 1
	self.Frame += 1

	if self.Frame > #animationData.Animations[self.CurrentAnimation] then
		self.Frame = 1
	end

	self:_Render(animationData)

	return
end

--[=[
	Decrements the `Frame` value by 1 and updates all of the hooked objects.
	`:PreviousFrame` is useful if you want you animation to play a certain amount of times but backwards.

	```lua
	local Animator = require(Rethink)
	local myAnimation = Animator.new()

	myAnimation:AddSpritesheet("6928232464", Vector2.new(100, 100), {
		["run"] = {
			-- This should normally represent to 1st row but since there's an `r` key
			-- `Animator` will offset it by that amount.

			-- In our case this will represent the 2nd row, instead of the 1st row.
			{ 1, 1, 1, 1, 1 },
		},
	})

	myAnimation:AttachObject(path.to.your.object)

	myAnimation:PreviousFrame()
	```
]=]
function Animator:PreviousFrame()
	if not self.Objects[1] then
		return warn(DebugStrings.Animator.NoObjectsAttached)
	elseif self.Running then
		return warn((DebugStrings.Animator.AnimationRunning):format(":PreviousFrame()"))
	end

	-- Check all attached objects that they still exist in the game
	self:CleanupObjects()

	local animationData: Animations = self._AnimationPointer[self.CurrentAnimation]
	-- Increment the Frame value and if it's more than the actual frames in the
	-- animation then reset it to 1
	self.Frame -= 1

	if self.Frame < 1 then
		self.Frame = self.MaxFrames
	end

	self:_Render(animationData)

	return
end

--[=[
	Hooks an ImageLabel or ImageButton and adds it to the `Objects` array. 
	Resulting in the object getting updates and showing the current frame.

	If no objects have been attached to the current `Animator handler` it will throw a warning!

	```lua
	local Animator = require(Rethink)
	local myAnimation = Animator.new()

	myAnimation:AddSpritesheet("6928232464", Vector2.new(100, 100), {
		["run"] = {
			-- This should normally represent to 1st row but since there's an `r` key
			-- `Animator` will offset it by that amount.

			-- In our case this will represent the 2nd row, instead of the 1st row.
			{ 1, 1, 1, 1, 1 },
		},
	})

	myAnimation:AttachObject(path.to.your.object)
	```

	@param {imagelabel | imagebutton} object - Object to apply the animation to
]=]
function Animator:AttachObject(object: ImageLabel | ImageButton)
	if not CheckObjectIsValid(object) then
		return warn((DebugStrings.Animator.NotValidObject):format(object.Name))
	end
	if table.find(self.Objects, object) then
		return warn(DebugStrings.Animator.ObjectAlreadyAttached)
	end

	object.Destroying:Connect(function()
		self:DetachObject(object)
	end)

	table.insert(self.Objects, object)

	return
end

--[=[
	Removes the given object from the Objects list, resulting in the animations not being
	played on them anymore.

	@param {imagelabel | imagebutton} object - Object to remove from the list
]=]
function Animator:DetachObject(object: ImageLabel | ImageButton)
	if not CheckObjectIsValid(object) then
		return warn((DebugStrings.Animator.NotValidObject):format(object.Name))
	end

	local isAttached = table.find(self.Objects, object)

	if isAttached then
		table.remove(self.Objects, isAttached)
	end

	return warn(DebugStrings.ObjectIsNotAttached)
end

--[=[
	Cleans up all of the objects that had :Destroy() called.

	This is required to prevent a memory leak. Because GC does not delete objects if they have been
	referenced here.
	
	@private
]=]
function Animator:CleanupObjects()
	for index, v: ImageLabel | ImageButton | Instance in ipairs(self.Objects) do
		if not v:IsDescendantOf(game) then
			table.remove(self.Objects, index)
		end
	end
end

--[=[
	Changes the animation data to the set value.

	```lua
	local Animator = require(Rethink)
	local myAnimation = Animator.new()

	myAnimation:AddSpritesheet("6928232464", Vector2.new(100, 100), {
		["run"] = {
			-- This should normally represent to 1st row but since there's an `r` key
			-- `Animator` will offset it by that amount.

			-- In our case this will represent the 2nd row, instead of the 1st row.
			{ 1, 1, 1, 1, 1 },
		},
	})

	myAnimation:AttachObject(path.to.your.object)

	local s, err = pcall(function()
		myAnimation:Play() --> will throw an error, because there is no animation was specified
	end)

	myAnimation:ChangeAnimation("run")

	myAnimation:Play() --> this won't throw an error now since we specified which animation `Animator` should play

	```

	@param {string} animationName - Name of the animation to play
]=]
function Animator:ChangeAnimation(animationName: string)
	TypeCheck.IsWrongType(":ChangeAnimation", { Value = animationName, Type = "string" }):andThen(function()
		if self._AnimationPointer[animationName] then
			self:_CancelRender()

			self.CurrentAnimation = animationName
			self.MaxFrames = #self._AnimationPointer[animationName].Animations[self.CurrentAnimation]

			if self.Running then
				self:Play()
			end
		end
	end)
end

--[=[
	Clears all the objects and animations from the memory saved by Animaotor
]=]
function Animator:ClearAnimationData()
	table.clear(self._AnimationPointer)
	table.clear(self._AnimationData)
	table.clear(self.Objects)
end

-- Getter functions

function Animator:GetCurrentAnimation()
	local animationData: Animations = self._AnimationPointer[self.CurrentAnimation]
	return animationData.Animations[self.CurrentAnimation]
end

function Animator:GetCurrentFrame()
	return self.Frame
end

function Animator:GetFramerate()
	return self.Framerate
end

function Animator:GetMaxFrames()
	return self.MaxFrames
end

function Animator:GetObjects()
	return self.Objects
end

------------------------------------------

--[=[
	Destroys the Animator class

	@destructor Animator
]=]
function Animator:Destroy()
	self:_CancelRender()
	self:ClearAnimationData()
	table.clear(self.Objects)
	table.clear(self)
	setmetatable(self, nil)
end

return Animator
