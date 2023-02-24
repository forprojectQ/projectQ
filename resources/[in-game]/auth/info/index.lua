local info = new('info')
local guiGetScreenSize = guiGetScreenSize
local dxDrawText = dxDrawText
local dxGetTextWidth = dxGetTextWidth
local tocolor = tocolor

function info.prototype.____constructor(self)
    self._function = {}
    self._function.get = function(...) self:get(self,...) end
    self._function.display = function(...) self:display(self) end
    self._function.stop = function(...) self:stop(self) end
    self.bold = exports.fonts:get('RobotoB', 10)
    self.screen = Vector2(guiGetScreenSize())
    self.render = nil
    addEvent('auth.info', true)
    addEventHandler('auth.info', root, self._function.get)
end

function info.prototype.display(self)
    self.textSize = dxGetTextWidth(self.text,1,self.bold)
    dxDrawText(self.text,self.screen.x/2-(self.textSize/2)-1,self.screen.y-25,nil,nil,tocolor(0,0,0),1,self.bold)
    dxDrawText(self.text,self.screen.x/2-(self.textSize/2),self.screen.y-25-1,nil,nil,tocolor(0,0,0),1,self.bold)
    dxDrawText(self.text,self.screen.x/2-(self.textSize/2)+1,self.screen.y-25,nil,nil,tocolor(0,0,0),1,self.bold)
    dxDrawText(self.text,self.screen.x/2-(self.textSize/2),self.screen.y-25+1,nil,nil,tocolor(0,0,0),1,self.bold)
    dxDrawText(self.text,self.screen.x/2-(self.textSize/2),self.screen.y-25,nil,nil,tocolor(195,157,108,175),1,self.bold)
end

function info.prototype.stop(self)
    if isTimer(self.render) then
        self.render:destroy()
    end
    if isTimer(self.close) then
        self.close:destroy()
    end
end

function info.prototype:get(self,text)
    if text then
        self.text = text
        if isTimer(self.render) then
            self.render:destroy()
        end
        if isTimer(self.close) then
            self.close:destroy()
        end
        self.render = Timer(self._function.display,0,0)
        self.close = Timer(self._function.stop,1500,1)
    end
end

load(info)