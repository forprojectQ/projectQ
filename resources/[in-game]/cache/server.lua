All = class("All")
Accounts = All:extend("Accounts")
Characters = All:extend("Characters")
Items = All:extend("Items")
Interiors = All:extend("Interiors")
Vehicles = All:extend("Vehicles")

function All:init()
    local conn = exports.mysql:getConn()
    local tonumber = tonumber
    local ipairs = ipairs
    local pairs = pairs
    local dbQuery = dbQuery
    local dbPoll = dbPoll
    dbQuery(
        function(qh)
            local res, rows, err = dbPoll(qh, 0)
            if rows > 0 then
                for index, row in ipairs(res) do
                    local dbid = tonumber(row.id)
                    for column, value in pairs(row) do
                        Accounts:set(dbid, column, value)
                    end
                end
            end
        end,
    conn, "SELECT * FROM accounts")

    dbQuery(
        function(qh)
            local res, rows, err = dbPoll(qh, 0)
            if rows > 0 then
                for index, row in ipairs(res) do
                    local dbid = tonumber(row.id)
                    for column, value in pairs(row) do
                        Characters:set(dbid, column, value)
                    end
                end
            end
        end,
    conn, "SELECT * FROM characters")

    dbQuery(
        function(qh)
            local res, rows, err = dbPoll(qh, 0)
            if rows > 0 then
                for index, row in ipairs(res) do
                    local dbid = tonumber(row.id)
                    for column, value in pairs(row) do
                        Items:set(dbid, column, value)
                    end
                end
            end
        end,
    conn, "SELECT * FROM items")


    --// Interiors

    --// Vehicles
    

    function getAccountData(target, key)
        local app = Accounts:get(target, key)
        return app
    end

    function setAccountData(target, key, value)
        if Accounts:set(target, key, value) then
            return true
        else
            return false
        end
    end

    function getCharacterData(target, key)
        local app = Characters:get(target, key)
        return app
    end

    function setCharacterData(target, key, value)
        if Characters:set(target, key, value) then
            return true
        else
            return false
        end
    end

    function getItemData(target, key)
        local app = Items:get(target, key)
        return app
    end

    function setItemData(target, key, value)
        if Items:set(target, key, value) then
            return true
        else
            return false
        end
    end

    function getInteriorData(taget, key)
        local app = Interiors:get(target, key)
        return app
    end

    function setInteriorData(target, key, value)
        if Interiors:set(target, key, value) then
            return true
        else
            return false
        end
    end

    function getVehicleData(target, key)
        local app = Vehicles:get(target, key)
        return app
    end

    function setVehicleData(target, key, value)
        if Vehicles:set(target, key, value) then
            return true
        else
            return false
        end
    end

end

All:new()