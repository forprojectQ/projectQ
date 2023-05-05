triggerServerEvent("death.check", localPlayer)

Timer(function()
    if localPlayer:getData("injured") == 1 then
        triggerServerEvent("death.injured", localPlayer)
    end
end, 300000, 0)

addEvent("death.injure", true)
addEventHandler("death.injure", root, function()
    setPedFootBloodEnabled(localPlayer, true)
end)

addEventHandler("onClientPlayerDamage", localPlayer, function()
    if localPlayer:getData("injured") == 0 then
        triggerServerEvent("death.damaged", localPlayer)
        setPedFootBloodEnabled(localPlayer, true)
    end
end)