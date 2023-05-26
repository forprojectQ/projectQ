--// BİRLİKTEN AYRILMA SAYFASI
ui.pages[6] = {
    open = function(self)

    end,

    close = function(self)

    end,

    render = function(self)
        dxDrawText("Birlikten Ayrılma", self.x+400, self.y+160, nil, nil, tocolor(255, 255, 255), 1, self.fonts.robotoBBig)
        dxDrawText("Bu birlikte şu an aktif "..(#self.members_info or 0).." üye var, birlik seviyesi "..(self.faction_info.level or 1).." gerçekten ayrılmak istiyormusun?", self.x+250, self.y+185, nil, nil, tocolor(175, 175, 175), 1, self.fonts.robotoSmall)

        dxDrawText("", self.x+465, self.y+125, nil, nil, tocolor(255, 255, 255, 150), 1, self.fonts.awesomeSmall)


        if isInBox(self.x+445, self.y+240, 65, 65, "hand") then
            dxDrawText("", self.x+455, self.y+250, nil, nil, tocolor(88, 101, 242, 200), 1, self.fonts.awesome)
            if isClicked() then
                triggerServerEvent("factions.quit", localPlayer)
                self:stop()
            end
        else
            dxDrawText("", self.x+455, self.y+250, nil, nil, tocolor(255, 255, 255, 200), 1, self.fonts.awesome)
        end
    end,
}