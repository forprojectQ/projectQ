setGameType('Roleplay')
local exports = exports
local triggerClientEvent = triggerClientEvent
local addEvent = addEvent
local addEventHandler = addEventHandler
local ipairs = ipairs
local mysql = exports.mysql
local objects = {}
local timers = {}
local login = function(player,username)
    if player then
        if username then
            dbQuery(
                function(qh,logined)
                    local res, rows, err = dbPoll(qh, 0)
                    if rows > 0 then
                        for index, row in ipairs(res) do
                            logined:setData('online', true)
                            logined:setData('admin', tonumber(row.admin))
                            logined:setData('helper', tonumber(row.helper))
                            logined:setData('account.id', tonumber(row.id))
                            logined:setData('account.name', row.name)
                            logined:setData('account.limit', tonumber(row.limit))
                        end
                    end
                    triggerClientEvent(logined,'auth.logined',logined)
                end,
            {player}, mysql:getConn(), "SELECT * FROM accounts WHERE name = ?", username)
        end
    end
end

addEventHandler('onPlayerChangeNick', root, function(oldNick,newNick)
    if not source:getData('name.change') then 
        cancelEvent()
        source.name = tostring(oldNick)
    end
end)

addEventHandler('onPlayerCommand', root, function(command)
    if not source:getData('online') then cancelEvent() end
end)

addEvent('auth.ped', true)
addEventHandler('auth.ped', root, function(x,y,z,dim)
    if source then
        objects[source] = Object(2114,x-0.1,y+0.3,z-0.8)
        objects[source]:setData('state', true)
        objects[source]:setDimension(tonumber(dim))
        objects[source]:setInterior(0)
        timers[source] = Timer(function(obj)
            if obj then
                if obj:getData('state') then
                    obj:setData('state', false)
                    obj:move(135, obj.position.x,obj.position.y,obj.position.z+0.8)
                else
                    obj:setData('state', true)
                    obj:move(135, obj.position.x,obj.position.y,obj.position.z-0.8)
                end
            end
        end, 225, 0, objects[source])
    end
end)

addEvent('auth.ped.stop', true)
addEventHandler('auth.ped.stop', root, function()
    if source then
        timers[source]:destroy()
        objects[source]:destroy()
    end
end)

addEvent('auth.login', true)
addEventHandler('auth.login', root, function(username,password)
    if source then
        if username and password then
            if username == 'kullanıcı adı' then triggerClientEvent(source,'auth.info',source,'lütfen geçerli bir kullanıcı adı belirleyin.') return end
            if password == 'şifre' then triggerClientEvent(source,'auth.info',source,'lütfen geçerli bir şifre belirleyin.') return end
            dbQuery(
                function(qh,player)
                    local res, rows, err = dbPoll(qh, 0)
                    if rows > 0 then
                        for index, row in ipairs(res) do
                            if row.password == password then
                                login(player,row.name)
                            else
                                triggerClientEvent(player,'auth.info',player,''..username..' hesabının şifresi yanlış, lütfen şifrenizi kontrol edin.')
                            end
                        end
                    else
                        triggerClientEvent(player,'auth.info',player,'böyle bir hesap bulunamadı, ('..username..')')
                    end
                end,
            {source}, mysql:getConn(), "SELECT password,name FROM accounts WHERE name = ?", username)
        else
            triggerClientEvent(source,'auth.info',source,'bir sorun oluştu, lütfen tekrar deneyiniz! (001)')
        end
    end
end)

addEvent('auth.register', true)
addEventHandler('auth.register', root, function(username,password,email)
    if source then
        if username and password and email then
            if username == 'kullanıcı adı' then triggerClientEvent(source,'auth.info',source,'lütfen geçerli bir kullanıcı adı belirleyin.') return end
            if password == 'şifre' then triggerClientEvent(source,'auth.info',source,'lütfen geçerli bir şifre belirleyin.') return end
            if email == 'youremail@icloud.com' then triggerClientEvent(source,'auth.info',source,'lütfen geçerli bir e posta belirleyin.') return end
            dbQuery(
                function(qh,player)
                    local res, rows, err = dbPoll(qh, 0)
                    if rows > 0 then
                        for index, row in ipairs(res) do
                            triggerClientEvent(player,'auth.info',player,'zaten bir hesabınız var, ('..row['name']..')')
                        end
                    else
                        dbQuery(
                            function(qh,player)
                                local res, rows, err = dbPoll(qh, 0)
                                if rows > 0 then
                                    for index, row in ipairs(res) do
                                        triggerClientEvent(player,'auth.info',player,'bu hesap ismi kullanılıyor, ('..row['name']..')')
                                    end
                                else
                                    dbExec(mysql:getConn(), "INSERT INTO accounts SET name='"..(username).."', password='"..(password).."', serial='"..(player.serial).."'")
                                    triggerClientEvent(player,'auth.info',player,'başarıyla kayıt oldunuz, ('..username..')')
                                end
                            end,
                        {player}, mysql:getConn(), "SELECT name FROM accounts WHERE name = ?", username)
                    end
                end,
            {source}, mysql:getConn(), "SELECT name FROM accounts WHERE serial = ?", source.serial)
        else
            triggerClientEvent(source,'auth.info',source,'bir sorun oluştu, lütfen tekrar deneyiniz! (002)')
        end
    end
end)

addEvent('auth.remember', true)
addEventHandler('auth.remember', root, function()
    if source then
        dbQuery(
            function(qh,player)
                local res, rows, err = dbPoll(qh, 0)
                if rows > 0 then
                    for index, row in ipairs(res) do
                        triggerClientEvent(player,'auth.remember.client',player,row.name,row.password)
                    end
                end
            end,
        {source}, mysql:getConn(), "SELECT * FROM accounts WHERE serial = ?", source.serial)
    end
end)