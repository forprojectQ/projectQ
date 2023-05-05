local cache = exports.cache

function respawnPlayer(player)
    local dbid = player:getData("dbid")
    local state = cache:getCharacterData(dbid, "dead") or 0
    if state == 1 then
        cache:setCharacterData(dbid, "dead", 0)
        cache:setCharacterData(dbid, "injured", 0)
        player:setData("injured", 0)
        player.frozen = false
        player:setAnimation()
        triggerClientEvent(player, "death.finish", player)
        return true
    end
    return false
end

addEvent("death.spawn", true)
addEventHandler("death.spawn", root, function()
    respawnPlayer(source)
end)

addEvent("death.check", true)
addEventHandler("death.check", root, function()
    if source:getData("online") then
        local dbid = source:getData("dbid")
        local dead = cache:getCharacterData(dbid, "dead") or 0
        if dead == 1 then
            source.health = 0
        end
        local injured = cache:getCharacterData(dbid, "injured") or 0
        source:setData("injured", injured)
        if injured == 1 then
            triggerClientEvent(source, "death.injure", source)
        end
    end
end)

addEvent("death.damaged", true)
addEventHandler("death.damaged", root, function()
    local dbid = source:getData("dbid")
    cache:setCharacterData(dbid, "injured", 1)
    source:setData("injured", 1)
end)

addEvent("death.injured", true)
addEventHandler("death.injured", root, function()
    local dbid = source:getData("dbid")
    local dead = cache:getCharacterData(dbid, "dead") or 0
    if dead == 1 then
        return
    end
    local hp = source.health
    source.health = hp - math.random(1, 5)
end)

addEventHandler("onPlayerWasted", root, function()
    local dbid = source:getData("dbid")
    local x, y, z = source.position.x, source.position.y, source.position.z
    local int, dim = source.interior, source.dimension
    local model = source.model
    cache:setCharacterData(dbid, "dead", 1)
    source:spawn(x, y, z, 0, model, int, dim)
    source.frozen = true
    source.health = 5
    source.armor = 0
    source:setAnimation("crack", "crckdeth1", -1, false, false, false)
    triggerClientEvent(source, "death.counter", source)
end)