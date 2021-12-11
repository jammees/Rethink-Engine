-- very simple data holder, so i dont have to write it down every single time11111!!11!
--[[

    2 ways to access the data:

    global:get(key)
    global.key

]]

local global = {}

function global:set(key, value)
    global[key] = value
end

function global:get(key)
    return global[key]
end

return global