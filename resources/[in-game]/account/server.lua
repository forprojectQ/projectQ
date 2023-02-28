



--// WAITING FIX








local tonumber = tonumber
local exports = exports
local addEvent = addEvent
local ipairs = ipairs
local pairs = pairs
local addEventHandler = addEventHandler
local triggerClientEvent = triggerClientEvent
local conn = exports.mysql:getConn()
local cache = exports.cache

addEventHandler('onPlayerChangeNick', root, function(oldNick,newNick)
    if not source:getData('name.access') then
        cancelEvent()
        source.name = tostring(oldNick)
    end
end)

addEventHandler('onPlayerCommand', root, function(command)
    if not source:getData('online') then
        cancelEvent()
    end
end)

function spawn(dbid)
    local dbid = tonumber(dbid)
    source:setData("dbid", dbid)
    local x, y, z, int, dim = unpack(split(cache:getCharacterData(dbid, "pos"), ","))
    local characterModel = cache:getCharacterData(dbid, "model")
    local characterName = cache:getCharacterData(dbid, "name")
    source:spawn(x,y,z)
    source:setInterior(tonumber(int))
    source:setDimension(tonumber(dim))
    source.cameraTarget = source
    source.gravity = 0.008
    source.model = tonumber(characterModel)
    source.name = tostring(characterName)
end
addEvent("auth.spawn.character", true)
addEventHandler("auth.spawn.character", root, spawn)

function createCharacter(name, height, weight, age, gender)
    local model
    local walk
    if tonumber(gender) == 1 then
        model = 59
        walk = 128
    else
        model = 93
        walk = 131
    end
    dbExec(conn, "INSERT INTO characters SET account='"..(source:getData('account.id')).."', name='"..(name).."', age='"..(tonumber(age)).."', height='"..(tonumber(height)).."', weight='"..(tonumber(weight)).."', gender='"..(tonumber(gender)).."', model='"..(tonumber(model)).."', walk='"..(tonumber(walk)).."'")
    dbQuery(
        function(qh)
            local res, rows, err = dbPoll(qh, 0)
            if rows > 0 then
                for index, row in ipairs(res) do
                    local dbid = tonumber(row.id)
                    for column, value in pairs(row) do
                        cache:setCharacterData(dbid, column, value)
                    end
                end
            end
        end,
    conn, "SELECT * FROM characters WHERE name = ?", name)
end
addEvent("auth.create.character", true)
addEventHandler("auth.create.character", root, createCharacter)

function loginStep(player)
    player:setData("online", true)
    dbQuery(
        function(qh,player)
            local res, rows, err = dbPoll(qh, 0)
            local data = {}
            if rows > 0 then
                for index, row in ipairs(res) do
                    local dbid = tonumber(row.id)
                    local x, y, z, int, dim = unpack(split(cache:getCharacterData(dbid, "pos"), ","))
                    local i = #data + 1
                    if not data[i] then
                        data[i] = {}
                    end
                    data[i][1] = dbid
                    data[i][2] = cache:getCharacterData(dbid, "name")
                    data[i][3] = cache:getCharacterData(dbid, "gender")
                    data[i][4] = getZoneName(x, y, z)
                    data[i][5] = cache:getCharacterData(dbid, "dead")
                end
            end
            triggerClientEvent(player, "auth.login.step", player, data)
        end,
    {player}, conn, "SELECT id FROM characters WHERE account = ?", player:getData('account.id'))
end

function login(username, password)
    if username == "kullanıcı adı" then return triggerClientEvent(source, "auth.notify", source, "Lütfen geçerli bir kullanıcı adı girin.") end
    if password == "şifre" then return triggerClientEvent(source, "auth.notify", source, "Lütfen geçerli bir şifre girin.") end
    dbQuery(
        function(qh,player)
            local res, rows, err = dbPoll(qh, 0)
            if rows > 0 then
                for index, row in ipairs(res) do
                    if row.password == password then
                        player:setData("account.id", tonumber(row.id))
                        loginStep(player)
                    else
                        triggerClientEvent(player, "auth.notify", player, ""..username.." hesabının şifresi yanlış, lütfen şifrenizi kontrol edin.")
                    end
                end
            else
                triggerClientEvent(player, "auth.notify", player, "böyle bir hesap bulunamadı, ("..username..")")
            end
        end,
    {source}, conn, "SELECT password,name,id FROM accounts WHERE name = ?", username)
end
addEvent("auth.login", true)
addEventHandler("auth.login", root, login)

function register(username, password, mail)
    if username == "kullanıcı adı" then return triggerClientEvent(source, "auth.notify", source, "Lütfen geçerli bir kullanıcı adı belirleyin.") end
    if password == "şifre" then return triggerClientEvent(source, "auth.notify", source, "Lütfen geçerli bir şifre belirleyin.") end
    if mail == "youremail@icloud.com" then return triggerClientEvent(source, "auth.notify", source, "Lütfen geçerli e posta adresi belirleyin.") end
    dbQuery(
        function(qh,player)
            local res, rows, err = dbPoll(qh, 0)
            if rows > 0 then
                for index, row in ipairs(res) do
                    triggerClientEvent(player, "auth.notify", player, "zaten bir hesabınız var, ("..row['name']..")")
                end
            else
                dbQuery(
                    function(qh,player)
                        local res, rows, err = dbPoll(qh, 0)
                        if rows > 0 then
                            for index, row in ipairs(res) do
                                triggerClientEvent(player, "auth.notify", player, "bu hesap ismi kullanılıyor, ("..row['name']..")")
                            end
                        else
                            dbExec(conn, "INSERT INTO accounts SET name='"..(username).."', password='"..(password).."', serial='"..(player.serial).."'")
                            dbQuery(
                                function(qh)
                                    local res, rows, err = dbPoll(qh, 0)
                                    if rows > 0 then
                                        for index, row in ipairs(res) do
                                            local dbid = tonumber(row.id)
                                            for column, value in pairs(row) do
                                                cache:setAccountData(dbid, column, value)
                                            end
                                        end
                                    end
                                end,
                            conn, "SELECT * FROM accounts WHERE name = ?", username)
                            triggerClientEvent(player, "auth.notify", player, "başarıyla kayıt oldunuz, ("..username..")")
                        end
                    end,
                {player}, conn, "SELECT name FROM accounts WHERE name = ?", username)
            end
        end,
    {source}, conn, "SELECT name FROM accounts WHERE serial = ?", source.serial)
end
addEvent("auth.register", true)
addEventHandler("auth.register", root, register)

function remember()
    dbQuery(
        function(qh,player)
            local res, rows, err = dbPoll(qh, 0)
            if rows > 0 then
                for index, row in ipairs(res) do
                    triggerClientEvent(player, "auth.remembered", player, row.name, row.password)
                end
            end
        end,
    {source}, conn, "SELECT name,password FROM accounts WHERE serial = ?", source.serial)
end
addEvent("auth.remember.me", true)
addEventHandler("auth.remember.me", root, remember)

function checkCharacterName(result)
    dbQuery(
        function(qh,player)
            local res, rows, err = dbPoll(qh, 0)
            if rows > 0 then
                triggerClientEvent(player, "auth.notify", player, "Bu karakter ismi kullanılıyor, başka bir tane deneyin.")
            else
                local oldName = player.name
                local successName = player:setName(result)
                if (successName) then
                    player:setName(oldName)
                    triggerClientEvent(player, "auth.next.step", player)
                else
                    triggerClientEvent(player, "auth.notify", player, "Seçtiğiniz karakter isminde bir sorun bulundu, başka bir tane deneyin.")
                end
            end
        end,
    {source}, conn, "SELECT name FROM characters WHERE name = ?", result)
end
addEvent("auth.check.character.name", true)
addEventHandler("auth.check.character.name", root, checkCharacterName)