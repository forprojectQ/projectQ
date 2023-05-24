--// ENVANTER SAYFASI
ui.pages[5] = {
    open = function(self)
        self.selectedTable, self.currentRow, self.maxRow = self.vehicles_info, 0, 10

        self.inventoryOptions = {
            {"", "Birlik Taşıtları", self.vehicles_info},
            {"", "Birlik Mülkleri", self.interiors_info},
        }

        self.inventoryInfoBox = {
            [1] = {"Araçlar", "", tocolor(255, 255, 255, 125)},
            [2] = {"Mülkler", "", tocolor(196, 86, 86, 125)},
        }

        self.inventoryInfo = {
            [1] = ""..(#self.vehicles_info or 0).." adet",
            [2] = ""..(#self.interiors_info or 0).." adet"
        }

        self.inventoryFunctions = {
            listUp = function()
                if self.currentRow > 0 then
                    self.currentRow = self.currentRow - 1
                end
            end,

            listDown = function()
                if self.currentRow < #self.selectedTable - self.maxRow then
                    self.currentRow = self.currentRow + 1
                end
            end,
        }

        bindKey("mouse_wheel_up", "down", self.inventoryFunctions.listUp)
        bindKey("mouse_wheel_down", "down", self.inventoryFunctions.listDown)
    end,

    close = function(self)
        unbindKey("mouse_wheel_up", "down", self.inventoryFunctions.listUp)
        unbindKey("mouse_wheel_down", "down", self.inventoryFunctions.listDown)
        self.currentRow, self.maxRow, self.inventoryFunctions, self.inventoryOptions, self.inventoryInfoBox, self.inventoryInfo, self.selectedTable = nil, nil, nil, nil, nil, nil, nil
        collectgarbage("collect")
    end,

    render = function(self)
        dxDrawText("Birlik Envanteri", self.x+210, self.y+30, nil, nil, tocolor(255, 255, 255), 1, self.fonts.robotoBBig)
        dxDrawText("Birliğe ait taşırlar ve mülklerin listesi.", self.x+210, self.y+50, nil, nil, tocolor(175, 175, 175), 1, self.fonts.robotoSmall)

         --// BİLGİ KUTUCUKLARI
        dxDrawCustomRoundedRectangle(12, self.x+200+self.w/2-15, self.y+25, 200, self.h-50, tocolor(65, 67, 74), false, false, true, false, true, false)
        local newX1 = self.x+200+self.w/2-7
        local newX2 = self.x+200+self.w/2+5
        local newY = 0
        for i=1, 2 do
            dxDrawRoundedRectangle(newX1, self.y+45+newY, 185, 60, 8, tocolor(39, 41, 46))
            dxDrawRectangle(newX1, self.y+55+newY, 2, 40, self.inventoryInfoBox[i][3])
            dxDrawText(self.inventoryInfoBox[i][2], newX2+140, self.y+65+newY, nil, nil, self.inventoryInfoBox[i][3], 1, self.fonts.awesomeSmall)
            dxDrawText(self.inventoryInfoBox[i][1], newX2, self.y+55+newY, nil, nil, tocolor(255, 255, 255, 245), 1, self.fonts.robotoB)
            dxDrawText(self.inventoryInfo[i], newX2, self.y+75+newY, nil, nil, tocolor(255, 255, 255, 175), 1, self.fonts.robotoSmall)
            newY = newY + 65
        end

        --// TÜM ARAÇLARI RESPAWNLA
        dxDrawRoundedRectangle(newX1, self.y+45+newY, 185, 60, 8, tocolor(39, 41, 46))
        dxDrawRectangle(newX1, self.y+55+newY, 2, 40, tocolor(88, 101, 242, 125))
        dxDrawText("Respawn", newX2, self.y+55+newY, nil, nil, tocolor(255, 255, 255, 245), 1, self.fonts.robotoB)
        dxDrawText("Araçları respawn'la", newX2, self.y+75+newY, nil, nil, tocolor(255, 255, 255, 175), 1, self.fonts.robotoSmall)
        local isHovered = isInBox(newX2+130, self.y+55+newY, 30, 30, "hand")
        dxDrawText("", newX2+140, self.y+65+newY, nil, nil, (isHovered) and tocolor(88, 101, 242, 125) or tocolor(255, 255, 255, 125), 1, self.fonts.awesomeSmall)
        if isHovered and isClicked() then
            triggerServerEvent("factions.vehicle", localPlayer, "respawn", "all")
        end

        --// SEÇENEKLER,
        for i, option in ipairs(self.inventoryOptions) do
            local isHovered = isInBox(self.x + 220 + (i - 1) * 150, self.y + 85, 150, 35, "hand")
            dxDrawText(option[1], self.x + 230 + (i - 1) * 150, self.y + 90, nil, nil, (isHovered or self.sidePage == i) and tocolor(88, 101, 242, 200) or tocolor(255, 255, 255, 200), 1, self.fonts.awesomeSmall)
            dxDrawText(option[2], self.x + 260 + (i - 1) * 150, self.y + 90, nil, nil, (isHovered or self.sidePage == i) and tocolor(88, 101, 242, 200) or tocolor(255, 255, 255, 200), 1, self.fonts.robotoSmall)
            if isHovered and isClicked() and self.sidePage ~= i then
                self.currentRow, self.maxRow = 0, 10
                self.selectedTable = option[3]
                self.sidePage = i
            end
        end

        local newY = 0
        local listColor = tocolor(65, 67, 74, 170) 
        local listColor2 = tocolor(47, 49, 55, 170)

        if self.sidePage == 1 then
            --// ARAÇLAR
            dxDrawText("Araç ID", self.x+225, self.y+140, nil, nil, tocolor(255, 255, 255), 1, self.fonts.robotoBSmall)
            dxDrawText("Plaka", self.x+335, self.y+140, nil, nil, tocolor(255, 255, 255), 1, self.fonts.robotoBSmall)

            if #self.selectedTable > 0 then
                for i = self.currentRow + 1, math.min(self.currentRow + self.maxRow, #self.selectedTable) do
                    local index = i - self.currentRow
                    dxDrawRectangle(self.x + 210, self.y + 160 + newY, 350, 30, i % 2 == 0 and listColor2 or listColor)
                    dxDrawText(self.vehicles_info[i].id, self.x + 225, self.y + 165 + newY, nil, nil, tocolor(255, 255, 255, 200), 1, self.fonts.robotoSmall)
                    dxDrawText(self.vehicles_info[i].plate, self.x + 335, self.y + 165 + newY, nil, nil, tocolor(255, 255, 255, 200), 1, self.fonts.robotoSmall)
                    local isHovered = isInBox(self.x + 530, self.y + 163 + newY, 25, 25, "hand")
                    dxDrawText("", self.x + 535, self.y + 167 + newY, nil, nil, (isHovered) and tocolor(88, 101, 242, 200) or tocolor(255, 255, 255, 150), 0.8, self.fonts.awesomeSmall)
                    if isHovered and isClicked() then
                        triggerServerEvent("factions.vehicle", localPlayer, "respawn", self.vehicles_info[i].id)
                    end
                    local isHovered = isInBox(self.x + 500, self.y + 163 + newY, 25, 25, "hand")
                    dxDrawText("", self.x + 510, self.y + 167 + newY, nil, nil, (isHovered) and tocolor(188, 75, 75, 200) or tocolor(255, 255, 255, 150), 0.8, self.fonts.awesomeSmall)
                    if isHovered and isClicked() then
                        triggerServerEvent("factions.vehicle", localPlayer, "remove", self.vehicles_info[i].id)
                        self:refresh()
                    end
                    newY = newY + 30
                end
            else
                dxDrawRectangle(self.x + 210, self.y + 160 + newY, 350, 30, listColor2)
                dxDrawText("Bu birliğe ait hiç taşıt yok.", self.x + 225, self.y + 165 + newY, nil, nil, tocolor(255, 255, 255, 200), 1, self.fonts.robotoSmall)
            end

        elseif self.sidePage == 2 then
            --// MÜLKLER
        end
    end,
}