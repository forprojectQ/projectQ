function class(name)
    local c = {}
    c.__index = c
    c.__type = name

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

    function c:find(target)
        if self[target] == nil then
            self[target] = target
        end
        return self[target]
    end

    function c:set(target, key, value)
        if not self[target] then
            self[target] = {}
        end
        self[target][key] = value
    end

    function c:get(target, key)
        return self[target][key]
    end

    function c:remove(target, key)
        self[target][key] = nil
        collectgarbage("collect")
    end

    function c:destroy(target)
        self[target] = nil
        collectgarbage("collect")
    end

    return c
end