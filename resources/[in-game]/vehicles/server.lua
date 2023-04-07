Async:setPriority("low")
local setElementData = setElementData
local exports = exports
local tonumber = tonumber
local ipairs = ipairs
local conn = exports.mysql:getConn()
local cache = exports.cache
local _print = outputDebugString

dbQuery(function(qh)
    local res = dbPoll(qh, 0)
    Async:foreach(res, function(row)
        local dbid = tonumber(row.id)
        local libid = tonumber(row.library_id)
        local x, y, z, int, dim = unpack(split(cache:getVehicleData(dbid, "pos"), ","))
        local r, g, b = unpack(split(cache:getVehicleData(dbid, "color"), ","))
        local plate = cache:getVehicleData(dbid, "plate")
        local lock = cache:getVehicleData(dbid, "lock")
        local engine = cache:getVehicleData(dbid, "engine")
        local fuel = cache:getVehicleData(dbid, "fuel")
        local tax = cache:getVehicleData(dbid, "tax")
        dbQuery(function(qh)
            local res = dbPoll(qh, 0) 
            Async:foreach(res, function(row)
                if libid == tonumber(row.id) then
                    local gta = tonumber(row.gta)
                    local carshop_price = tonumber(row.price)
                    local carshop_tax = tonumber(row.tax)
                    local veh = createVehicle(gta, x, y, z)
                    if veh then
                        setVehicleColor(veh, r, g, b)
                        setElementInterior(veh, int)
                        setElementDimension(veh, dim)
                        setVehiclePlateText(veh, plate)
                        setElementData(veh, "dbid", dbid)
                        setElementData(veh, "fuel", tonumber(fuel))
                        setElementData(veh, "tax", tonumber(tax))
                        setElementData(veh, "carshop_price", tonumber(carshop_price))
                        setElementData(veh, "carshop_tax", tonumber(carshop_tax))
                        if tonumber(lock) == 1 then
                            setVehicleLocked(veh, true)
                        else
                            setVehicleLocked(veh, false)
                        end
                        if tonumber(engine) == 1 then
                            setVehicleEngineState(veh, true)
                        else
                            setVehicleEngineState(veh, false)
                        end
                    else
                        _print("! VEHICLES FAILED CREATE VEHICLE "..dbid)
                    end
                end
            end)
        end, conn, "SELECT * FROM vehicles_library")
    end)
end, conn, "SELECT id,library_id FROM vehicles")

function startEnterVehicle(player)
    local vehicle = source
    local playerJob = cache:getCharacterData(getElementData(player, "dbid"), "job") or 0
    local vehicleJob = cache:getVehicleData(getElementData(vehicle, "dbid"), "job") or 0
    if vehicleJob > 0 then
        if playerJob ~= vehicleJob then
            cancelEvent()
        end
    end
end
addEventHandler("onVehicleStartEnter", getRootElement(), startEnterVehicle)

function enterVehicle(player, seat)
    if seat == 0 then
        local dbid = getElementData(source, "dbid")
        local engine = cache:getVehicleData(dbid, "engine") or 0
        if tonumber(engine) == 0 then
            setVehicleEngineState(source, false)
        end
    end
end
addEventHandler("onVehicleEnter", getRootElement(), enterVehicle)

function toggleVehicleLock()
    local x, y, z = getElementPosition(source)
    for _, vehicle in ipairs(getElementsByType("vehicle")) do
        local vx, vy, vz = getElementPosition(vehicle)
        if getDistanceBetweenPoints3D(x, y, z, vx, vy, vz) <= 5 then
            local dbid = getElementData(vehicle, "dbid")
            if exports.items:hasItem(source, 2, dbid) then
                local lock = exports.cache:getVehicleData(dbid, "lock") or 0
                if lock == 1 then
                    exports.cache:setVehicleData(dbid, "lock", 0)
                    setVehicleLocked(vehicle, false)
                else
                    exports.cache:setVehicleData(dbid, "lock", 1)
                    setVehicleLocked(vehicle, true)
                end
                triggerClientEvent("vehicle.effect.3d", root, "assets/lock.mp3", vx, vy, vz)
                setPedAnimation(source, "ped", "walk_doorpartial", -1, false, false, false, false)
                local oldState = getVehicleOverrideLights(vehicle)
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
addEvent("vehicle.toggle.lock", true)
addEventHandler("vehicle.toggle.lock", root, toggleVehicleLock)

function toggleVehicleEngine(vehicle)
    local x, y, z = getElementPosition(vehicle)
    local dbid = getElementData(vehicle, "dbid")
    local engine = cache:getVehicleData(dbid, "engine") or 0
    local fuel = getElementData(vehicle, "fuel")
    local job = cache:getVehicleData(dbid, "job")

    if job == 0 then
        if not exports.items:hasItem(source, 2, dbid) then
            return
        end
        if fuel <= 0 then
            outputChatBox("Aracınızda yakıt bulunmuyor", source, 255, 0, 0)
            return
        end
    end

    if tonumber(engine) == 0 then
        triggerClientEvent("vehicle.effect.3d", root, "assets/engine.mp3", x, y, z)
        setTimer(function()
            local chance = math.random(1, 3)
            if chance == 1 then
                outputChatBox("Aracın motorunu çalıştıramadınız.", source)
            else
                setVehicleEngineState(vehicle, true)
                cache:setVehicleData(dbid, "engine", 1)
            end
        end, 2500, 1, source, vehicle)
    else
        setVehicleEngineState(vehicle, false)
        cache:setVehicleData(dbid, "engine", 0)
    end
end
addEvent("vehicle.toggle.engine", true)
addEventHandler("vehicle.toggle.engine", root, toggleVehicleEngine)

function makeVehicle(player)
    -- soon
end