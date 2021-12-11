--[[

    Simple data holder for the entire engine

]]

local data = {}

function data.set(key, value)
    data[key] = value
end

function data.get(key)
    return data[key]
end


return data