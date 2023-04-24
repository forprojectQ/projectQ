function findPlayer(arg)
    if tonumber(arg) then
        local player = getElementByID("player"..arg)
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