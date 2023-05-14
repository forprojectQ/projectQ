function ui:getDashboardInfo()
    self.dashboardInfo = {
        [1] = "$ "..exports.global:formatMoney(self.faction_info.balance).."",
        [2] = ""..(#self.members_info or 0).." üye",
        [3] = ""..(self.faction_info.level or 1).." seviye",
        [4] = ""..types[self.faction_info.type].."",
    }
    return self.dashboardInfo
end

function ui:getDashboardNote()
    if self.sidePage >= 1 and self.sidePage <= #self.faction_notes then
        return self.faction_notes[self.sidePage]
    end
end

function ui:dashboard()
    --// SAYFA BAŞLIĞI
    dxDrawText("Birlik Panosu", self.x+210, self.y+30, nil, nil, tocolor(255, 255, 255), 1, self.fonts.robotoBBig)
    dxDrawText("Birlik hakkında bilgiler ve yöneticilerin notları.", self.x+210, self.y+50, nil, nil, tocolor(175, 175, 175), 1, self.fonts.robotoSmall)

    --// BİLGİ ARKAPLANI
    dxDrawCustomRoundedRectangle(12, self.x+200+self.w/2-15, self.y+25, 200, self.h-50, tocolor(65, 67, 74), false, false, true, false, true, false)

    --// NOTLAR KISMI
    local note = self:getDashboardNote()
    local width = dxGetTextWidth("", 1, self.fonts.awesomeSmall)
    local height = dxGetFontHeight(1, self.fonts.awesomeSmall)
    dxDrawRoundedRectangle(self.x+210, self.y+75, 355, 350, 12, tocolor(15, 15, 15, 75))
    dxDrawText(note, self.x+220, self.y+85, 800, 550, tocolor(255, 255, 255), 1, self.fonts.robotoSmall, "left", "top", true, true, false, true)
    dxDrawText(self.sidePage, self.x+245, self.y+85+357, nil, nil, tocolor(255, 255, 255, 150), 0.8, self.fonts.awesomeSmall)
    
    if isInBox(self.x+220, self.y+85+355, width, height, "hand") then
        dxDrawText("", self.x+220, self.y+85+355, nil, nil, tocolor(255, 255, 255), 1, self.fonts.awesomeSmall)
        if isClicked() then
            if self.sidePage > 1 then
                self.sidePage = self.sidePage - 1
            end
        end
    else
        dxDrawText("", self.x+220, self.y+85+355, nil, nil, tocolor(255, 255, 255, 150), 1, self.fonts.awesomeSmall)
    end
    
    if isInBox(self.x+270, self.y+85+355, width, height, "hand") then
        dxDrawText("", self.x+270, self.y+85+355, nil, nil, tocolor(255, 255, 255), 1, self.fonts.awesomeSmall)
        if isClicked() then
            if self.sidePage < 3 then
                self.sidePage = self.sidePage + 1
            end
        end
    else
        dxDrawText("", self.x+270, self.y+85+355, nil, nil, tocolor(255, 255, 255, 150), 1, self.fonts.awesomeSmall)
    end

    --// BİLGİ KUTUCUKLARI
    local dashboardInfo = self:getDashboardInfo()
    local newX1 = self.x+200+self.w/2-7
    local newX2 = self.x+200+self.w/2+5
    local newY = 0
    for i=1, 4 do
        dxDrawRoundedRectangle(newX1, self.y+45+newY, 185, 60, 8, tocolor(39, 41, 46))
        dxDrawRectangle(newX1, self.y+55+newY, 2, 40, self.infoBox[i][3])
        dxDrawText(self.infoBox[i][2], newX2+140, self.y+65+newY, nil, nil, self.infoBox[i][3], 1, self.fonts.awesomeSmall)
        dxDrawText(self.infoBox[i][1], newX2, self.y+55+newY, nil, nil, tocolor(255, 255, 255, 245), 1, self.fonts.robotoB)
        dxDrawText(dashboardInfo[i], newX2, self.y+75+newY, nil, nil, tocolor(255, 255, 255, 175), 1, self.fonts.robotoSmall)
        newY = newY + 65
    end
end