Async:setPriority("low")
local createVehicle = createVehicle
local setVehicleColor = setVehicleColor
local setElementInterior = setElementInterior
local setElementDimension = setElementDimension
local setVehiclePlateText = setVehiclePlateText
local setElementData = setElementData
local setVehicleLocked = setVehicleLocked
local setVehicleEngineState = setVehicleEngineState
local triggerClientEvent = triggerClientEvent
local addEvent = addEvent
local addEventHandler = addEventHandler
local tonumber = tonumber
local split = split
local exports = exports
local setElementData = setElementData
local conn = exports.mysql:getConn()
local cache = exports.cache
local _print = outputDebugString
local ipairs = ipairs

function loadAlllVehicle()
	dbQuery(function(qh)
		local res = dbPoll(qh, 0)
		Async:foreach(res, function(row)
			loadOneVehicle(row.id,row)
		end)
	end, conn, "SELECT v.*,vl.price AS carshop_price,vl.gta AS carshop_gta,vl.tax AS carshop_tax,vl.handling AS carshop_handling FROM vehicles v LEFT JOIN vehicles_library vl ON v.library_id = vl.id")
end
addEventHandler("onResourceStart", resourceRoot, loadAlllVehicle)

-- makeVehicle ile oluştururken sonra tekrar query yapılmaması için row yollanabilir.
function loadOneVehicle(dbid,row)
	local veh = getElementByID("vehicle"..dbid)
	if isElement(veh) then destroyElement(veh) end
	-- eğer row argümanı varsa direk onu kullan.
	if row then
		local dbid = tonumber(row.id)
		local libid = tonumber(row.library_id)
		local x, y, z, int, dim, rx, ry, rz = unpack(split(row.pos, ","))
		local veh = createVehicle(tonumber(row.carshop_gta), x, y, z)
		if veh then
			setElementID(veh,"vehicle"..dbid)
			setVehicleColor(veh, unpack(split(row.color, ",")))
			setElementInterior(veh, int)
			setElementDimension(veh, dim)
            setElementRotation(veh, rx, ry, rz)
			setVehiclePlateText(veh, tostring(row.plate))
            setElementData(veh, "window", 0)
			setElementData(veh, "dbid", dbid)
			setElementData(veh, "fuel", tonumber(row.fuel))
			setElementData(veh, "tax", tonumber(row.tax))
			setElementData(veh, "carshop_price", tonumber(row.carshop_price))
			setElementData(veh, "carshop_tax", tonumber(row.carshop_tax))
			setVehicleLocked(veh, tonumber(row.lock) == 1)
			setVehicleEngineState(veh, tonumber(row.engine) == 1)
			for property,value in pairs(fromJSON(row.carshop_handling or "[ [ ] ]") or {}) do
				setVehicleHandling(veh,property,value)
			end
			if row.handling then
				-- eğer aracın özel handı varsa önce handı sıfırla ve sonra özel handı yükle
				setVehicleHandling(veh, false) 
				for property,value in pairs(fromJSON(row.handling or "[ [ ] ]") or {}) do
					setVehicleHandling(veh,property,value)
				end
			end
		else
			_print("! VEHICLES FAILED CREATE VEHICLE "..dbid)
		end
	else
		-- eğer row argümanı yoksa dbQuery yap ve tekrar aynı fonksiyonu row argümanı vererek çağır.
		-- böylelikle yukardaki kodları tekrar yazmaya gerek yok
		dbQuery(
			function(qh)
				local res, rows, err = dbPoll(qh, 0)
				if rows > 0 then
					loadOneVehicle(res[1].id,res[1])
				end
			end,
		conn, "SELECT v.*,vl.price AS carshop_price,vl.gta AS carshop_gta,vl.tax AS carshop_tax,vl.handling AS carshop_handling FROM vehicles v LEFT JOIN vehicles_library vl ON v.library_id = vl.id WHERE v.id=? LIMIT 1", dbid)
	end
end

function makeVehicle(admin, libID, owner, job)
    if tonumber(libID) and tonumber(owner) and tonumber(job) then
        local targetPlayer, targetPlayerName = exports.global:findPlayer(owner)
        if targetPlayer then
            local nextID = exports.mysql:getNewID("vehicles")
            local pdbid = getElementData(targetPlayer, "dbid")
            local plate = exports.global:createRandomPlateText()
            local x, y, z = getElementPosition(targetPlayer)
            local interior, dimension = getElementInterior(targetPlayer), getElementDimension(targetPlayer)
            local rx, ry, rz = getElementRotation(targetPlayer)
			x = x + (( math.cos(math.rad(rz))) * 5)
			y = y + (( math.sin(math.rad(rz))) * 5)
            local position = ""..x..","..y..","..z..","..interior..","..dimension..","..rx..","..ry..","..rz..""
            exports.items:giveItem(targetPlayer, 2, nextID)
            dbExec(conn, "INSERT INTO vehicles SET id='"..(nextID).."', library_id='"..(libID).."', owner='"..(pdbid).."', job='"..(tonumber(job)).."', pos='"..(position).."',  plate='"..(tostring(plate)).."'")
			dbQuery(
                function(qh)
                    local res, rows = dbPoll(qh, -1)
                    if res then
                        if rows > 0 then
                            local dbid = tonumber(res[1].id)
                            for index, row in ipairs(res) do
                                for column, value in pairs(row) do
                                    --carshop columnlarını cache ekleme
                                    if column:sub(1,7) ~= "carshop" then
                                        cache:setVehicleData(dbid, column, value)
                                    end	
                                end
                            end
                            loadOneVehicle(dbid,res[1])
                        end
                    end
                end,
            conn, "SELECT v.*,vl.price AS carshop_price,vl.gta AS carshop_gta,vl.tax AS carshop_tax,vl.handling AS carshop_handling FROM vehicles v LEFT JOIN vehicles_library vl ON v.library_id = vl.id WHERE v.id=? LIMIT 1", nextID)
        else
            outputChatBox("[!]#ffffff Oyuncu bulunamadı, veya giriş yapmamış.", admin, 235, 180, 132, true)
        end
    else
        outputChatBox("[!]#ffffff /makeveh [Kütüphane ID] [Sahip] [Meslek(0 = Şahsi Araç)]", admin, 235, 180, 132, true)
    end
end

function deleteVehicle(admin, vehID)
    if tonumber(vehID) then
        local vehicle = exports.global:findVehicle(vehID)
        if vehicle then
            local dbid = getElementData(vehicle, "dbid")
            destroyElement(vehicle)
            dbExec(conn, "DELETE FROM vehicles WHERE id = '"..(dbid).."'")
            cache:clearVehicleAllData(dbid)
            outputChatBox("[!]#ffffff #"..dbid.." başarıyla silindi.", admin, 255, 0, 0, true)
        else
            outputChatBox("[!]#ffffff Araç bulunamadı veya yanlış ID girdiniz.", admin, 235, 180, 132, true)
        end
    else
        outputChatBox("[!]#ffffff /delveh [Araç ID]", admin, 235, 180, 132, true)
    end
end

function startEnterVehicle(player)
    local vehicle = source
    local playerJob = cache:getCharacterData(getElementData(player, "dbid"), "job") or 0
    local vehicleJob = cache:getVehicleData(getElementData(vehicle, "dbid"), "job") or 0
    if vehicleJob > 0 then
        if playerJob ~= vehicleJob then
            outputChatBox("[!]#ffffff Bu aracı kullanabilmek için meslekte olmalısınız.", player, 235, 180, 132, true)
            cancelEvent()
        end
    end
end
addEventHandler("onVehicleStartEnter", getRootElement(), startEnterVehicle)

function enterVehicle(player, seat)
    local dbid = getElementData(source, "dbid")
    if seat == 0 then
        local engine = cache:getVehicleData(dbid, "engine") or 0
        if tonumber(engine) == 0 then
            setVehicleEngineState(source, false)
        end
    end
end
addEventHandler("onVehicleEnter", getRootElement(), enterVehicle)

function exitVehicle(player, seat)
    local dbid = getElementData(source, "dbid")
    if seat == 0 then
        local x, y, z = getElementPosition(source)
        local interior, dimension = getElementInterior(source), getElementDimension(source)
        local rx, ry, rz = getElementRotation(source)
        local position = ""..x..","..y..","..z..","..interior..","..dimension..","..rx..","..ry..","..rz..""
        cache:setVehicleData(dbid, "pos", position)
    end
end
addEventHandler("onVehicleExit", getRootElement(), exitVehicle)

function toggleVehicleLock(key)
    local x, y, z = getElementPosition(source)
    for _, vehicle in ipairs(getElementsByType("vehicle")) do
        local vx, vy, vz = getElementPosition(vehicle)
        if getDistanceBetweenPoints3D(x, y, z, vx, vy, vz) <= 5 then
            local dbid = getElementData(vehicle, "dbid")
            if key then
                if key ~= dbid then
                    return
                end
            end
            if not exports.items:hasItem(source, 2, dbid) then
                return
            end
            local lock = cache:getVehicleData(dbid, "lock") or 0
            if lock == 1 then
                cache:setVehicleData(dbid, "lock", 0)
                setVehicleLocked(vehicle, false)
            else
                cache:setVehicleData(dbid, "lock", 1)
                setVehicleLocked(vehicle, true)
            end
            triggerClientEvent("vehicle.effect.3d", root, "assets/lock.wav", vx, vy, vz)
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
addEvent("vehicle.toggle.lock", true)
addEventHandler("vehicle.toggle.lock", root, toggleVehicleLock)

function toggleVehicleWindows(vehicle)
    local window = tonumber(getElementData(vehicle, "window")) or 0 --// ( 0 KAPALI / 1 AÇIK)
    local x, y, z = getElementPosition(vehicle)
    triggerClientEvent("vehicle.effect.3d", root, "assets/window.wav", x, y, z)
    if window == 1 then
        setElementData(vehicle, "window", 0)
    else
        setElementData(vehicle, "window", 1)
    end
end
addEvent("vehicle.toggle.windows", true)
addEventHandler("vehicle.toggle.windows", root, toggleVehicleWindows)

function toggleVehicleLights(vehicle)
    local dbid = getElementData(vehicle, "dbid")
    local engine = cache:getVehicleData(dbid, "engine") or 0
    if engine == 1 then
        if getVehicleOverrideLights(vehicle) ~= 2 then
            setVehicleOverrideLights(vehicle, 2)
        else
            setVehicleOverrideLights(vehicle, 1)
        end
    end
end
addEvent("vehicle.toggle.lights", true)
addEventHandler("vehicle.toggle.lights", root, toggleVehicleLights)

function toggleVehicleEngine(vehicle)
    local x, y, z = getElementPosition(vehicle)
    local dbid = getElementData(vehicle, "dbid")
    local engine = cache:getVehicleData(dbid, "engine") or 0
    local fuel = getElementData(vehicle, "fuel")
    local job = cache:getVehicleData(dbid, "job")
    local interest = cache:getVehicleData(dbid, "interest") or 0

    if job == 0 then
        if not exports.items:hasItem(source, 2, dbid) then
            return
        end
        if interest == 1 then
            outputChatBox("[!]#ffffff Aracınız faize bağlanmış.", source, 235, 180, 132, true)
            return
        end
        if fuel <= 0 then
            outputChatBox("[!]#ffffff Aracınızın yakıtı bitmiş.", source, 235, 180, 132, true)
            return
        end
    end

    if tonumber(engine) == 0 then
        triggerClientEvent("vehicle.effect.3d", root, "assets/engine.wav", x, y, z)
        setTimer(function()
            local chance = math.random(1, 3)
            if chance == 1 then
                outputChatBox("[!]#ffffff Aracın motorunu çalıştıramadınız.", source, 235, 180, 132, true)
            else
                setVehicleEngineState(vehicle, true)
                cache:setVehicleData(dbid, "engine", 1)
            end
        end, 1500, 1, source, vehicle)
    else
        setVehicleOverrideLights(vehicle, 1)
        setVehicleEngineState(vehicle, false)
        cache:setVehicleData(dbid, "engine", 0)
    end
end
addEvent("vehicle.toggle.engine", true)
addEventHandler("vehicle.toggle.engine", root, toggleVehicleEngine)