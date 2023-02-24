local login = new('login')
local addEvent = addEvent
local addEventHandler = addEventHandler
local dxDrawImage = dxDrawImage
local dxDrawRectangle = dxDrawRectangle
local dxDrawText = dxDrawText
local dxGetTextWidth = dxGetTextWidth
local getTickCount = getTickCount
local getKeyState = getKeyState
local tocolor = tocolor
local triggerServerEvent = triggerServerEvent
local guiGetScreenSize = guiGetScreenSize
local root = root
local localPlayer = localPlayer

function login.prototype.____constructor(self)
    self._function = {}
    self._function.write = function(...) self:write(self,...) end
    self._function.display = function(...) self:display(self) end
    self._function.renderText = function(...) self:renderText(self) end
    self._function.logined = function(...) self:logined(self) end
    self._function.remember = function(...) self:remember(self,...) end
    self.bold = exports.fonts:get('RobotoB', 10)
    self.icon = exports.fonts:get('RobotoB', 50)
    self.regular = exports.fonts:get('Roboto', 10)
    self.screen = Vector2(guiGetScreenSize())
    self.w, self.h = 250, 40
    self.x, self.y = self.screen.x/2-self.w/2, self.screen.y/2-self.h/2
    self:start(self)
    if localPlayer:getData('online') then else self:enter(self) end
end

function login.prototype.display(self)
    dxDrawRectangle(0,0,self.screen.x,self.screen.y,tocolor(25,25,25,225))
    dxDrawImage(25,self.screen.y-55-25,55,55,'assets/images/logo.png')
    dxDrawText('♫ Clairo - Sofia (slowed + reverb)',85,self.screen.y-55,nil,nil,tocolor(225,225,225,225),1,self.bold)
    if self.page == 1 then
        if self.selected == 1 then
            dxDrawRectangle(self.x,self.y,self.w,self.h,tocolor(15,15,15,245))
            self.textSize = dxGetTextWidth(self.username,1,self.bold)
            dxDrawText('l',self.x+5+(1*self.textSize),self.y+10,nil,nil,tocolor(195,195,195,self.textAlpha),1,self.bold)
        else
            if self:isInBox(self.x,self.y,self.w,self.h) then
                dxDrawRectangle(self.x,self.y,self.w,self.h,tocolor(15,15,15,245))
                if getKeyState('mouse1') and self.click+400 <= getTickCount() then
                    self.click = getTickCount()
                    self.selected = 1
                    if self.username == 'kullanıcı adı' then
                        self.username = ''
                        self.charUsername = string.len(self.username)+1
                    end
                end
            else
                dxDrawRectangle(self.x,self.y,self.w,self.h,tocolor(15,15,15,215))
            end
        end
        dxDrawText(self.username,self.x+5,self.y+10,nil,nil,tocolor(195,195,195),1,self.bold)
        if self.selected == 2 then
            dxDrawRectangle(self.x,self.y+self.h+5,self.w,self.h,tocolor(15,15,15,245))
            if self.show then
                self.textSize = dxGetTextWidth(self.password,1,self.bold)
            else
                self.textSize = dxGetTextWidth(string.gsub(self.password, '.', '*'),1,self.bold)
            end
            dxDrawText('l',self.x+5+(1*self.textSize),self.y+self.h+5+10,nil,nil,tocolor(195,195,195,self.textAlpha),1,self.bold)
        else
            if self:isInBox(self.x,self.y+self.h+5,self.w,self.h) then
                dxDrawRectangle(self.x,self.y+self.h+5,self.w,self.h,tocolor(15,15,15,245))
                if getKeyState('mouse1') and self.click+400 <= getTickCount() then
                    self.click = getTickCount()
                    self.selected = 2
                    if self.password == 'şifre' then
                        self.password = ''
                        self.charPassword = string.len(self.password)+1
                    end
                end
            else
                dxDrawRectangle(self.x,self.y+self.h+5,self.w,self.h,tocolor(15,15,15,215))
            end
        end
        if self.show then
            dxDrawText(self.password,self.x+5,self.y+self.h+5+10,nil,nil,tocolor(195,195,195),1,self.bold)
        else
            dxDrawText(string.gsub(self.password, '.', '*'),self.x+5,self.y+self.h+5+10,nil,nil,tocolor(195,195,195),1,self.bold)
        end

        if self:isInBox(self.x+self.w-35,self.y+self.h+7,35,35) then
            dxDrawImage(self.x+self.w-35,self.y+self.h+7,35,35,'assets/images/eye.png')
            if getKeyState('mouse1') and self.click+400 <= getTickCount() then
                self.click = getTickCount()
                if self.show then
                    self.show = false
                else
                    self.show = true
                end
            end
        else
            dxDrawImage(self.x+self.w-35,self.y+self.h+7,35,35,'assets/images/eye.png')
        end
        if self:isInBox(self.screen.x-150,0,150,self.screen.y) then
            dxDrawRectangle(self.screen.x-150,0,150,self.screen.y,tocolor(0,0,0,175))
            dxDrawText('➔',self.screen.x-100,self.screen.y/2-50,nil,nil,tocolor(195,195,195,155),1,self.icon)
            if getKeyState('mouse1') and self.click+400 <= getTickCount() then
                self.click = getTickCount()
                triggerServerEvent('auth.login',localPlayer,self.username,self.password)
            end
        else
            dxDrawRectangle(self.screen.x-150,0,150,self.screen.y,tocolor(0,0,0,125))
            dxDrawText('➔',self.screen.x-100,self.screen.y/2-50,nil,nil,tocolor(195,195,195),1,self.icon)
        end
        if self:isInBox(self.x+65,self.y+self.h+5+50,115,25) then
            dxDrawText('buralarda yeni misin?\n  bir hesap oluştur.',self.x+65,self.y+self.h+5+50,nil,nil,tocolor(195,195,195,225),0.8,self.bold)
            if getKeyState('mouse1') and self.click+400 <= getTickCount() then
                self.click = getTickCount()
                self.page = 2
            end
        else
            dxDrawText('buralarda yeni misin?\n  bir hesap oluştur.',self.x+65,self.y+self.h+5+50,nil,nil,tocolor(195,195,195,125),0.8,self.bold)
        end
    elseif self.page == 2 then
        if self.selected == 1 then
            dxDrawRectangle(self.x,self.y,self.w,self.h,tocolor(15,15,15,245))
            self.textSize = dxGetTextWidth(self.username,1,self.bold)
            dxDrawText('l',self.x+5+(1*self.textSize),self.y+10,nil,nil,tocolor(195,195,195,self.textAlpha),1,self.bold)
        else
            if self:isInBox(self.x,self.y,self.w,self.h) then
                dxDrawRectangle(self.x,self.y,self.w,self.h,tocolor(15,15,15,245))
                if getKeyState('mouse1') and self.click+400 <= getTickCount() then
                    self.click = getTickCount()
                    self.selected = 1
                    if self.username == 'kullanıcı adı' then
                        self.username = ''
                        self.charUsername = string.len(self.username)+1
                    end
                end
            else
                dxDrawRectangle(self.x,self.y,self.w,self.h,tocolor(15,15,15,215))
            end
        end
        dxDrawText(self.username,self.x+5,self.y+10,nil,nil,tocolor(195,195,195),1,self.bold)
        if self.selected == 2 then
            dxDrawRectangle(self.x,self.y+self.h+5,self.w,self.h,tocolor(15,15,15,245))
            if self.show then
                self.textSize = dxGetTextWidth(self.password,1,self.bold)
            else
                self.textSize = dxGetTextWidth(string.gsub(self.password, '.', '*'),1,self.bold)
            end
            dxDrawText('l',self.x+5+(1*self.textSize),self.y+self.h+5+10,nil,nil,tocolor(195,195,195,self.textAlpha),1,self.bold)
        else
            if self:isInBox(self.x,self.y+self.h+5,self.w,self.h) then
                dxDrawRectangle(self.x,self.y+self.h+5,self.w,self.h,tocolor(15,15,15,245))
                if getKeyState('mouse1') and self.click+400 <= getTickCount() then
                    self.click = getTickCount()
                    self.selected = 2
                    if self.password == 'şifre' then
                        self.password = ''
                        self.charPassword = string.len(self.password)+1
                    end
                end
            else
                dxDrawRectangle(self.x,self.y+self.h+5,self.w,self.h,tocolor(15,15,15,215))
            end
        end
        if self.show then
            dxDrawText(self.password,self.x+5,self.y+self.h+5+10,nil,nil,tocolor(195,195,195),1,self.bold)
        else
            dxDrawText(string.gsub(self.password, '.', '*'),self.x+5,self.y+self.h+5+10,nil,nil,tocolor(195,195,195),1,self.bold)
        end
        if self:isInBox(self.x+self.w-35,self.y+self.h+7,35,35) then
            dxDrawImage(self.x+self.w-35,self.y+self.h+7,35,35,'assets/images/eye.png')
            if getKeyState('mouse1') and self.click+400 <= getTickCount() then
                self.click = getTickCount()
                if self.show then
                    self.show = false
                else
                    self.show = true
                end
            end
        else
            dxDrawImage(self.x+self.w-35,self.y+self.h+7,35,35,'assets/images/eye.png')
        end
        if self.selected == 3 then
            dxDrawRectangle(self.x,self.y+self.h+self.h+10,self.w,self.h,tocolor(15,15,15,245))
            self.textSize = dxGetTextWidth(self.email,1,self.bold)
            dxDrawText('l',self.x+5+(1*self.textSize),self.y+self.h+self.h+10+10,nil,nil,tocolor(195,195,195,self.textAlpha),1,self.bold)
        else
            if self:isInBox(self.x,self.y+self.h+self.h+10,self.w,self.h) then
                dxDrawRectangle(self.x,self.y+self.h+self.h+10,self.w,self.h,tocolor(15,15,15,245))
                if getKeyState('mouse1') and self.click+400 <= getTickCount() then
                    self.click = getTickCount()
                    self.selected = 3
                    if self.email == 'youremail@icloud.com' then
                        self.email = ''
                        self.charEmail = string.len(self.email)+1
                    end
                end
            else
                dxDrawRectangle(self.x,self.y+self.h+self.h+10,self.w,self.h,tocolor(15,15,15,215))
            end
        end
        dxDrawText(self.email,self.x+5,self.y+self.h+self.h+10+10,nil,nil,tocolor(195,195,195),1,self.bold)
        if self:isInBox(self.screen.x-150,0,150,self.screen.y) then
            dxDrawRectangle(self.screen.x-150,0,150,self.screen.y,tocolor(0,0,0,175))
            dxDrawText('➔',self.screen.x-100,self.screen.y/2-50,nil,nil,tocolor(195,195,195,155),1,self.icon)
            if getKeyState('mouse1') and self.click+400 <= getTickCount() then
                self.click = getTickCount()
                triggerServerEvent('auth.register',localPlayer,self.username,self.password,self.email)
            end
        else
            dxDrawRectangle(self.screen.x-150,0,150,self.screen.y,tocolor(0,0,0,125))
            dxDrawText('➔',self.screen.x-100,self.screen.y/2-50,nil,nil,tocolor(195,195,195),1,self.icon)
        end
        if self:isInBox(self.x+65,self.y+self.h+self.h+10+50,115,25) then
            dxDrawText('zaten bir hesabın var mı?\n  hesabına giriş yap.',self.x+65,self.y+self.h+self.h+10+50,nil,nil,tocolor(195,195,195,225),0.8,self.bold)
            if getKeyState('mouse1') and self.click+400 <= getTickCount() then
                self.click = getTickCount()
                self.page = 1
            end
        else
            dxDrawText('zaten bir hesabın var mı?\n  hesabına giriş yap.',self.x+65,self.y+self.h+self.h+10+50,nil,nil,tocolor(195,195,195,125),0.8,self.bold)
        end
    end
    if getKeyState('backspace') and self.click+120 <= getTickCount() then
        self.click = getTickCount()
        if self.selected == 1 then
            self.fistPart = self.username:sub(0, self.charUsername-1)
            self.lastPart = self.username:sub(self.charUsername+1, #self.username)
            self.username = self.fistPart..self.lastPart
            self.charUsername = string.len(self.username)
        elseif self.selected == 2 then
            self.fistPart = self.password:sub(0, self.charPassword-1)
            self.lastPart = self.password:sub(self.charPassword+1, #self.password)
            self.password = self.fistPart..self.lastPart
            self.charPassword = string.len(self.password)
        elseif self.selected == 3 then
            self.fistPart = self.email:sub(0, self.charEmail-1)
            self.lastPart = self.email:sub(self.charEmail+1, #self.email)
            self.email = self.fistPart..self.lastPart
            self.charEmail = string.len(self.email)
        end
    end
end

function login.prototype:remember(self,username,password)
    self.username = username
    self.password = password
    self.charUsername = string.len(self.username)
    self.charPassword = string.len(self.password)
end

function login.prototype.enter(self)
    showChat(false)
    showCursor(true)
    fadeCamera(true)
    self.dim = math.random(1,9999)
    localPlayer:setDimension(self.dim)
    localPlayer:setInterior(0)
    Camera.setMatrix(2114.9575195312, -1738.3399658203, 13.37619972229, 2114.9345703125, -1737.3570556641, 13.558897972107)
    self.username = 'kullanıcı adı'
    self.password = 'şifre'
    self.email = 'youremail@icloud.com'
    self.active = true
    self.click = 0
    self.selected = 0
    self.page = 1
    self.texts = Timer(self._function.renderText,550,0)
    self.render = Timer(self._function.display,0,0)
    triggerServerEvent('auth.remember',localPlayer)
    music = Sound('assets/sounds/music.mp3')
    self:create(self)
end

function login.prototype.stop(self)
    self.active = 0
    if isTimer(self.texts) then
        self.texts:destroy()
    end
    if isTimer(self.render) then
        self.render:destroy()
    end
end

function login.prototype.create(self)
    self.ped = createPed(170,2114.0390625,-1732.623046875,13.558608055115,72)
    self.ped:setDimension(self.dim)
    self.ped:setInterior(0)
    self.ped.frozen = true
    self.ped:setAnimation('bsktball','bball_idleloop')
    triggerServerEvent('auth.ped', localPlayer, self.ped.position.x, self.ped.position.y, self.ped.position.z, self.dim)
end

function login.prototype.logined(self)
    triggerServerEvent('auth.characters',localPlayer)
    triggerEvent('auth.get.ped', localPlayer, self.ped)
    removeEventHandler('onClientCharacter', root, self._function.write)
    Timer(function()
        self:stop(self)
    end,115,1)
end

function login.prototype.renderText(self)
    if not self.textAlpha then
        self.textAlpha = 225
    end
    if self.textAlpha == 225 then
        self.textAlpha = 0
    else
        self.textAlpha = 225
    end
end

function login.prototype:write(self,char)
    if self.active then
        if self.selected == 1 then
            if self.click+50 <= getTickCount() then
                self.click = getTickCount()
                if string.len(self.username) <= 15 then
                    self.username = ''..self.username..''..char
                    self.charUsername = string.len(self.username)+1
                end
            end
        elseif self.selected == 2 then
            if self.click+50 <= getTickCount() then
                self.click = getTickCount()
                if string.len(self.password) <= 20 then
                    self.password = ''..self.password..''..char
                    self.charPassword = string.len(self.password)+1
                end
            end
        elseif self.selected == 3 then
            if self.click+50 <= getTickCount() then
                self.click = getTickCount()
                if string.len(self.email) <= 25 then
                    self.email = ''..self.email..''..char
                    self.charEmail = string.len(self.email)+1
                end
            end
        end
    end
end

function login.prototype.start(self)
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
    addEvent('auth.logined', true)
    addEventHandler('auth.logined', root, self._function.logined)
    addEvent('auth.remember.client', true)
    addEventHandler('auth.remember.client', root, self._function.remember)
    addEventHandler('onClientCharacter', root, self._function.write)
end

function login.prototype:isInBox(xS,yS,wS,hS)
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

load(login)