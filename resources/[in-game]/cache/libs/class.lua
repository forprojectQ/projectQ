conn = exports.mysql:newConnect("cache","suppress=1060,1062")
tables_cache = {} --// Tüm verilerin tutulcağı tablo. tables_cache["accounts"]

function class(name)
    local c = {}
    c[0] = {}
    c.pool = {}
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

    function c:find(target)
        if self[target] == nil then
            self[target] = target
        end
        return self[target]
    end

    function c:set(target, key, value, noSql)
        if (not self.databaseLoaded) then table.insert(self.pool,{target,key,value,noSql}) return false end
	    if (not target or not key) then return false end
		
        if not self[target] then
            self[target] = {}
            if not noSql then dbExec(conn, "INSERT INTO `"..(self.__type).."` (id) VALUES(?)", target) end
        end
        if (self[0] and self[0][key] == nil) then
            self[0][key] = true
            if not noSql then  dbExec(conn, "ALTER TABLE `"..(self.__type).."` ADD `??` text", key) end
        end
        if not noSql then dbExec(conn, "UPDATE `"..(self.__type).."` SET `??`=? WHERE id=?", key, value==nil and "NULL" or  tostring(value), target) end
		
        self[target][key] = value
        return true
    end

    function c:get(target, key)
        if (not self.databaseLoaded) then return false end
	    if (not target or not key) then return nil end
        if (self[target] == nil) then return nil end
        return tonumber(self[target][key]) or self[target][key]
    end

    function c:remove(target, key)
        self[target][key] = nil
        collectgarbage("collect")
    end

    function c:clear(target)
        self[target] = nil
        collectgarbage("collect")
    end

    return c
end