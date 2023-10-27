local Log = require(script.Parent.Parent.Parent.Library.Log)
local t = require(script.Parent.Parent.Parent.Vendors.t)
local ObjectPoolClass = require(script.Parent.Parent.Parent.Library.ObjectPool).Class
local Types = require(script.Parent.Types)

local Sound = {}
Sound.__index = Sound

function Sound.new(soundID: string | number, properties: Types.SoundProperties?)
	Log.TAssert(t.union(t.string, t.number)(soundID))
	Log.TAssert(t.optional(t.strictInterface({
		Amount = t.optional(t.number),
		Loop = t.optional(t.boolean),
		Volume = t.optional(t.number),
	}))(properties))
	if not properties then
		properties = {}
	end

	local self = setmetatable({}, Sound)

	self.Amount = properties.Amount or 5
	self.Loop = properties.Loop or false
	self.Volume = properties.Volume or 1
	self.SoundID = tostring(soundID)

	self.Instances = ObjectPoolClass.new("Sound", self.Amount, true)

	return self
end

function Sound:Play()
	local sound: Sound = self.Instances:Get()
	sound.SoundId = self.SoundID
	sound.Volume = self.Volume
	sound.Looped = self.Loop
	sound.Parent = script

	if not self.Loop then
		sound.Ended:Connect(function()
			self.Instances:Return(sound)
		end)
	end

	sound:Play()
end

function Sound:Stop()
	for _, object in self.Instances.Objects do
		local sound: Sound = object.Object
		sound:Stop()
		self.Instances:Return(sound)
	end
end

function Sound:Destroy()
	for _, object in self.Instances.Objects do
		local sound: Sound = object.Object

		self.Instances:Retire(sound)
		sound:Destroy()
	end

	setmetatable(self.Instances, nil)
	table.clear(self.Instances)
	setmetatable(self, nil)
	table.clear(self)
end

return Sound
