local conn = exports.mysql:getConn()
local cache = exports.cache
local _print = outputDebugString

dbQuery(
    function(qh)
        local res, rows, _ = dbPoll(qh, 0)
        for index, row in ipairs(res) do
            local dbid = tonumber(row.id)
            local x, y, z, int, dim = unpack(split(cache:getVehicleData(dbid, "pos"), ","))
            local r, g, b = unpack(split(cache:getVehicleData(dbid, "color"), ","))
            local plate = cache:getVehicleData(dbid, "plate")
            local lock = cache:getVehicleData(dbid, "lock")
            local gta = tonumber(row.gta)
            local veh = createVehicle(gta, x, y, z)
            if veh then
                setVehicleColor(veh, r, g, b)
                setElementInterior(veh, int)
                setElementDimension(veh, dim)
                setVehiclePlateText(veh, plate)
                setElementData(veh, "dbid", dbid)
                if tonumber(lock) == 1 then
                    setVehicleLocked(veh, true)
                else
                    setVehicleLocked(veh, false)
                end
            else
                _print("! VEHICLES FAILED CREATE VEHICLE "..dbid)
            end
        end
    end,
conn, "SELECT id,gta FROM vehicles")

function makeVehicle()
    -- soon
end
