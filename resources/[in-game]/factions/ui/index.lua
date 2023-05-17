ui = class("UI")

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
    --// ARKAPLAN
    dxDrawRoundedRectangle(self.x-5, self.y-5, self.w+10, self.h+10, 15, tocolor(0, 0, 0, 45))
    dxDrawRoundedRectangle(self.x, self.y, self.w, self.h, 15, tocolor(33, 35, 39))
    dxDrawRoundedRectangle(self.x+200-10, self.y+25-10, self.w-220+20, self.h-50+20, 12, tocolor(0, 0, 0, 7))
    dxDrawRoundedRectangle(self.x+200, self.y+25, self.w-220, self.h-50, 12, tocolor(39, 41, 46))

    --// YÜKLEME EKRANI
    if not self.loaded then
        if getTickCount() >= self.finishLoad then
            dxDrawText("", self.x+100, self.y+self.h/2-25, nil, nil, tocolor(255, 255, 255, 200), 1, self.fonts.awesome, "center", "center")
            return
        end
        self.loading = self.loading + 10
        dxDrawText("", self.x+100, self.y+self.h/2-25, nil, nil, tocolor(255, 255, 255, 200), 1, self.fonts.awesome, "center", "center", false, false, false, false, false, self.loading)
        return
    end

    dxDrawText("", self.x+15, self.y+30, nil, nil, tocolor(255, 255, 255), 1, self.fonts.awesomeSmall)
    dxDrawText("Birlik Arayüzü", self.x+45, self.y+30, nil, nil, tocolor(255, 255, 255), 1, self.fonts.robotoBBig)
    dxDrawText(self.faction_info.name, self.x+15, self.y+55, 500, 500, tocolor(125, 125, 125), 1, self.fonts.roboto, "left", "top", false, true) 

    dxDrawRectangle(self.x+5, self.y+120, 180, 2, tocolor(255, 255, 255, 125))

    --// SOL TARAF LİSTE
    local newY = 0
    for i=1, #self.options do
        local isHoveredPage = isInBox(self.x+5, self.y+140+newY, 180, 50, "hand")
        dxDrawText(self.options[i][1], self.x+20, self.y+150+newY, nil, nil,(isHoveredPage or self.page==i) and tocolor(88, 101, 242, 200) or tocolor(255, 255, 255, 200), 1, self.fonts.awesomeSmall)
        dxDrawText(self.options[i][2], self.x+55, self.y+152+newY, nil, nil,(isHoveredPage or self.page==i) and tocolor(88, 101, 242, 200) or tocolor(255, 255, 255, 200), 1, self.fonts.roboto)
        if isHoveredPage and isClicked() and self.page ~= i then
            self:call(self.page, "close")
            self.page = i
            self.sidePage = 1
            self:call(self.page, "open")
        end
        newY = newY + 50
    end
    
    self:render()
end

function ui:render()
    self:call(self.page, "render")
end

function ui:call(page, state)
    if self.pages[page] and self.pages[page][state] then
        self.pages[page][state](self)
    end
end

function ui:start()
    if localPlayer:getData("online") then
        if self.display then
            self:stop()
        else
            self.display, self.loaded, self.page = true, false, 1
            self.loading, self.finishLoad, self.sidePage = 0, getTickCount()+3000, 1
            showCursor(true)
            addEventHandler("onClientRender", root, self._functions.menu, true, "low-9999")
            triggerServerEvent("factions.get.server", localPlayer)
        end
    end
end

function ui:refresh()
    self:call(self.page, "close")
    self.loaded = false
    self.finishLoad = getTickCount()+3000
    triggerServerEvent("factions.get.server", localPlayer)
end

function ui:stop()
    self.display = false
    self:call(self.page, "close")
    showCursor(false)
    removeEventHandler("onClientRender", root, self._functions.menu)
end

function ui:load(faction, ranks, members)
    self.faction_info = faction
    self.ranks_info = ranks
    self.members_info = members
    self.loaded = true
    self:call(self.page, "open")
end

function ui:loadAssets()
    assert(loadstring(exports.dxlibrary:loadFunctions()))()

    self.x, self.y, self.w, self.h = screen.x/2-800/2, screen.y/2-500/2, 800, 500

    self.options = {
        [1] = {"", "Birlik Panosu"},
        [2] = {"", "Üye Listesi"},
        [3] = {"", "Finans"},
        [4] = {"", "Rütbeler / Yetkiler"},
        [5] = {"", "Birlik Envanteri"},
        [6] = {"", "Birlikten Ayrıl"},
    }

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