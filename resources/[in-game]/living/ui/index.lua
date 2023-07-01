local ui = class("UI")

function ui:init()
    self:loadAssets()
    self:registerEvents()
end

function ui:loadAssets()
    assert(loadstring(exports.dxlibrary:loadFunctions()))()

    self.fonts = {
        awesome = exports.fonts:getFont("AwesomeSolid", 12),
        roboto = exports.fonts:getFont("Oswald", 20)
    }

    self.icons = {
        hearth = "",
        armor = "",
        hunger = "",
        thirst = ""
    }
end

function ui:registerEvents()
    self._renderFunction = function(...)
        self:render(...)
    end

    self._needFunction = function(...)
        if localPlayer:getData("online") then
            triggerServerEvent("living.need", localPlayer)
        end
    end

    Timer(self._needFunction, 600000, 0)
    addEventHandler("onClientRender", root, self._renderFunction, false, "low-9999")
end

function ui:render()
    if not localPlayer:getData("online") then
        return
    end

    local iconWidth, iconHeight = 100, 20
    local iconPadding = 40
    local x, y = screen.x / 2 - (iconWidth + 100 * 4 + iconPadding * 3) / 2, screen.y - 25

    local stats = {
        { value = localPlayer.health, color = tocolor(26, 135, 86, 200) },
        { value = localPlayer.armor, color = tocolor(8, 69, 151, 200) },
        { value = localPlayer:getData("hunger"), color = tocolor(185, 154, 102, 200) },
        { value = localPlayer:getData("thirst"), color = tocolor(16, 202, 237, 200) },
    }

    for i, icon in ipairs({self.icons.hearth, self.icons.armor, self.icons.hunger, self.icons.thirst}) do
        local xPos = x + iconPadding * (i - 1) + i * iconWidth - iconPadding + 12

        dxDrawShadowedText(icon, xPos-25, y, iconWidth, iconHeight, tocolor(200, 200, 200, 200), 1, self.fonts.awesome)
        dxDrawRectangle(xPos - 1, y - 1, iconWidth + 2, iconHeight + 2, tocolor(15, 15, 15))
        dxDrawRectangle(xPos, y, stats[i].value, iconHeight, stats[i].color)
    end
    dxDrawShadowedText(""..exports.global:formatMoney(localPlayer:getData("money")).."#005000₺", x+280, y-35, 100, 25, tocolor(175, 175, 175, 220), 1, self.fonts.roboto, "left", "top", false, false, false, true, false)
end
ui:new()