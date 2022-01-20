local function throwError(key, tableName)
    error(("%q (%s) is not a valid member of %s"):format(tostring(key), typeof(key), tostring(tableName)))
end

return function (t)
    return setmetatable(t, {
        __index = function(_, key)
            throwError(key, t)
        end,

        __newindex = function(_, key)
            throwError(key, t)
        end
    })
end