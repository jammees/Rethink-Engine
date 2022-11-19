local saveData = {}

local wrapper = {}
wrapper.__index = wrapper

function wrapper.GiveData(array: { [string]: any })
	saveData = array
end

function wrapper.Wrap(include: { [number]: string }): { any }
	local wrappedVariables = {}

	if include then
		for _, v in ipairs(include) do
			if saveData[v] then
				wrappedVariables[v] = saveData[v]
			end
		end
	end

	return setmetatable(wrappedVariables, wrapper)
end

return wrapper
