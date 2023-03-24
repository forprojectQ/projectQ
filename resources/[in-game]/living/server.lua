local cache = exports.cache

addEvent("living.need", true)
addEventHandler("living.need", root, function()
    local hunger = source:getData("hunger")
    local thirst = source:getData("thirst")
    local dbid = source:getData("dbid")
    if hunger <= 0 then
        local health = source.health
        source.health = health - 10
    else
        local new = tonumber(hunger - math.random(1, 3))
        if new < 0 then
            new = 0
        end
        source:setData("hunger", new)
        cache:setCharacterData(dbid, "hunger", new)
    end
    if thirst <= 0 then
        local health = source.health
        source.health = health - 10
    else
        local new = tonumber(thirst - math.random(1, 3))
        if new < 0 then
            new = 0
        end
        source:setData("thirst", new)
        cache:setCharacterData(dbid, "thirst", new)
    end
end)