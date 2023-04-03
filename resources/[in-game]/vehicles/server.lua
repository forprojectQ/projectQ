local setElementData = setElementData
local exports = exports
local tonumber = tonumber
local ipairs = ipairs
local conn = exports.mysql:getConn()
local cache = exports.cache
local _print = outputDebugString

dbQuery(
    function(qh)
        local res, rows, _ = dbPoll(qh, 0)
        for index, row in ipairs(res) do
            local dbid = tonumber(row.id)
            local libid = tonumber(row.library_id)
            local x, y, z, int, dim = unpack(split(cache:getVehicleData(dbid, "pos"), ","))
            local r, g, b = unpack(split(cache:getVehicleData(dbid, "color"), ","))
            local plate = cache:getVehicleData(dbid, "plate")
            local lock = cache:getVehicleData(dbid, "lock")
            local fuel = cache:getVehicleData(dbid, "fuel")
            local tax = cache:getVehicleData(dbid, "tax")
            dbQuery(
                function(qh)
                    local res, rows, _ = dbPoll(qh, 0)
                    for index, row in ipairs(res) do
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
                            else
                                _print("! VEHICLES FAILED CREATE VEHICLE "..dbid)
                            end
                            break
                        end
                    end
                end,
            conn, "SELECT * FROM vehicles_library")
        end
    end,
conn, "SELECT * FROM vehicles")

function makeVehicle()
    -- soon
end