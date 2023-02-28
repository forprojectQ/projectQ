local ipairs = ipairs
local getKeyState = getKeyState
local dxDrawText = dxDrawText
local dxDrawRectangle = dxDrawRectangle
local dxDrawCircle = dxDrawCircle
local dxGetFontHeight = dxGetFontHeight
local dxGetTextWidth = dxGetTextWidth
local tocolor = tocolor
local exports = exports
local getTickCount = getTickCount
local addEventHandler = addEventHandler
local addEvent = addEvent
local removeEventHandler = removeEventHandler
local guiGetScreenSize = guiGetScreenSize
local getCursorPosition = getCursorPosition
local triggerServerEvent = triggerServerEvent
account = class("All")

function account:init()
    self._functions = {
        render = function(...) self:render(...) end,
        textRectangle = function(...) self:textRectangle(...) end,
        notify = function(...) self:notify(...) end,
        notifyRender = function(...) self:notifyRender(...) end,
        write = function(...) self:write(...) end,
        login = function(...) self:login(...) end,
        remember = function(...) self:remember(...) end
    }
    self.icons = {
        load = exports.fonts:getIcon("load"),
        user = exports.fonts:getIcon("user"),
        key = exports.fonts:getIcon("key"),
        arrow = exports.fonts:getIcon("arrow-right"),
        plus = exports.fonts:getIcon("plus"),
        login = exports.fonts:getIcon("login"),
        mail = exports.fonts:getIcon("mail"),
        eye = exports.fonts:getIcon("eye"),
        eyeslash = exports.fonts:getIcon("eye-slash"),
        male = exports.fonts:getIcon("person"),
        female = exports.fonts:getIcon("person-dress"),
        location = exports.fonts:getIcon("location")
    }
    self.screen = Vector2(guiGetScreenSize())
    self.awesome = exports.fonts:getFont("AwesomeSolid", 9)
    self.roboto = exports.fonts:getFont('Roboto', 10)
    self.robotoB = exports.fonts:getFont('RobotoB', 10)

    self:start()
    self:components()
end

function account:render()
    dxDrawRectangle(0, 0, self.screen.x, self.screen.y, tocolor(25,25,25))

    --// CURSOR FUNCTIONS
    local cursorShowing = isCursorShowing()
    local cursorX, cursorY
    if cursorShowing then
        cursorX, cursorY = getCursorPosition()
        cursorX, cursorY = cursorX*self.screen.x, cursorY*self.screen.y
    end

    if self.load <= 750 then
        self.load = self.load + 5
        dxDrawText(self.icons.load, self.screen.x/2, self.screen.y/2, nil, nil, tocolor(225,225,225), 1, self.awesome, "center", "center", false, false, false, false, false, self.load)
    else
        if self.page == 1 then
            local newY = 0
            local order = 1
            if self.selected == order then
                self:roundedRectangle(self.screen.x/2-240/2, self.screen.y/2-30/2+newY, 240, 30, 9, tocolor(55,55,55,245))
                local textSize = dxGetTextWidth(self.texts.username, 1, self.roboto)
                dxDrawText('l', self.screen.x/2-240/2+30+(textSize), self.screen.y/2-30/2+newY+6, nil, nil,tocolor(195,195,195,self.alpha), 1, self.roboto)
            else
                if cursorShowing and cursorX >= self.screen.x/2-240/2 and cursorX <= self.screen.x/2-240/2+240 and cursorY >= self.screen.y/2-30/2+newY and cursorY <= self.screen.y/2-30/2+newY+30 then
                    self:roundedRectangle(self.screen.x/2-240/2, self.screen.y/2-30/2+newY, 240, 30, 9, tocolor(55,55,55,245))
                    if getKeyState('mouse1') and self.tick+400 <= getTickCount() then
                        self.tick = getTickCount()
                        self.selected = order
                        if self.texts.username == "kullanıcı adı" then
                            self.texts.username = ""
                        end
                    end
                else
                    self:roundedRectangle(self.screen.x/2-240/2, self.screen.y/2-30/2+newY, 240, 30, 9, tocolor(55,55,55,200))
                end
            end
            dxDrawText(self.icons.user, self.screen.x/2-240/2+10, self.screen.y/2-30/2+newY+7, nil, nil, tocolor(225,225,225), 1, self.awesome)
            dxDrawText(self.texts.username, self.screen.x/2-240/2+30, self.screen.y/2-30/2+newY+6, nil, nil, tocolor(225,225,225), 1, self.roboto)

            local textSize
            local newY = newY + 33
            local order = 2
            if self.selected == order then
                self:roundedRectangle(self.screen.x/2-240/2, self.screen.y/2-30/2+newY, 240, 30, 9, tocolor(55,55,55,245))
                if self.show then
                    textSize = dxGetTextWidth(self.texts.password, 1, self.roboto)
                else
                    textSize = dxGetTextWidth(string.gsub(self.texts.password, ".", "*"), 1, self.roboto)
                end
                dxDrawText('l', self.screen.x/2-240/2+30+(textSize), self.screen.y/2-30/2+newY+6, nil, nil,tocolor(195,195,195,self.alpha), 1, self.roboto)
            else
                if cursorShowing and cursorX >= self.screen.x/2-240/2 and cursorX <= self.screen.x/2-240/2+240 and cursorY >= self.screen.y/2-30/2+newY and cursorY <= self.screen.y/2-30/2+newY+30 then
                    self:roundedRectangle(self.screen.x/2-240/2, self.screen.y/2-30/2+newY, 240, 30, 9, tocolor(55,55,55,245))
                    if getKeyState('mouse1') and self.tick+400 <= getTickCount() then
                        self.tick = getTickCount()
                        self.selected = order
                        if self.texts.password == "şifre" then
                            self.texts.password = ""
                        end
                    end
                else
                    self:roundedRectangle(self.screen.x/2-240/2, self.screen.y/2-30/2+newY, 240, 30, 9, tocolor(55,55,55,200))
                end
            end
            dxDrawText(self.icons.key, self.screen.x/2-240/2+10, self.screen.y/2-30/2+newY+7, nil, nil, tocolor(225,225,225), 1, self.awesome)
            if self.show then
                dxDrawText(self.texts.password, self.screen.x/2-240/2+30, self.screen.y/2-30/2+newY+6, nil, nil, tocolor(225,225,225), 1, self.roboto)
            else
                dxDrawText(string.gsub(self.texts.password, ".", "*"), self.screen.x/2-240/2+30, self.screen.y/2-30/2+newY+6, nil, nil, tocolor(225,225,225), 1, self.roboto)
            end

            local icon
            if self.show then
                icon = self.icons.eyeslash
            else
                icon = self.icons.eye
            end
            local width = dxGetTextWidth(self.icons.arrow, 1, self.awesome)
            local height = dxGetFontHeight(1, self.awesome)
            if cursorShowing and cursorX >= self.screen.x/2-240/2+215 and cursorX <= self.screen.x/2-240/2+215+width and cursorY >= self.screen.y/2-30/2+newY+6 and cursorY <= self.screen.y/2-30/2+newY+6+height then
                dxDrawText(icon, self.screen.x/2-240/2+215, self.screen.y/2-30/2+newY+6, nil, nil, tocolor(225,225,225,245), 1, self.awesome)
                if getKeyState('mouse1') and self.tick+400 <= getTickCount() then
                    self.tick = getTickCount()
                    if self.show then
                        self.show = false
                    else
                        self.show = true
                    end
                end
            else
                dxDrawText(icon, self.screen.x/2-240/2+215, self.screen.y/2-30/2+newY+6, nil, nil, tocolor(225,225,225,200), 1, self.awesome)
            end

            local width = dxGetTextWidth(self.icons.arrow, 1, self.awesome)
            local height = dxGetFontHeight(1, self.awesome)
            if cursorShowing and cursorX >= self.screen.x/2-240/2+240+10 and cursorX <= self.screen.x/2-240/2+240+10+width and cursorY >= self.screen.y/2-30/2+newY+7 and cursorY <= self.screen.y/2-30/2+newY+7+height then
                dxDrawText(self.icons.arrow, self.screen.x/2-240/2+240+10, self.screen.y/2-30/2+newY+7, nil, nil, tocolor(225,225,225,245), 1, self.awesome)
                if getKeyState('mouse1') and self.tick+400 <= getTickCount() then
                    self.tick = getTickCount()
                    triggerServerEvent("auth.login", localPlayer, self.texts.username, self.texts.password)
                end
            else
                dxDrawText(self.icons.arrow, self.screen.x/2-240/2+240+10, self.screen.y/2-30/2+newY+7, nil, nil, tocolor(225,225,225,200), 1, self.awesome)
            end

            local newY = newY - 32
            local width = dxGetTextWidth(self.icons.plus, 1, self.awesome)
            local height = dxGetFontHeight(1, self.awesome)
            if cursorShowing and cursorX >= self.screen.x/2-240/2+240+10 and cursorX <= self.screen.x/2-240/2+240+10+width and cursorY >= self.screen.y/2-30/2+newY+6 and cursorY <= self.screen.y/2-30/2+newY+6+height then
                dxDrawText(self.icons.plus, self.screen.x/2-240/2+240+10, self.screen.y/2-30/2+newY+6, nil, nil, tocolor(225,225,225,245), 1, self.awesome)
                if getKeyState('mouse1') and self.tick+400 <= getTickCount() then
                    self.tick = getTickCount()
                    self.page = 2
                end
            else
                dxDrawText(self.icons.plus, self.screen.x/2-240/2+240+10, self.screen.y/2-30/2+newY+6, nil, nil, tocolor(225,225,225,200), 1, self.awesome)
            end
        elseif self.page == 2 then
            local newY = 0
            local order = 1
            if self.selected == order then
                self:roundedRectangle(self.screen.x/2-240/2, self.screen.y/2-30/2+newY, 240, 30, 9, tocolor(55,55,55,245))
                local textSize = dxGetTextWidth(self.texts.username, 1, self.roboto)
                dxDrawText('l', self.screen.x/2-240/2+30+(textSize), self.screen.y/2-30/2+newY+6, nil, nil,tocolor(195,195,195,self.alpha), 1, self.roboto)
            else
                if cursorShowing and cursorX >= self.screen.x/2-240/2 and cursorX <= self.screen.x/2-240/2+240 and cursorY >= self.screen.y/2-30/2+newY and cursorY <= self.screen.y/2-30/2+newY+30 then
                    self:roundedRectangle(self.screen.x/2-240/2, self.screen.y/2-30/2+newY, 240, 30, 9, tocolor(55,55,55,245))
                    if getKeyState('mouse1') and self.tick+400 <= getTickCount() then
                        self.tick = getTickCount()
                        self.selected = order
                        if self.texts.username == "kullanıcı adı" then
                            self.texts.username = ""
                        end
                    end
                else
                    self:roundedRectangle(self.screen.x/2-240/2, self.screen.y/2-30/2+newY, 240, 30, 9, tocolor(55,55,55,200))
                end
            end
            dxDrawText(self.icons.user, self.screen.x/2-240/2+10, self.screen.y/2-30/2+newY+7, nil, nil, tocolor(225,225,225), 1, self.awesome)
            dxDrawText(self.texts.username, self.screen.x/2-240/2+30, self.screen.y/2-30/2+newY+6, nil, nil, tocolor(225,225,225), 1, self.roboto)

            local textSize
            local newY = newY + 33
            local order = 2
            if self.selected == order then
                self:roundedRectangle(self.screen.x/2-240/2, self.screen.y/2-30/2+newY, 240, 30, 9, tocolor(55,55,55,245))
                if self.show then
                    textSize = dxGetTextWidth(self.texts.password, 1, self.roboto)
                else
                    textSize = dxGetTextWidth(string.gsub(self.texts.password, ".", "*"), 1, self.roboto)
                end
                dxDrawText('l', self.screen.x/2-240/2+30+(textSize), self.screen.y/2-30/2+newY+6, nil, nil,tocolor(195,195,195,self.alpha), 1, self.roboto)
            else
                if cursorShowing and cursorX >= self.screen.x/2-240/2 and cursorX <= self.screen.x/2-240/2+240 and cursorY >= self.screen.y/2-30/2+newY and cursorY <= self.screen.y/2-30/2+newY+30 then
                    self:roundedRectangle(self.screen.x/2-240/2, self.screen.y/2-30/2+newY, 240, 30, 9, tocolor(55,55,55,245))
                    if getKeyState('mouse1') and self.tick+400 <= getTickCount() then
                        self.tick = getTickCount()
                        self.selected = order
                        if self.texts.password == "şifre" then
                            self.texts.password = ""
                        end
                    end
                else
                    self:roundedRectangle(self.screen.x/2-240/2, self.screen.y/2-30/2+newY, 240, 30, 9, tocolor(55,55,55,200))
                end
            end
            dxDrawText(self.icons.key, self.screen.x/2-240/2+10, self.screen.y/2-30/2+newY+7, nil, nil, tocolor(225,225,225), 1, self.awesome)
            if self.show then
                dxDrawText(self.texts.password, self.screen.x/2-240/2+30, self.screen.y/2-30/2+newY+6, nil, nil, tocolor(225,225,225), 1, self.roboto)
            else
                dxDrawText(string.gsub(self.texts.password, ".", "*"), self.screen.x/2-240/2+30, self.screen.y/2-30/2+newY+6, nil, nil, tocolor(225,225,225), 1, self.roboto)
            end

            local icon
            if self.show then
                icon = self.icons.eyeslash
            else
                icon = self.icons.eye
            end
            local width = dxGetTextWidth(self.icons.arrow, 1, self.awesome)
            local height = dxGetFontHeight(1, self.awesome)
            if cursorShowing and cursorX >= self.screen.x/2-240/2+215 and cursorX <= self.screen.x/2-240/2+215+width and cursorY >= self.screen.y/2-30/2+newY+6 and cursorY <= self.screen.y/2-30/2+newY+6+height then
                dxDrawText(icon, self.screen.x/2-240/2+215, self.screen.y/2-30/2+newY+6, nil, nil, tocolor(225,225,225,245), 1, self.awesome)
                if getKeyState('mouse1') and self.tick+400 <= getTickCount() then
                    self.tick = getTickCount()
                    if self.show then
                        self.show = false
                    else
                        self.show = true
                    end
                end
            else
                dxDrawText(icon, self.screen.x/2-240/2+215, self.screen.y/2-30/2+newY+6, nil, nil, tocolor(225,225,225,200), 1, self.awesome)
            end

            local newY = newY + 33
            local order = 3
            if self.selected == order then
                self:roundedRectangle(self.screen.x/2-240/2, self.screen.y/2-30/2+newY, 240, 30, 9, tocolor(55,55,55,245))
                local textSize = dxGetTextWidth(self.texts.email, 1, self.roboto)
                dxDrawText('l', self.screen.x/2-240/2+30+(textSize), self.screen.y/2-30/2+newY+6, nil, nil,tocolor(195,195,195,self.alpha), 1, self.roboto)
            else
                if cursorShowing and cursorX >= self.screen.x/2-240/2 and cursorX <= self.screen.x/2-240/2+240 and cursorY >= self.screen.y/2-30/2+newY and cursorY <= self.screen.y/2-30/2+newY+30 then
                    self:roundedRectangle(self.screen.x/2-240/2, self.screen.y/2-30/2+newY, 240, 30, 9, tocolor(55,55,55,245))
                    if getKeyState('mouse1') and self.tick+400 <= getTickCount() then
                        self.tick = getTickCount()
                        self.selected = order
                        if self.texts.email == "youremail@icloud.com" then
                            self.texts.email = ""
                        end
                    end
                else
                    self:roundedRectangle(self.screen.x/2-240/2, self.screen.y/2-30/2+newY, 240, 30, 9, tocolor(55,55,55,200))
                end
            end
            dxDrawText(self.icons.mail, self.screen.x/2-240/2+10, self.screen.y/2-30/2+newY+7, nil, nil, tocolor(225,225,225), 1, self.awesome)
            dxDrawText(self.texts.email, self.screen.x/2-240/2+30, self.screen.y/2-30/2+newY+6, nil, nil, tocolor(225,225,225), 1, self.roboto)

            local width = dxGetTextWidth(self.icons.plus, 1, self.awesome)
            local height = dxGetFontHeight(1, self.awesome)
            if cursorShowing and cursorX >= self.screen.x/2-240/2+240+10 and cursorX <= self.screen.x/2-240/2+240+10+width and cursorY >= self.screen.y/2-30/2+newY+6 and cursorY <= self.screen.y/2-30/2+newY+6+height then
                dxDrawText(self.icons.plus, self.screen.x/2-240/2+240+10, self.screen.y/2-30/2+newY+6, nil, nil, tocolor(225,225,225,245), 1, self.awesome)
                if getKeyState('mouse1') and self.tick+400 <= getTickCount() then
                    self.tick = getTickCount()
                    triggerServerEvent("auth.register", localPlayer, self.texts.username, self.texts.password, self.texts.mail)
                end
            else
                dxDrawText(self.icons.plus, self.screen.x/2-240/2+240+10, self.screen.y/2-30/2+newY+6, nil, nil, tocolor(225,225,225,200), 1, self.awesome)
            end

            local newY = newY - 32
            local width = dxGetTextWidth(self.icons.login, 1, self.awesome)
            local height = dxGetFontHeight(1, self.awesome)
            if cursorShowing and cursorX >= self.screen.x/2-240/2+240+10 and cursorX <= self.screen.x/2-240/2+240+10+width and cursorY >= self.screen.y/2-30/2+newY+6 and cursorY <= self.screen.y/2-30/2+newY+6+height then
                dxDrawText(self.icons.login, self.screen.x/2-240/2+240+10, self.screen.y/2-30/2+newY+6, nil, nil, tocolor(225,225,225,245), 1, self.awesome)
                if getKeyState('mouse1') and self.tick+400 <= getTickCount() then
                    self.tick = getTickCount()
                    self.page = 1
                end
            else
                dxDrawText(self.icons.login, self.screen.x/2-240/2+240+10, self.screen.y/2-30/2+newY+6, nil, nil, tocolor(225,225,225,200), 1, self.awesome)
            end
        elseif self.page == 3 then
            if self.load <= 750 then
                self.load = self.load + 5
                dxDrawText(self.icons.load, self.screen.x/2, self.screen.y/2, nil, nil, tocolor(225,225,225), 1, self.awesome, "center", "center", false, false, false, false, false, self.load)
            else
                self:roundedRectangle(self.screen.x/2-400/2, self.screen.y/2-300/2, 400, 300, 9, tocolor(55,55,55,245))
                dxDrawText("Karakter", self.screen.x/2-400/2+15, self.screen.y/2-300/2+15, nil, nil, tocolor(175,175,175), 1, self.robotoB)
                dxDrawText("Lokasyon", self.screen.x/2-400/2+200, self.screen.y/2-300/2+15, nil, nil, tocolor(175,175,175), 1, self.robotoB)

                local newY = 0
                for index, value in ipairs(self.characters) do
                    --// GENDER AND NAME
                    local icon
                    local color
                    if value[3] == 1 then
                        icon = self.icons.male
                        color = tocolor(121,179,245)
                    elseif value[3] == 2 then
                        icon = self.icons.female
                        color = tocolor(245,121,245)
                    end
                    dxDrawText(icon, self.screen.x/2-400/2+15, self.screen.y/2-300/2+45+newY, nil, nil, color, 1, self.awesome)
                    local width = dxGetTextWidth(icon, 1, self.awesome)
                    dxDrawText(value[2]:gsub("_", " "), self.screen.x/2-400/2+20+width, self.screen.y/2-300/2+45+newY, nil, nil, tocolor(225,225,225), 1, self.robotoB)
                    --// LOCATION
                    local icon = self.icons.location
                    dxDrawText(icon, self.screen.x/2-400/2+200, self.screen.y/2-300/2+45+newY, nil, nil, tocolor(166,121,245), 1, self.awesome)
                    local width = dxGetTextWidth(icon, 1, self.awesome)
                    dxDrawText(string.sub(value[4], 1, 10), self.screen.x/2-400/2+205+width, self.screen.y/2-300/2+45+newY, nil, nil, tocolor(225,225,225), 1, self.robotoB)
                    --// SPAWN
                    local width = dxGetTextWidth(self.icons.login, 1, self.awesome)
                    local height = dxGetFontHeight(1, self.awesome)
                    if cursorShowing and cursorX >= self.screen.x/2-400/2+350 and cursorX <= self.screen.x/2-400/2+350+width and cursorY >= self.screen.y/2-300/2+45+newY and cursorY <= self.screen.y/2-300/2+45+newY+height then
                        dxDrawText(self.icons.login, self.screen.x/2-400/2+350, self.screen.y/2-300/2+45+newY, nil, nil, tocolor(225,225,225,245), 1, self.awesome)
                        if getKeyState('mouse1') and self.tick+400 <= getTickCount() then
                            self.tick = getTickCount()
                            triggerServerEvent("auth.spawn.character", localPlayer, value[1])
                            self:stop()
                        end
                    else
                        dxDrawText(self.icons.login, self.screen.x/2-400/2+350, self.screen.y/2-300/2+45+newY, nil, nil, tocolor(225,225,225,200), 1, self.awesome)
                    end
                    newY = newY + 25
                end

                local width = dxGetTextWidth(self.icons.plus, 1, self.awesome)
                local height = dxGetFontHeight(1, self.awesome)
                if cursorShowing and cursorX >= self.screen.x/2-400/2+375 and cursorX <= self.screen.x/2-400/2+375+width and cursorY >= self.screen.y/2-300/2+275 and cursorY <= self.screen.y/2-300/2+275+height then
                    dxDrawText(self.icons.plus, self.screen.x/2-400/2+375, self.screen.y/2-300/2+275, nil, nil, tocolor(225,225,225,245), 1, self.awesome)
                    if getKeyState('mouse1') and self.tick+400 <= getTickCount() then
                        self.tick = getTickCount()
                        self.page = 4
                    end
                else
                    dxDrawText(self.icons.plus, self.screen.x/2-400/2+375, self.screen.y/2-300/2+275, nil, nil, tocolor(225,225,225,200), 1, self.awesome)
                end
            end
        elseif self.page == 4 then
            --// CHARACTER CREATE SCREEN SOON..
        end
    end
    if getKeyState('backspace') and self.tick+120 <= getTickCount() then
        self.tick = getTickCount()
        if self.selected == 1 then
            self.fistPart = self.texts.username:sub(0, string.len(self.texts.username)-1)
            self.lastPart = self.texts.username:sub(string.len(self.texts.username)+1, #self.texts.username)
            self.texts.username = self.fistPart..self.lastPart
        elseif self.selected == 2 then
            self.fistPart = self.texts.password:sub(0, string.len(self.texts.password)-1)
            self.lastPart = self.texts.password:sub(string.len(self.texts.password)+1, #self.texts.password)
            self.texts.password = self.fistPart..self.lastPart
        elseif self.selected == 3 then
            self.fistPart = self.texts.email:sub(0, string.len(self.texts.email)-1)
            self.lastPart = self.texts.email:sub(string.len(self.texts.email)+1, #self.texts.email)
            self.texts.email = self.fistPart..self.lastPart
        end
    end
end

function account:notifyRender()
    if self.animate <= 25 then
        self.animate = self.animate + 10
    end
    local width = dxGetTextWidth(self.result, 1, self.robotoB)
    dxDrawText(self.result, self.screen.x/2-width/2, self.animate, nil, nil, tocolor(225,225,225), 1, self.robotoB)
end

function account:notify(result)
    self.result = result
    self.animate = 0
    if isTimer(self.stopNotify) then
        killTimer(self.stopNotify)
        removeEventHandler("onClientRender", root, self._functions.notifyRender)
    end
    self.stopNotify = Timer(function()
        removeEventHandler("onClientRender", root, self._functions.notifyRender)
    end, 2500, 1)
    addEventHandler("onClientRender", root, self._functions.notifyRender, true, "low-99999")
end

function account:write(character)
    if self.selected == 1 then
        if string.len(self.texts.username) <= 20 then
            self.texts.username = ""..self.texts.username..""..character
        end
    elseif self.selected == 2 then
        if string.len(self.texts.password) <= 20 then
            self.texts.password = ""..self.texts.password..""..character
        end
    elseif self.selected == 3 then
        if string.len(self.texts.email) <= 20 then
            self.texts.email = ""..self.texts.email..""..character
        end
    end
end

function account:roundedRectangle(x, y, width, height, radius, color)
    local diameter = radius * 2
    dxDrawCircle(x + radius, y + radius, radius, 180, 270, color)
    dxDrawCircle(x + width - radius, y + radius, radius, 270, 360, color)
    dxDrawCircle(x + radius, y + height - radius, radius, 90, 180, color)
    dxDrawCircle(x + width - radius, y + height - radius, radius, 0, 90, color)
    dxDrawRectangle(x + radius, y, width - diameter, height, color)
    dxDrawRectangle(x, y + radius, radius, height - diameter, color)
    dxDrawRectangle(x + width - radius, y + radius, radius, height - diameter, color)
    dxDrawRectangle(x + radius, y + radius, width - diameter, height - diameter, tocolor(0, 0, 0, 0))
end

function account:remember(username, password)
    self.texts.username = username
    self.texts.password = password
end

function account:login(results)
    self.characters = results or {}
    self.page = 3
    self.load = 0
end

function account:textRectangle()
    if self.alpha == 255 then
        self.alpha = 0
    else
        self.alpha = 255
    end
end

function account:stop()
    showChat(true)
    showCursor(false)
    if isTimer(self.timer) then
        killTimer(self.timer)
    end
    removeEventHandler("onClientCharacter", root, self._functions.write)
    removeEventHandler("onClientRender", root, self._functions.render)
end

function account:start()
    self.tick, self.page, self.load = 0, 1, 0
    self.texts = {
        username = "kullanıcı adı",
        password = "şifre",
        email = "youremail@icloud.com"
    }
    Camera.fade(true)
    showChat(false)
    showCursor(true)
    localPlayer:setDimension(0)
    localPlayer:setInterior(0)
    triggerServerEvent("auth.remember.me", localPlayer)
    addEventHandler("onClientCharacter", root, self._functions.write)
    self.timer = Timer(self._functions.textRectangle, 375, 0)
    addEventHandler("onClientRender", root, self._functions.render, true, "low-9999")
end

function account:components()
    Engine.setAsynchronousLoading(true, true)
    setFarClipDistance(5000)
    setFogDistance(5000)
    for i = 1, 10000 do
        engineSetModelLODDistance(i, 1000)
    end
    isWorldSpecialPropertyEnabled('extraairresistance', false)
    setAmbientSoundEnabled('gunfire', false )
    setDevelopmentMode(false)
    setPedTargetingMarkerEnabled(false)
    toggleControl('radar', false)
    guiSetInputMode('no_binds_when_editing')
    setPlayerHudComponentVisible('all', false)
    addEvent("auth.notify", true)
    addEventHandler("auth.notify", root, self._functions.notify)
    addEvent("auth.login.step", true)
    addEventHandler("auth.login.step", root, self._functions.login)
    addEvent("auth.remembered", true)
    addEventHandler("auth.remembered", root, self._functions.remember)
end

account:new()