local ui = class("UI")

function ui:init()
    self._functions = {
        load = function(...) self:load(...) end,
        start = function(...) self:start(...) end,
        menu = function(...) self:menu(...) end,
    }

    self:registerEvents()
    self:loadAssets()

    bindKey("F3", "down", self._functions.start)
end

function ui:menu()
    local x, y, w, h = screen.x/2-800/2, screen.y/2-500/2, 800, 500

    --// ARKAPLAN
    dxDrawRoundedRectangle(x-5, y-5, w+10, h+10, 15, tocolor(0, 0, 0, 45))
    dxDrawRoundedRectangle(x, y, w, h, 15, tocolor(33, 35, 39))
    dxDrawRoundedRectangle(x+200-10, y+25-10, w-220+20, h-50+20, 12, tocolor(0, 0, 0, 7))
    dxDrawRoundedRectangle(x+200, y+25, w-220, h-50, 12, tocolor(39, 41, 46))

    --// YÜKLEME EKRANI
    if not self.loaded then
        if getTickCount() >= self.finishLoad then
            dxDrawText("", x+100, y+h/2-25, nil, nil, tocolor(255, 255, 255, 200), 1, self.fonts.awesome, "center", "center")
            --// YÜKLENEMEDİ EKRANI ...
            return
        end
        self.loading = self.loading + 10
        dxDrawText("", x+100, y+h/2-25, nil, nil, tocolor(255, 255, 255, 200), 1, self.fonts.awesome, "center", "center", false, false, false, false, false, self.loading)
        return
    end

    --// SOL TARAF
    local name = self.faction_info.name
    if string.len(name) >= 15 then
        name = ""..string.sub(name,1,15).."\n"..string.sub(name,15,30)
    end

    dxDrawText("", x+15, y+30, nil, nil, tocolor(255, 255, 255), 1, self.fonts.awesomeSmall)
    dxDrawText("Birlik Arayüzü", x+45, y+30, nil, nil, tocolor(255, 255, 255), 1, self.fonts.robotoBBig)
    dxDrawText(name, x+15, y+55, nil, nil, tocolor(125, 125, 125), 1, self.fonts.roboto)

    dxDrawRectangle(x+5, y+120, 180, 2, tocolor(255, 255, 255, 125))

    --// SOL TARAF LİSTE
    local newY = 0
    for i=1, #self.options do
        if self.page == i then
            if isInBox(x+5, y+140+newY, 180, 50, "hand") then end
            dxDrawText(self.options[i][1], x+20, y+150+newY, nil, nil, tocolor(88, 101, 242, 200), 1, self.fonts.awesomeSmall)
            dxDrawText(self.options[i][2], x+55, y+152+newY, nil, nil, tocolor(88, 101, 242, 200), 1, self.fonts.roboto)
        else
            if isInBox(x+5, y+140+newY, 180, 50, "hand") then
                dxDrawText(self.options[i][1], x+20, y+150+newY, nil, nil, tocolor(88, 101, 242, 200), 1, self.fonts.awesomeSmall)
                dxDrawText(self.options[i][2], x+55, y+152+newY, nil, nil, tocolor(88, 101, 242, 200), 1, self.fonts.roboto)
                if isClicked() then
                    self.page = i
                end
            else
                dxDrawText(self.options[i][1], x+20, y+150+newY, nil, nil, tocolor(255, 255, 255, 200), 1, self.fonts.awesomeSmall)
                dxDrawText(self.options[i][2], x+55, y+152+newY, nil, nil, tocolor(255, 255, 255, 200), 1, self.fonts.roboto)
            end
        end
        newY = newY + 50
    end

    --// SAYFALAR
    if self.page == 1 then
        --// SAYFA BAŞLIĞI
        dxDrawText("Birlik Panosu", x+210, y+30, nil, nil, tocolor(255, 255, 255), 1, self.fonts.robotoBBig)
        dxDrawText("Lorem İpsum Lorem İpsum Lorem İpsum Lorem İpsum.", x+210, y+50, nil, nil, tocolor(175, 175, 175), 1, self.fonts.robotoSmall)

        --// BİLGİ KUTUCUKLARI ...
        dxDrawRectangle(x+200+w/2-15, y+25, 185, h-50, tocolor(65, 67, 74))
        dxDrawRoundedRectangle(x+200+w/2, y+25, 185, h-50, 12, tocolor(65, 67, 74))

        dxDrawRoundedRectangle(x+200+w/2-7, y+45, 185, 60, 8, tocolor(39, 41, 46))
        dxDrawRectangle(x+200+w/2-7, y+55, 2, 40, tocolor(88, 101, 242, 125))

        dxDrawRoundedRectangle(x+200+w/2-7, y+45+65, 185, 60, 8, tocolor(39, 41, 46))
        dxDrawRectangle(x+200+w/2-7, y+55+65, 2, 40, tocolor(88, 101, 242, 125))

        dxDrawRoundedRectangle(x+200+w/2-7, y+45+65*2, 185, 60, 8, tocolor(39, 41, 46))
        dxDrawRectangle(x+200+w/2-7, y+55+65*2, 2, 40, tocolor(88, 101, 242, 125))

    elseif self.page == 2 then
         --// SAYFA BAŞLIĞI
        dxDrawRoundedRectangle(x+200, y+25, w-220, 75, 12, tocolor(65, 67, 74))
        dxDrawRectangle(x+200, y+45, w-220, 75, tocolor(65, 67, 74))
        dxDrawRectangle(x+200, y+45+75, w-220, 2, tocolor(255, 255, 255, 125))

    end
end

function ui:start()
    if localPlayer:getData("online") then
        if self.display then
            self:stop()
        else
            self.display, self.loaded, self.page = true, false, 1
            self.loading, self.finishLoad = 0, getTickCount()+3000
            showCursor(true)
            addEventHandler("onClientRender", root, self._functions.menu, true, "low-9999")
            triggerServerEvent("factions.get.server", localPlayer)
        end
    end
end

function ui:stop()
    self.display = false
    showCursor(false)
    removeEventHandler("onClientRender", root, self._functions.menu)
end

function ui:load(faction, ranks)
    self.faction_info = faction
    self.ranks_info = ranks
    self.loaded = true
end

function ui:loadAssets()
    self.options = {
        [1] = {"", "Birlik Panosu"},
        [2] = {"", "Üye Listesi"},
        [3] = {"", "Finans"},
        [4] = {"", "Rütbeler / Yetkiler"},
        [5] = {"", "Birlik Envanteri"},
        [6] = {"", "Birlikten Ayrıl"},
    }

    assert(loadstring(exports.dxlibrary:loadFunctions()))()

    self.fonts = {
        awesome = exports.fonts:getFont("AwesomeSolid", 25),
        awesomeSmall = exports.fonts:getFont("AwesomeSolid", 12),
        roboto = exports.fonts:getFont("Roboto", 11),
        robotoSmall = exports.fonts:getFont("Roboto", 10),
        robotoB = exports.fonts:getFont("RobotoB", 11),
        robotoBBig = exports.fonts:getFont("RobotoB", 14),
    }
end

function ui:registerEvents()
    addEvent("factions.load.client", true)
    addEventHandler("factions.load.client", root, self._functions.load)
end

ui:new()