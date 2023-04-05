local tonumber = tonumber
local ipairs = ipairs
local cache = exports.cache

function refueling()
    for _, vehicle in ipairs(getElementsByType("vehicle")) do
        local dbid = getElementData(vehicle, "dbid")
        if cache:getVehicleData(dbid, "job") == 0 then return end
        if cache:getVehicleData(dbid, "engine") == 1 then
            local fuel = getElementData(vehicle, "fuel")
            if fuel <= 0 then
                setVehicleEngineState(vehicle, false)
                cache:setVehicleData(dbid, "engine", 0)
                return
            end
            local new = fuel - 1
            setElementData(vehicle, "fuel", new)
            cache:setVehicleData(dbid, "fuel", new)
        end
    end
end
setTimer(refueling, 300000, 0)