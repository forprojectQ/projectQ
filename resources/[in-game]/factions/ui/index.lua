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
    local x, y, w, h = screen.x/2-600/2, screen.y/2-400/2, 600, 400
    dxDrawRoundedRectangle(x, y, w, h, 10, tocolor(15, 15, 15))
end

function ui:start()
    if localPlayer:getData("online") then
        if self.display then
            self:stop()
        else
            self.display = true
            self.loaded = false
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
    self.loaded = true
end

function ui:loadAssets()
    assert(loadstring(exports.dxlibrary:loadFunctions()))()
end

function ui:registerEvents()
    addEvent("factions.load.client", true)
    addEventHandler("factions.load.client", root, self._functions.load)
end

ui:new()