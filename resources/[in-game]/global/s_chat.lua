local function getDistanceColor(player, target, type)
    local x, y, z = player.position.x, player.position.y, player.position.z
    local vx, vy, vz = target.position.x, target.position.y, target.position.z
    local distance = getDistanceBetweenPoints3D(x, y, z, vx, vy, vz)
    if type == 0 then
        if distance > 10 and distance <= 20 then
            return 175, 175, 175
        end
        return 255, 255, 255
    elseif type == 1 then
        if distance > 10 and distance <= 20 then
            return 121, 55, 171
        end
        return 158, 82, 223
    elseif type == 2 then
        if distance > 10 and distance <= 20 then
            return 86, 175, 112
        end
        return 89, 215, 140
    end
end

function sendLocalICText(source, message)
    local x, y, z = source.position.x, source.position.y, source.position.z
    local vehicle = source.vehicle
    for _, player in ipairs(Element.getWithinRange(x, y, z, 20, "player")) do
        if player:getData("online") then
            local r, g, b = getDistanceColor(source, player, 0)
            if vehicle then
                local windowState = vehicle:getData("window") or 0 --// 0 KAPALI, 1 AÇIK
                if windowState == 0 then
                    local targetVehicle = player.vehicle
                    if vehicle == targetVehicle then
                        player:outputChat(""..source.name:gsub("_", " ").." diyor ki (Araç İçi): "..message.."", 175, 175, 175)
                    end
                else
                    player:outputChat(""..source.name:gsub("_", " ").." diyor ki: "..message.."", r, g, b)
                end
            else
                player:outputChat(""..source.name:gsub("_", " ").." diyor ki: "..message.."", r, g, b)
            end
        end
    end
end

function sendLocalOOCText(source, message)
    local x, y, z = source.position.x, source.position.y, source.position.z
    local adminDuty = source:getData("adminduty") or 0
    local supporterDuty = source:getData("gmduty") or 0
    for _, player in ipairs(Element.getWithinRange(x, y, z, 20, "player")) do
        if player:getData("online") then
            if adminDuty > 0 then
                player:outputChat("[OOC] #AF3737"..source.name:gsub("_", " ")..": #C4FFFF"..message.."", 196, 255, 255, true)
            elseif supporterDuty > 0 then
                player:outputChat("[OOC] #37AF37"..source.name:gsub("_", " ")..": #C4FFFF"..message.."", 196, 255, 255, true)
            else
                player:outputChat("[OOC] "..source.name:gsub("_", " ")..": "..message.."", 196, 255, 255, true)
            end
        end
    end
end

function sendLocalMeAction(source, message)
    local x, y, z = source.position.x, source.position.y, source.position.z
    local vehicle = source.vehicle
    for _, player in ipairs(Element.getWithinRange(x, y, z, 20, "player")) do
        if player:getData("online") then
            local r, g, b = getDistanceColor(source, player, 1)
            if vehicle then
                local windowState = vehicle:getData("window") or 0 --// 0 KAPALI, 1 AÇIK
                if windowState == 0 then
                    local targetVehicle = player.vehicle
                    if vehicle == targetVehicle then
                        player:outputChat("* "..source.name:gsub("_", " ").." (Araç İçi) "..message.."", 121, 55, 171)
                    end
                else
                    player:outputChat("* "..source.name:gsub("_", " ").." "..message.."", r, g, b)
                end
            else
                player:outputChat("* "..source.name:gsub("_", " ").." "..message.."", r, g, b)
            end
        end
    end
end

function sendLocalDoAction(source, message)
    local x, y, z = source.position.x, source.position.y, source.position.z
    local vehicle = source.vehicle
    for _, player in ipairs(Element.getWithinRange(x, y, z, 20, "player")) do
        if player:getData("online") then
            local r, g, b = getDistanceColor(source, player, 2)
            if vehicle then
                local windowState = vehicle:getData("window") or 0 --// 0 KAPALI, 1 AÇIK
                if windowState == 0 then
                    local targetVehicle = player.vehicle
                    if vehicle == targetVehicle then
                        player:outputChat(""..message.." (Araç İçi) ("..source.name:gsub("_", " ")..")", 86, 175, 112)
                    end
                else
                    player:outputChat(""..message.." ("..source.name:gsub("_", " ")..")", r, g, b)
                end
            else
                player:outputChat(""..message.." ("..source.name:gsub("_", " ")..")", r, g, b)
            end
        end
    end
end

function sendMessageToAdmins(message)
    for _, admin in ipairs(Element.getAllByType("player")) do
        local level = exports.cache:getAccountData(admin:getData("account.id"), "admin") or 0
        local duty = admin:getData("adminduty") or 0
        if level >= 2 and duty > 0 then
            admin:outputChat("[ADM] "..message.."", 175, 55, 55, true)
        end
    end
end

function sendMessageToSupporters(message)
    for _, supporter in ipairs(Element.getAllByType("player")) do
        local level = exports.cache:getAccountData(supporter:getData("account.id"), "admin") or 0
        local duty = supporter:getData("gmduty") or 0
        if level >= 1 and duty > 0 then
            supporter:outputChat("[SUP] "..message.."", 55, 175, 55, true)
        end
    end
end