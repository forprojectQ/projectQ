
local triggerClientEvent = triggerClientEvent
local pairs = pairs
local exports = exports
local tonumber = tonumber
local addEvent = addEvent
local addEventHandler = addEventHandler
local mysql = exports.mysql
local items = {}

local getBigID = function()
    local query = dbQuery(mysql:getConn(), "SELECT `id` FROM items ORDER BY id DESC LIMIT 1")
	local result = dbPoll(query, -1)
	if #result > 0 then
		return tonumber(result[1]["id"]) or 1
    end
	return 1
end

local lastID = getBigID()

local getlastID = function()
    lastID = lastID + 1
    return lastID
end

local refresh = function(player)
    triggerClientEvent(player,'load.items.client',player,items)
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
                    triggerClientEvent(player,'load.items.client',player,items)
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
    local count = count or 1
    local value = value or 0
    local itemIndex,itemID,itemValue, itemCount = hasItem(player,item,value)
    if itemIndex then
        local newCount = itemCount + count
        items[player][itemIndex] = {tonumber(item),tonumber(value),tonumber(newCount)}
        dbExec(mysql:getConn(), "UPDATE items SET count='"..(newCount).."', value='"..(value).."' WHERE id=?", itemIndex)
    else
        local id = getlastID()
        items[player][id] = {tonumber(item),tonumber(value),tonumber(count)}
        dbExec(mysql:getConn(), "INSERT INTO items SET id='"..(id).."', owner='"..(player:getData('dbid')).."', item='"..(tonumber(item)).."', value='"..(value).."', count='"..(tonumber(count)).."'")
    end
    refresh(player)
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

function setItemValue(player,item,value)
    local value = value or 0
    local itemIndex,itemID,itemValue, itemCount = hasItem(player,item,value)
    if itemIndex then
        items[player][itemIndex] = {tonumber(item),tonumber(value),tonumber(itemCount)}
        dbExec(mysql:getConn(), "UPDATE items SET value='"..(value).."' WHERE id=?", itemIndex)
        refresh(player)
        return true
    else
        return false
    end
end

function setItemCount(player,item,count)
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