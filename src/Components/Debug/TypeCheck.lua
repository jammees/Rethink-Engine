type ArgumentData = {
	Value: any,
	Type: string?,
}

local components = script:FindFirstAncestor("Components")

local Promise = require(components.Library.Promise)
local DebugStrings = require(script.Parent.Strings)

type PromiseClass = typeof(Promise)

local TypeCheck = {}

--[=[
	@since 0.6.0
	@returns {Promise}
]=]
function TypeCheck.IsWrongType(methodName: string, ...): PromiseClass
	local checks = table.pack(...)
	local passes = 0

	return Promise.new(function(resolve, reject)
		for _, argumentData: ArgumentData in ipairs(checks) do
			if typeof(argumentData.Value) ~= argumentData.Type then
				reject((DebugStrings.IsWrongType):format(methodName, typeof(argumentData.Type), typeof(argumentData.Value)))
			end

			passes += 1
		end

		if passes == #checks then
			resolve()
		end
	end):catch(warn)
end

function TypeCheck.Assert(errorMessage: string, object: any, ...: string)
	local objectTypes = table.pack(...)
	objectTypes.n = nil

	for _, v in ipairs(objectTypes) do
		local result = typeof(object) == v
		if result then
			return v
		end
	end

	error(string.format(errorMessage, table.concat(objectTypes, ", "), typeof(object)), 3)
end

--[=[
	Better alternative to .IsWrontType
	More cleaner, takes less space and easier to detect with TestEZ

	@since 1.0.0
]=]
function TypeCheck.Is(variableName: string, variable: any, expectedType: string)
	if typeof(variable) ~= expectedType then
		error(string.format(DebugStrings.ExpectedVariable, variableName, expectedType, typeof(variable)), 3)
	end
end

return TypeCheck
