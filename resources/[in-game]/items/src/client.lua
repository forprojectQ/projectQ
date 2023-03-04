items = {}

addEvent('load.items.client',true)
addEventHandler('load.items.client',root,function(results)
    local results = results or {}
    items = results
end)

function getItems()
    return items
end

function hasItem(item,value)
    if  tonumber(item) then
        local value = value or 0
        for i, v in pairs(items) do
            if v[1] == item and v[2] == value then
                return i, v[1], v[2], v[3]
            end
        end
        return false
    end
end

function getItemValue(item,value)
    local value = value or 0
    local _, _, itemValue, _ = hasItem(item,value)
    return itemValue or 0
end

function getItemCount(item,value)
    local value = value or 0
    local _, _, _, itemCount = hasItem(item,value)
    return itemCount or 0
end

triggerServerEvent('load.items.server',localPlayer)