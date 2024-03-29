--[[
	Log

	A simple implementation of a Logger
]]

local RunService = game:GetService("RunService")

local Promise = require(script.Parent.Parent.Vendors.Promise)
local t = require(script.Parent.Parent.Vendors.t)

local isStudio = RunService:IsStudio()

-- A very hacky way to get the caller's name
-- of the function by messing around with the
-- stacktrace
local function GetCallerName()
	local stacktrace = debug.traceback()
	local splitByLines = string.split(stacktrace, "\n")
	local splitByDots = string.split(splitByLines[3], ".")
	return string.split(splitByDots[#splitByDots], ":")[1]
	-- return string.split(splitByDots[#splitByDots], " ")[1]
end

local function ProcessMessage(message: string | { string })
	if Promise.Error.is(message) then
		return tostring(message)
	end

	return message
end

local Log = {}
Log._Data = {}

function Log.TAssert(predicate: boolean, message: string?)
	assert(t.boolean(predicate))
	assert(t.optional(t.string)(message))

	if predicate then
		return
	end

	error(`[TYPE ERROR] [{GetCallerName()}]: ` .. ProcessMessage(message), 2)
end

function Log.Print(message: string, atEvery: number?)
	assert(t.string(message))
	assert(t.optional(t.number)(atEvery))

	if not Log._AtEvery(atEvery) then
		return
	end

	print(`[{GetCallerName()}]: ` .. ProcessMessage(message))
end

function Log.Debug(message: string, atEvery: number?)
	assert(t.string(message))
	assert(t.optional(t.number)(atEvery))

	if not isStudio then
		return
	end

	if not Log._AtEvery(atEvery) then
		return
	end

	print(`[DEBUG] [{GetCallerName()}]: ` .. ProcessMessage(message))
end

function Log.Warn(message: string, atEvery: number?)
	assert(t.string(message))
	assert(t.optional(t.number)(atEvery))

	if not Log._AtEvery(atEvery) then
		return
	end

	warn(`[WARN] [{GetCallerName()}]: ` .. ProcessMessage(message))
end

function Log.Error(message: string, atEvery: number?)
	assert(t.string(message))
	assert(t.optional(t.number)(atEvery))

	if not Log._AtEvery(atEvery) then
		return
	end

	error(`[ERROR] [{GetCallerName()}]: ` .. ProcessMessage(message), 2)
end

function Log._AtEvery(atEvery): boolean
	if not atEvery then
		return true
	end

	local stacktrace = debug.traceback()

	if not Log._Data[stacktrace] or Log._Data[stacktrace].AtEvery ~= atEvery then
		Log._Data[stacktrace] = {
			AtEvery = atEvery,
			Count = 0,
		}
	end

	local logData = Log._Data[stacktrace] :: { AtEvery: number, Count: number }

	logData.Count += 1

	if logData.Count < logData.AtEvery then
		return false
	end

	logData.Count = 0

	return true
end

return Log
