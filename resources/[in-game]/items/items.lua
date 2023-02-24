list = {
    -- eşyaID, isim, tür((1 CÜZDAN), (2 ÇANTA), (3 ANAHTAR), (4 SİLAH)), ağırlık, bağlama(true/false(true ise karakter bu eşyayı transfer edemez.)), category
    [5] = {'Kızartma', 2, 0.1, false, 'FOOD'},
    [6] = {'Hamburger', 2, 0.1, false, 'FOOD'},
    [7] = {'Sosisli', 2, 0.1, false, 'FOOD'},
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