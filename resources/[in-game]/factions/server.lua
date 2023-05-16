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
                end, conn, "SELECT id, name, faction_rank, lastlogin FROM characters WHERE faction = " .. k)
            end
            print("! LOADED "..#factions.." FACTİON")
        end)
    end
end, conn, "SELECT f.id as faction_id, f.name as faction_name, f.type as faction_type, f.note as faction_note, f.balance as faction_balance, f.level as faction_level, r.id, r.name as rank_name FROM factions f LEFT JOIN factions_rank r ON f.id = r.faction_id")

addEvent("factions.get.server", true)
addEventHandler("factions.get.server", root, function()
    local fact_id = tonumber(cache:getCharacterData(source, "faction")) or 0
    local fact_info = {}
    local rank_info = {}
    local member_info = {}
    if fact_id > 0 then
        local res = factions[fact_id]
        fact_info = {id = fact_id, name = res.name, note = res.note, type = res.type, balance = res.balance, level = res.level}
        rank_info=factions_rank[fact_id]
        for k,v in pairs(factions_members[fact_id]) do
            local app = exports.global:findPlayer(v.id)
            table.insert(member_info, {id = v.id, rank = v.faction_rank, name = v.name, lastlogin = v.lastlogin, online = (app and true or false)})
        end
        triggerClientEvent(source, "factions.load.client", source, fact_info, rank_info, member_info)
    end
end)