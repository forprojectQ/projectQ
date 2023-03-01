All = class("All")
-- cache yapılcak mysql table isimleri.
cached_tables = {
    "accounts","characters"
}

function All:init()
    local tonumber = tonumber
    local ipairs = ipairs
    local pairs = pairs
    local dbQuery = dbQuery
    local dbPoll = dbPoll

    function loadCache(i)
        local v = cached_tables[i]
        if not v then print("cache işlemi bitti") return end
        tables_cache[v] = All:extend(v)

        dbQuery(function(qh,tablename,tableindex)
                local res, rows, err = dbPoll(qh, 0)
                for index, row in ipairs(res) do
                    local dbid = tonumber(row.id)
                    tables_cache[tablename][dbid] = {}
                    for column, value in pairs(row) do
                        if not tables_cache[tablename][0][column] then tables_cache[tablename][0][column] = true end
                        if value then
                            tables_cache[tablename][dbid][column]=value
                        end
                    end
                end
                tables_cache[tablename].databaseLoaded = true
                loadCache(tableindex+1)
        end,{v,i},conn,"SELECT * FROM "..v)
    end
    loadCache(1)    

    --// set and get functions
    function getAccountData(target, key)
        return tables_cache["accounts"]:get(target, key)
    end
    function setAccountData(target, key, value)
        return tables_cache["accounts"]:set(target, key, value)
    end

    function getCharacterData(target, key)
        return tables_cache["characters"]:get(target, key)
    end
    function setCharacterData(target, key, value)
        return tables_cache["characters"]:set(target, key, value)
    end

    function getInteriorData(taget, key)
        return tables_cache["interiors"]:get(target, key)
    end
    function setInteriorData(target, key, value)
        return tables_cache["interiors"]:set(target, key, value)
    end

    function getVehicleData(target, key)
        return tables_cache["vehicles"]:get(target, key)
    end
    function setVehicleData(target, key, value)
        return tables_cache["vehicles"]:set(target, key, value)
    end

end

All:new()