addEvent("vehicle.effect.3d", true)
addEventHandler("vehicle.effect.3d", root, function(src, x, y, z)
    local effect = playSound3D(src, x, y, z, false)
    setSoundMaxDistance(effect, 12)
end)

bindKey("j", "down", function()
    if not getElementData(localPlayer, "online") then
        return
    end
    
    local vehicle = getPedOccupiedVehicle(localPlayer)
    
    if not vehicle then
        return
    end

    triggerServerEvent("vehicle.toggle.engine", localPlayer, vehicle)
end)

bindKey("l", "down", function()
    if not getElementData(localPlayer, "online") then
        return
    end
    
    local vehicle = getPedOccupiedVehicle(localPlayer)
    
    if not vehicle then
        return
    end

    triggerServerEvent("vehicle.toggle.lights", localPlayer, vehicle)
end)

bindKey("x", "down", function()
    if not getElementData(localPlayer, "online") then
        return
    end
    
    local vehicle = getPedOccupiedVehicle(localPlayer)
    
    if not vehicle then
        return
    end

    triggerServerEvent("vehicle.toggle.windows", localPlayer, vehicle)
end)


bindKey("k", "down", function()
    if not getElementData(localPlayer, "online") then
        return
    end

    triggerServerEvent("vehicle.toggle.lock", localPlayer)
end)