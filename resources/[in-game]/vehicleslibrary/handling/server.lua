local mysql = exports.mysql
local conn = mysql:getConn()

addEvent("vehicle.library.handling", true)
addEventHandler("vehicle.library.handling", root, function(id)
    dbQuery(
        function(qh, player)
            local res, rows, _ = dbPoll(qh, 0)
            if rows > 0 then
                local x, y, z = player.position.x, player.position.y, player.position.z
                local int, dim = player.interior, player.dimension
                player:setData("vehicle.library.test", true)
                player:setData("position.old", {x, y, z, int, dim})
                local newDim = math.random(1,100)
                for _, row in ipairs(res) do
                    local testVeh = Vehicle(row.gta, 1428.71484375, -2593.26953125, 13.273954391479)
                    testVeh:setDimension(newDim)
                    player.vehicle = testVeh
                end
                triggerClientEvent(player, "vehicle.library.edt.handling", player, id)
            else
                player:outputChat("[!]#ffffff Araç veri tabanına bulunamadı, lütfen daha sonra tekrar deneyin.", 111, 72, 201, true)
            end
        end,
    {source}, conn, "SELECT gta FROM vehicles_library WHERE id=?", id)
end)

addEvent("vehicle.library.handling.stop", true)
addEventHandler("vehicle.library.handling.stop", root, function(veh)
    local pos = source:getData("position.old")
    if veh then
        veh:destroy()
        source.vehicle = nil
        source:setPosition(pos[1], pos[2], pos[3])
        source:setInterior(pos[4])
        source:setDimension(pos[5])
        source:removeData("position.old")
        source:removeData("vehicle.library.test")
    end
end)

addEvent("vehicle.library.set.handling", true)
addEventHandler("vehicle.library.set.handling", root, function(option, value)
    local veh = source.vehicle
    if veh then
        setVehicleHandling(veh, tostring(option), tonumber(value))
        triggerClientEvent(source, "vehicle.library.refresh.handling", source, tostring(option))
    else
        source:outputChat("[!]#ffffff Değişiklikleri uygulamak için test aracında olmalısınız.", 111, 72, 201, true)
    end
end)

addEvent("vehicle.library.save", true)
addEventHandler("vehicle.library.save", root, function(id)
    --// SOON.
end)