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

function enterVehicle(player)
    local vehicle = source
    local playerJob = cache:getCharacterData(getElementData(player, "dbid"), "job") or 0
    local vehicleJob = cache:getVehicleData(getElementData(vehicle, "dbid"), "job") or 0
    if vehicleJob > 0 then
        if playerJob ~= vehicleJob then
            cancelEvent()
        end
    end
end
addEventHandler("onVehicleStartEnter", getRootElement(), enterVehicle)

function makeVehicle(player)
    -- soon
end