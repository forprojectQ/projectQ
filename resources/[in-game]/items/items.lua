list = {
    -- eşyaID, isim, tür((1 CÜZDAN), (2 ÇANTA), (3 ANAHTAR), (4 SİLAH)), ağırlık, bağlama(true/false(true ise karakter bu eşyayı transfer edemez.)), category

}

function getItemName(itemID)
    if tonumber(itemID) then
        return list[itemID][1] or 'null'
    end
end

function getItemCategory(itemID)
    if tonumber(itemID) then
        return list[itemID][2] or 0
    end
end

function getItemType(itemID)
    if tonumber(itemID) then
        return list[itemID][5] or itemID
    end
end