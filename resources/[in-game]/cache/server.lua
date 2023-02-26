All = class("All")
Accounts = All:extend("Accounts")
Characters = All:extend("Characters")
Items = All:extend("Items")

function All:init()
    local conn = exports.mysql:getConn()
    local tonumber = tonumber
    local ipairs = ipairs
    local dbQuery = dbQuery
    local dbPoll = dbPoll

    dbQuery(
        function(qh)
            local res, rows, err = dbPoll(qh, 0)
            if rows > 0 then
                for index, row in ipairs(res) do
                    local dbid = tonumber(row.id)
                    Accounts:set(dbid, "account.name", row.name)
                    Accounts:set(dbid, "account.password", row.password)
                    Accounts:set(dbid, "account.limit", tonumber(row.limit))
                    Accounts:set(dbid, "admin", tonumber(row.admin))
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
                    Characters:set(dbid, "age", tonumber(row.age))
                    Characters:set(dbid, "height", tonumber(row.height))
                    Characters:set(dbid, "weight", tonumber(row.weight))
                    Characters:set(dbid, "gender", tonumber(row.gender))
                    Characters:set(dbid, "model", tonumber(row.model))
                    Characters:set(dbid, "money", tonumber(row.money))
                    Characters:set(dbid, "hunger", tonumber(row.hunger))
                    Characters:set(dbid, "thirst", tonumber(row.thirst))
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
                    Items:set(dbid, "id", tonumber(row.item))
                    Items:set(dbid, "value", tonumber(row.value))
                    Items:set(dbid, "count", tonumber(row.count))
                end
            end
        end,
    conn, "SELECT * FROM items")
end

All:new()