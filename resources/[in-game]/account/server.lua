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
    source:setData("online", true)
    local dbid = tonumber(dbid)
    source:setData("dbid", dbid)
    local x, y, z, int, dim = unpack(split(cache:getCharacterData(dbid, "pos"), ","))
    local characterModel = cache:getCharacterData(dbid, "model")
    local characterName = cache:getCharacterData(dbid, "name")
    local walk = cache:getCharacterData(dbid, "walk")
    local hunger = cache:getCharacterData(dbid, "hunger")
    local thirst = cache:getCharacterData(dbid, "thirst")
    local money = cache:getCharacterData(dbid, "money")
    local hp = cache:getCharacterData(dbid, "health")
    local arm = cache:getCharacterData(dbid, "armor")
    source:setData("money", tonumber(money))
    source:setData("hunger", tonumber(hunger))
    source:setData("thirst", tonumber(thirst))
    source:spawn(x,y,z)
    source:setInterior(tonumber(int))
    source:setDimension(tonumber(dim))
    source.cameraTarget = source
    source.gravity = 0.008
    source.model = tonumber(characterModel)
    source.name = tostring(characterName)
    source.walkingStyle = walk
    source.health = hp
    source.armor = arm
    triggerEvent("death.check", source)
    triggerEvent("load.items.server", source)
    cache:setCharacterData(source, "lastlogin", exports.global:getTimeStamp())
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
    local nextID = exports.mysql:getNewID("characters")
    dbExec(conn, "INSERT INTO characters SET id='"..(nextID).."', account='"..(source:getData('account.id')).."', name='"..(name).."', age='"..(tonumber(age)).."', height='"..(tonumber(height)).."', weight='"..(tonumber(weight)).."', gender='"..(tonumber(gender)).."', model='"..(tonumber(model)).."', walk='"..(tonumber(walk)).."', lastlogin='"..exports.global:getTimeStamp().."'")
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
    conn, "SELECT * FROM characters WHERE id = ?", nextID)
    loginStep(source)
end
addEvent("auth.create.character", true)
addEventHandler("auth.create.character", root, createCharacter)

function loginStep(player)
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
                    data[i][5] = cache:getCharacterData(dbid, "active")
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
                        cache:setAccountData(player, "lastlogin", exports.global:getTimeStamp())
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
                            local nextID = exports.mysql:getNewID("accounts")
                            dbExec(conn, "INSERT INTO accounts SET id='"..(nextID).."', name='"..(username).."', password='"..(password).."', serial='"..(player.serial).."', lastlogin='"..exports.global:getTimeStamp().."'")
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
                            conn, "SELECT * FROM accounts WHERE id = ?", nextID)
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