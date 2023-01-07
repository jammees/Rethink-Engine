--[[
    ProfilerWrapper is used for Boatbomber's benchmarking plugin.

    This module's purpose is to expose the Profiler, so that components can have access to it.
]]

local WARN_CONSOLE = true

local isTestMode = false

local ProfilerWrapper = {}
ProfilerWrapper.Profiler = nil

function ProfilerWrapper.AttachProfiler(profiler: any, isTestModeEnabled: boolean)
	ProfilerWrapper.Profiler = profiler
	isTestMode = isTestModeEnabled
end

function ProfilerWrapper.Start(title: string)
	if isTestMode == false then
		return warn(WARN_CONSOLE and "Attempted to call .Start, but TestMode is not enabled!" or "")
	end

	ProfilerWrapper.Profiler.Begin(title)
end

function ProfilerWrapper.End()
	if isTestMode == false then
		return warn(WARN_CONSOLE and "Attempted to call .End, but TestMode is not enabled!" or "")
	end

	ProfilerWrapper.Profiler.End()
end

return ProfilerWrapper
