
local triggerClientEvent = triggerClientEvent
local pairs = pairs
local exports = exports
local tonumber = tonumber
local addEvent = addEvent
local addEventHandler = addEventHandler
local mysql = exports.mysql
local items = {}

local getlastID = function()
    return mysql:getNewID("items")
end

local refresh = function(player)
    triggerClientEvent(player,'load.items.client',player,items[player])
end

function loadItems(player)
    if player then
        if player:getData('online') then
            if not items[player] then
                items[player] = {}
            end
            dbQuery(
                function(qh,player)
                    local res, rows, err = dbPoll(qh, 0)
                    if rows > 0 then
                        for index, row in ipairs(res) do
                            items[player][row.id] = {tonumber(row.item),tonumber(row.value),tonumber(row.count)}
                        end
                    end
                    triggerClientEvent(player,'load.items.client',player,items[player])
                end,
            {player}, mysql:getConn(), "SELECT * FROM items WHERE owner = ?", player:getData('dbid'))
        end
    end
end

function hasItem(player,item,value)
    if player and tonumber(item) then
        local value = value or 0
        local data = items[player] or {}
        for i, v in pairs(data) do
            if v[1] == item and v[2] == value then
                return i, v[1], v[2], v[3]
            end
        end
        return false
    end
end

function getItems(player)
    if player then
        return items[player] or {}
    end
end

function giveItem(player,item,value,count)
    if not list[item] then return false end
    local count = count or 1
    local value = value or getItemDefaultValue(item)
    local itemIndex,itemID,itemValue, itemCount = hasItem(player,item,value)
    -- aynı id ve value' olan bir item envanterinde varsa ve o item stack yapılıyor ise, count arttır.
    if itemIndex and isStackableItem(item) then
        local newCount = itemCount + count
        items[player][itemIndex] = {tonumber(item),tonumber(value),tonumber(newCount)}
        dbExec(mysql:getConn(), "UPDATE items SET count='"..(newCount).."', value='"..(value).."' WHERE id=?", itemIndex)
    else -- eğer item yoksa veya item varsa ama stack yapılmıyosa yeni item oalrak ver
        local id = getlastID()
        items[player][id] = {tonumber(item),tonumber(value),tonumber(count)}
        dbExec(mysql:getConn(), "INSERT INTO items SET id='"..(id).."', owner='"..(player:getData('dbid')).."', item='"..(tonumber(item)).."', value='"..(value).."', count='"..(tonumber(count)).."'")
    end
    refresh(player)
    return true
end

function takeItem(player,item,value,count)
    local count = count or 1
    local value = value or 0
    local itemIndex,itemID,itemValue, itemCount = hasItem(player,item,value)
    if itemIndex then
        local newCount = itemCount - count
        if newCount < 0 then
            return false
        end
        if newCount == 0 then
            items[player][itemIndex] = nil
            dbExec(mysql:getConn(), "DELETE FROM items WHERE id=?",itemIndex)
            collectgarbage('collect')
        else
            items[player][itemIndex] = {tonumber(item),tonumber(value),tonumber(newCount)}
            dbExec(mysql:getConn(), "UPDATE items SET count='"..(newCount).."' WHERE id=?", itemIndex)
        end
        refresh(player)
        return true
    else
        return false
    end
end

function setItemValue(player,itemIndex,value)
    if not items[player] then return false end
    if not items[player][itemIndex] then return false end
    local info = items[player][itemIndex]
    local value = value or 0
    local itemID,itemValue, itemCount = unpack({info[1],info[2],info[3]})
    if itemIndex then
        items[player][itemIndex] = {tonumber(itemID),tonumber(value),tonumber(itemCount)}
        dbExec(mysql:getConn(), "UPDATE items SET value='"..(value).."' WHERE id=?", itemIndex)
        refresh(player)
        return true
    else
        return false
    end
end

function setItemCount(player,item,value,count)
    local count = count or 1
    local itemIndex,itemID,itemValue, itemCount = hasItem(player,item,value)
    if itemIndex then
        return takeItem(player,item,itemValue,count)
    else
        return false
    end
end

function getItemValue(player,item,value)
    local value = value or 0
    local _, _, itemValue, _ = hasItem(player,item,value)
    return itemValue or 0
end

function getItemCount(player,item,value)
    local value = value or 0
    local _, _, _, itemCount = hasItem(player,item,value)
    return itemCount or 0
end

addEvent('load.items.server', true)
addEventHandler('load.items.server', root, function()
    loadItems(source)
end)