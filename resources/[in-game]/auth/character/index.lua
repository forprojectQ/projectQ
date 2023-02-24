local character = new('character')
local tocolor = tocolor
local dxDrawImage = dxDrawImage
local dxDrawRectangle = dxDrawRectangle
local dxDrawText = dxDrawText
local getTickCount = getTickCount
local getCursorPosition = getCursorPosition
local guiGetScreenSize = guiGetScreenSize
local getKeyState = getKeyState
local localPlayer = localPlayer
local root = root
local addEvent = addEvent
local addEventHandler = addEventHandler
local triggerServerEvent = triggerServerEvent
local dxGetTextWidth = dxGetTextWidth
local ipairs = ipairs

function character.prototype.____constructor(self)
    self._function = {}
    self._function.get = function(...) self:get(self,...) end
    self._function.display = function(...) self:display(self) end
    self._function.ped = function(...) self:getPed(self,...) end
    self._function.write = function(...) self:write(self,...) end
    self._function.renderText = function(...) self:renderText(self) end
    self._function.success = function(...) self:success(self) end
    self.bold = exports.fonts:get('RobotoB', 10)
    self.bold2 = exports.fonts:get('RobotoB', 14)
    self.icon = exports.fonts:get('RobotoB', 50)
    self.regular = exports.fonts:get('Roboto', 10)
    self.screen = Vector2(guiGetScreenSize())
    self.w, self.h = 200, 30
    self.x, self.y = self.screen.x/2-self.w/2, self.screen.y/2-self.h/2
    self:start(self)
end

function character.prototype.display(self)
    self.load = self.load + 5
    if self.load >= 1000 then
        dxDrawRectangle(0,0,self.screen.x,self.screen.y,tocolor(25,25,25,145))
        if self.page == 1 then
            if #self.data <= 0 then
                self.textSize = dxGetTextWidth(''..localPlayer:getData('account.name')..', oluşturulmuş bir karaterin yok\n  hadi yeni bir tane oluşturalım.',1,self.bold2)
                dxDrawText(''..localPlayer:getData('account.name')..', oluşturulmuş bir karaterin yok\n  hadi yeni bir tane oluşturalım.',self.screen.x/2-(self.textSize/2),self.screen.y-75,nil,nil,tocolor(225,225,225,125),1,self.bold2)
                if self:isInBox(0,0,150,self.screen.y) then
                    dxDrawRectangle(0,0,150,self.screen.y,tocolor(0,0,0,175))
                    dxDrawText('+',45,self.screen.y/2-50,nil,nil,tocolor(195,195,195,155),1,self.icon)
                    if getKeyState('mouse1') and self.click+400 <= getTickCount() then
                        self.click = getTickCount()
                        self.page = 2
                        self.selected = 0
                        self.gender = 1
                    end
                else
                    dxDrawRectangle(0,0,150,self.screen.y,tocolor(0,0,0,125))
                    dxDrawText('+',45,self.screen.y/2-50,nil,nil,tocolor(195,195,195),1,self.icon)
                end
            else
                if self:isInBox(0,0,150,self.screen.y) then
                    dxDrawRectangle(0,0,150,self.screen.y,tocolor(0,0,0,175))
                    dxDrawText('+',45,self.screen.y/2-50,nil,nil,tocolor(195,195,195,155),1,self.icon)
                    if getKeyState('mouse1') and self.click+400 <= getTickCount() then
                        self.click = getTickCount()
                        self.page = 2
                        self.selected = 0
                        self.gender = 1
                    end
                else
                    dxDrawRectangle(0,0,150,self.screen.y,tocolor(0,0,0,125))
                    dxDrawText('+',45,self.screen.y/2-50,nil,nil,tocolor(195,195,195),1,self.icon)
                end
                for index, value in ipairs(self.data) do
                    if self.current == index then
                        self.ped.model = value[7]
                        self.textSize = dxGetTextWidth('Mevcut karakter '..value[2]:gsub('_', ' ')..',\n Son görülen yer '..getZoneName(value[3],value[4],value[5]),1,self.bold2)
                        dxDrawText('Mevcut karakter '..value[2]:gsub('_', ' ')..',\n Son görülen yer '..getZoneName(value[3],value[4],value[5]),self.screen.x/2-(self.textSize/2),self.screen.y-75,nil,nil,tocolor(225,225,225,125),1,self.bold2)
                        if value[6] == 1 then
                            dxDrawImage(self.screen.x/2-(self.textSize/2)-50,self.screen.y-75,40,40,'assets/images/male.png')
                        else
                            dxDrawImage(self.screen.x/2-(self.textSize/2)-50,self.screen.y-75,40,40,'assets/images/female.png')
                        end
                        if self:isInBox(self.screen.x/2-50-25,self.screen.y-115,55,25) then
                            dxDrawText('←',self.screen.x/2-50-25,self.screen.y-155,nil,nil,tocolor(225,225,225,225),1,self.icon)
                            if getKeyState('mouse1') and self.click+400 <= getTickCount() then
                                self.click = getTickCount()
                                if self.current <= 1 then
                                    self.current = 1
                                else
                                    self.current = self.current - 1
                                end
                            end
                        else
                            dxDrawText('←',self.screen.x/2-50-25,self.screen.y-155,nil,nil,tocolor(225,225,225,125),1,self.icon)
                        end

                        if self:isInBox(self.screen.x/2-50+25,self.screen.y-115,55,25) then
                            dxDrawText('→',self.screen.x/2-50+25,self.screen.y-155,nil,nil,tocolor(225,225,225,225),1,self.icon)
                            if getKeyState('mouse1') and self.click+400 <= getTickCount() then
                                self.click = getTickCount()
                                if self.current >= #self.data then
                                    self.current = #self.data
                                else
                                    self.current = self.current + 1
                                end
                            end
                        else
                            dxDrawText('→',self.screen.x/2-50+25,self.screen.y-155,nil,nil,tocolor(225,225,225,125),1,self.icon)
                        end
                        if self:isInBox(self.screen.x-150,0,150,self.screen.y) then
                            dxDrawRectangle(self.screen.x-150,0,150,self.screen.y,tocolor(0,0,0,175))
                            dxDrawText('➔',self.screen.x-100,self.screen.y/2-50,nil,nil,tocolor(195,195,195,155),1,self.icon)
                            if getKeyState('mouse1') and self.click+400 <= getTickCount() then
                                self.click = getTickCount()
                                triggerServerEvent('auth.spawn',localPlayer,value[1])
                                self:stop(self)
                            end
                        else
                            dxDrawRectangle(self.screen.x-150,0,150,self.screen.y,tocolor(0,0,0,125))
                            dxDrawText('➔',self.screen.x-100,self.screen.y/2-50,nil,nil,tocolor(195,195,195),1,self.icon)
                        end
                    end
                end
            end
        elseif self.page == 2 then
            dxDrawText('yeni karakterini kişiselleştir,',self.x,self.screen.y-25-self.h-35-100,nil,nil,tocolor(225,225,225,195),0.8,self.bold2)
            if self.gender == 1 then
                dxDrawImage(self.x+50,self.screen.y-25-self.h-35-65,40,40,'assets/images/male.png',0,0,0,tocolor(255,255,255,125))
            else
                if self:isInBox(self.x+50,self.screen.y-25-self.h-35-65,40,40) then
                    dxDrawImage(self.x+50,self.screen.y-25-self.h-35-65,40,40,'assets/images/male.png',0,0,0,tocolor(255,255,255,125))
                    if getKeyState('mouse1') and self.click+400 <= getTickCount() then
                        self.click = getTickCount()
                        self.gender = 1
                    end
                else
                    dxDrawImage(self.x+50,self.screen.y-25-self.h-35-65,40,40,'assets/images/male.png')
                end
            end
            if self.gender == 2 then
                dxDrawImage(self.x+110,self.screen.y-25-self.h-35-65,40,40,'assets/images/female.png',0,0,0,tocolor(255,255,255,125))
            else
                if self:isInBox(self.x+110,self.screen.y-25-self.h-35-65,40,40) then
                    dxDrawImage(self.x+110,self.screen.y-25-self.h-35-65,40,40,'assets/images/female.png',0,0,0,tocolor(255,255,255,125))
                    if getKeyState('mouse1') and self.click+400 <= getTickCount() then
                        self.click = getTickCount()
                        self.gender = 2
                    end
                else
                    dxDrawImage(self.x+110,self.screen.y-25-self.h-35-65,40,40,'assets/images/female.png')
                end
            end
            if self.gender == 1 then
                self.ped.model = 170
            elseif self.gender == 2 then
                self.ped.model = 193
            end
            if self.selected == 1 then
                dxDrawRectangle(self.x,self.screen.y-25-self.h-35-10,self.w,self.h,tocolor(15,15,15,245))
                self.textSize = dxGetTextWidth(self.name,1,self.bold)
                dxDrawText('l',self.x+5+(1*self.textSize),self.screen.y-25-self.h-35-10+5,nil,nil,tocolor(195,195,195,self.textAlpha),1,self.bold)
            else
                if self:isInBox(self.x,self.screen.y-25-self.h-35-10,self.w,self.h) then
                    if getKeyState('mouse1') and self.click+400 <= getTickCount() then
                        self.click = getTickCount()
                        self.selected = 1
                        if self.name == 'isim_soyad' then
                            self.name = ''
                            self.charName = string.len(self.name)+1
                        end
                    end
                    dxDrawRectangle(self.x,self.screen.y-25-self.h-35-10,self.w,self.h,tocolor(15,15,15,245))
                else
                    dxDrawRectangle(self.x,self.screen.y-25-self.h-35-10,self.w,self.h,tocolor(15,15,15,165))
                end
            end
            dxDrawText(self.name,self.x+5,self.screen.y-25-self.h-35-10+5,nil,nil,tocolor(225,225,225,200),1,self.bold)
            if self.selected == 2 then
                dxDrawRectangle(self.x-200-10+150,self.screen.y-25-self.h-10,self.w/2,self.h,tocolor(15,15,15,245))
                self.textSize = dxGetTextWidth(self.age,1,self.bold)
                dxDrawText('l',self.x-200-10+150+8+(1*self.textSize),self.screen.y-25-self.h-10+5,nil,nil,tocolor(195,195,195,self.textAlpha),1,self.bold)
            else
                if self:isInBox(self.x-200-10+150,self.screen.y-25-self.h-10,self.w/2,self.h) then
                    dxDrawRectangle(self.x-200-10+150,self.screen.y-25-self.h-10,self.w/2,self.h,tocolor(15,15,15,245))
                    if getKeyState('mouse1') and self.click+400 <= getTickCount() then
                        self.click = getTickCount()
                        self.selected = 2
                        if self.age == '18' then
                            self.age = ''
                            self.charAge = string.len(self.age)+1
                        end
                    end
                else
                    dxDrawRectangle(self.x-200-10+150,self.screen.y-25-self.h-10,self.w/2,self.h,tocolor(15,15,15,165))
                end
            end
            dxDrawText(''..self.age..' yaşında',self.x-200-10+150+8,self.screen.y-25-self.h-10+5,nil,nil,tocolor(225,225,225,200),1,self.bold)
            if self.selected == 3 then
                dxDrawRectangle(self.x-200-10+270,self.screen.y-25-self.h-10,self.w/2,self.h,tocolor(15,15,15,235))
                self.textSize = dxGetTextWidth(self.height,1,self.bold)
                dxDrawText('l',self.x-200-10+270+15+(1*self.textSize),self.screen.y-25-self.h-10+5,nil,nil,tocolor(195,195,195,self.textAlpha),1,self.bold)
            else
                if self:isInBox(self.x-200-10+270,self.screen.y-25-self.h-10,self.w/2,self.h) then
                    dxDrawRectangle(self.x-200-10+270,self.screen.y-25-self.h-10,self.w/2,self.h,tocolor(15,15,15,235))
                    if getKeyState('mouse1') and self.click+400 <= getTickCount() then
                        self.click = getTickCount()
                        self.selected = 3
                        if self.height == '175' then
                            self.height = ''
                            self.charHeight = string.len(self.height)+1
                        end
                    end
                else
                    dxDrawRectangle(self.x-200-10+270,self.screen.y-25-self.h-10,self.w/2,self.h,tocolor(15,15,15,165))
                end
            end
            dxDrawText(''..self.height..' cm',self.x-200-10+270+15,self.screen.y-25-self.h-10+5,nil,nil,tocolor(225,225,225,200),1,self.bold)
            if self.selected == 4 then
                dxDrawRectangle(self.x-200-10+390,self.screen.y-25-self.h-10,self.w/2,self.h,tocolor(15,15,15,235))
                self.textSize = dxGetTextWidth(self.weight,1,self.bold)
                dxDrawText('l',self.x-200-10+390+15+(1*self.textSize),self.screen.y-25-self.h-10+5,nil,nil,tocolor(195,195,195,self.textAlpha),1,self.bold)
            else
                if self:isInBox(self.x-200-10+390,self.screen.y-25-self.h-10,self.w/2,self.h) then
                    dxDrawRectangle(self.x-200-10+390,self.screen.y-25-self.h-10,self.w/2,self.h,tocolor(15,15,15,235))
                    if getKeyState('mouse1') and self.click+400 <= getTickCount() then
                        self.click = getTickCount()
                        self.selected = 4
                        if self.weight == '65' then
                            self.weight = ''
                            self.charWeight = string.len(self.weight)+1
                        end
                    end
                else
                    dxDrawRectangle(self.x-200-10+390,self.screen.y-25-self.h-10,self.w/2,self.h,tocolor(15,15,15,165))
                end
            end
            dxDrawText(''..self.weight..' kg',self.x-200-10+390+15,self.screen.y-25-self.h-10+5,nil,nil,tocolor(225,225,225,200),1,self.bold)
            if self:isInBox(0,0,150,self.screen.y) then
                dxDrawRectangle(0,0,150,self.screen.y,tocolor(0,0,0,175))
                dxDrawText('↺',45,self.screen.y/2-50,nil,nil,tocolor(195,195,195,155),1,self.icon)
                if getKeyState('mouse1') and self.click+400 <= getTickCount() then
                    self.click = getTickCount()
                    self.page = 1
                    self.selected = 0
                end
            else
                dxDrawRectangle(0,0,150,self.screen.y,tocolor(0,0,0,125))
                dxDrawText('↺',45,self.screen.y/2-50,nil,nil,tocolor(195,195,195),1,self.icon)
            end

            if self:isInBox(self.screen.x-150,0,150,self.screen.y) then
                dxDrawRectangle(self.screen.x-150,0,150,self.screen.y,tocolor(0,0,0,175))
                dxDrawText('✔',self.screen.x-115,self.screen.y/2-50,nil,nil,tocolor(195,195,195,155),1,self.icon)
                if getKeyState('mouse1') and self.click+400 <= getTickCount() then
                    self.click = getTickCount()
                    triggerServerEvent('auth.create',localPlayer,self.name,self.age,self.height,self.weight,self.gender,self.ped.model)
                end
            else
                dxDrawRectangle(self.screen.x-150,0,150,self.screen.y,tocolor(0,0,0,125))
                dxDrawText('✔',self.screen.x-115,self.screen.y/2-50,nil,nil,tocolor(195,195,195),1,self.icon)
            end
        end
        if getKeyState('backspace') and self.click+120 <= getTickCount() then
            self.click = getTickCount()
            if self.selected == 1 then
                self.fistPart = self.name:sub(0, self.charName-1)
                self.lastPart = self.name:sub(self.charName+1, #self.name)
                self.name = self.fistPart..self.lastPart
                self.charName = string.len(self.name)
            elseif self.selected == 2 then
                self.fistPart = self.age:sub(0, self.charAge-1)
                self.lastPart = self.age:sub(self.charAge+1, #self.age)
                self.age = self.fistPart..self.lastPart
                self.charAge = string.len(self.age)
            elseif self.selected == 3 then
                self.fistPart = self.height:sub(0, self.charHeight-1)
                self.lastPart = self.height:sub(self.charHeight+1, #self.height)
                self.height = self.fistPart..self.lastPart
                self.charHeight = string.len(self.height)
            elseif self.selected == 4 then
                self.fistPart = self.weight:sub(0, self.charWeight-1)
                self.lastPart = self.weight:sub(self.charWeight+1, #self.weight)
                self.weight = self.fistPart..self.lastPart
                self.charWeight = string.len(self.weight)
            end
        end
    else
        dxDrawRectangle(0,0,self.screen.x,self.screen.y,tocolor(25,25,25,225))
        dxDrawImage(32, self.screen.y-55-32, 32, 32, 'assets/images/loading.png', self.load)
    end
end

function character.prototype.success(self)
    triggerServerEvent('auth.characters',localPlayer)
    self.page = 1
end

function character.prototype:write(self,char)
    if self.active then
        if self.selected == 1 then
            if self.click+50 <= getTickCount() then
                self.click = getTickCount()
                if string.len(self.name) <= 20 then
                    self.name = ''..self.name..''..char
                    self.charName = string.len(self.name)+1
                end
            end
        elseif self.selected == 2 then
            if tonumber(char) then
                if self.click+50 <= getTickCount() then
                    self.click = getTickCount()
                    if string.len(self.age) < 2 then
                        self.age = ''..self.age..''..char
                        self.charAge = string.len(self.age)+1
                    end
                end
            end
        elseif self.selected == 3 then
            if tonumber(char) then
                if self.click+50 <= getTickCount() then
                    self.click = getTickCount()
                    if string.len(self.height) < 3 then
                        self.height = ''..self.height..''..char
                        self.charHeight = string.len(self.height)+1
                    end
                end
            end
        elseif self.selected == 4 then
            if tonumber(char) then
                if self.click+50 <= getTickCount() then
                    self.click = getTickCount()
                    if string.len(self.weight) < 2 then
                        self.weight = ''..self.weight..''..char
                        self.charWeight = string.len(self.weight)+1
                    end
                end
            end
        end
    end
end

function character.prototype.stop(self)
    if isTimer(self.texts) then
        self.texts:destroy()
    end
    if isTimer(self.render) then
        self.render:destroy()
    end
    self.active = false
    self.ped:destroy()
    triggerServerEvent('auth.ped.stop',localPlayer)
    removeEventHandler('onClientCharacter', root, self._function.write)
    showChat(true)
    showCursor(false)
    if music then
        stopSound(music)
        music = nil
    end
end

function character.prototype:get(self,data)
    if data then
        if self.active then
            self.data = data
        else
            self.current = 1
            self.data = data
            self.active = true
            self.click = 0
            self.load = 0
            self.page = 1
            self.selected = 0
            self.name = 'isim_soyad'
            self.age = '18'
            self.height = '175'
            self.weight = '65'
            self.gender = 1
            self.render = Timer(self._function.display,0,0)
            self.texts = Timer(self._function.renderText,550,0)
        end
    end
end

function character.prototype.renderText(self)
    if not self.textAlpha then
        self.textAlpha = 225
    end
    if self.textAlpha == 225 then
        self.textAlpha = 0
    else
        self.textAlpha = 225
    end
end

function character.prototype:getPed(self,ped)
    if ped then
        self.ped = ped
    end
end

function character.prototype.start(self)
    addEvent('auth.character.render', true)
    addEventHandler('auth.character.render', root, self._function.get)
    addEvent('auth.get.ped', true)
    addEventHandler('auth.get.ped', root, self._function.ped)
    addEventHandler('onClientCharacter', root, self._function.write)
    addEvent('auth.create.success', true)
    addEventHandler('auth.create.success', root, self._function.success)
end

function character.prototype:isInBox(xS,yS,wS,hS)
    if(isCursorShowing()) then
        local cursorX, cursorY = getCursorPosition()
        sX,sY = guiGetScreenSize()
        cursorX, cursorY = cursorX*sX, cursorY*sY
        if(cursorX >= xS and cursorX <= xS+wS and cursorY >= yS and cursorY <= yS+hS) then
            return true
        else
            return false
        end
    end
end

load(character)
