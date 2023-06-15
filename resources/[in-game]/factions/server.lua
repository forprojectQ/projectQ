local conn = exports.mysql:getConn()
local cache = exports.cache
local factions = {}
local factions_rank = {}
local factions_members = {}

local query_sql = [[
    SELECT
        f.id as faction_id,
        f.name as faction_name,
        f.type as faction_type,
        f.note as faction_note,
        f.balance as faction_balance,
        f.level as faction_level,
        r.id as rank_id,
        r.name as rank_name,
        r.permissions as rank_permissions
    FROM
        factions f
    LEFT JOIN factions_rank r ON 
        f.id = r.faction_id
]]

local function processResults(results)
    if not results then return end
    Async:foreach(results, function(row)
        local fact_id = tonumber(row.faction_id)
        if not factions[fact_id] then
            --// BİRLİK YÜKLEME
            factions[fact_id] = {
                name = row.faction_name,
                type = tonumber(row.faction_type),
                balance = tonumber(row.faction_balance),
                note = tostring(row.faction_note),
                level = tonumber(row.faction_level)
            }
            factions_rank[fact_id] = {}
        end
        --// BİRLİĞE RÜTBELERİ YÜKLEME
        table.insert(factions_rank[fact_id], {
            id = tonumber(row.rank_id),
            faction_id = tonumber(fact_id),
            name = row.rank_name,
			permissions = split(row.rank_permissions or "",",")
        })
    end)
end

dbQuery(function(qh)
    local results = dbPoll(qh, -1)
    processResults(results)
    --// BİRLİK ÜYELERİ YÜKLEME
    for k, faction in pairs(factions) do
        dbQuery(function(qh)
            local results = dbPoll(qh, -1)
            if results then
                factions_members[k] = results
            end
        end, conn, "SELECT id, name, faction_rank, faction_lead, lastlogin FROM characters WHERE faction = " .. k)
    end
    print("! LOADED "..#factions.." FACTION")
end, conn, query_sql)

function sendFactionAnnouncement(faction, message)
    if tonumber(faction) then
        for _, member in ipairs(Element.getAllByType("player")) do
            if cache:getCharacterData(member, "faction") == faction then
                member:outputChat("[BİRLİK] "..message.."", 191, 134, 70)
            end
        end
    end
end

function deleteFaction(fact_id)
    if tonumber(fact_id) and factions[fact_id] then
        local query = dbExec(conn, "DELETE FROM factions WHERE id = " .. fact_id)
        if query then
            factions[fact_id] = nil
            factions_rank[fact_id] = nil
            factions_members[fact_id] = nil
            dbExec(conn, "DELETE FROM factions_rank WHERE faction_id = " .. fact_id)
            collectgarbage("collect")
        end
    end
end

addEvent("factions.quit", true)
addEventHandler("factions.quit", root, function()
    local fact_id = tonumber(cache:getCharacterData(source, "faction")) or 0
    local dbid = tonumber(source:getData("dbid"))

    sendFactionAnnouncement(fact_id, ""..source.name..", birlikten ayrıldı!")

    cache:setCharacterData(source, "faction", 0)
    cache:setCharacterData(source, "faction_rank", 0)
    cache:setCharacterData(source, "faction_lead", 0)

    local memberToRemove = nil
    for index, member in ipairs(factions_members[fact_id]) do
        if member.id == dbid then
            memberToRemove = index
            break
        end
    end

    if memberToRemove then
        table.remove(factions_members[fact_id], memberToRemove)
    end

    if #factions_members[fact_id] <= 0 then
        --// üye kalmadıysa birlik siliniyor.
        deleteFaction(fact_id)
    end
end)

addEvent("factions.get.server", true)
addEventHandler("factions.get.server", root, function()
    local fact_id = tonumber(cache:getCharacterData(source, "faction")) or 0

    local fact_info = {}
    local rank_info = {}
    local member_info = {}
    local vehicle_info = {}
    local interior_info = {}

    if fact_id > 0 then
        local res = factions[fact_id]

        fact_info = {id = fact_id, name = res.name, note = res.note, type = res.type, balance = res.balance, level = res.level}
        rank_info=factions_rank[fact_id]

        for k, v in pairs(factions_members[fact_id]) do
            local app = exports.global:findPlayer(v.id)
            table.insert(member_info, {id = v.id, rank = v.faction_rank, name = v.name, lead = v.faction_lead, lastlogin = v.lastlogin, online = (app and true or false)})
        end

        for _, vehicle in ipairs(Element.getAllByType("vehicle")) do
            if cache:getVehicleData(vehicle, "faction") == fact_id then
                table.insert(vehicle_info, {id = vehicle:getData("dbid"), plate = vehicle.plateText})
            end
        end
        
        triggerClientEvent(source, "factions.load.client", source, fact_info, rank_info, member_info, vehicle_info, interior_info)
    end
end)

addEvent("factions.finance", true)
addEventHandler("factions.finance", root, function(factionID, amount, app)
    if tonumber(amount) then
        if factions[factionID] then
            if app == "withdraw" then
                local current = tonumber(factions[factionID].balance)
                local new = current - tonumber(amount)
                if new < 0 then
                    source:outputChat("[!]#FFFFFF Birlik kasasında çekmek istediğiniz kadar nakit bulunmuyor!", 55, 55, 200, true)
                    return
                end
                factions[factionID].balance = new
                exports.global:giveMoney(source, tonumber(amount))
                dbExec(conn, "UPDATE factions SET balance='"..(new).."' WHERE id='"..(factionID).."'")
            elseif app == "deposit" then
                if exports.global:takeMoney(source, tonumber(amount)) then
                    local current = tonumber(factions[factionID].balance)
                    local new = current + tonumber(amount)
                    factions[factionID].balance = new
                    dbExec(conn, "UPDATE factions SET balance='"..(new).."' WHERE id='"..(factionID).."'")
                else
                    source:outputChat("[!]#FFFFFF Üzerinizde kasya yatırmak için bu kadar nakit bulunmuyor!", 55, 55, 200, true)
                end
            end
        end
    end
end)

local respawnDelay = {}

addEvent("factions.vehicle", true)
addEventHandler("factions.vehicle", root, function(app, val)
    local fact_id = tonumber(cache:getCharacterData(source, "faction")) or 0

    if app == "respawn" then
        if respawnDelay[source] then
            source:outputChat("[!]#FFFFFF Bu işlemi bu kadar sık gerçekleştiremezsiniz.", 55, 55, 200, true)
            return
        end

        respawnDelay[source] = Timer(function(player)
            respawnDelay[player] = nil
            collectgarbage("collect")
        end, 30000, 1, source)

        if tonumber(val) then
            local vehicle = exports.global:findVehicle(val)
            if vehicle and not vehicle.controller then
                vehicle:respawn()
                source:outputChat("[!]#FFFFFF Aracı respawnladınız.", 55, 55, 200, true)
                sendFactionAnnouncement(fact_id, ""..source.name..", #"..val.." ID birlik aracını respawnladı.")
            else
                source:outputChat("[!]#FFFFFF Birlik aracı şu anda birisi tarafından kullanılıyor.", 55, 55, 200, true)
            end
        else
            for _, vehicle in ipairs(Element.getAllByType("vehicle")) do
                if cache:getVehicleData(vehicle, "faction") == fact_id and not vehicle.controller then
                    vehicle:respawn()
                end
            end
            source:outputChat("[!]#FFFFFF Tüm birlik araçlarını respawnladınız.", 55, 55, 200, true)
            sendFactionAnnouncement(fact_id, ""..source.name..", tüm birlik araçlarını respawnladı.")
        end
    elseif app == "remove" then
        local vehicle = exports.global:findVehicle(val)
        if vehicle then
            if cache:getVehicleData(vehicle, "faction") == fact_id then
                cache:setVehicleData(vehicle, "faction", 0)
                sendFactionAnnouncement(fact_id, ""..source.name..", #"..val.." ID aracı birlikten çıkardı.")
            else
                source:outputChat("[!]#FFFFFF Araç zaten bu birliğe ait değil.", 55, 55, 200, true)
            end
        else
            source:outputChat("[!]#FFFFFF Bir sorun oluştu, daha sonra tekrar deneyin.", 55, 55, 200, true)
        end
    end
end)


addEvent("factions.updateRankPermissions", true)
addEventHandler("factions.updateRankPermissions", root, function(rank_id, rank_perms)
	local fact_id = tonumber(cache:getCharacterData(client, "faction"))
	if fact_id == 0 then return end
	local rank_index = false
	for i,v in ipairs(factions_rank[fact_id]) do
		if v.id == rank_id then
			rank_index = i
			break
		end
	end
	if not rank_index then client:outputChat("[!]#FFFFFF Seçtiğin rank bulunamadı.", 55, 55, 200, true) return end
	local rank = factions_rank[fact_id][rank_index]
	factions_rank[fact_id][rank_index].permissions=rank_perms
	sendFactionAnnouncement(fact_id, ""..client.name..", "..rank.name.." isimli rankın izinlerini güncelledi.")
	client:outputChat("[!]#FFFFFF "..rank.name.." isimli rankın izinlerini güncellediniz.", 55, 55, 200, true)
	dbExec(conn, "UPDATE factions_rank SET permissions=? WHERE id=?",table.concat(rank_perms,","),rank.id)
end)