--// ÜYELER SAYFASI
ui.pages[2] = {
    open = function(self)
        self.selectedTable, self.currentRow, self.maxRow = self.members_info, 0, 10
        self.editing = nil
        self.onlineMembers = 0
        self.memberFunctions = {
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

        for k, v in pairs(self.members_info) do
            if v.online then
                self.onlineMembers = self.onlineMembers + 1
            end
        end

        bindKey("mouse_wheel_up", "down", self.memberFunctions.listUp)
        bindKey("mouse_wheel_down", "down", self.memberFunctions.listDown)
    end,

    close = function(self)
        unbindKey("mouse_wheel_up", "down", self.memberFunctions.listUp)
        unbindKey("mouse_wheel_down", "down", self.memberFunctions.listDown)
        self.onlineMembers, self.editing, self.currentRow, self.maxRow, self.memberFunctions, self.selectedTable = nil, nil, nil, nil, nil, nil
        collectgarbage("collect")
    end,

    render = function(self)
        dxDrawCustomRoundedRectangle(12, self.x+200, self.y+25, self.w-220, 75, tocolor(65, 67, 74), false, false, false, false, true, true)
        dxDrawRectangle(self.x+200, self.y+25+75, self.w-220, 2, tocolor(255, 255, 255, 125))

        --// SAYFA BAŞLIĞI
        dxDrawText("Birlik Üyeleri", self.x+210, self.y+30, nil, nil, tocolor(255, 255, 255), 1, self.fonts.robotoBBig)
        dxDrawText("Birlik üyelerinin listesi, şu anda aktif "..self.onlineMembers.." üye var.", self.x+210, self.y+50, nil, nil, tocolor(175, 175, 175), 1, self.fonts.robotoSmall)

        dxDrawText("Üye", self.x+215, self.y+110, nil, nil, tocolor(255, 255, 255), 1, self.fonts.robotoB)
        dxDrawText("Rütbe", self.x+405, self.y+110, nil, nil, tocolor(255, 255, 255), 1, self.fonts.robotoB)
        dxDrawText("Son Giriş", self.x+555, self.y+110, nil, nil, tocolor(255, 255, 255), 1, self.fonts.robotoB)
        
        local newY = 0
        local listColor = tocolor(65, 67, 74, 170) 
        local listColor2 = tocolor(47, 49, 55, 170)

        for i = self.currentRow + 1, math.min(self.currentRow + self.maxRow, #self.members_info) do
            local val = self.members_info[i]
            if val then
                dxDrawRectangle(self.x+210, self.y+140+newY, self.w-240, 30, i%2 == 0 and listColor2 or listColor)
                dxDrawText(val.name, self.x+215, self.y+145+newY, self.x+215+180, self.y+215+30+newY, tocolor(255, 255, 255, 200), 1, self.fonts.robotoSmall, nil, nil, true, false)
                dxDrawText((self.ranks_info[val.rank].name or "Rütbesiz"), self.x+400, self.y+145+newY, self.x+400+130, self.y+215+30+newY, tocolor(255, 255, 255, 200), 1, self.fonts.robotoSmall, nil, nil, true, false)
                dxDrawText(val.lastlogin, self.x+540, self.y+145+newY, nil, nil, tocolor(255, 255, 255, 200), 1, self.fonts.robotoSmall)

                local isHovered = isInBox(self.x + 722, self.y + 143 + newY, 25, 25, "hand")
                dxDrawText("", self.x+730, self.y+147+newY, nil, nil, (isHovered) and tocolor(88, 101, 242, 200) or tocolor(255, 255, 255, 150), 0.8, self.fonts.awesomeSmall)
                if isHovered and isClicked() then
                    self.editing = {i, val.id, val.name, val.rank}
                end

                newY = newY + 30
            end
        end
    end,
}