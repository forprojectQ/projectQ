local tonumber = tonumber
local ipairs = ipairs
local cache = exports.cache

-- arabanın motoru açık olduğu sürece benzini azalt ve verileri kaydet.
function refueling()
    for _, vehicle in ipairs(getElementsByType("vehicle")) do
        if  cache:getVehicleData(vehicle, "job") == 0 and cache:getVehicleData(vehicle, "engine") == 1 then
            local fuel = getElementData(vehicle, "fuel")
            local odometer = getElementData(vehicle, "odometer")
            if fuel <= 0 then
                setVehicleEngineState(vehicle, false)
                cache:setVehicleData(vehicle, "engine", 0)
                return
            end
            local new = fuel - 1
            setElementData(vehicle, "fuel", new)
            cache:setVehicleData(vehicle, "fuel", new)
            cache:setVehicleData(vehicle, "odometer", odometer)
        end
    end
end
setTimer(refueling, 30000, 0)