functions = {
    -- itemID, function
    ['FOOD'] = {function(player,itemID,itemValue,itemCount,itemIndex)
        local dbid = player:getData('dbid')
        local hunger = player:getData('hunger') or 100
        local newHunger = hunger + 20
        local new_value = tonumber(itemValue) - 25
        
        if new_value <= 0 then 
            takeItemFromIndex(player,itemIndex,1)
            if itemCount > 1 then setItemValue(player,itemIndex,100) end
        else 
            setItemValue(player,itemIndex,new_value)
        end


        if newHunger > 100 then
            player:setData('hunger', 100)
            exports.cache:setCharacterData(dbid, 'hunger', 100)
        else
            player:setData('hunger', newHunger)
            exports.cache:setCharacterData(dbid, 'hunger', newHunger)
        end
    end},

    ['DRINK'] = {function(player,itemID,itemValue,itemCount,itemIndex)
        local dbid = player:getData("dbid")
        local thirst = player:getData('thirst') or 100
        local newThirst = thirst + 20
        local new_value = tonumber(itemValue) - 25

        if new_value <= 0 then 
            takeItemFromIndex(player,itemIndex,1)
            if itemCount > 1 then setItemValue(player,itemIndex,100) end
        else 
            setItemValue(player,itemIndex,new_value)
        end

        if newThirst > 100 then
            player:setData('thirst', 100)
            exports.cache:setCharacterData(dbid, 'thirst', 100)
        else
            player:setData('thirst', newThirst)
            exports.cache:setCharacterData(dbid, 'thirst', newThirst)
        end
    end},

    ['KEY'] = {function(player,itemID,itemValue,itemCount,itemIndex)
        if itemID == 1 then
            --// INTERIOR
        else
            local x, y, z = player.position.x, player.position.y, player.position.z
            for _, vehicle in ipairs(Element.getAllByType('vehicle')) do
                local vx, vy, vz = vehicle.position.x, vehicle.position.y, vehicle.position.z
                if getDistanceBetweenPoints3D(x, y, z, vx, vy, vz) <= 5 then
                    local dbid = vehicle:getData('dbid')
                    if itemValue == dbid then
                        local lock = exports.cache:getVehicleData(dbid, 'lock') or 0
                        if lock == 1 then
                            exports.cache:setVehicleData(dbid, 'lock', 0)
                            vehicle:setLocked(false)
                        else
                            exports.cache:setVehicleData(dbid, 'lock', 1)
                            vehicle:setLocked(true)
                        end
                        player:setAnimation('ped', 'walk_doorpartial', -1, false, false, false, false)
                        local oldState = vehicle.overrideLights
                        local from = 2
                        local to = oldState
                        if oldState == 2 then
                            from = 1
                        end
                        setVehicleOverrideLights(vehicle, from)
                        setTimer(setVehicleOverrideLights, 500, 1, vehicle, to)
                        break
                    end
                end
            end
        end
    end},
}

function useItem(info)
    local itemID,itemValue,_ = unpack(info)
    if source and tonumber(itemID) then
        if functions[getItemType(itemID)] then
            local itemIndex,_,itemValue_, itemCount = hasItem(source,itemID,itemValue)
            functions[getItemType(itemID)][1](source,itemID,itemValue_,itemCount,itemIndex)
        end
    end
end
addEvent('use.item',true)
addEventHandler('use.item',root,useItem)
