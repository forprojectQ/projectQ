--// ENVANTER SAYFASI
ui.pages[5] = {
    open = function(self)
        self.currentRow, self.maxRow = 0, 10

        self.inventoryFunctions = {
            listUp = function()
                if self.currentRow > 0 then
                    self.currentRow = self.currentRow - 1
                end
            end,

            listDown = function()
                if self.currentRow < #self.vehicles_info - self.maxRow then
                    self.currentRow = self.currentRow + 1
                end
            end,
        }

        self.inventoryOptions = {
            {"", "Birlik Taşıtları"},
            {"", "Birlik Mülkleri"},
        }

        bindKey("mouse_wheel_up", "down", self.inventoryFunctions.listUp)
        bindKey("mouse_wheel_down", "down", self.inventoryFunctions.listDown)
    end,

    close = function(self)
        unbindKey("mouse_wheel_up", "down", self.inventoryFunctions.listUp)
        unbindKey("mouse_wheel_down", "down", self.inventoryFunctions.listDown)
        self.currentRow, self.maxRow, self.inventoryFunctions, self.inventoryOptions = nil, nil, nil, nil
        collectgarbage("collect")
    end,

    render = function(self)
        dxDrawText("Birlik Envanteri", self.x+210, self.y+30, nil, nil, tocolor(255, 255, 255), 1, self.fonts.robotoBBig)
        dxDrawText("Birliğe ait taşırlar ve mülklerin listesi.", self.x+210, self.y+50, nil, nil, tocolor(175, 175, 175), 1, self.fonts.robotoSmall)

        local newX = 0
        local newY = 0
        local listColor = tocolor(65, 67, 74, 170) 
        local listColor2 = tocolor(47, 49, 55, 170)

        for i=1, #self.inventoryOptions do
            local isHovered = isInBox(self.x+220+newX, self.y+85, 150, 35, "hand")
            dxDrawText(self.inventoryOptions[i][1], self.x+230+newX, self.y+90, nil, nil, (isHovered or self.sidePage==i) and tocolor(88, 101, 242, 200) or tocolor(255, 255, 255, 200), 1, self.fonts.awesomeSmall)
            dxDrawText(self.inventoryOptions[i][2], self.x+260+newX, self.y+90, nil, nil, (isHovered or self.sidePage==i) and tocolor(88, 101, 242, 200) or tocolor(255, 255, 255, 200), 1, self.fonts.robotoSmall)
            if isHovered and isClicked() and self.sidePage ~= i then
                self.sidePage = i
            end
            newX = newX + 150
        end

        if self.sidePage == 1 then
            dxDrawText("Araç ID", self.x+225, self.y+140, nil, nil, tocolor(255, 255, 255), 1, self.fonts.robotoBSmall)
            dxDrawText("Plaka", self.x+335, self.y+140, nil, nil, tocolor(255, 255, 255), 1, self.fonts.robotoBSmall)
            if #self.vehicles_info > 0 then
                local listCounter = 0
                for i=1, #self.vehicles_info do
                    if i > self.currentRow and listCounter < self.maxRow then
                        dxDrawRectangle(self.x+210, self.y+160+newY, 350, 30, i%2 == 0 and listColor2 or listColor)
                        listCounter = listCounter + 1
                        newY = newY + 30
                    end
                end
            else
                dxDrawRectangle(self.x+210, self.y+160+newY, 350, 30, listColor2)
                dxDrawText("Bu birliğe ait hiç taşıt yok.", self.x+225, self.y+165+newY, nil, nil, tocolor(255, 255, 255, 200), 1, self.fonts.robotoSmall)
            end
        elseif self.sidePage == 2 then
            dxDrawText("Mülk ID", self.x+225, self.y+140, nil, nil, tocolor(255, 255, 255), 1, self.fonts.robotoBSmall)
            dxDrawText("Konum", self.x+335, self.y+140, nil, nil, tocolor(255, 255, 255), 1, self.fonts.robotoBSmall)
            dxDrawRectangle(self.x+210, self.y+160+newY, 350, 30, listColor2)
            dxDrawText("Bu birliğe ait hiç mülk yok.", self.x+225, self.y+165+newY, nil, nil, tocolor(255, 255, 255, 200), 1, self.fonts.robotoSmall)
        end
    end,
}