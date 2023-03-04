list = {
    --[[
        [eşyaID] = {
            isim (yazı),
            kategori (sayı) ((1 CÜZDAN), (2 ÇANTA), (3 ANAHTAR), (4 SİLAH)),
            ağırlık (sayı),
            bağlama (true/false) (true ise karakter bu eşyayı transfer edemez.),
            stack (true/false) (true ise, aynı id ve value' ile item verildiği zaman stack olur.)
            tip (yazı) (itemi kullanırken item tipine göre olaylar yapmak için.),
        }

    ]]
    [5] = {'Kızartma', 2, 0.1, false, true, 'FOOD'},
    [6] = {'Hamburger', 2, 0.1, false, true, 'FOOD'},
    [7] = {'Sosisli', 2, 0.1, false,, true, 'FOOD'},
    [8] = {'Su', 2, 0.1, false, true, 'DRINK'},
    [9] = {'Kola', 2, 0.1, false, true, 'DRINK'},
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
        return list[itemID][6] or itemID
    end
end

function getItemDefaultValue(itemID)
    if not tonumber(itemID) then return false end
    local info = list[itemID]
    if not info then return false end
    -- eğer giveItem yapılırken value verilmişse verilen valueyi döndür
    local category = info[5]
    -- yiyecek ve içecek kategorilerinde value default olarak 100.
    if category == "FOOD" or category == "DRINK" then
        return 100
    end   
    return 0 
end