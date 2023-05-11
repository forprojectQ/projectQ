local prevX, prevY, prevZ = 0
local timerIntervall = 10000
local maxDistance = timerIntervall
noFuelVehicles = {
    ["Boat"] = true,
    ["Train"] = true,
    ["Trailer"] = true,
    ["BMX"] = true,
}

-- araba hareket ettiği sürece km sayacı ve gittiğie yola göre benzin azaltma. 
--(server.lua da da benzin azaltma var fakat o hem kayıt için hem de araba hareket etmese bile ama motoru açık olsa bile benzin azaltmak için.)
function calculateDistance()
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if not isElement(vehicle) or getVehicleController(vehicle) ~= localPlayer or isElementFrozen(vehicle) or not isControlEnabled("forwards") then
		return
	end
	if getVehicleType(vehicle) ~= "Plane" and not isVehicleOnGround ( vehicle ) then return end
	local x,y,z = getElementPosition(vehicle)
	if prevX ~= 0 then
		local distanceSinceLast = ((x-prevX)^2 + (y-prevY)^2 + (z-prevZ)^2)^(0.5)
		if distanceSinceLast < maxDistance then
			local total = tonumber(getElementData(vehicle,"odometer")) or 0
			local fuel = tonumber(getElementData(vehicle,"fuel")) or 0
			if fuel > 0  then
				local newfuel = math.floor(distanceSinceLast)/1000
				local vtype = getVehicleType(vehicle) 
				if newfuel > 0 and not noFuelVehicles[vtype]  then
					setElementData(vehicle,"fuel",fuel-(newfuel))
				end
			end
			setElementData(vehicle,"odometer",total+distanceSinceLast)
		end
	end
	prevX,prevY,prevZ = x,y,z
end
setTimer(calculateDistance,timerIntervall,0)