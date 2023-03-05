local conn = exports.mysql:getConn()

addCommandHandler("vehlib", function(player)
    if player:getData("online") then
        dbQuery(
            function(qh, thePlayer)
                local res, rows, _ = dbPoll(qh, 0)
                triggerClientEvent(thePlayer, "vehicle.library", thePlayer, res)
            end,
        {player}, conn, "SELECT * FROM vehicles_library")
    end
end)

addEvent("vehicle.library.edit", true)
addEventHandler("vehicle.library.edit", root, function(id, brand, model, year, price, tax, gta, isEnabled)
    local query = dbExec(conn, "UPDATE vehicles_library SET brand='"..(brand).."', model='"..(model).."', year='"..(year).."', price='"..(price).."', tax='"..(tax).."', gta='"..(gta).."', enabled='"..(isEnabled).."' WHERE id=?", id)
    if query then
        source:outputChat("[!]#ffffff Araç veri tabanına başarılı bir şekilde kaydedildi.", 111, 72, 201, true)
    else
        source:outputChat("[!]#ffffff Araç veri tabanına kayedilirken bir sorun oluştu.", 111, 72, 201, true)
    end
end)

addEvent("vehicle.library.create", true)
addEventHandler("vehicle.library.create", root, function(brand, model, year, price, tax, gta, isEnabled)
    local query = dbExec(conn, "INSERT INTO vehicles_library SET brand='"..(brand).."', model='"..(model).."', year='"..(year).."', price='"..(price).."', tax='"..(tax).."', gta='"..(gta).."', enabled='"..isEnabled.."'")
    if query then
        source:outputChat("[!]#ffffff Araç veri tabanına başarılı bir şekilde kaydedildi.", 111, 72, 201, true)
    else
        source:outputChat("[!]#ffffff Araç veri tabanına kayedilirken bir sorun oluştu.", 111, 72, 201, true)
    end
end)