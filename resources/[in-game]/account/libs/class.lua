function class(name)
    local c = {}
    c[0] = {}
    c.__index = c
    c.__type = name
    c.databaseLoaded = false

    function c:new(...)
        local instance = setmetatable({}, self)
        instance:init(...)
        return instance
    end

    function c:addMethod(name, fn)
        self[name] = fn
    end

    function c:extend(name)
        local subclass = class(name)
        setmetatable(subclass, { __index = self })
        return subclass
    end

    return c
end