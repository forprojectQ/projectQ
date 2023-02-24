functions = {
    -- itemID, function

}

function useItem(itemID)
    if source and tonumber(itemID) then
        if functions[getItemType(itemID)] then
            
        end
    end
end
addEvent('use.item',true)
addEventHandler('use.item',root,useItem)