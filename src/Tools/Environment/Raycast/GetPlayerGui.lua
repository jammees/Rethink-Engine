--[[
	This additional module is not yet in use, but will be in the future.
	
	-> Only for debugging purposes.	
]]--

return function ()
	local service = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
	
	if service then
		return service
	end	
end
