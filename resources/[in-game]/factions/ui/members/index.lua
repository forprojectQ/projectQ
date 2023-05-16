--// ÜYELER SAYFASI
ui.pages[2] = {
    open = function(self)
        self.onlineMembers = 0
        for k, v in pairs(self.members_info) do
            if v.online then
                self.onlineMembers = self.onlineMembers + 1
            end
        end
    end,

    close = function(self)
        self.onlineMembers = nil
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
        for i=1, #self.members_info do
            dxDrawRectangle(self.x+210, self.y+140+newY, self.w-240, 30, i%2 == 0 and listColor2 or listColor)
            dxDrawText(self.members_info[i].name, self.x+215, self.y+145+newY, self.x+215+180, self.y+215+30, tocolor(255, 255, 255, 200), 1, self.fonts.robotoSmall, nil, nil, true)
            dxDrawText((self.ranks_info[ self.members_info[i].rank ].name or "Rütbesiz"), self.x+400, self.y+145+newY, self.x+400+130, self.y+215+30, tocolor(255, 255, 255, 200), 1, self.fonts.robotoSmall, nil, nil, true)
            dxDrawText(self.members_info[i].lastlogin, self.x+550, self.y+145+newY, nil, nil, tocolor(255, 255, 255, 200), 1, self.fonts.robotoSmall)
            newY = newY + 30
        end
    end,
}