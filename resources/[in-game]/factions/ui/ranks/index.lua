--// YETKİLER SAYFASI
ui.pages[4] = {
    open = function(self)
        self.selectedTable, self.currentRow, self.maxRow, self.selectedRank = self.ranks_info, 0, 9,0
		self.currentRowPerms,self.maxRowPerms = 0,7
        self.editing,self.cachedRankPerms = nil,{}
        self.ranksFunctions = {
            listUp = function()
				if isInBox(self.x+210,self.y+120,280,#self.selectedTable*30) then
					if self.currentRow > 0 then
						self.currentRow = self.currentRow - 1
					end
				elseif isInBox((self.x+210)+290,self.y+150,270,#permissions*30) then
					if self.currentRowPerms > 0 then
						self.currentRowPerms = self.currentRowPerms - 1
					end	
				end	
            end,

            listDown = function()
				if isInBox(self.x+210,self.y+120,280,#self.selectedTable*30) then
					if self.currentRow < #self.selectedTable - self.maxRow then
						self.currentRow = self.currentRow + 1
					end
				elseif isInBox((self.x+210)+290,self.y+150,270,#permissions*30) then
					if self.currentRowPerms < #permissions - self.maxRowPerms then
						self.currentRowPerms = self.currentRowPerms + 1
					end	
				end	
            end,
			selectRank = function(rank_index)
				self.cachedRankPerms = {}
				self.selectedRank=rank_index
				for i,v in ipairs(self.selectedTable[rank_index].permissions) do
					self.cachedRankPerms[v]=true
				end
			end,
			updatePerms = function()
				if self.selectedRank == 0 then return end
				local perms = {}
				for perm,v in pairs(self.cachedRankPerms) do table.insert(perms,perm) end
				triggerServerEvent("factions.updateRankPermissions",resourceRoot,tonumber(self.selectedTable[self.selectedRank].id),perms)
			end,
        }
		self.rankButtons = {
			{"Ekle","+",tocolor(88, 242, 88, 125)},
			{"Değiştir","",tocolor(88, 101, 242, 125)},
			{"Kaldır","",tocolor(255, 0, 0, 125)},
		}

        bindKey("mouse_wheel_up", "down", self.ranksFunctions.listUp)
        bindKey("mouse_wheel_down", "down", self.ranksFunctions.listDown)
    end,

    close = function(self)
        unbindKey("mouse_wheel_up", "down", self.ranksFunctions.listUp)
        unbindKey("mouse_wheel_down", "down", self.ranksFunctions.listDown)
		self.editing, self.currentRow, self.maxRow, self.ranksFunctions, self.selectedTable, self.selectedRank = nil, nil, nil, nil, nil, nil
        collectgarbage("collect")
    end,

    render = function(self)
        dxDrawCustomRoundedRectangle(12, self.x+200, self.y+25, self.w-220, 75, tocolor(65, 67, 74), false, false, false, false, true, true)
        dxDrawRectangle(self.x+200, self.y+25+75, self.w-220, 2, tocolor(255, 255, 255, 125))

        --// SAYFA BAŞLIĞI
        dxDrawText("Birlik Yetkileri", self.x+210, self.y+30, nil, nil, tocolor(255, 255, 255), 1, self.fonts.robotoBBig)
        dxDrawText("Birlik yetkilerinin düzenleme", self.x+210, self.y+50, nil, nil, tocolor(175, 175, 175), 1, self.fonts.robotoSmall)

        local newY,newY2 = 0,0
        local listColor = tocolor(65, 67, 74, 170) 
        local listColor2 = tocolor(47, 49, 55, 170)
        local listColor3 = tocolor(30, 30, 30, 255)
		--// YETKİLER
        for i = self.currentRow + 1, math.min(self.currentRow + self.maxRow, #self.selectedTable) do
            local val = self.selectedTable[i]
            if val then
				local isHovered = isInBox(self.x+210, self.y+120+newY, 280, 30, "hand")
                dxDrawRectangle(self.x+210, self.y+120+newY, 280, 30, (isHovered or self.selectedRank==i) and (listColor3) or (i%2 == 0 and listColor2 or listColor)) 
				dxDrawText(val.name, self.x+215, self.y+125+newY, (self.x+210)+280, (self.y+125+newY)+30, tocolor(255, 255, 255, 200), 1, self.fonts.robotoSmall, nil, nil, true, false)
                if isHovered and isClicked() then
					self.ranksFunctions.selectRank(i)
                end

                newY = newY + 30
            end
        end
		--// YETKİ İZİNLERİ
		for i = self.currentRowPerms + 1, math.min(self.currentRowPerms + self.maxRowPerms, #permissions) do
            local val = permissions[i]
            if val then
				local isHovered = self.selectedRank > 0 and isInBox((self.x+210)+290, self.y+150+newY2, 270, 30, "hand") or false
                dxDrawRectangle((self.x+210)+290, self.y+150+newY2, 270, 30, (isHovered) and (listColor3) or (i%2 == 0 and listColor2 or listColor)) 
				dxDrawText(val[1], ((self.x+210)+290)+30, self.y+155+newY2, (((self.x+210)+290)+30)+270, (self.y+155+newY2)+30, tocolor(255, 255, 255, 200), 1, self.fonts.robotoSmall, nil, nil, true, false)
				local rank = self.selectedTable[self.selectedRank]
				if rank then
					local has_perm = self.cachedRankPerms[val[2]]
					dxDrawText(has_perm and "" or "", ((self.x+210)+290)+5, self.y+155+newY2, (((self.x+210)+290)+5)+270, (self.y+155+newY2)+30, tocolor(255, 255, 255, 200), 1, self.fonts.awesomeSmall, nil, nil, true, false)
					if isHovered and isClicked() then
						self.cachedRankPerms[val[2]]= not has_perm or nil
						iprint(self.cachedRankPerms)
					end
				end
                newY2 = newY2 + 30
            end
        end
		if self.selectedRank == 0 then
			dxDrawRectangle((self.x+210)+290,self.y+150,270,newY2,tocolor(0,0,0,200))
		end	
		--// BUTONLAR
		dxDrawRoundedRectangle((self.x+210)+290+10, (self.y+150)+newY2+5, 250, 30, 8, tocolor(65, 67, 74))
		dxDrawText("İzinleri Uygula", (self.x+210)+290+15, (self.y+150)+newY2+5, ((self.x+210)+290+10)+250, ((self.y+150)+newY2+5)+30, tocolor(255, 255, 255, 200), 1, self.fonts.robotoB, "left", "center", true, false)
		local isHovered = isInBox((self.x+210)+290+230, (self.y+150)+newY2+5, 20, 20, "hand")
		dxDrawText("", (self.x+210)+290+15, (self.y+150)+newY2+5, ((self.x+210)+290)+250, ((self.y+150)+newY2+5)+30, (isHovered) and tocolor(88, 101, 242, 125) or tocolor(255, 255, 255, 200), 1, self.fonts.awesomeSmall, "right", "center", false, false)
		if self.selectedRank > 0 and isHovered and isClicked() then 
			self.ranksFunctions.updatePerms()
		end
		for i=1,#self.rankButtons do
			local val = self.rankButtons[i]
			local newX = self.x+210+ ((i-1)*95)
			dxDrawRoundedRectangle(newX, (self.y+125)+newY, 90, 30, 8, tocolor(65, 67, 74))
			dxDrawRectangle(newX, (self.y+125)+newY+5, 2, 20, val[3])
			dxDrawText(val[1], newX+5, (self.y+125)+newY, (newX)+90, (self.y+125+newY)+30, tocolor(255, 255, 255, 200), 1, self.fonts.robotoB, "left", "center", true, false)
			local isHovered = isInBox(newX+67, (self.y+125)+newY, 20, 20, "hand")
			dxDrawText(val[2], newX+67, (self.y+125)+newY, nil, (self.y+125+newY)+30, (isHovered) and tocolor(88, 101, 242, 125) or tocolor(255, 255, 255, 200), 1, self.fonts.awesomeSmall, nil, "center", false, false)
		end
    end,
}