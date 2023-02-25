functions = {
    -- itemID, function
    ['FOOD'] = {function(player,itemID)
        local hunger = player:getData('hunger') or 100
        local newHunger = hunger + 20
        takeItem(player, itemID, nil, 1)

        if newHunger > 100 then
            player:setData('hunger', 100)
        else
            player:setData('hunger', newHunger)
        end
    end},

    ['DRİNK'] = {function(player,itemID)
        local thirst = player:getData('thirst') or 100
        local newThirst = thirst + 20
        takeItem(player, itemID, nil, 1)

        if newThirst > 100 then
            player:setData('thirst', 100)
        else
            player:setData('thirst', newThirst)
        end
    end},
}

function useItem(itemID)
    if source and tonumber(itemID) then
        if functions[getItemType(itemID)] then
            functions[getItemType(itemID)][1](source,itemID)
        end
    end
end
addEvent('use.item',true)
addEventHandler('use.item',root,useItem)