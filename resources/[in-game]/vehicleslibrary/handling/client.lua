local screen = Vector2(guiGetScreenSize())
local options = {
    --// LİSTE ADI, MAKS. AYAR, REFERANS
    {"Azami Hız", 275, "maxVelocity"},
    {"Hızlanma", 75, "engineAcceleration"},
    {"Motor Ataleti", 30, "engineInertia"},
    {"Süspansiyon Yüksekliği", 0.1, "suspensionLowerLimit"},
    {"Süspansiyon Ön Arka Basıncı", 0.95, "suspensionFrontRearBias"},
    {"Süspansiyon Kuvvet Seviyesi", 0.2, "suspensionForceLevel"},
    {"Süspansiyon Sönümleme", 0.2, "suspensionDamping"},
    {"Direksiyon Kilidi", 55, "steeringLock"},
    {"Kütle Ağırlığı", 10000, "mass"},
    {"Sürükleme Katsayısı", 6, "dragCoeff"},
    {"Frenleme Gücü", 50, "brakeDeceleration"},
    {"Frenleme Basıncı", 1, "brakeBias"},
    {"Çekim Gücü Çarpanı", 6, "tractionMultiplier"},
    {"Çekim Gücü Basıncı", 1, "tractionBias"},
}

local dbid
local max
local option
local validation = function(maximum, new)
    if tonumber(new) and tonumber(maximum) >= tonumber(new) then
        return true
    end
    outputChatBox("Lütfen araç özelliklerini düzgün bir şekilde doldurun!", 255, 25, 25)
    return false
end

function editorWindow(index, name, value)
    if isElement(editBox) then
        editBox:destroy()
    end
    max = options[index][2]
    option = tostring(options[index][3])
    editBox = GuiWindow(screen.x/2-325/2, screen.y/2-115/2, 325, 115, ""..name.." (MAKS: "..max..")", false)
    editBox:setSizable(false)
    newValue = GuiEdit(15, 30, 395, 30, value, false, editBox)
    saveEdit = GuiButton(325/2-150/2, 65, 150, 30, "Kaydet", false, editBox)
end

function select()
    local selected = handlingList:getSelectedItem()
    if selected >= 0 then
        local i = selected + 1
        local name = handlingList:getItemText(selected, 1)
        local value = handlingList:getItemText(selected, 2)
        local index = i
        editorWindow(index, name, value)
    end
end

function editWindow(id)
    dbid = id
    local veh = localPlayer.vehicle
    local currentHand = veh.handling
    if isElement(handlingWindow) then
        handlingWindow:destroy()
    end
    handlingWindow = GuiWindow(10, screen.y-460, 400, 450, "Araç Özellikleri ("..dbid..")", false)
    handlingWindow:setSizable(false)
    handlingList = GuiGridList(5, 25, 385, 370, false, handlingWindow)
    handlingList:setSortingEnabled(false)
    handlingName = handlingList:addColumn("Özellik", 0.70)
    handlingValue = handlingList:addColumn("Değer", 0.2)
    for _, value in ipairs(options) do
        local row = handlingList:addRow()
        handlingList:setItemText(row, handlingName, value[1], false, false)
        handlingList:setItemText(row, handlingValue, ""..tostring(currentHand[value[3]]).."", false, false)
        handlingList:setItemData(row, handlingValue, value[2])
    end
    handlingSave = GuiButton(45, 400, 150, 30, "Kaydet", false, handlingWindow)
    handlingClose = GuiButton(45+155, 400, 150, 30, "Arayüzü Kapat", false, handlingWindow)
    addEventHandler("onClientGUIDoubleClick", handlingList, select)
end

function refresh(opt)
    local veh = localPlayer.vehicle
    local currentHand = veh.handling
    local row = handlingList:getSelectedItem()
    handlingList:setItemText(row, handlingValue, ""..tostring(currentHand[opt]).."", false, false)
end

function closeEditorBox()
    max, option, dbid = nil, nil, nil
    if isElement(editBox) then
        editBox:destroy()
    end
end

function closeHandling()
    max, option, dbid = nil, nil, nil
    removeEventHandler("onClientGUIDoubleClick", handlingList, select)
    if isElement(editBox) then
        editBox:destroy()
    end
    if isElement(handlingWindow) then
        handlingWindow:destroy()
    end
end

addEventHandler("onClientGUIClick", resourceRoot, function()
    if source == handlingClose then
        closeHandling()
        triggerServerEvent("vehicle.library.handling.stop", localPlayer)
    elseif source == saveEdit then
        local getNewValue = newValue.text
        if max and option then
            if validation(max, getNewValue) then
                triggerServerEvent("vehicle.library.set.handling", localPlayer, tostring(option), tonumber(getNewValue))
                closeEditorBox()
            end
        else
            outputChatBox("Bir sorun oluştu, lütfen arayüzü yenileyin veya daha sonra tekrar deneyin.", 255, 25, 25)
        end
    elseif source == handlingSave then
        triggerServerEvent("vehicle.library.save", localPlayer, dbid)
    end
end)

addEventHandler("onClientVehicleExit", getRootElement(), function(player)
    if player == localPlayer then
        if player:getData("vehicle.library.test") then
            triggerServerEvent("vehicle.library.handling.stop", player, source)
            closeHandling()
        end
    end
end)

addEvent("vehicle.library.edt.handling", true)
addEventHandler("vehicle.library.edt.handling", root, editWindow)
addEvent("vehicle.library.refresh.handling", true)
addEventHandler("vehicle.library.refresh.handling", root, refresh)