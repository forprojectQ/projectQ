ui = class("UI")

function ui:init()
    self:loadAssets()
    self:events()

    bindKey("tab", "both", self._startRender)
    bindKey('mouse_wheel_up', 'down', self._up)
    bindKey('mouse_wheel_down', 'down', self._down)
end

function ui:loadAssets()
    assert(loadstring(exports.dxlibrary:loadFunctions()))()
    self.fonts = {
        awesome = exports.fonts:getFont("AwesomeRegular", 20),
        awesome2 = exports.fonts:getFont("AwesomeSolid", 23),
        robotoB = exports.fonts:getFont("RobotoB", 10),
        roboto = exports.fonts:getFont("Roboto", 12),
        oswald = exports.fonts:getFont("Oswald", 23)
    }
    self.players = {}
    self.maxPlayers = 300
    self.current = 1
    self.latest = 1
end

function ui:syncID()
    self.players = {}
    for k, v in ipairs(Element.getAllByType("player")) do 
        self.players[k] = v 
    end
    table.sort(self.players, function(a, b)
        if a ~= localPlayer and b ~= localPlayer and getElementData(a, "playerid") and getElementData(b, "playerid") then 
            return tonumber(getElementData(a, "playerid")) < tonumber(getElementData(b, "playerid"))
        end
    end)
end

function ui:events()
    self._renderFunction = function(...)
        self:render(...)
    end
    self._syncID = function(...)
        self:syncID(...)
    end
    self._startRender = function(...)
        self:start(...)
    end
    self._up = function(...)
        self:up(...)
    end
    self._down = function(...)
        self:down(...)
    end
end

function ui:start()
    if localPlayer:getData("online") then
        self.active = not self.active
        if self.active then 
            self.loading, self.finishLoad = 1, getTickCount()+3000
            addEventHandler("onClientRender", root, self._renderFunction, true, "low-9999")
            Delay = Timer(function()
                self.loaded = true
            end, 3000, 1)
        else
            removeEventHandler("onClientRender", root, self._renderFunction)
            self.loaded = false
        end
    end
end

function ui:render()
    w, h = 390, 480
    x, y = (screen.x-w)/2, (screen.y-h)/2


    self._syncID()

    dxDrawRoundedRectangle(x, y, w, h, 5, tocolor(30, 30, 30, 255))
    dxDrawRectangle(x+80, y+10, 2, 50, tocolor(255, 255, 255, 50))
    dxDrawText("projectQ ROLEPLAY", x+90, y, nil, nil, tocolor(255, 255, 255, 170), 1, self.fonts.oswald)
    dxDrawText("Write You'r History ...", x+91, y+35, nil, nil, tocolor(255, 255, 255, 140), 1, self.fonts.roboto)
    dxDrawText("", x+20, y+15, nil, nil, tocolor(255, 255, 255, 140), 1, self.fonts.awesome2)

    if not self.loaded then
        self.loading = self.loading + 5
        dxDrawText("", x+200, y+220, nil, nil, tocolor(255, 255, 255, 200), 1, self.fonts.awesome2, "center", "center", false, false, false, false, false, self.loading)
        return
    end  

    self.latest = self.current + self.maxPlayers - 1
    counterY = 0
    for k, v in pairs(self.players) do 
        if k >= self.current and k <= self.latest then
            k = k - self.current + 1
            ping = v:getPing()
            id = v:getData('playerid')
            name = v.name:gsub("_", " ")
            hours = (v:getData('timeingame') or 0).." saat"
            if ping > 80 then 
                ping = ping - 20
            end
            if v:getData('online') then
                r, g, b = 255, 255, 255
                dxDrawText(id, x+25, y+80+counterY, nil, nil, tocolor(r, g, b), 1, self.fonts.robotoB)
                dxDrawText(name, x+80, y+80+counterY, nil, nil, tocolor(r, g, b), 1, self.fonts.robotoB)
                dxDrawText(hours, x+250, y+80+counterY, nil, nil, tocolor(r, g, b), 1, self.fonts.robotoB)
                dxDrawText(ping.."ms", x+340, y+80+counterY, nil, nil, tocolor(r, g, b), 1, self.fonts.robotoB)
            else
                r, g, b = 100, 100, 100, 100
                dxDrawText(id, x+25, y+80+counterY, nil, nil, tocolor(r, g, b), 1, self.fonts.robotoB)
                dxDrawText("Giriş Yapıyor", x+100, y+80+counterY, nil, nil, tocolor(r, g, b), 1, self.fonts.robotoB)
                dxDrawText("Bilinmiyor", x+230, y+80+counterY, nil, nil, tocolor(r, g, b), 1, self.fonts.robotoB)
                dxDrawText("?", x+340, y+80+counterY, nil, nil, tocolor(r, g, b), 1, self.fonts.robotoB)
            end
        end
        counterY = counterY + 50
    end
end


function ui:up()
    if getKeyState('tab') then
        if self.current > 1 then
            self.current = self.current - 1
        end
    end
end

function ui:down()
    if getKeyState('tab') then
        if self.current < (#self.players) - (self.max_players - 1) then
            self.current = self.current + 1
        end
    end
end

ui:new()


