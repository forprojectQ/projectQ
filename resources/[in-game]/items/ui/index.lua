assert(loadstring(exports.dxlibrary:loadFunctions()))()
local ui = class("UI")
local localPlayer = getLocalPlayer()
local isCursorShowing = isCursorShowing
local tonumber = tonumber
local tocolor = tocolor
local guiGetScreenSize = guiGetScreenSize
local dxDrawCircle = dxDrawCircle
local dxDrawImage = dxDrawImage
local dxDrawRectangle = dxDrawRectangle
local ipairs = ipairs
local getCursorPosition = getCursorPosition
local getKeyState = getKeyState
local getTickCount = getTickCount
local triggerServerEvent = triggerServerEvent
local cursorX, cursorY

local bgColor = tocolor(15, 15, 15, 235)
local hoverBgColor = tocolor(25, 25, 25, 235)
local progColor = tocolor(66, 135, 245)

function ui:init()
    self._function = {
        open = function(...) self:open(...) end,
        display = function(...) self:display(...) end,
    }
    self.categorys = {}
    self:addCategory('Cüzdan', 'assets/images/wallet.png')
    self:addCategory('Çanta', 'assets/images/pack.png')
    self:addCategory('Anahtarlık', 'assets/images/key.png')
    self:addCategory('Silahlar', 'assets/images/gun.png')
    self.screen = Vector2(guiGetScreenSize())
    self.font = exports.fonts:getFont('RobotoB', 9)
    self.itemImages = {}
    self.current = 1
    bindKey('i', 'down', self._function.open)
end

function ui:display()
    local x,y,w,h = self.screen.x-70,self.screen.y/2-250/2,60,250
    local boxX, boxY, boxW, boxH = x+5, y+20, 50, 50
    local newX,newY = 55,20
    dxDrawroundedRectangle(self.screen.x-5-self.size,y,self.size+2.5,h,9,bgColor)
    for index, value in ipairs(self.items) do
	if isInBox(self.screen.x-1-newX,y+newY,boxW,boxH) then
            dxDrawRectangle(self.screen.x-1-newX,y+newY,boxW,boxH,hoverBgColor)
            if getKeyState('mouse1') and self.tick+400 <= getTickCount() then
                self.tick = getTickCount()
                triggerServerEvent('use.item',localPlayer,value[1])
                self:open()
            end
        else
            dxDrawRectangle(self.screen.x-1-newX,y+newY,boxW,boxH,bgColor)
        end
        dxDrawText('x'..value[3],self.screen.x-1-newX,y+newY,nil,nil,tocolor(155,155,155,235),1,self.font)
        dxDrawImage(self.screen.x-1+10-newX,y+10+newY,30,30,value[2])
        if value[4] == "FOOD" or value[4] == "DRINK" then 
            dxDrawRectangle(self.screen.x-1-newX,y+newY+boxH-5,math.min((boxW/100)*value[1][2],boxW),5,progColor)
        end
        newY = newY + 52
        if index % 4 == 0 then
            newY = 20
            newX = newX + 55
        end
    end
    x, boxX = x - newX, boxX - newX
    dxDrawroundedRectangle(x,y,w,h,9,bgColor)
    for i = 1, #self.categorys do
        local category = self.categorys[i]
        if self.current == i then
            dxDrawRectangle(boxX,boxY,boxW,boxH,hoverBgColor)
	elseif isInBox(boxX,boxY,boxW,boxH) then
            dxDrawRectangle(boxX,boxY,boxW,boxH,hoverBgColor)
            if getKeyState('mouse1') and self.tick+400 <= getTickCount() then
                self.tick = getTickCount()
                self.current = i
                self:refresh()
            end
        else
            dxDrawRectangle(boxX,boxY,boxW,boxH,bgColor)
        end
        dxDrawImage(boxX+7.5,boxY+7.5,35,35,category[2])
        boxY=boxY+52
    end
end

function ui:addCategory(name, image)
    table.insert(self.categorys, {name, image})
end

function ui:open()
    if localPlayer:getData("online") then
        self.active = not self.active
        self.items = {}
        showCursor(self.active)
        if self.active then
            self.tick = 0
            self:refresh()
            Sound('assets/audio/bag.wav')
            self.render = self.render or Timer(self._function.display, 0, 0)
        else
            if self.render and self.render.valid then
                self.render:destroy()
                self.render = nil
            end
        end
    end
end

function ui:refresh()
    local items = getItems(localPlayer) or {}
    local category = getItemCategory
    local current = self.current
    local size = 55
    self.items = {}
    for index, value in pairs(items) do
        if category(value[1]) == current then
            table.insert(self.items, {
                value, 
                self:getImage(value[1]), 
                getItemCount(value[1],value[2]),
                getItemType(value[1]),
            })
            if index % 4 == 0 then
                size = size + 55
            end
        end
    end
    self.size = size
end

function ui:getImage(itemID)
    if not self.itemImages[itemID] then
        local imagePath = 'assets/images/items/'..itemID..'.png'
        self.itemImages[itemID] = File.exists(imagePath) and imagePath or 'assets/images/null.png'
    end
    return self.itemImages[itemID]
end

ui:new()
