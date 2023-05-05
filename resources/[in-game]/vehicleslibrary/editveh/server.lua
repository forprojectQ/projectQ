local mysql = exports.mysql
local conn = mysql:getConn()

local handling_test = {}

addEvent("editveh.openwindow", true)
addEvent("editveh.saveCustoms", true)
addEvent("editveh.resetCustoms", true)

addEventHandler("editveh.openwindow", root, function()
    local vehicle = source.vehicle
	if not isElement(vehicle) then
		source:outputChat("[!]#ffffff Lütfen bir araca bin.",255,0,0,true)
		return
	end
	local dbid = vehicle:getData("dbid")
	if not dbid then return end
	local info = vehicle:getData("info")
	info.id = dbid
	info.mtamodel = vehicle:getModel()
	info.price = vehicle:getData("carshop_price")
	info.tax = vehicle:getData("carshop_tax")
	triggerClientEvent(source,"editveh.openwindow",source,info)
end)

addEventHandler("editveh.saveCustoms",root,function(dbid,info)
	if exports.vehicles:isVehicleHasCustomRecord(dbid) then
		dbExec(conn,"UPDATE vehicles_custom SET brand=?,model=?,year=?,tax=?,notes=?,price=? WHERE id=?",info.brand,info.model,info.year,info.tax,info.notes,info.price,dbid)
	else
		dbExec(conn,"INSERT vehicles_custom SET brand=?,model=?,year=?,tax=?,notes=?,price=?,id=?",info.brand,info.model,info.year,info.tax,info.notes,info.price,dbid)
	end	
	exports.vehicles:reloadVehicle(dbid)
end)
addEventHandler("editveh.resetCustoms",root,function(dbid)
	dbExec(conn,"DELETE from vehicles_custom WHERE id=?",dbid)
	exports.vehicles:reloadVehicle(dbid)
end)