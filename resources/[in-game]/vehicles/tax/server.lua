local tonumber = tonumber
local ipairs = ipairs
local cache = exports.cache

function taxation()
    for _, vehicle in ipairs(getElementsByType("vehicle")) do
        local dbid = getElementData(vehicle, "dbid")
        if cache:getVehicleData(dbid, "job") == 0 then
            local interest = tonumber(cache:getVehicleData(dbid, "interest"))
            if interest == 1 then
                return
            end
            local current = tonumber(getElementData(vehicle, "tax"))
            if current > 25000 then
                setVehicleEngineState(vehicle, false)
                cache:setVehicleData(dbid, "engine", 0)
                cache:setVehicleData(dbid, "interest", 1)
                return
            end
            local add = tonumber(getElementData(vehicle, "carshop_tax"))
            local new = current + add
            setElementData(vehicle, "tax", new)
            cache:setVehicleData(dbid, "tax", new)
        end
    end
end
setTimer(taxation, 3600000, 0)