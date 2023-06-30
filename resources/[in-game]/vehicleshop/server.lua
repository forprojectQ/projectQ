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

function buyVehicle(price, selectedModel, vehlibID)
    if source then
        if exports.global:takeMoney(source, price) then
            local owner = source:getData("dbid")
            exports.vehicles:makeVehicle(vehlibID, owner, 0)
            source:outputChat(">#D0D0D0 Başarıyla "..selectedModel.." markalı aracı satın aldın!", 0, 255, 0, true)
        else
            source:outputChat(">#D0D0D0 Bu aracı satın almak için paranız yeterli değil. Gerekli miktar: "..exports.global:formatMoney(price).."$", 255, 0, 0, true)
        end
	end
end
addEvent("vehicle.buy", true)
addEventHandler("vehicle.buy", root, buyVehicle)
