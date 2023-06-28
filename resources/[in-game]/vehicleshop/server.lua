local connection = exports.mysql:getConn()

function getVehicleData (thePlayer)
    if thePlayer then 
        source = thePlayer 
    end
    dbQuery(
        function(qh, thePlayer)
            local res, rows, err = dbPoll(qh, 0)
            local vehicles = {}
            if rows > 0 then	
                for index, row in ipairs(res) do
                    table.insert(vehicles, {vehlibID = row.id, gtaID = row.gta, brand = row.brand, model = row.model, year = row.year, price = row.price, tax = row.tax, enabled = row.enabled, stock = row.stock, fueltype = row.fueltype})
                end      
            end
            triggerClientEvent(thePlayer, "vehicle.data", thePlayer, vehicles)
        end,
        {source}, connection, "SELECT * FROM vehicles_library")
    end
addEvent("vehicle.get.data", true)
addEventHandler("vehicle.get.data", root, getVehicleData)

function closeVehicleShop()
    source.dimension = 0
    source.cameraTarget = source
    source:setFrozen(false)
    source:setPosition(555.318359375, -1291.763671875, 17.248237609863)
    toggleAllControls(source, true)
end
addEvent("close.vehicle.shop", true)
addEventHandler("close.vehicle.shop", root, closeVehicleShop)

function buyVehicle(gtaID, price, selectedModel, model, vehlibID, tax)
    if source and tonumber(gtaID) then
        if exports.global:takeMoney(source, price) then
            local dbid = source:getData('dbid')
            local x, y, z = 528.4072265625, -1288.0625, 17.2421875
            local rotZ = 16.059509277344
            local position = x..","..y..","..z..",0,0,0,0,"..rotZ
            local plate = exports.global:createRandomPlateText()
            local color = toJSON( {255,255,255} )
            local smallestID = smallestID()
            local veh = Vehicle(gtaID, x,y,z)
            dbExec(connection, "INSERT INTO vehicles SET id='"..(smallestID).."', library_id='" .. (vehlibID) .. "', fuel='100', odometer='0', tax='".. (tax) .."', job='0', pos='".. (position) .."', plate='".. (plate) .."', color='".. (color) .."', upgrades='false', lock='1', interest='0', owner='".. (owner) .."', faction='0', engine='0', enabled='0'")
            call(getResourceFromName("items"), "deleteAll", 3, smallestID)
            exports.items:giveItem(source, 3, smallestID)
            exports.vehicle:reloadVehicle(smallestID)
            source:outputChat('>#D0D0D0 Başarıyla '..selectedModel..' markalı aracı satın aldın!', 0, 255, 0, true)
        else
            source:outputChat('>#D0D0D0 Bu aracı satın almak için paranız yeterli değil. Gerekli miktar: '..exports.global:formatMoney(price)..'$', 255, 0, 0, true)
        end
	end
end
addEvent("vehicle.buy", true)
addEventHandler("vehicle.buy", root, buyVehicle)

function smallestID()
    local query = dbQuery(connection, "SELECT MIN(e1.id+1) AS nextID FROM vehicles AS e1 LEFT JOIN vehicles AS e2 ON e1.id +1 = e2.id WHERE e2.id IS NULL")
	local result = dbPoll(query, -1)
	if result then
		local id = tonumber(result[1]["nextID"]) or 1
		return id
	end
	return false
end