local screen = Vector2(guiGetScreenSize())

local local_info = {}

function editVehWindowOpen(info)
    local_info = info
    if isElement(editVehWindow) then editVehWindow:destroy() end
	
	local pg,pu = 425,400
	local x,y = (screen.x-pg)/2,(screen.y-pu)/2
	
    editVehWindow = GuiWindow(x,y, pg,pu , "Araç Özellikleri - #"..(info.id), false)
    editVehWindow:setSizable(false)

	modelLbl = GuiLabel(10,25,200,20,"MTA Araç Modeli:",false,editVehWindow):setFont("default-bold-small")
	modelEdit = GuiEdit(10,25+20,200,30,info.mtamodel,false,editVehWindow) modelEdit:setProperty("ValidationString", "[0-9]*")
	modelEdit:setEnabled(false)
	
	markaLbl = GuiLabel(10,25+(55),200,20,"Marka:",false,editVehWindow):setFont("default-bold-small")
	markaEdit = GuiEdit(10,25+(75),200,30,info.brand,false,editVehWindow)
	
	modelLbl = GuiLabel(10,25+(55*2),200,20,"Model:",false,editVehWindow):setFont("default-bold-small")
	modelEdit = GuiEdit(10,25+(65*2),200,30,info.model,false,editVehWindow)
	
	yilLbl = GuiLabel(220,25,200,20,"Yıl:",false,editVehWindow):setFont("default-bold-small")
	yilEdit = GuiEdit(220,25+20,200,30,info.year,false,editVehWindow) yilEdit:setProperty("ValidationString", "[0-9]*")
	
	ucretLbl = GuiLabel(220,25+(55),200,20,"Ücret:",false,editVehWindow):setFont("default-bold-small")
	ucretEdit = GuiEdit(220,25+(75),200,30,info.price,false,editVehWindow) ucretEdit:setProperty("ValidationString", "[0-9]*")
	
	vergiLbl = GuiLabel(220,25+(55*2),200,20,"Vergi:",false,editVehWindow):setFont("default-bold-small")
	vergiEdit = GuiEdit(220,25+(65*2),200,30,info.tax,false,editVehWindow) vergiEdit:setProperty("ValidationString", "[0-9]*")
	
	notlarLbl = GuiLabel(10,pu-180,pg-20,20,"Notlar:",false,editVehWindow):setFont("default-bold-small")
	notlarMemo = GuiMemo(10,pu-160,pg-20,120,info.notes or "",false,editVehWindow)
	

    editVehSave = GuiButton(pg-100,  pu-35, 100, 30, "Kaydet", false, editVehWindow)
    editVehClose = GuiButton(10, pu-35, 100, 30, "İptal", false, editVehWindow)
    editVehReset = GuiButton(10+105, pu-35, 100, 30, "Sıfırla", false, editVehWindow)
    editVehHandling = GuiButton(10+210, pu-35, 100, 30, "Özel Hand", false, editVehWindow)
end

function editVehWindowClose()
	if isElement(editVehWindow) then editVehWindow:destroy() end
end


-- NULL olan yerleri değiştirme.
function checkText(s)
	return s:gsub(" ","") == "" and "NULL" or s
end

addEventHandler("onClientGUIClick", resourceRoot, function()
    if source == editVehClose then
        editVehWindowClose()
    elseif source == editVehSave then
		local info = {
			brand = checkText(markaEdit:getText()),
			model = checkText(modelEdit:getText()),
			year = tonumber(yilEdit:getText()) or "NULL",
			price = tonumber(ucretEdit:getText()) or "NULL",
			tax = tonumber(vergiEdit:getText()) or "NULL",
			notes = checkText(notlarMemo:getText()),
		}
		triggerServerEvent("editveh.saveCustoms",resourceRoot,local_info.id,info)
		editVehWindowClose()
	elseif source == editVehReset then	
		triggerServerEvent("editveh.resetCustoms",resourceRoot,local_info.id)
		editVehWindowClose()
	elseif 	source == editVehHandling then
		editVehWindowClose()
		triggerServerEvent("vehicle.library.handling",localPlayer,local_info.library_id,local_info.id)
    end
end)


addEvent("editveh.openwindow", true)
addEventHandler("editveh.openwindow", root, editVehWindowOpen)