local screen = Vector2(guiGetScreenSize())
local dbid
local adds = {
    {"ID", 0.05},
    {"GTA", 0.06},
    {"MARKA", 0.15},
    {"MODEL", 0.15},
    {"YIL", 0.06},
    {"ÜCRET", 0.12},
    {"VERGİ", 0.1},
    {"GÜNCELLEYEN", 0.1},
    {"TARİH", 0.15},
}

local formatMoney = function(amount)
    local left,num,right = string.match(tostring(amount),'^([^%d]*%d)(%d*)(.-)$')
    return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end

local validation = function(...)
    for i,v in ipairs({...}) do
        if not tonumber(gui.edit[v].text) then
            outputChatBox("Lütfen yeni araç bilgilerini geçerli bir şekilde doldurun!", 255, 25, 25)
            return false
        end  
    end  
    return true    
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
        list:setItemText(row, columns[8], value.updatedbyname or "", false, false)
        list:setItemText(row, columns[9], value.updatedate or "", false, false)
        list:setItemData(row,1,value)
        if value.enabled == 0 then
            for columnid=1,#columns do
                list:setItemColor(row,columnid,255,0,0)
            end    
        end
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
    gui = {staticLbls={},edit={},combos={},check={}}
    local pg,pu = 450,550
    local x,y = (screen.x-pg)/2,(screen.y-pu)/2
    editWindow = GuiWindow(x,y,pg,pu,"Araç Özellikleri", false)
    editWindow:setSizable(false)
    local text = GuiLabel(0, 25, 450, 20, "Oluşturacağınız aracın bilgilerini doldurun.", false, editWindow)
    text.horizontalAlign = "center"

    gui.staticLbls[1] = GuiLabel(10,60,200,20,"araç markası:",false,editWindow)
    gui.edit["brand"] = GuiEdit(10, 80, 200, 40, "", false, editWindow)
    gui.staticLbls[2] = GuiLabel(10,60+(65),200,20,"araç modeli:",false,editWindow)
    gui.edit["model"] = GuiEdit(10, 80+(65), 200, 40, "", false, editWindow)
    gui.staticLbls[3] = GuiLabel(10,60+(65*2),200,20,"araç yılı:",false,editWindow)
    gui.edit["year"] = GuiEdit(10, 80+(65*2), 200, 40, "", false, editWindow)
    gui.staticLbls[4] = GuiLabel(10,60+(65*3),200,20,"kalan stok:",false,editWindow)
    gui.edit["stock"] = GuiEdit(10, 80+(65*3), 200, 40, "", false, editWindow)

    gui.staticLbls[5] = GuiLabel(240,60,200,20,"gta araç id",false,editWindow)
    gui.edit["gta"] = GuiEdit(240, 80, 200, 40, "", false, editWindow)
    gui.staticLbls[6] = GuiLabel(240,60+(65),200,20,"araç vergisi:",false,editWindow)
    gui.edit["tax"] = GuiEdit(240, 80+(65), 200, 40, "", false, editWindow)
    gui.staticLbls[7] = GuiLabel(240,60+(65*2),200,20,"araç fiyatı:",false,editWindow)
    gui.edit["price"] = GuiEdit(240, 80+(65*2), 200, 40, "", false, editWindow)
    gui.staticLbls[8] = GuiLabel(240,60+(65*3),200,20,"depo limiti:",false,editWindow)
    gui.edit["tanksize"] = GuiEdit(240, 80+(65*3), 200, 40, "", false, editWindow)
    gui.staticLbls[9] = GuiLabel(240,60+(65*4),200,20,"donate fiyatı:",false,editWindow)
    gui.edit["donateprice"] = GuiEdit(240, 80+(65*4), 200, 40, "0", false, editWindow)
    gui.staticLbls[9]:setVisible(false) gui.edit["donateprice"]:setVisible(false) 

    gui.staticLbls[10] = GuiLabel(10,60+(65*4),200,20,"kapı tipi:",false,editWindow)
    gui.combos["doortype"] = GuiComboBox(10,80+(65*4),200,75,"Standart",false,editWindow)
    for i,v in ipairs({"Kelebek","Makas"}) do
        gui.combos["doortype"]:addItem(v)
    end 
    gui.staticLbls[11] = GuiLabel(10,60+(62*5),200,20,"yakıt tipi:",false,editWindow)
    gui.combos["fueltype"] = GuiComboBox(10,80+(62*5),200,75,"Dizel",false,editWindow)
    for i,v in ipairs({"Benzin","LPG"}) do
        gui.combos["fueltype"]:addItem(v)
    end     

    gui.check["enabled"] = GuiCheckBox(10,80+(58*6),200,20,"Galeriden satın alınabilsin mi?",true,false,editWindow)
    gui.check["isdonate"] = GuiCheckBox(10,80+(62*6),200,20,"Donate araç?",false,false,editWindow)

    -- carPrice = GuiEdit(15+245, 60+45, 175, 40, "araç fiyatı", false, editWindow)
    -- carTax = GuiEdit(15, 60+45*2, 175, 40, "araç vergisi", false, editWindow)
    -- carGta = GuiEdit(15+180, 60+45*2, 175, 40, "gta araç id", false, editWindow)
    -- carEnabled = GuiCheckBox(15,60+45*3,250,25,"Bu araba galeriden satın alınabilsin mi?",true,false,editWindow)
    saveE = GuiButton(450/2-200/2-52, pu-40, 150, 30, "Kaydet", false, editWindow)
    closeE = GuiButton(450/2-200/2+102, pu-40, 150, 30, "Arayüzü Kapat", false, editWindow)

    for i,v in pairs(gui.staticLbls) do
        v:setFont("default-bold-small")
    end
    for i,v in ipairs({"gta","year","stock","price","tax","tanksize","donateprice"}) do
        gui.edit[v]:setProperty("ValidationString", "[0-9]*")
    end
end

function closeAll()
    closeEdit()
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
            for key,elm in pairs(gui.edit) do
                if info[key] then
                   elm:setText(info[key] or "")     
                end    
            end
            dbid = info.id
            gui.combos["doortype"]:setSelected(info.doortype or -1)
            gui.combos["fueltype"]:setSelected(info.fueltype or -1)
            guiCheckBoxSetSelected(gui.check["enabled"],info.enabled == 1)
            guiCheckBoxSetSelected(gui.check["isdonate"],info.isdonate == 1)
        end
    elseif gui and source == gui.check["isdonate"] then
        local state = source:getSelected()
        gui.staticLbls[9]:setVisible(state) gui.edit["donateprice"]:setVisible(state)     
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
        local info = {}
        for key,elm in pairs(gui.edit) do
            info[key] = elm.text
        end
        info["doortype"] = gui.combos["doortype"]:getSelected()
        info["fueltype"] = gui.combos["fueltype"]:getSelected()
        info["enabled"] = guiCheckBoxGetSelected(gui.check["enabled"]) and 1 or 0
        info["isdonate"] = guiCheckBoxGetSelected(gui.check["isdonate"]) and 1 or 0
        if validation("gta","year","stock","price","tax","tanksize","donateprice") then
            if dbid then
                triggerServerEvent("vehicle.library.edit", localPlayer, dbid,info)
            else
                triggerServerEvent("vehicle.library.create", localPlayer, info)
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


--edit()