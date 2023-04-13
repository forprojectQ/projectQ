local conn = exports.mysql:getConn()

commands = {
    {
        command = "ornekhesapkomut",
        --// bu komutu kullanabilecek hesap isimleri
        account = "mahlukat,bekiroj",
        func = function(player, args)
            iprint(player)
        end,
    },
    {
        command = "ornekserialkomut",
        -- bu komutu kullanabilecek serial adresleri
        serial = "31E905B109F9F8F359BB2DE44BA66742,B5D767EFFB542805FE49564D79C68A54",
        func = function(player, args)
            iprint(player)
        end,
    },
    {
        command = "setstyle",
        -- admin leveli 5 ve 5'den büyük kişiler kullanabilir.
        access = 5,
        func = function(player, args)
            if setPedFightingStyle(player, tonumber(args[1]))  then
                player:outputChat("Dövüş stilin değiştirildi", 0, 255, 0)
            else
                player:outputChat("Dövüş stilin değiştirilemedi", 255, 0, 0)
            end
        end,
    },
    {
        command = "gotopos,setxyz",
        -- admin leveli 8 ve 8'den büyük kişiler kullanabilir.
        access = 8,
        func = function(player, args)
            if tonumber(args[1]) and tonumber(args[2]) and tonumber(args[3]) then
                local element = getPedOcuupiedVehicle(player) or player
                element:setPosition(args[1], args[2], args[3])
            end
        end,
    },
    {
        command = "getpos",
        access = 1,
        func = function(player, args)
            local x, y, z = player.position.x, player.position.y, player.position.z
            local int, dim = player.interior, player.dimension
            local rx, ry, rz = player.rotation.x, player.rotation.y, player.rotation.z

            player:outputChat("Pozisyon: " .. x .. ", " .. y .. ", " .. z, 255, 194, 14)
            player:outputChat("Rotasyon: " .. rx .. ", " .. ry .. ", " .. rz, 255, 194, 14)
            player:outputChat("Dimension, Interior: " .. dim .. ", " .. int .. ", " .. rz, 255, 194, 14)
        end,
    },
    {
        command = "vehlib",
        -- araç kütüphanesi
        access = 5,
        func = function(player)
            dbQuery(
                function(qh, thePlayer)
                    local results = dbPoll(qh, -1)
                    if results then
                        triggerClientEvent(thePlayer, "vehicle.library", thePlayer, results)
                    end
                end,
            {player}, conn, "SELECT * FROM vehicles_library")
        end,
    },
    {
        command = "makeveh",
        access = 5,
        func = function(player, args)
            exports.vehicles:makeVehicle(player, args[1], args[2], args[3])
        end,
    },
}