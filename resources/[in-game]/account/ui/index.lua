assert(loadstring(exports.dxlibrary:loadFunctions()))()
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
local account = class("account")

function account:init()
    self._functions = {
        render = function(...) self:render(...) end,
        textRectangle = function(...) self:textRectangle(...) end,
        notify = function(...) self:notify(...) end,
        notifyRender = function(...) self:notifyRender(...) end,
        write = function(...) self:write(...) end,
        login = function(...) self:login(...) end,
        listUp = function(...) self:listUp(...) end,
        listDown = function(...) self:listDown(...) end,
        step = function(...) self:next(...) end,
        remember = function(...) self:remember(...) end
    }
	
    self.icons = {
        load = exports.fonts:getIcon("load"),
        user = exports.fonts:getIcon("user"),
        key = exports.fonts:getIcon("key"),
        arrow = exports.fonts:getIcon("arrow-right"),
        plus = exports.fonts:getIcon("person-circle-plus"),
        login = exports.fonts:getIcon("login"),
        mail = exports.fonts:getIcon("mail"),
        eye = exports.fonts:getIcon("eye"),
        eyeslash = exports.fonts:getIcon("eye-slash"),
        male = exports.fonts:getIcon("person"),
        female = exports.fonts:getIcon("person-dress"),
        list = exports.fonts:getIcon("hand-holding-heart"),
        down = exports.fonts:getIcon("up-down"),
        skull = exports.fonts:getIcon("skull"),
        heart = exports.fonts:getIcon("heart"),
        back = exports.fonts:getIcon("back"),
        location = exports.fonts:getIcon("location")
    }
	
    self.screen = Vector2(guiGetScreenSize())
    self.awesome = exports.fonts:getFont("AwesomeSolid", 9)
    self.awesomeBig = exports.fonts:getFont("AwesomeSolid", 14)
    self.awesomeVeryBig = exports.fonts:getFont("AwesomeSolid", 25)
    self.roboto = exports.fonts:getFont('Roboto', 10)
    self.robotoB = exports.fonts:getFont('RobotoB', 10)

    if not localPlayer:getData("online") then self:start() end
    self:components()
end

function account:render()
    dxDrawRectangle(0, 0, self.screen.x, self.screen.y, tocolor(25,25,25))
    if self.load <= 550 then
        self.load = self.load + 5
        dxDrawText(self.icons.load, self.screen.x/2, self.screen.y/2, nil, nil, tocolor(225,225,225), 1, self.awesome, "center", "center", false, false, false, false, false, self.load)
    else
        if self.page == 1 then
            local newY = 0
            local order = 1
            if self.selected == order then
                dxDrawRoundedRectangle(self.screen.x/2-240/2, self.screen.y/2-30/2+newY, 240, 30, 9, tocolor(55,55,55,245))
                local textSize = dxGetTextWidth(self.texts.username, 1, self.roboto)
                dxDrawText('l', self.screen.x/2-240/2+30+(textSize), self.screen.y/2-30/2+newY+6, nil, nil,tocolor(195,195,195,self.alpha), 1, self.roboto)
            else
		        if isInBox(self.screen.x/2-240/2, self.screen.y/2-30/2+newY, 240, 30) then
                    dxDrawRoundedRectangle(self.screen.x/2-240/2, self.screen.y/2-30/2+newY, 240, 30, 9, tocolor(55,55,55,245))
                    if getKeyState('mouse1') and self.tick+400 <= getTickCount() then
                        self.tick = getTickCount()
                        self.selected = order
                        if self.texts.username == "kullanıcı adı" then
                            self.texts.username = ""
                        end
                    end
                else
                    dxDrawRoundedRectangle(self.screen.x/2-240/2, self.screen.y/2-30/2+newY, 240, 30, 9, tocolor(55,55,55,200))
                end
            end
            dxDrawText(self.icons.user, self.screen.x/2-240/2+10, self.screen.y/2-30/2+newY+7, nil, nil, tocolor(225,225,225), 1, self.awesome)
            dxDrawText(self.texts.username, self.screen.x/2-240/2+30, self.screen.y/2-30/2+newY+6, nil, nil, tocolor(225,225,225), 1, self.roboto)
            local textSize
            local newY = newY + 33
            local order = 2
            if self.selected == order then
                dxDrawRoundedRectangle(self.screen.x/2-240/2, self.screen.y/2-30/2+newY, 240, 30, 9, tocolor(55,55,55,245))
                if self.show then
                    textSize = dxGetTextWidth(self.texts.password, 1, self.roboto)
                else
                    textSize = dxGetTextWidth(string.gsub(self.texts.password, ".", "*"), 1, self.roboto)
                end
                dxDrawText('l', self.screen.x/2-240/2+30+(textSize), self.screen.y/2-30/2+newY+6, nil, nil,tocolor(195,195,195,self.alpha), 1, self.roboto)
            else
		if isInBox(self.screen.x/2-240/2, self.screen.y/2-30/2+newY, 240, 30) then
                    dxDrawRoundedRectangle(self.screen.x/2-240/2, self.screen.y/2-30/2+newY, 240, 30, 9, tocolor(55,55,55,245))
                    if getKeyState('mouse1') and self.tick+400 <= getTickCount() then
                        self.tick = getTickCount()
                        self.selected = order
                        if self.texts.password == "şifre" then
                            self.texts.password = ""
                        end
                    end
                else
                    dxDrawRoundedRectangle(self.screen.x/2-240/2, self.screen.y/2-30/2+newY, 240, 30, 9, tocolor(55,55,55,200))
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
	    if isInBox(self.screen.x/2-240/2+215, self.screen.y/2-30/2+newY+6, width, height) then
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
	    if isInBox(self.screen.x/2-240/2+240+10, self.screen.y/2-30/2+newY+7, width, height) then
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
	    if isInBox(self.screen.x/2-240/2+240+10, self.screen.y/2-30/2+newY+6, width, height) then
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
                dxDrawRoundedRectangle(self.screen.x/2-240/2, self.screen.y/2-30/2+newY, 240, 30, 9, tocolor(55,55,55,245))
                local textSize = dxGetTextWidth(self.texts.username, 1, self.roboto)
                dxDrawText('l', self.screen.x/2-240/2+30+(textSize), self.screen.y/2-30/2+newY+6, nil, nil,tocolor(195,195,195,self.alpha), 1, self.roboto)
            else
	        if isInBox(self.screen.x/2-240/2, self.screen.y/2-30/2+newY, 240, 30) then
                    dxDrawRoundedRectangle(self.screen.x/2-240/2, self.screen.y/2-30/2+newY, 240, 30, 9, tocolor(55,55,55,245))
                    if getKeyState('mouse1') and self.tick+400 <= getTickCount() then
                        self.tick = getTickCount()
                        self.selected = order
                        if self.texts.username == "kullanıcı adı" then
                            self.texts.username = ""
                        end
                    end
                else
                    dxDrawRoundedRectangle(self.screen.x/2-240/2, self.screen.y/2-30/2+newY, 240, 30, 9, tocolor(55,55,55,200))
                end
            end
            dxDrawText(self.icons.user, self.screen.x/2-240/2+10, self.screen.y/2-30/2+newY+7, nil, nil, tocolor(225,225,225), 1, self.awesome)
            dxDrawText(self.texts.username, self.screen.x/2-240/2+30, self.screen.y/2-30/2+newY+6, nil, nil, tocolor(225,225,225), 1, self.roboto)

            local textSize
            local newY = newY + 33
            local order = 2
            if self.selected == order then
                dxDrawRoundedRectangle(self.screen.x/2-240/2, self.screen.y/2-30/2+newY, 240, 30, 9, tocolor(55,55,55,245))
                if self.show then
                    textSize = dxGetTextWidth(self.texts.password, 1, self.roboto)
                else
                    textSize = dxGetTextWidth(string.gsub(self.texts.password, ".", "*"), 1, self.roboto)
                end
                dxDrawText('l', self.screen.x/2-240/2+30+(textSize), self.screen.y/2-30/2+newY+6, nil, nil,tocolor(195,195,195,self.alpha), 1, self.roboto)
            else
		        if isInBox(self.screen.x/2-240/2, self.screen.y/2-30/2+newY, 240, 30) then
                    dxDrawRoundedRectangle(self.screen.x/2-240/2, self.screen.y/2-30/2+newY, 240, 30, 9, tocolor(55,55,55,245))
                    if getKeyState('mouse1') and self.tick+400 <= getTickCount() then
                        self.tick = getTickCount()
                        self.selected = order
                        if self.texts.password == "şifre" then
                            self.texts.password = ""
                        end
                    end
                else
                    dxDrawRoundedRectangle(self.screen.x/2-240/2, self.screen.y/2-30/2+newY, 240, 30, 9, tocolor(55,55,55,200))
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
	    if isInBox(self.screen.x/2-240/2+215, self.screen.y/2-30/2+newY+6, width, height) then
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
                dxDrawRoundedRectangle(self.screen.x/2-240/2, self.screen.y/2-30/2+newY, 240, 30, 9, tocolor(55,55,55,245))
                local textSize = dxGetTextWidth(self.texts.email, 1, self.roboto)
                dxDrawText('l', self.screen.x/2-240/2+30+(textSize), self.screen.y/2-30/2+newY+6, nil, nil,tocolor(195,195,195,self.alpha), 1, self.roboto)
            else
		        if isInBox(self.screen.x/2-240/2, self.screen.y/2-30/2+newY, 240, 30) then
                    dxDrawRoundedRectangle(self.screen.x/2-240/2, self.screen.y/2-30/2+newY, 240, 30, 9, tocolor(55,55,55,245))
                    if getKeyState('mouse1') and self.tick+400 <= getTickCount() then
                        self.tick = getTickCount()
                        self.selected = order
                        if self.texts.email == "youremail@icloud.com" then
                            self.texts.email = ""
                        end
                    end
                else
                    dxDrawRoundedRectangle(self.screen.x/2-240/2, self.screen.y/2-30/2+newY, 240, 30, 9, tocolor(55,55,55,200))
                end
            end
            dxDrawText(self.icons.mail, self.screen.x/2-240/2+10, self.screen.y/2-30/2+newY+7, nil, nil, tocolor(225,225,225), 1, self.awesome)
            dxDrawText(self.texts.email, self.screen.x/2-240/2+30, self.screen.y/2-30/2+newY+6, nil, nil, tocolor(225,225,225), 1, self.roboto)

            local width = dxGetTextWidth(self.icons.plus, 1, self.awesome)
            local height = dxGetFontHeight(1, self.awesome)
			if isInBox(self.screen.x/2-240/2+240+10, self.screen.y/2-30/2+newY+6, width, height) then
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
   	    if isInBox(self.screen.x/2-240/2+240+10, self.screen.y/2-30/2+newY+6, width, height) then
                dxDrawText(self.icons.login, self.screen.x/2-240/2+240+10, self.screen.y/2-30/2+newY+6, nil, nil, tocolor(225,225,225,245), 1, self.awesome)
                if getKeyState('mouse1') and self.tick+400 <= getTickCount() then
                    self.tick = getTickCount()
                    self.page = 1
                end
            else
                dxDrawText(self.icons.login, self.screen.x/2-240/2+240+10, self.screen.y/2-30/2+newY+6, nil, nil, tocolor(225,225,225,200), 1, self.awesome)
            end
        elseif self.page == 3 then
            if self.load <= 250 then
                self.load = self.load + 5
                dxDrawText(self.icons.load, self.screen.x/2, self.screen.y/2, nil, nil, tocolor(225,225,225), 1, self.awesome, "center", "center", false, false, false, false, false, self.load)
            else
                dxDrawText(self.icons.list, self.screen.x/2-200, self.screen.y/2-100, nil, nil, tocolor(175,175,175), 1, self.awesome)
                dxDrawText(self.icons.down, self.screen.x/2-200+3, self.screen.y/2-50, nil, nil, tocolor(175,175,175), 1, self.awesome)
                dxDrawText("Karakter", self.screen.x/2-150, self.screen.y/2-100, nil, nil, tocolor(175,175,175), 1, self.robotoB)
                dxDrawText("Durum", self.screen.x/2, self.screen.y/2-100, nil, nil, tocolor(175,175,175), 1, self.robotoB)
                dxDrawText("Lokasyon", self.screen.x/2+100, self.screen.y/2-100, nil, nil, tocolor(175,175,175), 1, self.robotoB)

                local newY = 0
                local current = 0
                if #self.characters > 0 then
                    for index, value in ipairs(self.characters) do
                        --// LİST SORTED
                        if index > self.currentRow and current < self.maxRow then
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
                            dxDrawText(icon, self.screen.x/2-150, self.screen.y/2-60+newY, nil, nil, color, 1, self.awesome)
                            local width = dxGetTextWidth(icon, 1, self.awesome)
                            dxDrawText(string.sub(value[2]:gsub("_", " "), 1, 15), self.screen.x/2-145+width, self.screen.y/2-60+newY, nil, nil, tocolor(225,225,225), 1, self.robotoB)
                            --// STATE
                            local icon
                            local color
                            if value[5] == 1 then
                                icon = self.icons.skull
                                color = tocolor(226,67,67)
                            else
                                icon = self.icons.heart
                                color = tocolor(147,233,121)
                            end
                            dxDrawText(icon, self.screen.x/2+13, self.screen.y/2-60+newY, nil, nil, color, 1, self.awesome)
                            --// LOCATION
                            dxDrawText(string.sub(value[4], 1, 10), self.screen.x/2+100, self.screen.y/2-60+newY, nil, nil, tocolor(225,225,225), 1, self.robotoB)
                            --// SPAWN
                            if value[5] == 1 then
                                dxDrawText(self.icons.login, self.screen.x/2+175+width, self.screen.y/2-60+newY, nil, nil, tocolor(125,125,125,200), 1, self.awesome)
                            else
                                local width = dxGetTextWidth(self.icons.login, 1, self.awesome)
                                local height = dxGetFontHeight(1, self.awesome)
								if isInBox(self.screen.x/2+175+width, self.screen.y/2-60+newY, width, height) then
                                    dxDrawText(self.icons.login, self.screen.x/2+175+width, self.screen.y/2-60+newY, nil, nil, tocolor(225,225,225,245), 1, self.awesome)
                                    if getKeyState('mouse1') and self.tick+400 <= getTickCount() then
                                        self.tick = getTickCount()
                                        triggerServerEvent("auth.spawn.character", localPlayer, value[1])
                                        self:stop()
                                    end
                                else
                                    dxDrawText(self.icons.login, self.screen.x/2+175+width, self.screen.y/2-60+newY, nil, nil, tocolor(225,225,225,200), 1, self.awesome)
                                end
                            end
                            newY = newY + 25
                            current = current + 1
                        end
                    end
                end
                --// CREATE BUTTON
                local width = dxGetTextWidth(self.icons.plus, 1, self.awesome)
                local height = dxGetFontHeight(1, self.awesome)
		if isInBox(self.screen.x/2+243+width, self.screen.y/2-60+newY, width, height) then
                    dxDrawText(self.icons.plus, self.screen.x/2+243+width, self.screen.y/2-60+newY, nil, nil, tocolor(225,225,225,245), 1, self.awesome)
                    if getKeyState('mouse1') and self.tick+400 <= getTickCount() then
                        self.tick = getTickCount()
                        self.page, self.load, self.step = 4, 0, 1
                    end
                else
                    dxDrawText(self.icons.plus, self.screen.x/2+243+width, self.screen.y/2-60+newY, nil, nil, tocolor(225,225,225,200), 1, self.awesome)
                end
            end
        elseif self.page == 4 then
            if self.load <= 150 then
                self.load = self.load + 5
                dxDrawText(self.icons.load, self.screen.x/2, self.screen.y/2, nil, nil, tocolor(225,225,225), 1, self.awesome, "center", "center", false, false, false, false, false, self.load)
            else
		if isInBox(0, 0, 150, self.screen.y) then
                    dxDrawRectangle(0, 0, 150, self.screen.y, tocolor(17,17,17,245))
                    if getKeyState('mouse1') and self.tick+400 <= getTickCount() then
                        self.tick = getTickCount()
                        if self.step == 1 then
                            self.page, self.load, self.step = 3, 0, 0
                        else
                            self.step = self.step - 1
                        end
                    end
                else
                    dxDrawRectangle(0, 0, 150, self.screen.y, tocolor(10,10,10,225))
                end
                local icon = self.icons.back
                local width = dxGetTextWidth(icon, 1, self.awesomeVeryBig)
                local height = dxGetFontHeight(1, self.awesomeVeryBig)
                dxDrawText(icon, 150/2-width/2, self.screen.y/2-height/2, nil, nil, tocolor(225,225,225), 1, self.awesomeVeryBig)

                if self.step == 1 then
                    local text = "Yeni karakteriniz için bir isim belirleyelim ('ENTER')"
                    local width = dxGetTextWidth(text, 1, self.robotoB)
                    local height = dxGetFontHeight(1, self.robotoB)
                    dxDrawText(text, self.screen.x/2-width/2, self.screen.y/2-height/2, nil, nil, tocolor(225,225,225), 1, self.robotoB)
                    local textSize = dxGetTextWidth(self.texts.charName, 1, self.robotoB)
                    dxDrawText(self.texts.charName, self.screen.x/2-(textSize/2), self.screen.y/2-height/2+20, nil, nil, tocolor(225,225,225), 1, self.robotoB)
                    dxDrawText('l', self.screen.x/2-(textSize/2)+(textSize), self.screen.y/2-height/2+20, nil, nil ,tocolor(195,195,195,self.alpha), 1, self.robotoB)
                    if getKeyState('enter') and self.tick+400 <= getTickCount() then
                        self.tick = getTickCount()
                        triggerServerEvent("auth.check.character.name", localPlayer, self.texts.charName)
                    end
                elseif self.step == 2 then
                    local text = "Şimdi yeni karakterinize bir yaş belirleyelim ('ENTER')"
                    local width = dxGetTextWidth(text, 1, self.robotoB)
                    local height = dxGetFontHeight(1, self.robotoB)
                    dxDrawText(text, self.screen.x/2-width/2, self.screen.y/2-height/2, nil, nil, tocolor(225,225,225), 1, self.robotoB)
                    local textSize = dxGetTextWidth(self.texts.age, 1, self.robotoB)
                    dxDrawText(self.texts.age, self.screen.x/2-(textSize/2), self.screen.y/2-height/2+20, nil, nil, tocolor(225,225,225), 1, self.robotoB)
                    dxDrawText('l', self.screen.x/2-(textSize/2)+(textSize), self.screen.y/2-height/2+20, nil, nil ,tocolor(195,195,195,self.alpha), 1, self.robotoB)
                    if getKeyState('enter') and self.tick+400 <= getTickCount() then
                        self.tick = getTickCount()
                        self:next()
                    end
                elseif self.step == 3 then
                    local text = "Şimdi yeni karakterinize bir boy belirleyelim ('ENTER')"
                    local width = dxGetTextWidth(text, 1, self.robotoB)
                    local height = dxGetFontHeight(1, self.robotoB)
                    dxDrawText(text, self.screen.x/2-width/2, self.screen.y/2-height/2, nil, nil, tocolor(225,225,225), 1, self.robotoB)
                    local textSize = dxGetTextWidth(self.texts.height, 1, self.robotoB)
                    dxDrawText(""..self.texts.height.." cm", self.screen.x/2-(textSize/2), self.screen.y/2-height/2+20, nil, nil, tocolor(225,225,225), 1, self.robotoB)
                    dxDrawText('l', self.screen.x/2-(textSize/2)+(textSize), self.screen.y/2-height/2+20, nil, nil ,tocolor(195,195,195,self.alpha), 1, self.robotoB)
                    if getKeyState('enter') and self.tick+400 <= getTickCount() then
                        self.tick = getTickCount()
                        self:next()
                    end
                elseif self.step == 4 then
                    local text = "Şimdi yeni karakterinize bir kilo belirleyelim ('ENTER')"
                    local width = dxGetTextWidth(text, 1, self.robotoB)
                    local height = dxGetFontHeight(1, self.robotoB)
                    dxDrawText(text, self.screen.x/2-width/2, self.screen.y/2-height/2, nil, nil, tocolor(225,225,225), 1, self.robotoB)
                    local textSize = dxGetTextWidth(self.texts.weight, 1, self.robotoB)
                    dxDrawText(""..self.texts.weight.." kg", self.screen.x/2-(textSize/2), self.screen.y/2-height/2+20, nil, nil, tocolor(225,225,225), 1, self.robotoB)
                    dxDrawText('l', self.screen.x/2-(textSize/2)+(textSize), self.screen.y/2-height/2+20, nil, nil ,tocolor(195,195,195,self.alpha), 1, self.robotoB)
                    if getKeyState('enter') and self.tick+400 <= getTickCount() then
                        self.tick = getTickCount()
                        self:next()
                    end
                elseif self.step == 5 then
                    local text = "Şimdi yeni karakterinizin cinsiyetini belirleyelim ('TIKLA')"
                    local width = dxGetTextWidth(text, 1, self.robotoB)
                    local height = dxGetFontHeight(1, self.robotoB)
                    dxDrawText(text, self.screen.x/2-width/2, self.screen.y/2-height/2, nil, nil, tocolor(225,225,225), 1, self.robotoB)

                    local icon = self.icons.male
                    local width = dxGetTextWidth(icon, 1, self.awesomeBig)
                    local height = dxGetFontHeight(1, self.awesomeBig)
		    if isInBox(self.screen.x/2-width/2-100, self.screen.y/2-height/2+50, width, height) then
                        dxDrawText(icon, self.screen.x/2-width/2-100, self.screen.y/2-height/2+50, nil, nil, tocolor(121,179,245,225), 1, self.awesomeBig)
                        if getKeyState('mouse1') and self.tick+400 <= getTickCount() then
                            self.tick = getTickCount()
                            self.gender = 1
                            self:next()
                        end
                    else
                        dxDrawText(icon, self.screen.x/2-width/2-100, self.screen.y/2-height/2+50, nil, nil, tocolor(121,179,245), 1, self.awesomeBig)
                    end

                    local icon = self.icons.female
                    local width = dxGetTextWidth(icon, 1, self.awesomeBig)
                    local height = dxGetFontHeight(1, self.awesomeBig)
		    if isInBox(self.screen.x/2-width/2+100, self.screen.y/2-height/2+50, width, height) then
                        dxDrawText(icon, self.screen.x/2-width/2+100, self.screen.y/2-height/2+50, nil, nil, tocolor(245,121,245,225), 1, self.awesomeBig)
                        if getKeyState('mouse1') and self.tick+400 <= getTickCount() then
                            self.tick = getTickCount()
                            self.gender = 2
                            self:next()
                        end
                    else
                        dxDrawText(icon, self.screen.x/2-width/2+100, self.screen.y/2-height/2+50, nil, nil, tocolor(245,121,245), 1, self.awesomeBig)
                    end
                end
            end
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
        elseif self.page == 4 then
            if self.step == 1 then
                self.fistPart = self.texts.charName:sub(0, string.len(self.texts.charName)-1)
                self.lastPart = self.texts.charName:sub(string.len(self.texts.charName)+1, #self.texts.charName)
                self.texts.charName = self.fistPart..self.lastPart
            elseif self.step == 2 then
                self.fistPart = self.texts.age:sub(0, string.len(self.texts.age)-1)
                self.lastPart = self.texts.age:sub(string.len(self.texts.age)+1, #self.texts.age)
                self.texts.age = self.fistPart..self.lastPart
            elseif self.step == 3 then
                self.fistPart = self.texts.height:sub(0, string.len(self.texts.height)-1)
                self.lastPart = self.texts.height:sub(string.len(self.texts.height)+1, #self.texts.height)
                self.texts.height = self.fistPart..self.lastPart
            elseif self.step == 4 then
                self.fistPart = self.texts.weight:sub(0, string.len(self.texts.weight)-1)
                self.lastPart = self.texts.weight:sub(string.len(self.texts.weight)+1, #self.texts.weight)
                self.texts.weight = self.fistPart..self.lastPart
            end
        end
    end
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
    elseif self.page == 4 then
        if self.step == 1 then
            if string.len(self.texts.charName) <= 30 then
                self.texts.charName = ""..self.texts.charName..""..character
            end
        elseif self.step == 2 then
            if tonumber(character) then
                if string.len(self.texts.age) <= 1 then
                    self.texts.age = ""..self.texts.age..""..character
                end
            end
        elseif self.step == 3 then
            if tonumber(character) then
                if string.len(self.texts.height) <= 2 then
                    self.texts.height = ""..self.texts.height..""..character
                end
            end
        elseif self.step == 4 then
            if tonumber(character) then
                if string.len(self.texts.weight) <= 1 then
                    self.texts.weight = ""..self.texts.weight..""..character
                end
            end
        end
    end
end

function account:remember(username, password)
    self.texts.username = username
    self.texts.password = password
end

function account:login(results)
    local results = results or {}
    self.characters, self.page, self.load, self.selected = results, 3, 0, nil
end

function account:textRectangle()
    if self.alpha == 255 then
        self.alpha = 0
    else
        self.alpha = 255
    end
end

function account:next()
    if self.step == 5 then
        triggerServerEvent("auth.create.character", localPlayer, self.texts.charName, self.texts.height, self.texts.weight, self.texts.age, self.gender)
	self.step, self.load, self.page = 0, 0, 3
    end
    self.step, self.load = self.step + 1, 0
end

function account:listUp()
    if self.page == 3 then
        if self.currentRow > 0 then
            self.currentRow = self.currentRow - 1
        end
    end
end

function account:listDown()
   if self.page == 3 then
      local table = self.characters or {}
      if self.currentRow < #table - self.maxRow then
         self.currentRow = self.currentRow + 1
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

function account:stop()
    if isTimer(self.timer) then
        killTimer(self.timer)
    end
    unbindKey("mouse_wheel_up", "down", self._functions.listUp)
    unbindKey("mouse_wheel_down", "down", self._functions.listDown)
    removeEventHandler("onClientCharacter", root, self._functions.write)
    removeEventHandler("onClientRender", root, self._functions.render)
    showChat(true)
    showCursor(false)
end

function account:start()
    self.tick, self.page, self.load = 0, 1, 0
    self.currentRow, self.maxRow = 0, 5
    self.texts = {
        username = "kullanıcı adı",
        password = "şifre",
        email = "youremail@icloud.com",
        charName = "",
        age = "21",
        height = "175",
        weight = "70"
    }
    Camera.fade(true)
    showChat(false)
    showCursor(true)
    localPlayer:setDimension(0)
    localPlayer:setInterior(0)
    triggerServerEvent("auth.remember.me", localPlayer)
    addEventHandler("onClientCharacter", root, self._functions.write)
    bindKey("mouse_wheel_up", "down", self._functions.listUp)
    bindKey("mouse_wheel_down", "down", self._functions.listDown)
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
    addEvent("auth.next.step", true)
    addEventHandler("auth.next.step", root, self._functions.step)
end

account:new()
