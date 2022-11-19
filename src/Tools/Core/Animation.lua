--[[

	 _              _                       _                  
    / \     _ __   (_)  _ __ ___     __ _  | |_    ___    _ __ 
   / _ \   | '_ \  | | | '_ ` _ \   / _` | | __|  / _ \  | '__|
  / ___ \  | | | | | | | | | | | | | (_| | | |_  | (_) | | |   
 /_/   \_\ |_| |_| |_| |_| |_| |_|  \__,_|  \__|  \___/  |_|  

 Standalone version 0.1.0 - dev
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

local Promise = require(script.Promise)
--local Argument = require(script.Argument)
local ConsoleErrors = require(script.ConsoleErrors)

local function ValidateArguments(LogContainer: string, ...)
	local logs = ConsoleErrors[LogContainer]
	local checks = table.pack(...)
	local passes = 0

	return Promise.new(function(resolve, reject)
		for index, argumentData: ArgumentData in ipairs(checks) do
			if typeof(argumentData.Value) ~= argumentData.Type then
				reject((logs["Invalid" .. tostring(index)]):format(typeof(argumentData.Value)))
			end

			passes += 1
		end

		if passes >= #checks then
			resolve()
		end
	end):catch(warn)
end

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

-- Restrictions:
-- ImageLabel
-- ImageButton
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

function Animator.new(objects: { [number]: ImageLabel | ImageButton }?)
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
			local Animator = this.module

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
			local Animator = this.module

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
	local Animator = this.module

	Animation:AddSpritesheet("6928232464", Vector2.new(100, 100), {
		["run"] = {
			{ 1, 1, 1, 1, 1 },
		},
	})
	
	```

	In case the animation does not start at the first row you can use r in the map table to offset it.

	```lua
	local Animator = this.module

	Animation:AddSpritesheet("6928232464", Vector2.new(100, 100), {
		["run"] = {
			-- This should normally represent to 1st row but since there's an `r` key
			-- `Animator` will offset it by that amiunt.

			-- In our case this will represent the 2nd row, instead of the 1st row.
			{ r = 2, 1, 1, 1, 1, 1 },
		},
	})
	
	```

	@param (imageId: string) - the spritesheet's id as a string \n
	@param (size: vector2) - the size of one frame in the spritesheet
	@param (map: table) - assign the spritesheet's frames into different animations
]=]
function Animator:AddSpritesheet(imageId: string, size: Vector2, map: { [string]: { [number]: number } })
	-- Simple and easy-to-use argument validator
	ValidateArguments(
		"AddSpritesheet",
		{ Value = imageId, Type = "string" },
		{ Value = size, Type = "Vector2" },
		{ Value = map, Type = "table" }
	):andThen(function() --> if the check is successful proceed
		local newAnimation = {
			ImageId = imageId,
			Size = size,
			Animations = {},
		}

		-- loop trough the map table 3 times
		-- get animation name and data
		for animationName, animationData in pairs(map) do
			local AnimationOffsets = CalculateAnimationOffsets(animationData, size)

			newAnimation.Animations[animationName] = AnimationOffsets
			self._AnimationPointer[animationName] = newAnimation
		end

		table.insert(self._AnimationData, newAnimation)
	end)
end

--[[
	Animator:AddCollection(size: vector2, map: table)

	Animator:AddImages(Vector2.new(50,50), {
		["Hello world"] = {
			123,
			1234,
			12345,
		}
	})
]]
function Animator:AddCollection(collection: { [string]: number })
	-- Simple and easy-to-use argument validator
	ValidateArguments("AddImages", { Value = collection, Type = "table" }):andThen(
		function() --> if the check is successful proceed
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

			warn(newAnimation)
		end
	)
end

--[=[
	Updates all of the hooked object's appearance relative to the current frame.

	@private
]=]
function Animator:_Render(animationData: Animations)
	for _, object: ImageLabel | ImageButton in ipairs(self.Objects) do
		-- If we're dealing with a Collection then we should not try and set the offset and size.
		if animationData.Type == "Collection" then
			-- Reset the offset and size if we previously used a spritesheet
			object.ImageRectSize = Vector2.new(0, 0)
			object.ImageRectOffset = Vector2.new(0, 0)
			object.Image = ("rbxassetid://%d"):format(
				animationData.Animations[self.CurrentAnimation][math.floor(self.Frame)]
			)

			continue
		end

		-- Set ImageId and Size to the animation's values
		if object.Image ~= "rbxassetid://" .. animationData.ImageId then
			object.Image = "rbxassetid://" .. animationData.ImageId
			object.ImageRectSize = animationData.Size
		end

		-- Apply the current frame now that we set up the object to the
		-- current size and image
		object.ImageRectOffset = animationData.Animations[self.CurrentAnimation][math.floor(self.Frame)]
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

	[!] Does not support collections.

	```lua
	local Animator = this.module

	Animation:AddSpritesheet("6928232464", Vector2.new(100, 100), {
		["run"] = {
			-- This should normally represent to 1st row but since there's an `r` key
			-- `Animator` will offset it by that amiunt.

			-- In our case this will represent the 2nd row, instead of the 1st row.
			{ 1, 1, 1, 1, 1 },
		},
	})

	Animation:HookObject(path.to.your.object)

	Animation:Play()
	```

	@returns (Promise: Promise) - Used to make the code asynchronous but can be synchronous using :await()
]=]
function Animator:Play(): { Promise }
	return Promise.new(function(resolve, reject)
		-- TODO: clean this up
		-- currently this looks really messy but I'll clean it up eventaully
		if not self.CurrentAnimation then
			reject(ConsoleErrors.Play.NoAnimations)
		elseif not self.Objects[1] then
			reject(ConsoleErrors.NoObjectsHooked)
		end

		resolve()
	end)
		:andThen(function()
			self.Running = true
			local animationData: Animations = self._AnimationPointer[self.CurrentAnimation]

			self:_CancelRender()
			self._RenderHandle = RunService.RenderStepped:Connect(function(deltaTime: number)
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

	This will stop playing after 5 seconds passed.

	```lua
	local Animator = this.module

	Animation:AddSpritesheet("6928232464", Vector2.new(100, 100), {
		["run"] = {
			{ 1, 1, 1, 1, 1 },
		},
	})

	Animation:HookObject(path.to.your.object)

	Animation:Play()

	task.wait(5)

	Animation:Stop()
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

	This peace of code will set the framerate to 1 FPS after 5 seconds passed.

	```lua
	local Animator = this.module

	Animation:AddSpritesheet("6928232464", Vector2.new(100, 100), {
		["run"] = {
			-- This should normally represent to 1st row but since there's an `r` key
			-- `Animator` will offset it by that amiunt.

			-- In our case this will represent the 2nd row, instead of the 1st row.
			{ 1, 1, 1, 1, 1 },
		},
	})

	Animation:HookObject(path.to.your.object)

	Animation:Play()

	task.wait(1)

	Animation:SetFramerate(1)
	```

	@param (framerate: number) - Speed which the animation will get played (common values are 60 or 30)
	@default (framerate: number) - 60 FPS
]=]
function Animator:SetFramerate(framerate: number)
	ValidateArguments("SetFramerate", { Value = framerate, Type = "number" }):andThen(function()
		self.Framerate = framerate
	end)
end

--[=[
	Increments the `Frame` value by 1 and updates all of the hooked objects.
	`:NextFrame` is useful if you want you animation to play a certain amount of times.

	```lua
	local Animator = this.module

	Animation:AddSpritesheet("6928232464", Vector2.new(100, 100), {
		["run"] = {
			-- This should normally represent to 1st row but since there's an `r` key
			-- `Animator` will offset it by that amiunt.

			-- In our case this will represent the 2nd row, instead of the 1st row.
			{ 1, 1, 1, 1, 1 },
		},
	})

	Animation:HookObject(path.to.your.object)

	Animation:NextFrame()
	```
]=]
function Animator:NextFrame()
	if not self.Objects[1] then
		return warn(ConsoleErrors.NoObjectsHooked)
	end

	local animationData: Animations = self._AnimationPointer[self.CurrentAnimation]
	-- Increment the Frame value and if it's more than the actual frames in the
	-- animation then reset it to 1
	self.Frame += 1

	if self.Frame > #animationData.Animations[self.CurrentAnimation] then
		self.Frame = 1
	end

	self:_Render(animationData)
end

--[=[
	Decrements the `Frame` value by 1 and updates all of the hooked objects.
	`:PreviousFrame` is useful if you want you animation to play a certain amount of times but backwards.

	```lua
	local Animator = this.module

	Animation:AddSpritesheet("6928232464", Vector2.new(100, 100), {
		["run"] = {
			-- This should normally represent to 1st row but since there's an `r` key
			-- `Animator` will offset it by that amiunt.

			-- In our case this will represent the 2nd row, instead of the 1st row.
			{ 1, 1, 1, 1, 1 },
		},
	})

	Animation:HookObject(path.to.your.object)

	Animation:PreviousFrame()
	```
]=]
function Animator:PreviousFrame()
	if not self.Objects[1] then
		return warn(ConsoleErrors.NoObjectsHooked)
	end

	local animationData: Animations = self._AnimationPointer[self.CurrentAnimation]
	-- Increment the Frame value and if it's more than the actual frames in the
	-- animation then reset it to 1
	self.Frame -= 1

	if self.Frame < 1 then
		self.Frame = self.MaxFrames
	end

	self:_Render(animationData)
end

--[=[
	Hooks an ImageLabel or ImageButton and adds it to the `Objects` array. 
	Resulting in the object getting updates and showing the current frame.

	If no objects have been attached to the current `Animator handler` it will throw a warning!

	```lua
	local Animator = this.module

	Animation:AddSpritesheet("6928232464", Vector2.new(100, 100), {
		["run"] = {
			-- This should normally represent to 1st row but since there's an `r` key
			-- `Animator` will offset it by that amiunt.

			-- In our case this will represent the 2nd row, instead of the 1st row.
			{ 1, 1, 1, 1, 1 },
		},
	})

	Animation:HookObject(path.to.your.object)
	```

	@param (object: imagelabel | imagebutton) - Object(s) to update
]=]
function Animator:HookObject(object: ImageLabel | ImageButton)
	if not CheckObjectIsValid(object) then
		return warn("Error whilst calling :HookObject -> Expected ImageLabel or ImageButton!")
	end

	table.insert(self.Objects, object)
end

--[=[
	Changes the animation data to the set value.

	```lua
	local Animator = this.module

	Animation:AddSpritesheet("6928232464", Vector2.new(100, 100), {
		["run"] = {
			-- This should normally represent to 1st row but since there's an `r` key
			-- `Animator` will offset it by that amiunt.

			-- In our case this will represent the 2nd row, instead of the 1st row.
			{ 1, 1, 1, 1, 1 },
		},
	})

	Animation:HookObject(path.to.your.object)

	Animation:Play() --> will throw an error

	Animation:ChangeAnimation("run")

	Animation:Play() --> this won't throw an error now since we specified which animation `Animator` should play

	```

	@param (animationName: string) - The name of the animation that was set in `:AddSpritesheet`
]=]
function Animator:ChangeAnimation(animationName: string)
	ValidateArguments("ChangeAnimation", { Value = animationName, Type = "string" }):andThen(function()
		if self._AnimationPointer[animationName] then
			self.CurrentAnimation = animationName
			self.MaxFrames = #self._AnimationPointer[animationName].Animations[self.CurrentAnimation]
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
	Destroys the current Animator handler.
]=]
function Animator:Destroy()
	self:_CancelRender()
	self:ClearAnimationData()
	table.clear(self)
	setmetatable(self, nil)
end

return Animator
