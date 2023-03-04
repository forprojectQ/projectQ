functions = {
    -- itemID, function
    ['FOOD'] = {function(player,itemID,itemValue,itemCount,itemIndex)
        local hunger = player:getData('hunger') or 100
        local newHunger = hunger + 20
        local new_value = tonumber(itemValue) - 25
        
        if new_value <= 0 then 
            takeItem(player, itemID, itemValue, 1)
            if itemCount > 1 then setItemValue(player,itemIndex,100) end
        else 
            setItemValue(player,itemIndex,new_value)
        end


        if newHunger > 100 then
            player:setData('hunger', 100)
        else
            player:setData('hunger', newHunger)
        end
    end},

    ['DRINK'] = {function(player,itemID,itemValue,itemCount,itemIndex)
        local thirst = player:getData('thirst') or 100
        local newThirst = thirst + 20
        local new_value = tonumber(itemValue) - 25

        if new_value <= 0 then 
            takeItem(player, itemID, itemValue, 1)
            if itemCount > 1 then setItemValue(player,itemIndex,100) end
        else 
            setItemValue(player,itemIndex,new_value)
        end

        if newThirst > 100 then
            player:setData('thirst', 100)
        else
            player:setData('thirst', newThirst)
        end
    end},
}

function useItem(info)
    local itemID,itemValue,_ = unpack(info)
    if source and tonumber(itemID) then
        if functions[getItemType(itemID)] then
            local itemIndex,_,itemValue_, itemCount = hasItem(source,itemID,itemValue)
            functions[getItemType(itemID)][1](source,itemID,itemValue_,itemCount,itemIndex)
        end
    end
end
addEvent('use.item',true)
addEventHandler('use.item',root,useItem)