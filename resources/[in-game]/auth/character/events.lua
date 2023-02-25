local exports = exports
local addEvent = addEvent
local addEventHandler = addEventHandler
local tonumber = tonumber
local triggerClientEvent = triggerClientEvent
local mysql = exports.mysql

-- karakter spawn olduğundan tetiklenir.
addEvent('onCharacterSpawn', true)
--Source:
    -- spawnlanan oyuncu.
--Parametreler:
    -- table karakter bilgileri

addEvent('auth.spawn', true)
addEventHandler('auth.spawn', root, function(dbid)
    if source then
        if tonumber(dbid) then
            dbQuery(
                function(qh,player)
                    local res, rows, err = dbPoll(qh, 0)
                    local data = {}
                    if rows > 0 then
                        for index, row in ipairs(res) do
                            local x,y,z,int,dim = unpack(split(row.pos,","))
                            player:spawn(x,y,z)
                            player:setInterior(tonumber(int))
                            player:setDimension(tonumber(dim))
                            player.cameraTarget = player
                            player.gravity = 0.008
                            player.model = tonumber(row.model)
                            player.name = tostring(row.name)
                            player:setData("characterDatas",{
                                admin=tonumber(row.admin),
                                age=tonumber(row.age),
                                height=tonumber(row.height),
                                weight=tonumber(row.weight),
                                gender=tonumber(row.gender),
                            })
                            player:setData('dbid', tonumber(row.id))
                            player:setData('money', tonumber(row.money))
                            player:setData('hunger', tonumber(row.hunger))
                            player:setData('thirst', tonumber(row.thirst))
                        end
                        triggerEvent("onCharacterSpawn",player,res[1])
                    end
                end,
            {source}, mysql:getConn(), "SELECT * FROM characters WHERE id = ?", tonumber(dbid))
        end
    end
end)

addEvent('auth.characters', true)
addEventHandler('auth.characters', root, function()
    if source then
        dbQuery(
            function(qh,player)
                local res, rows, err = dbPoll(qh, 0)
                local data = {}
                if rows > 0 then
                    for index, row in ipairs(res) do
                        local i = #data + 1
                        if not data[i] then
                            data[i] = {}
                        end
                        data[i][1] = tonumber(row.id)
                        data[i][2] = row.name
                        data[i][3] = tonumber(0)
                        data[i][4] = tonumber(0)
                        data[i][5] = tonumber(0)
                        data[i][6] = tonumber(row.gender)
                        data[i][7] = tonumber(row.model)
                    end
                end
                triggerClientEvent(player,'auth.character.render',player,data)
            end,
        {source}, mysql:getConn(), "SELECT * FROM characters WHERE account = ?", source:getData('account.id'))
    end
end)

addEvent('auth.create', true)
addEventHandler('auth.create', root, function(name,age,height,weight,gender,model)
    if source then
        if name and tonumber(age) and tonumber(height) and tonumber(weight) and tonumber(gender) and tonumber(model) then
            if name == 'isim_soyad' then triggerClientEvent(source,'auth.info',source,'lütfen karakterinize bir isim belirleyin') return end
            local charname = string.gsub(tostring(name), " ", "_")
            dbQuery(
                function(qh,player)
                    local res, rows, err = dbPoll(qh, 0)
                    if rows > 0 then
                        triggerClientEvent(player,'auth.info',player,'bu karakter ismi kullanılıyor')
                    else
                        dbQuery(
                            function(qh,player)
                                local res, rows, err = dbPoll(qh, 0)
                                local count = #res
                                if count >= player:getData('account.limit') then
                                    triggerClientEvent(player,'auth.info',player,'daha fazla karakter oluşturamazsın')
                                else
                                    local successName = player:setName(charname)
                                    if (successName) then
                                        dbExec(mysql:getConn(), "INSERT INTO characters SET account='"..(player:getData('account.id')).."', name='"..(charname).."', age='"..(tonumber(age)).."', height='"..(tonumber(height)).."', weight='"..(tonumber(weight)).."', gender='"..(tonumber(gender)).."', model='"..(tonumber(model)).."'")
                                        triggerClientEvent(player,'auth.create.success',player)
                                        triggerClientEvent(player, 'auth.info', player, 'karakterinizi oluşturdunuz, '..charname)
                                    else
                                        triggerClientEvent(player, 'auth.info', player, 'lütfen başka bir karakter ismi belirleyin')
                                    end
                                end
                            end,
                        {player}, mysql:getConn(), "SELECT id FROM characters WHERE account = ?", player:getData('account.id'))
                    end
                end,
            {source}, mysql:getConn(), "SELECT id FROM characters WHERE name = ?", charname)
        else
            triggerClientEvent(source,'auth.info',source,'lütfen boşlukları düzgün bir şekilde doldurun')
        end
    end
end)
