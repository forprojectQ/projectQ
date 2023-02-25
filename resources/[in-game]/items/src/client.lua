local items = {}

addEvent('load.items.client',true)
addEventHandler('load.items.client',root,function(data)
    local data = data or {}
    items = data
end)

function getItems(player)
    return items[player]
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

triggerServerEvent('load.items.server',localPlayer)