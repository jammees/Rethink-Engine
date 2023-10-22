local Value = {}
Value.__index = Value
Value.__tostring = function(self)
	return `Value<{tostring(self._Value)}>`
end

function Value.new(defaultValue: any)
	local self = setmetatable({}, Value)

	self._Callbacks = {}
	self._Value = defaultValue

	return self
end

function Value:OnChange(callback)
	table.insert(self._Callbacks, callback)
end

function Value:Get()
	return self._Value
end

function Value:Set(newValue)
	if self._Value ~= newValue then
		self._Value = newValue

		for _, callback in ipairs(self._Callbacks) do
			callback(newValue)
		end
	end
end

function Value:Destroy()
	table.clear(self._Callbacks)
	self._Value = nil
	setmetatable(self, nil)
	table.clear(self)
end

export type Value = typeof(Value.new())

return Value
