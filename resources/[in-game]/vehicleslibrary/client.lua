local screen = Vector2(guiGetScreenSize())
local dbid
local adds = {
    {"ID", 0.05},
    {"GTA", 0.1},
    {"BRAND", 0.25},
    {"MODEL", 0.25},
    {"YEAR", 0.1},
    {"PRICE", 0.1},
    {"TAX", 0.1}
}

local formatMoney = function(amount)
    local left,num,right = string.match(tostring(amount),'^([^%d]*%d)(%d*)(.-)$')
    return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end

local validation = function(price, tax, gta)
    if tonumber(price) and tonumber(tax) and tonumber(gta) then
        return true
    end
    outputChatBox("Lütfen yeni araç bilgilerini geçerli bir şekilde doldurun!", 255, 25, 25)
    return false
end

function library(results)
    local columns = {}
    if isElement(window) then
        window:destroy()
    end
    window = GuiWindow(screen.x/2-800/2, screen.y/2-500/2, 800, 500, "Araç Kütüphanesi", false)
    window:setSizable(false)
    list = GuiGridList(5, 25, 785, 420, false, window)
    list:setSortingEnabled(false)
    for index, value in ipairs(adds) do
        columns[index] = list:addColumn(value[1], value[2])
    end
    for index, value in ipairs(results) do
        local row = list:addRow(columns[index])
        list:setItemText(row, columns[1], value.id, false, false)
        list:setItemText(row, columns[2], value.gta, false, false)
        list:setItemText(row, columns[3], value.brand, false, false)
        list:setItemText(row, columns[4], value.model, false, false)
        list:setItemText(row, columns[5], value.year, false, false)
        list:setItemText(row, columns[6], "$"..formatMoney(value.price), false, false)
        list:setItemText(row, columns[7], "$"..formatMoney(value.tax), false, false)
        list:setItemData(row,1,value)
    end
    editW = GuiButton(5, 450, 150, 30, "Seçili Aracı Düzenle", false, window)
    addW = GuiButton(5+150+5, 450, 150, 30, "Yeni Bir Araç Ekle", false, window)
    handlingW = GuiButton(5+300+5, 450, 150, 30, "Handling", false, window)
    closeW = GuiButton(5+450+5, 450, 150, 30, "Arayüzü Kapat", false, window)
end

function edit()
    if isElement(editWindow) then
        editWindow:destroy()
    end
    editWindow = GuiWindow(screen.x/2-450/2, screen.y/2-250/2, 450, 270, "Araç Özellikleri", false)
    editWindow:setSizable(false)
    local text = GuiLabel(0, 25, 450, 60, "Oluşturacağınız aracın bilgilerini doldurun.", false, editWindow)
    text.horizontalAlign = "center"
    carBrand = GuiEdit(15, 60, 240, 40, "araç markası", false, editWindow)
    carModel = GuiEdit(15, 60+45, 240, 40, "araç modeli", false, editWindow)
    carYear = GuiEdit(15+245, 60, 175, 40, "araç yılı", false, editWindow)
    carPrice = GuiEdit(15+245, 60+45, 175, 40, "araç fiyatı", false, editWindow)
    carTax = GuiEdit(15, 60+45*2, 175, 40, "araç vergisi", false, editWindow)
    carGta = GuiEdit(15+180, 60+45*2, 175, 40, "gta araç id", false, editWindow)
    carEnabled = GuiCheckBox(15,60+45*3,250,25,"Bu araba galeriden satın alınabilsin mi?",true,false,editWindow)
    saveE = GuiButton(450/2-200/2-52, 230, 150, 30, "Kaydet", false, editWindow)
    closeE = GuiButton(450/2-200/2+102, 230, 150, 30, "Arayüzü Kapat", false, editWindow)
end

function closeAll()
    if isElement(editWindow) then
        editWindow:destroy()
    end
    if isElement(window) then
        window:destroy()
    end
    dbid = nil
end

function closeEdit()
    if isElement(editWindow) then
        editWindow:destroy()
    end
    dbid = nil
end

addEventHandler("onClientGUIClick", resourceRoot, function()
    if source == editW then
        local selected = list:getSelectedItem()
        if selected < 0 then
            outputChatBox("Listeden bir araç seçmediniz.", 255, 25, 25)
        else
            local info = list:getItemData(selected,1)
            edit()
            dbid = info.id
            carBrand:setText(info.brand)
            carModel:setText(info.model)
            carYear:setText(info.year)
            carPrice:setText(info.price)
            carTax:setText(info.tax)
            carGta:setText(info.gta)
            guiCheckBoxSetSelected(carEnabled,info.enabled == 1)
        end
    elseif source == handlingW then
        local selected = list:getSelectedItem()
        if selected < 0 then
            outputChatBox("Listeden bir araç seçmediniz.", 255, 25, 25)
        else
            local id = list:getItemData(selected,1).id
            triggerServerEvent("vehicle.library.handling", localPlayer, id)
            closeAll()
        end
    elseif source == addW then
        dbid = nil
        edit()
    elseif source == saveE then
        local getBrand = carBrand.text
        local getModel = carModel.text
        local getYear = carYear.text
        local getPrice = carPrice.text
        local getTax = carTax.text
        local getGta = carGta.text
        local isEnabled = guiCheckBoxGetSelected(carEnabled) and 1 or 0
        if validation(getPrice, getTax, getGta) then
            if dbid then
                triggerServerEvent("vehicle.library.edit", localPlayer, dbid, getBrand, getModel, getYear, getPrice, getTax, getGta, isEnabled)
            else
                triggerServerEvent("vehicle.library.create", localPlayer, getBrand, getModel, getYear, getPrice, getTax, getGta, isEnabled)
            end
            closeAll()
        end
    elseif source == closeW then
        closeAll()
    elseif source == closeE then
        closeEdit()
    end
end)

addEvent("vehicle.library", true)
addEventHandler("vehicle.library", root, library)