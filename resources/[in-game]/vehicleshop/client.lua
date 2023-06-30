ui = class("UI")

function ui:init()
    self.functions = {
        render = function(...) self:render(...) end,
        load = function(...) self:load(...) end,
        startRender = function(...) self:start(...) end,
        up = function(...) self:up(...) end,
        down = function(...) self:down(...) end,
        carScreen = function(...) self:carScreen(...) end
    }
    self:registerEvent()
    self:loadAssets()
    bindKey('mouse_wheel_up', 'down', self.functions.up)
    bindKey('mouse_wheel_down', 'down', self.functions.down)
    self.npc = createPed(11, 555.537109375, -1293.08203125, 17.248237609863, 2.3923034667969)
    self.npc:setData('name', 'Carol Joshua')
    self.npc.frozen = true
    addEventHandler('onClientClick', root, function(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
        if (clickedElement) then
            if clickedElement == self.npc then
                if button == "right" and state == "down" then
                    self.functions.startRender()
                end
            end
        end
    end)
end

function ui:render()
    self.w, self.h = 250, 80
    self.x, self.y = (screen.x-self.w), (screen.y-self.h)/2 
    self.x2 = interpolateBetween(self.x+200, 0, 0, self.x-30, 0, 0, ((getTickCount() - self.startTime) / 700), "Linear")
    dxDrawRoundedRectangle(self.x2, self.y-300, 400, 600, 2, tocolor(50, 50, 50, 240))
    dxDrawText("Grotti Car's", self.x2+150, self.y-280, nil, nil, tocolor(255, 255, 255, 200), 1, self.fonts.oswald, "center", "center", false, false, false, false, true)
    if not self.loaded then
        self.loading = self.loading + 5
        dxDrawText("", self.x2+155, self.y-10, nil, nil, tocolor(255, 255, 255, 200), 1, self.fonts.awesome2, "center", "center", false, false, false, false, false, self.loading)
        dxDrawText("Araçlar Yükleniyor", self.x2+155, self.y+25, nil, nil, tocolor(255, 255, 255, 200), 1, self.fonts.robotoB, "center", "center", false, false, false, false, false)
        return
    end
    self.counterYText = 0
    self.counterYRect = 0
    self.latest = self.current + self.maxCar - 1
    for i, v in ipairs(self.vehicle) do 
        if i >= self.current and i <= self.latest then
            if (v.enabled) == 0 then return end
            if i == self.selected then 
                if isInBox(self.x-15, self.y-230+self.counterYRect, self.w, self.h, "hand") then
                    dxDrawRoundedRectangle(self.x-15, self.y-230+self.counterYRect, self.w, self.h, 2, tocolor(20, 20, 20, 250))
                    if getKeyState("mouse1") and isClicked() then 
                        self.buyScreen = true
                        self.selected = nil
                    end
                else
                    dxDrawRoundedRectangle(self.x-15, self.y-230+self.counterYRect, self.w, self.h, 2, tocolor(20, 20, 20, 200))
                end
            else
                if isInBox(self.x-15, self.y-230+self.counterYRect, self.w, self.h, "hand") then
                    dxDrawRoundedRectangle(self.x-15, self.y-230+self.counterYRect, self.w, self.h, 2, tocolor(20, 20, 20, 250))
                    if getKeyState("mouse1") and isClicked() then 
                        self.buyScreen = false
                        self.selected = i
                        self.tax = v.tax
                        self.model = v.model
                        self.selectedModel = ""..v.brand.. " " ..v.model..""
                        self.year = v.year
                        self.fueltype = v.fueltype
                        self.price = v.price
                        self.gtaID = v.gtaID
                        self.vehlibID = v.vehlibID
                    end
                else
                    dxDrawRoundedRectangle(self.x-15, self.y-230+self.counterYRect, self.w, self.h, 2, tocolor(20, 20, 20, 200))
                end
            end
            dxDrawText(v.brand, self.x-5, self.y-230+self.counterYText, nil, nil, tocolor(255, 255, 255, 200), 1, self.fonts.oswald)
            dxDrawText(v.model, self.x-5, self.y-197+self.counterYText, nil, nil, tocolor(255, 255, 255, 170), 1, self.fonts.roboto)
            self.lenght = dxGetTextWidth(""..exports.global:formatMoney(v.price).."#008000$", 1, self.fonts.oswaldS)
            dxDrawText(""..exports.global:formatMoney(v.price).."#008000$", self.x+300-self.lenght, self.y-190+self.counterYText, nil, nil, tocolor(255, 255, 255, 170), 1, self.fonts.oswaldS, "left", "top", _, _, _, true)
            dxDrawText("Stok: "..v.stock.."", self.x-5, self.y-180+self.counterYText, nil, nil, tocolor(255, 255, 255, 170), 1, self.fonts.roboto)

            if (v.fueltype) == -1 then 
                v.fueltype = "Dizel"
            elseif (v.fueltype) == 0 then
                v.fueltype = "Benzin"
            elseif (v.fueltype) == 1 then
                v.fueltype = "LPG"
            end 

            self.counterYText = self.counterYText + 85
            self.counterYRect = self.counterYRect + 85
        end
        if self.buyScreen then
            dxDrawRoundedRectangle(self.x-30, self.y+320, 280, 200, 2, tocolor(50, 50, 50, 240))
            dxDrawText("Satın Alım Ekranı", self.x-15, self.y+320, nil, nil, tocolor(255, 255, 255, 200), 1, self.fonts.oswald)
            dxDrawText("Seçili Araç: #ECAB53"..self.selectedModel.."", self.x-15, self.y+370, nil, nil, tocolor(255, 255, 255, 170), 1, self.fonts.roboto, _, _, _, _ ,_, true)
            dxDrawText("Vergi: "..exports.global:formatMoney(self.tax).."#008000$".."", self.x-15, self.y+390, nil, nil, tocolor(255, 255, 255, 170), 1, self.fonts.roboto, _, _, _, _ ,_, true)
            dxDrawText("Çıkış Yılı: #FF2222"..self.year.."", self.x-15, self.y+410, nil, nil, tocolor(255, 255, 255, 170), 1, self.fonts.roboto, _, _, _, _ ,_, true)
            dxDrawText("Yakıt Türü: #FFFF50"..self.fueltype.."", self.x-15, self.y+430, nil, nil, tocolor(255, 255, 255, 170), 1, self.fonts.roboto, _, _, _, _ ,_, true)

            if isInBox(self.x-15, self.y+470, 120, 35, "hand") then 
                dxDrawRoundedRectangle(self.x-15, self.y+470, 120, 35, 2, tocolor(0, 128, 0, 200))
                if getKeyState("mouse1") and isClicked() then 
                    triggerServerEvent("vehicle.buy", localPlayer, self.price, self.selectedModel, self.vehlibID)
                    showCursor(false)
                end
            else
                dxDrawRoundedRectangle(self.x-15, self.y+470, 120, 35, 2, tocolor(20, 20, 20, 220))
            end
            dxDrawText("Satın Al", self.x+18, self.y+476, nil, nil, tocolor(255, 255, 255, 200), 1, self.fonts.roboto)

            if isInBox(self.x+120, self.y+470, 120, 35, "hand") then 
                dxDrawRoundedRectangle(self.x+120, self.y+470, 120, 35, 2, tocolor(0, 105, 92, 200))
                if getKeyState("mouse1") and isClicked() then 
                    self.functions.carScreen(self.gtaID)
                end
            else
                dxDrawRoundedRectangle(self.x+120, self.y+470, 120, 35, 2, tocolor(20, 20, 20, 220))
            end
            dxDrawText(self.screenText, self.x+150, self.y+476, nil, nil, tocolor(255, 255, 255, 200), 1, self.fonts.roboto)
        end
    end
end

function ui:start()
    if localPlayer:getData("online") then
        self.active = not self.active
        if self.active then 
            self.loading, self.finishLoad = 1, getTickCount()+3000
            addEventHandler("onClientRender", root, self.functions.render, true, "low-9999")
            triggerServerEvent("vehicle.get.data", localPlayer)
            Delay = Timer(function()
                self.loaded = true
            end, 4000, 1)
            self.maxCar = 6
            self.current = 1
            self.latest = 1
            self.startTime = getTickCount()
            self.selected = nil
            self.x2 = 0
            self.screenText = "Görüntüle"
            showCursor(true)
        else
            showCursor(false)
            removeEventHandler("onClientRender", root, self.functions.render)
            self.loaded = false
        end
    end
end

function ui:carScreen(gtaID)
    self.state = not self.state 
    if self.state then
        self.dimension = 100
        self.veh = Vehicle(602, 2263.654296875, -2484.3349609375, 8.2896251678467)
        self.veh.dimension = self.dimension
        Camera.setMatrix(2252.056640625, -2477.9736328125, 10.98962688446, 2263.654296875, -2484.3349609375, 8.2896251678467)
        localPlayer:setPosition(2257, -2482, 8.296875)
        localPlayer:setRotation(0, 0, 247)
        localPlayer.dimension = self.dimension
        localPlayer:setFrozen(true)
        self.screenText = "Geri Dön"
        self.veh.model = gtaID
        toggleAllControls(false)
    else
        self.buyScreen = false
        self.veh:destroy()
        triggerServerEvent("close.vehicle.shop", localPlayer)
        self.screenText = "Görüntüle"
    end
end

function ui:up()
    if self.active then
        if self.current > 1 then
            self.current = self.current - 1
        end
    end
end

function ui:down()
    if self.active then
        if self.current < (#self.vehicle) - (self.maxCar - 1) then
            self.current = self.current + 1
        end
    end
end

function ui:loadAssets()
    assert(loadstring(exports.dxlibrary:loadFunctions()))()
    self.fonts = {
        awesome = exports.fonts:getFont("AwesomeRegular", 20),
        awesome2 = exports.fonts:getFont("AwesomeSolid", 23),
        robotoB = exports.fonts:getFont("RobotoB", 11),
        roboto = exports.fonts:getFont("Roboto", 11),
        oswald = exports.fonts:getFont("Oswald", 23),
        oswaldS = exports.fonts:getFont("Oswald", 20),
    }
end

function ui:load(vehData)
    self.vehicle = vehData
end

function ui:registerEvent()
    addEvent("vehicle.data", true)
    addEventHandler("vehicle.data", root, self.functions.load)  
end


ui:new()