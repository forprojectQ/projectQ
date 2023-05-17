function findPlayer(arg)
    if tonumber(arg) then
        local player = Element.getByID("player"..arg)
        if player then
            return player, player.name
        else
            return false
        end
    else
        local player = Player(arg)
        if player then
            return player, player.name
        else
            return false
        end
    end
    return false
end

function takeMoney(player, amount)
    if tonumber(amount) then
        local current = tonumber(player:getData("money"))
        local new = current - amount
        if new < 0 then
            return false
        end
        player:setData("money", new)
        exports.cache:setCharacterData("money", new)
        return true
    else
        print("! takeMoney: amount is not a number")
    end
end

function giveMoney(player, amount)
    if tonumber(amount) then
        local current = tonumber(player:getData("money"))
        local new = current + amount
        player:setData("money", new)
        exports.cache:setCharacterData(player, "money", new)
    else
        print("! giveMoney: amount is not a number")
    end
end