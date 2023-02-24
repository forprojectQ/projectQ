local items = {}

addEvent('load.items.client',true)
addEventHandler('load.items.client',root,function(data)
    local data = data or {}
    items = data
end)

function getItems(player)
    return items[player]
end

triggerServerEvent('load.items.server',localPlayer)