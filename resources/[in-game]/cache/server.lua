All = class("All")
cached_tables = { --// cache yapılcak mysql table isimleri.
    "accounts","characters","vehicles"
}
addEvent("onDatabaseLoaded",true)

function All:init()
    local tonumber = tonumber
    local ipairs = ipairs
    local pairs = pairs
    local dbQuery = dbQuery
    local dbPoll = dbPoll

    function loadCache(i)
        local v = cached_tables[i]
        if not v then print("! CACHE IS FINISHED") return end
        tables_cache[v] = All:extend(v)
        dbQuery(function(qh,tablename,tableindex)
            local res = dbPoll(qh, 0)
            Async:foreach(res, function(row)
                local dbid = tonumber(row.id)
                tables_cache[tablename][dbid] = {}
                for column, value in pairs(row) do
                    if not tables_cache[tablename][0][column] then tables_cache[tablename][0][column] = true end
                    if value then
                        tables_cache[tablename][dbid][column]=value
                    end
                end
            end, function() 
				tables_cache[tablename].databaseLoaded = true
				triggerEvent("onDatabaseLoaded",root,tablename)
				loadCache(tableindex+1) 
			end)
        end,{v,i},conn,"SELECT * FROM "..v)
    end
    loadCache(1)
	
	addEventHandler("onDatabaseLoaded",root,function(tablename)
		if #tables_cache[tablename].pool > 0 then
			for i,v in ipairs(tables_cache[tablename].pool) do tables_cache[tablename]:set(unpack(v)) end
			print(tablename.."'s pool set and cleared.")
			tables_cache[tablename].pool = {}
		end
	end)

    --// set, get, remove and clear functions
	
	function getID(target)
		return isElement(target) and target:getData("dbid") or target
	end
	
    --// ACCOUNTS
    function getAccountData(target, key)
        return tables_cache["accounts"]:get(getID(target), key)
    end
    function setAccountData(target, key, value, noSql)
        return tables_cache["accounts"]:set(getID(target), key, value, noSql)
    end
    function removeAccountData(target, key)
        return tables_cache["accounts"]:remove(getID(target), key)
    end
    function clearAccountAllData(target)
        return tables_cache["accounts"]:clear(getID(target))
    end

    --// CHARACTERS
    function getCharacterData(target, key)
        return tables_cache["characters"]:get(getID(target), key)
    end
    function setCharacterData(target, key, value, noSql)
        return tables_cache["characters"]:set(getID(target), key, value, noSql)
    end
    function removeCharacterData(target, key)
        return tables_cache["characters"]:remove(getID(target), key)
    end
    function clearCharacterAllData(target)
        return tables_cache["characters"]:clear(getID(target))
    end

    --// INTERIORS
    function getInteriorData(taget, key)
        return tables_cache["interiors"]:get(getID(target), key)
    end
    function setInteriorData(target, key, value, noSql)
        return tables_cache["interiors"]:set(getID(target), key, value, noSql)
    end
    function removeInteriorData(target, key)
        return tables_cache["interiors"]:remove(getID(target), key)
    end
    function clearInteriorAllData(target)
        return tables_cache["interiors"]:clear(getID(target))
    end

    --// VEHICLES
    function getVehicleData(target, key)
        return tables_cache["vehicles"]:get(getID(target), key)
    end
    function setVehicleData(target, key, value, noSql)
        return tables_cache["vehicles"]:set(getID(target), key, value, noSql)
    end
    function removeVehicleData(target, key)
        return tables_cache["vehicles"]:remove(getID(target), key)
    end
    function clearVehicleAllData(target)
        return tables_cache["vehicles"]:clear(getID(target))
    end

end

All:new()