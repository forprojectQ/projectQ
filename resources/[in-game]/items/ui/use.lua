functions = {
    -- itemID, function
    ['FOOD'] = {function(player,itemID)
        player:outputChat(itemID)
    end}
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