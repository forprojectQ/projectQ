local mysql = exports.mysql
local conn = mysql:getConn()

local handling_test = {}

addEvent("vehicle.library.handling", true)
addEventHandler("vehicle.library.handling", root, function(id)
    dbQuery(
        function(qh, player)
            local res, rows, _ = dbPoll(qh, 0)
            if rows > 0 then
                local x, y, z = player.position.x, player.position.y, player.position.z
                local int, dim = player.interior, player.dimension
                local newDim = math.random(1,100)
                local row = res[1]
                local testVeh = Vehicle(row.gta, 1428.71484375, -2593.26953125, 13.273954391479)
                for property,value in pairs(fromJSON(row.handling or "[ [ ] ]")) do
                    setVehicleHandling(testVeh,property,value)
                end

                testVeh:setDimension(newDim)
                player:setDimension(newDim)
                player:setData("vehicle.library.test", true)
                player.vehicle = testVeh
                handling_test[player] = {}
                handling_test[player].pos = {x, y, z, int, dim}
                handling_test[player].veh = testVeh
                handling_test[player].vehlib_id = row.id

                triggerClientEvent(player, "vehicle.library.edt.handling", player, id)
            else
                player:outputChat("[!]#ffffff Araç veri tabanına bulunamadı, lütfen daha sonra tekrar deneyin.", 111, 72, 201, true)
            end
        end,
    {source}, conn, "SELECT gta,id,handling FROM vehicles_library WHERE id=?", id)
end)

addEvent("vehicle.library.handling.stop", true)
addEventHandler("vehicle.library.handling.stop", root, function()
    local info = handling_test[source]
    if info then
        if isElement(info.veh) then info.veh:destroy() end
        source.vehicle=nil
        source:setPosition(info.pos[1], info.pos[2], info.pos[3])
        source:setInterior(info.pos[4])
        source:setDimension(info.pos[5])
        source:removeData("vehicle.library.test")
        handling_test[source] = nil
    end
end)
addEvent("vehicle.library.set.handling", true)
addEventHandler("vehicle.library.set.handling", root, function(option, value)
    local info = handling_test[source]
    if isElement(info.veh) then
        setVehicleHandling(info.veh, tostring(option), tonumber(value))
        triggerClientEvent(source, "vehicle.library.refresh.handling", source, tostring(option))
    else
        source:outputChat("[!]#ffffff Değişiklikleri uygulamak için test aracında olmalısınız.", 111, 72, 201, true)
    end
end)

addEvent("vehicle.library.save", true)
addEventHandler("vehicle.library.save", root, function(id)
    local info = handling_test[source]
    if isElement(info.veh) then
        local hand = getVehicleHandling(info.veh)
        local query = dbExec(conn, "UPDATE vehicles_library SET handling=? WHERE id=?",toJSON(hand), info.vehlib_id)
        if query then
            source:outputChat("[!]#ffffff Aracın handı veri tabanına başarılı bir şekilde kaydedildi.", 111, 72, 201, true)
        else
            source:outputChat("[!]#ffffff Aracın handı veri tabanına kayedilirken bir sorun oluştu.", 111, 72, 201, true)
        end  
    end
end)