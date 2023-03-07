komutlar = {
    {
        komut="ornekhesapkomut",
        -- bu komudu kullanabilcek hesap isimleri
        hesap="mahlukat,bekiroj",
        fnc = function(oyuncu,arg)
            iprint(oyuncu)
        end,
    },
    {
        komut="ornekserialkomut",
        -- bu komudu kullanabilcek serial adresleri
        serial="31E905B109F9F8F359BB2DE44BA66742,62E905B109F9F8F359BB2DE44BA66762",
        fnc = function(oyuncu,arg)
            iprint(oyuncu)
        end,
    },
    {
        komut="setstyle",
        -- admin leveli 5 ve 5'den büyük kişiler kullanabilir.
        yetki=5,
        fnc = function(oyuncu,arg)
            if setPedFightingStyle(oyuncu, tonumber(arg[1]) )  then
                outputChatBox("Dövüş stilin değiştirildi.",oyuncu,0,255,0)
            else    
                outputChatBox("Dövüş stilin değiştirilemedi.",oyuncu,255,0,0)
            end
        end,    
    },
    {
        komut="gotopos,setxyz",
         -- admin leveli 8 ve 8'den büyük kişiler kullanabilir.
        yetki=8,
        fnc = function(oyuncu,arg)
            if tonumber(arg[1]) and tonumber(arg[2]) and tonumber(arg[3]) then
                local elm = getPedOcuupiedVehicle(oyuncu) or oyuncu
                elm:setPosition(arg[1], arg[2], arg[3])
            end
        end,    
    },
    {
        komut="getpos",
        yetki=1,
        fnc = function(oyuncu,arg)
            local x, y, z = oyuncu.position.x, oyuncu.position.y, oyuncu.position.z
            local int, dim = oyuncu.interior, oyuncu.dimension
            local rx, ry, rz = oyuncu.rotation.x, oyuncu.rotation.y, oyuncu.rotation.z
            
            outputChatBox("Pozisyon: " .. x .. ", " .. y .. ", " .. z, oyuncu, 255, 194, 14)
            outputChatBox("Rotasyon: " .. rx .. ", " .. ry .. ", " .. rz, oyuncu, 255, 194, 14)
            outputChatBox("Dimension: " .. dim, oyuncu, 255, 194, 14)
            outputChatBox("Interior: " .. int, oyuncu, 255, 194, 14)
        end,    
    },
}