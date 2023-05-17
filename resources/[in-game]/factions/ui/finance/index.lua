--// FİNANS SAYFASI
ui.pages[3] = {
    open = function(self)
        self.text = ""
        self.alpha = 0
        self.financeFunctions = {
            write = function(key)
                if tonumber(key) then
                    if string.len(self.text) > 15 then return end 
                    self.text = self.text..key
                end
            end,

            textRectangle = function()
                if self.alpha == 125 then
                    self.alpha = 0
                else
                    self.alpha = 125
                end
            end,
        }
        self.financeOptions = {
            {"", "Kasaya Para Yatır"},
            {"", "Kasadan Para Çek"},
        }
        self.timer = Timer(self.financeFunctions.textRectangle, 350, 0)
        addEventHandler("onClientCharacter", root, self.financeFunctions.write)
    end,

    close = function(self)
        self.timer:destroy()
        removeEventHandler("onClientCharacter", root, self.financeFunctions.write)
        self.alpha = nil
        self.text = nil
        self.financeFunctions = nil
        self.financeOptions = nil
        collectgarbage("collect")
    end,

    render = function(self)
        dxDrawText("Birlik Kasası", self.x+210, self.y+30, nil, nil, tocolor(255, 255, 255), 1, self.fonts.robotoBBig)
        dxDrawText("Mevcut kasa ve para yatırma/çekme işlemleri.", self.x+210, self.y+50, nil, nil, tocolor(175, 175, 175), 1, self.fonts.robotoSmall)

        local case = exports.global:formatMoney(self.faction_info.balance)
        local cash = exports.global:formatMoney(localPlayer:getData("money"))
        local money = exports.global:formatMoney(self.text) or "0"
        local textSize = dxGetTextWidth("$"..money, 1, self.fonts.robotoBBig)

        local newX = 0
        for i=1, #self.financeOptions do
            local isHovered = isInBox(self.x+220+newX, self.y+85, 150, 35, "hand")
            dxDrawText(self.financeOptions[i][1], self.x+230+newX, self.y+90, nil, nil, (isHovered or self.sidePage==i) and tocolor(88, 101, 242, 200) or tocolor(255, 255, 255, 200), 1, self.fonts.awesomeSmall)
            dxDrawText(self.financeOptions[i][2], self.x+260+newX, self.y+90, nil, nil, (isHovered or self.sidePage==i) and tocolor(88, 101, 242, 200) or tocolor(255, 255, 255, 200), 1, self.fonts.robotoSmall)
            if isHovered and isClicked() and self.sidePage ~= i then
                self.sidePage = i
                self.text = ""
            end
            newX = newX + 150
        end

        if getKeyState("backspace") and tick+120 <= getTickCount() then
            tick = getTickCount()
            local fistPart = self.text:sub(0, string.len(self.text)-1)
            local lastPart = self.text:sub(string.len(self.text)+1, #self.text)
            self.text = fistPart..lastPart
        end

        --// SAYFALAR
        if self.sidePage == 1 then
            dxDrawText("Kasaya Yatırılacak Miktar", self.x+230, self.y+150, nil, nil, tocolor(255, 255, 255, 245), 1, self.fonts.robotoB)
 
            dxDrawText("$"..money, self.x+230, self.y+175, nil, nil, tocolor(88, 242, 88, 155), 1, self.fonts.robotoBBig)
            dxDrawText("l", self.x+230+textSize, self.y+175, nil, nil, tocolor(88, 242, 88, self.alpha), 1, self.fonts.robotoBBig)

            --// İŞLEM
            dxDrawText("İşlem", self.x+230, self.y+270, nil, nil, tocolor(255, 255, 255, 245), 1, self.fonts.robotoB)

            dxDrawRoundedRectangle(self.x+215, self.y+300, 275, 60, 8, tocolor(65, 67, 74, 155))
            dxDrawRectangle(self.x+215, self.y+310, 2, 40, tocolor(88, 242, 88, 125))
            dxDrawText("Birlik Kasası", self.x+230, self.y+305, nil, nil, tocolor(255, 255, 255, 245), 1, self.fonts.robotoB)
            dxDrawText("$"..case.." + $"..money, self.x+230, self.y+325, nil, nil, tocolor(255, 255, 255, 175), 1, self.fonts.robotoSmall)
            dxDrawText("", self.x+450, self.y+320, nil, nil, tocolor(88, 242, 88, 125), 1, self.fonts.awesomeSmall)

            dxDrawRoundedRectangle(self.x+215+280, self.y+300, 275, 60, 8, tocolor(65, 67, 74, 155))
            dxDrawRectangle(self.x+215+280, self.y+310, 2, 40, tocolor(242, 88, 88, 125))
            dxDrawText("Cüzdanınız", self.x+230+280, self.y+305, nil, nil, tocolor(255, 255, 255, 245), 1, self.fonts.robotoB)
            dxDrawText("$"..cash.." - $"..money, self.x+230+280, self.y+325, nil, nil, tocolor(255, 255, 255, 175), 1, self.fonts.robotoSmall)
            dxDrawText("", self.x+450+280, self.y+320, nil, nil, tocolor(242, 88, 88, 125), 1, self.fonts.awesomeSmall)

            if isInBox(self.x+460, self.y+395, 50, 50, "hand") then
                dxDrawText("", self.x+475, self.y+400, nil, nil, tocolor(255, 255, 255, 125), 1, self.fonts.awesome)
                if isClicked() then
                    triggerServerEvent("factions.finance", localPlayer, self.faction_info.id, self.text, "deposit")
                    self:refresh()
                end
            else
                dxDrawText("", self.x+475, self.y+400, nil, nil, tocolor(255, 255, 255, 175), 1, self.fonts.awesome)
            end
        elseif self.sidePage == 2 then
            dxDrawText("Kasadan Çeliecek Miktar", self.x+230, self.y+150, nil, nil, tocolor(255, 255, 255, 245), 1, self.fonts.robotoB)
 
            dxDrawText("$"..money, self.x+230, self.y+175, nil, nil, tocolor(88, 242, 88, 155), 1, self.fonts.robotoBBig)
            dxDrawText("l", self.x+230+textSize, self.y+175, nil, nil, tocolor(88, 242, 88, self.alpha), 1, self.fonts.robotoBBig)

            --// İŞLEM
            dxDrawText("İşlem", self.x+230, self.y+270, nil, nil, tocolor(255, 255, 255, 245), 1, self.fonts.robotoB)

            dxDrawRoundedRectangle(self.x+215, self.y+300, 275, 60, 8, tocolor(65, 67, 74, 155))
            dxDrawRectangle(self.x+215, self.y+310, 2, 40, tocolor(242, 88, 88, 125))
            dxDrawText("Birlik Kasası", self.x+230, self.y+305, nil, nil, tocolor(255, 255, 255, 245), 1, self.fonts.robotoB)
            dxDrawText("$"..case.." - $"..money, self.x+230, self.y+325, nil, nil, tocolor(255, 255, 255, 175), 1, self.fonts.robotoSmall)
            dxDrawText("", self.x+450, self.y+320, nil, nil, tocolor(242, 88, 88, 125), 1, self.fonts.awesomeSmall)

            dxDrawRoundedRectangle(self.x+215+280, self.y+300, 275, 60, 8, tocolor(65, 67, 74, 155))
            dxDrawRectangle(self.x+215+280, self.y+310, 2, 40, tocolor(88, 242, 88, 125))
            dxDrawText("Cüzdanınız", self.x+230+280, self.y+305, nil, nil, tocolor(255, 255, 255, 245), 1, self.fonts.robotoB)
            dxDrawText("$"..cash.." + $"..money, self.x+230+280, self.y+325, nil, nil, tocolor(255, 255, 255, 175), 1, self.fonts.robotoSmall)
            dxDrawText("", self.x+450+280, self.y+320, nil, nil, tocolor(88, 242, 88, 125), 1, self.fonts.awesomeSmall)

            if isInBox(self.x+460, self.y+395, 50, 50, "hand") then
                dxDrawText("", self.x+475, self.y+400, nil, nil, tocolor(255, 255, 255, 125), 1, self.fonts.awesome)
                if isClicked() then
                    triggerServerEvent("factions.finance", localPlayer, self.faction_info.id, self.text, "withdraw")
                    self:refresh()
                end
            else
                dxDrawText("", self.x+475, self.y+400, nil, nil, tocolor(255, 255, 255, 175), 1, self.fonts.awesome)
            end
        end
    end,
}