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
    [1] = {'Ev Anahtarı', 3, 0.1, false, false, 'KEY'},
    [2] = {'Araç Anahtarı', 3, 0.1, false, false, 'KEY'},
    [5] = {'Kızartma', 2, 0.1, false, true, 'FOOD'},
    [6] = {'Hamburger', 2, 0.1, false, true, 'FOOD'},
    [7] = {'Sosisli', 2, 0.1, false, true, 'FOOD'},
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

function isStackableItem(itemID)
    if tonumber(itemID) then
        return list[itemID][5]
    end
end

function getItemDefaultValue(itemID)
    if not tonumber(itemID) then return false end
    local info = list[itemID]
    if not info then return false end
    local tip = info[6]
    -- yiyecek ve içecek kategorilerinde value default olarak 100.
    if tip == "FOOD" or tip == "DRINK" then
        return 100
    end   
    return 0 
end