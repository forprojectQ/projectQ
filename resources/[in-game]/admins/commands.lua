local conn = exports.mysql:getConn()
local cache = exports.cache

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
        command = "editveh",
        access = 5,
        func = function(player)
            triggerEvent("editveh.openwindow",player)
        end,
    },
    {
        command = "makeveh",
        access = 5,
        func = function(player, args)
            if tonumber(args[1]) and tonumber(args[2]) and tonumber(args[3]) then --// Kütüphane ID , Sahip, Meslek
                if exports.vehicles:makeVehicle(args[1], args[2], args[3]) then
                    player:outputChat("[!]#ffffff Araç oluşturuldu.", 235, 180, 132, true)
                else
                    player:outputChat("[!]#ffffff Bir hata meydana geldi, girdiğiniz argümanları doğrulayın.", 235, 180, 132, true)
                end
            else
                player:outputChat("[!]#ffffff /makeveh [Kütüphane ID] [Sahip ID] [Meslek (0 = Şahıs Aracı)]", 235, 180, 132, true)
            end
        end,
    },
    {
        command = "delveh",
        access = 5,
        func = function(player, args)
            if tonumber(args[1]) then --// ARAÇ ID
                if exports.vehicles:deleteVehicle(args[1]) then
                    player:outputChat("[!]#ffffff #"..ags[1]..", silindi.", 235, 180, 132, true)
                else
                    player:outputChat("[!]#ffffff Geçersiz araç ID, daha sonra tekrar deneyiniz.", 235, 180, 132, true)
                end
            else
                player:outputChat("[!]#ffffff /delveh [ID]", 235, 180, 132, true)
            end
        end,
    },
    {
        command = "reloadveh",
        access = 7,
        func = function(player, args)

        end,
    },
    {
        command = "sethp",
        access = 2,
        func = function(player, args)
            if args[1] and tonumber(args[2]) then --// Target, hp value
                local targetPlayer, targetPlayerName = exports.global:findPlayer(args[1])
                if targetPlayer then
                    if tonumber(args[2]) > 100 then
                        args[2] = 100
                    end
                    player:outputChat("[!]#ffffff "..targetPlayer.name.." isimli oyuncunun canını: %"..args[2].." olarak değiştirdiniz.", 235, 180, 132, true)
                    targetPlayer:outputChat("[!]#ffffff "..player.name.." isimli yetkili canınızı: %"..args[2].." olarak değiştirdi.", 235, 180, 132, true)
                    targetPlayer.health = args[2]
                else
                    player:outputChat("[!]#ffffff Oyuncu bulunamadı veya giriş yapmamış.", 235, 180, 132, true)
                end
            else
                player:outputChat("[!]#ffffff /sethp [ID] [Değer]", 235, 180, 132, true)
            end
        end,
    },
    {
        command = "setarmor",
        access = 2,
        func = function(player, args)
            if args[1] and tonumber(args[2]) then --// Target, arm value
                local targetPlayer, targetPlayerName = exports.global:findPlayer(args[1])
                if targetPlayer then
                    if tonumber(args[2]) > 100 then
                        args[2] = 100
                    end
                    player:outputChat("[!]#ffffff "..targetPlayer.name.." isimli oyuncunun zırhını: %"..args[2].." olarak değiştirdiniz.", 235, 180, 132, true)
                    targetPlayer:outputChat("[!]#ffffff "..player.name.." isimli yetkili zırhınızı: %"..args[2].." olarak değiştirdi.", 235, 180, 132, true)
                    targetPlayer.armor = args[2]
                else
                    player:outputChat("[!]#ffffff Oyuncu bulunamadı veya giriş yapmamış.", 235, 180, 132, true)
                end
            else
                player:outputChat("[!]#ffffff /setarmor [ID] [Değer]", 235, 180, 132, true)
            end
        end,
    },
    {
        command = "revive",
        access = 4,
        func = function(player, args)
            if args[1] then
                local targetPlayer, targetPlayerName = exports.global:findPlayer(args[1])
                if targetPlayer then
                    if exports.essantials:respawnPlayer(targetPlayer) then
                        player:outputChat("[!]#ffffff "..targetPlayer.name.." isimli oyuncuyu kaldırdınız.", 235, 180, 132, true)
                        targetPlayer:outputChat("[!]#ffffff "..player.name.." isimli yetkili sizi kaldırdı.", 235, 180, 132, true)
                    else
                        player:outputChat("[!]#ffffff "..targetPlayer.name.." baygın değil.", 235, 180, 132, true)
                    end
                else
                    player:outputChat("[!]#ffffff Oyuncu bulunamadı veya giriş yapmamış.", 235, 180, 132, true)
                end
            else
                player:outputChat("[!]#ffffff /revive [ID]", 235, 180, 132, true)
            end
        end,
    },
    {
        command = "setvehcolor",
        access = 4,
        func = function(player, args)
            if tonumber(args[1]) and tonumber(args[2]) and tonumber(args[3]) and tonumber(args[4]) then --// vehicle, r, g, b
                local vehicle = exports.global:findVehicle(args[1])
                if vehicle then
                    local dbid = vehicle:getData("dbid")
                    local r, g, b = args[2], args[3], args[4]
                    local color = ""..(r)..","..(g)..","..(b)..""
                    vehicle:setColor(r, g, b)
                    cache:setVehicleData(dbid, "color", color)
                else
                    player:outputChat("[!]#ffffff Araç bulunamadı, lütfen ID kontrol edin.", 235, 180, 132, true)
                end
            else
                player:outputChat("[!]#ffffff /setvehcolor [Araç ID] [R, G, B]", 235, 180, 132, true)
            end
        end,
    },
    {
        command = "setvehplate",
        access = 4,
        func = function(player, args)
            if tonumber(args[1]) and args[2] then --// vehicle, plate
                local vehicle = exports.global:findVehicle(args[1])
                if vehicle then
                    local dbid = vehicle:getData("dbid")
                    local newPlate = args[2]
                    vehicle:setPlateText(newPlate)
                    cache:setVehicleData(dbid, "plate", newPlate)
                else
                    player:outputChat("[!]#ffffff Araç bulunamadı, lütfen ID kontrol edin.", 235, 180, 132, true)
                end
            else
                player:outputChat("[!]#ffffff /setvehplate [Araç ID] [Plaka]", 235, 180, 132, true)
            end
        end,
    },
    {
        command = "getcar",
        access = 1,
        func = function(player, args)
            if tonumber(args[1]) then --// vehicle
                local vehicle = exports.global:findVehicle(args[1])
                if vehicle then
                    local dbid = vehicle:getData("dbid")
                    local x, y, z = player.position.x, player.position.y, player.position.z
                    local int, dim = player.interior, player.dimension
                    local rx, ry, rz = player.rotation.x, player.rotation.y, player.rotation.z
                    x = x + (( math.cos(math.rad(rz))) * 5)
			        y = y + (( math.sin(math.rad(rz))) * 5)
                    local position = x..","..y..","..z..","..int..","..dim..","..rx..","..ry..","..rz..""
                    vehicle:setPosition(x, y, z)
                    vehicle:setInterior(int)
                    vehicle:setDimension(dim)
                    vehicle:setRotation(rx, ry, rz)
                    cache:setVehicleData(dbid, "pos", position)
                else
                    player:outputChat("[!]#ffffff Araç bulunamadı, lütfen ID kontrol edin.", 235, 180, 132, true)
                end
            else
                player:outputChat("[!]#ffffff /getcar [Araç ID]", 235, 180, 132, true)
            end
        end,
    },
    {
        command = "fixveh",
        access = 1,
        func = function(player, args)
            if tonumber(args[1]) then --// vehicle
                local vehicle = exports.global:findVehicle(args[1])
                if vehicle then
                    vehicle:fix()
                    player:outputChat("[!]#ffffff Araç tamir edildi.", 235, 180, 132, true)
                else
                    player:outputChat("[!]#ffffff Araç bulunamadı, lütfen ID kontrol edin.", 235, 180, 132, true)
                end
            else
                player:outputChat("[!]#ffffff /fixveh [Araç ID]", 235, 180, 132, true)
            end
        end,
    },
    {
        command = "fuelveh",
        access = 1,
        func = function(player, args)
            if tonumber(args[1]) and tonumber(args[2]) then --// vehicle, new fuel
                local vehicle = exports.global:findVehicle(args[1])
                if vehicle then
                    local dbid = vehicle:getData("dbid")
                    if tonumber(args[2]) <= 0 then
                        args[2] = 0
                    elseif tonumber(args[2]) >= 100 then
                        args[2] = 100
                    end
                    vehicle:setData("fuel", args[2])
                    cache:setVehicleData(dbid, "fuel", args[2])
                    player:outputChat("[!]#ffffff Aracın benzinini %"..args[2].." olarak ayarladınız.", 235, 180, 132, true)
                else
                    player:outputChat("[!]#ffffff Araç bulunamadı, lütfen ID kontrol edin.", 235, 180, 132, true)
                end
            else
                player:outputChat("[!]#ffffff /fixveh [Araç ID] [%Benzin]", 235, 180, 132, true)
            end
        end,
    },
}