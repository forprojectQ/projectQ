local conn = exports.mysql:getConn()
local cache = exports.cache

local factions = {}
local factions_rank = {}
local factions_members = {}

dbQuery(function(qh)
    local results = dbPoll(qh, -1)
    if results then
        Async:foreach(results, function(row)
        local fact_id = tonumber(row.faction_id)
        if factions[fact_id] == nil then
            factions[fact_id] = {
                name = row.faction_name,
                type = tonumber(row.faction_type),
                balance = tonumber(row.faction_balance),
                note = tostring(row.faction_note),
                level = tonumber(row.faction_level)
            }
            factions_rank[fact_id] = {}
        end
        table.insert(factions_rank[fact_id], {
            id = tonumber(row.id),
            faction_id = tonumber(fact_id),
            name = row.rank_name
        })
        end, function()
            for k, faction in pairs(factions) do
                dbQuery(function(qh)
                    local results = dbPoll(qh, -1)
                    if results then
                        factions_members[k] = results
                    end
                end, conn, "SELECT id, name, faction_rank, faction_lead, lastlogin FROM characters WHERE faction = " .. k)
            end
            print("! LOADED "..#factions.." FACTİON")
        end)
    end
end, conn, "SELECT f.id as faction_id, f.name as faction_name, f.type as faction_type, f.note as faction_note, f.balance as faction_balance, f.level as faction_level, r.id, r.name as rank_name FROM factions f LEFT JOIN factions_rank r ON f.id = r.faction_id")

function sendFactionAnnouncement(faction, message)
    if tonumber(faction) then
        for _, member in ipairs(Element.getAllByType("player")) do
            if cache:getVehicleData(member, "faction") == faction then
                member:outputChat("[BİRLİK] "..message.."", 191, 134, 70)
            end
        end
    end
end

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