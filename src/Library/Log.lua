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

function Log.TAssert(predicate: boolean, message: string)
	if predicate then
		return
	end

	error(`[TYPEDEF ERROR] [{GetCallerName()}]: ` .. ProcessMessage(message), 2)
end

function Log.Print(message: string)
	print(`[{GetCallerName()}]: ` .. ProcessMessage(message))
end

function Log.Debug(message: string)
	if not isStudio then
		return
	end

	print(`[DEBUG] [{GetCallerName()}]: ` .. ProcessMessage(message))
end

function Log.Warn(message: string)
	warn(`[WARN] [{GetCallerName()}]: ` .. ProcessMessage(message))
end

function Log.Error(message: string)
	error(`[ERROR] [{GetCallerName()}]: ` .. ProcessMessage(message), 2)
end

return Log
