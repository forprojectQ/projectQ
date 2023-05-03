local ui = class("UI")

function ui:init()
    triggerServerEvent("death.check", localPlayer)

    self:loadAssets()
    self:registerEvents()
end

function ui:loadAssets()
    assert(loadstring(exports.dxlibrary:loadFunctions()))()

    self.fonts = {
        awesome = exports.fonts:getFont("AwesomeSolid", 45),
        robotoB = exports.fonts:getFont("RobotoB", 10),
        roboto = exports.fonts:getFont("Roboto", 11)
    }

end

function ui:registerEvents()
    self._renderFunction = function(...)
        self:render(...)
    end

    self._deathFunction = function(...)
        self:death(...)
    end

    self._finishFunction = function(...)
        self:finish(...)
    end

    addEvent("death.counter", true)
    addEventHandler("death.counter", root, self._deathFunction)
    addEvent("death.finish", true)
    addEventHandler("death.finish", root, self._finishFunction)
end

function ui:render()
    if not localPlayer:getData("online") then
        return
    end
    dxDrawRectangle(0, 0, screen.x, screen.y, tocolor(20, 20, 20))
    dxDrawText("", screen.x/2, screen.y/2-100, nil, nil, tocolor(225, 225, 225, self.alpha), 1, self.fonts.awesome)
    dxDrawText("Bayıldınız, tekrar ayaklanmak için kalan", screen.x/2-75, screen.y/2-15, nil, nil, tocolor(225, 225, 225, 225), 1, self.fonts.robotoB)
    dxDrawText(""..self.counter.." saniye", screen.x/2, screen.y/2+5, nil, nil, tocolor(225, 178, 84, 225), 1, self.fonts.roboto)
end

function ui:death()
    if self.active then
        return
    end
    self.active = true
    self.counter = 150 --// 150 saniye
    self.alpha = 225
    showChat(false)
    showCursor(true)
    addEventHandler("onClientRender", root, self._renderFunction, true, "low-9999")
    self.timer = Timer(function()
        if self.counter <= 0 then
            triggerServerEvent("death.spawn", localPlayer)
            return
        end
        if self.alpha == 225 then
            self.alpha = 75
        else
            self.alpha = 225
        end
        self.counter = self.counter - 1
    end, 1000, 0)
end

function ui:finish()
    self.active = false
    showChat(true)
    showCursor(false)
    removeEventHandler("onClientRender", root, self._renderFunction)
    if self.timer.valid then
        self.timer:destroy()
    end
end

ui:new()