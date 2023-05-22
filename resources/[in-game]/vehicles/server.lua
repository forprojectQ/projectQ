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

-- Araba load oldukdan sonra veya oluşturuldukdan sonra cacheye gönderilcek fakat sql işlenmicek column isimleri
local noSql_columns = {
	["carshop_price"]=true,["carshop_gta"]=true,["carshop_tax"]=true,["carshop_handling"]=true,["carshop_brand"]=true,["carshop_model"]=true,["carshop_year"]=true,
	["carshop_doortype"]=true,["carshop_fueltype"]=true,["carshop_tanksize"]=true,
	["custom_price"]=true,["custom_brand"]=true,["custom_model"]=true,["custom_year"]=true,["custom_tax"]=true,["custom_handling"]=true,["custom_notes"]=true,
	["custom_doortype"]=true,["custom_fueltype"]=true,["custom_tanksize"]=true,
}

local query_sql = [[
	SELECT 
		v.*,
		vl.price AS carshop_price,
		vl.gta AS carshop_gta,
		vl.tax AS carshop_tax,
		vl.brand AS carshop_brand,
		vl.model AS carshop_model,
		vl.year AS carshop_year,
		vl.handling AS carshop_handling,
		vl.doortype AS carshop_doortype,
		vl.fueltype AS carshop_fueltype,
		vl.tanksize AS carshop_tanksize,
		vc.price AS custom_price,
		vc.brand AS custom_brand,
		vc.model AS custom_model,
		vc.year AS custom_year,
		vc.tax AS custom_tax,		
		vc.handling AS custom_handling,	
		vc.notes AS custom_notes,
		vc.doortype AS custom_doortype,
		vc.fueltype AS custom_fueltype,
		vc.tanksize AS custom_tanksize
	FROM 
		vehicles v 
	LEFT JOIN vehicles_library vl ON 
		v.library_id = vl.id
	LEFT JOIN vehicles_custom vc ON 
		v.id = vc.id	
]]	

function loadAlllVehicle()
	dbQuery(function(qh)
		local res = dbPoll(qh, 0)
		Async:foreach(res, function(row)
			loadOneVehicle(row.id,row,"start")
		end)
	end, conn, query_sql.." WHERE v.enabled=1")
end
addEventHandler("onResourceStart", resourceRoot, loadAlllVehicle)

function reloadVehicle(dbid)
	loadOneVehicle(dbid)
end

-- makeVehicle ile oluştururken sonra tekrar query yapılmaması için row yollanabilir.
function loadOneVehicle(dbid,row,loadtype)
	local veh = getElementByID("vehicle"..dbid)
	if isElement(veh) then destroyElement(veh) end
	-- eğer row argümanı varsa direk onu kullan.
	if row then
		local x, y, z, int, dim, rx, ry, rz = unpack(split(row.pos, ","))
		local veh = createVehicle(tonumber(row.carshop_gta), x, y, z, rx, ry, rz, tostring(row.plate))
		if veh then
			setElementID(veh,"vehicle"..dbid)
			setElementInterior(veh, int)
			setElementDimension(veh, dim)
            setElementData(veh, "window", 0)
			setElementData(veh, "dbid", dbid)
			setElementData(veh, "fuel", tonumber(row.fuel))
			-- draw işlemi yaparken; odometer=string.format("%.3f", (odometer/100)).." km"
			setElementData(veh, "odometer", tonumber(row.odometer or 0)) 
			setElementData(veh, "tax", tonumber(row.tax))
			setElementData(veh, "carshop_price", tonumber(row.custom_price or row.carshop_price))
			setElementData(veh, "carshop_tax", tonumber(row.custom_tax or row.carshop_tax))
			setElementData(veh, "info", {
				library_id = row.library_id,
				brand=tostring(row.custom_brand or row.carshop_brand),
				model=tostring(row.custom_model or row.carshop_model),
				year=tonumber(row.custom_year or row.carshop_year),
				notes=row.custom_notes and tostring(row.custom_notes) or nil,
				doortype = tonumber(row.custom_doortype or row.carshop_doortype),
				fueltype = tonumber(row.custom_fueltype or row.carshop_fueltype),
				tanksize = tonumber(row.custom_tanksize or row.carshop_tanksize),
			})
			setVehicleLocked(veh, tonumber(row.lock) == 1)
			setVehicleEngineState(veh, tonumber(row.engine) == 1)
			setVehicleColor(veh, unpack(split(row.color, ",")))
			for property,value in pairs(fromJSON((row.custom_handling or row.carshop_handling) or "[ [ ] ]") or {}) do
				setVehicleHandling(veh,property,value)
			end
			for slot, upgrade in ipairs(fromJSON(row.upgrades or "[ [ ] ]") or {}) do addVehicleUpgrade(veh, upgrade) end

			for column, value in pairs(row) do
				-- eğer loadtype start ise, noSql_columns olanları cache gönder. çünkü cache reslenmiş ise bu veriler kaybolmuş olacaktır.
				if loadtype =="start" and noSql_columns[column] then
					cache:setVehicleData(dbid, column, value, true)
					
				-- eğer loadtype create ise, tüm verileri cache gönder ve noSql_columns olanlar içinde argüman gönder.	
				elseif loadtype =="create" then
					cache:setVehicleData(dbid, column, value, noSql_columns[column])
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
					loadOneVehicle(res[1].id,res[1],"create")
				end
			end,
		conn, query_sql.." WHERE v.id=? LIMIT 1", dbid)
	end
end

function makeVehicle(libID, owner, job)
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
            local position = x..","..y..","..z..","..interior..","..dimension..","..rx..","..ry..","..rz
            exports.items:giveItem(targetPlayer, 2, nextID)
            dbExec(conn, "INSERT INTO vehicles SET id='"..(nextID).."', library_id='"..(libID).."', owner='"..(pdbid).."', job='"..(tonumber(job)).."', pos='"..(position).."',  plate='"..(tostring(plate)).."'")
			loadOneVehicle(nextID)
            return true
        else
            return false
        end
    else
        return false
    end
end

function deleteVehicle(vehID)
    if tonumber(vehID) then
        local vehicle = exports.global:findVehicle(vehID)
        if vehicle then
            local dbid = getElementData(vehicle, "dbid")
            destroyElement(vehicle)
            dbExec(conn,"UPDATE vehicles SET enabled='0' WHERE id='"..(dbid).."'")
            cache:clearVehicleAllData(dbid)
            return true
        else
            return false
        end
    else
        return false
    end
end

function isVehicleHasCustomRecord(dbid)
	for column,v in pairs(noSql_columns) do
		if column:sub(1,6) == "custom" then
			if cache:getVehicleData(dbid,column) then return true end
		end
	end
	return false
end

function startEnterVehicle(player)
    local vehicle = source
    local playerJob = cache:getCharacterData(player, "job") or 0
    local vehicleJob = cache:getVehicleData(vehicle, "job") or 0
    if vehicleJob > 0 then
        if playerJob ~= vehicleJob then
            outputChatBox("[!]#ffffff Bu aracı kullanabilmek için meslekte olmalısınız.", player, 235, 180, 132, true)
            cancelEvent()
        end
    end
end
addEventHandler("onVehicleStartEnter", getRootElement(), startEnterVehicle)

function enterVehicle(player, seat)
    if seat == 0 then
        local engine = cache:getVehicleData(source, "engine") or 0
        if tonumber(engine) == 0 then
            setVehicleEngineState(source, false)
        end
    end
end
addEventHandler("onVehicleEnter", getRootElement(), enterVehicle)

function exitVehicle(player, seat)
    if seat == 0 then
        local x, y, z = getElementPosition(source)
        local interior, dimension = getElementInterior(source), getElementDimension(source)
        local rx, ry, rz = getElementRotation(source)
        local position = ""..x..","..y..","..z..","..interior..","..dimension..","..rx..","..ry..","..rz..""
        cache:setVehicleData(source, "pos", position)
        setVehicleRespawnPosition(source, x, y, z, rx, ry, rz)
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
                exports.global:sendLocalMeAction(source, "sağ elini cebindeki anahtara götürür ve aracın kilidini açar.")
            else
                cache:setVehicleData(dbid, "lock", 1)
                setVehicleLocked(vehicle, true)
                exports.global:sendLocalMeAction(source, "sağ elini cebindeki anahtara götürür ve aracı kilitler.")
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
        exports.global:sendLocalMeAction(source, "aracın camlarını açar.")
    else
        setElementData(vehicle, "window", 1)
        exports.global:sendLocalMeAction(source, "aracın camlarını kapatır.")
    end
end
addEvent("vehicle.toggle.windows", true)
addEventHandler("vehicle.toggle.windows", root, toggleVehicleWindows)

function toggleVehicleLights(vehicle)
    local engine = cache:getVehicleData(vehicle, "engine") or 0
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
    local faction = cache:getVehicleData(dbid, "faction") or 0

    if job == 0 then
        if faction == 0 then
            if not exports.items:hasItem(source, 2, dbid) then
                return
            end
        else
            local pFaction = cache:getCharacterData(source, "faction") or 0
            if pFaction ~= faction then
                return
            end
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
        exports.global:sendLocalMeAction(source, "anahtarı cebinden çıkarıp kontağa takar ve motoru çalıştırmayı dener.")
        setTimer(function(thePlayer, theVehicle)
            local chance = math.random(1, 3)
            if chance == 1 then
                exports.global:sendLocalDoAction(thePlayer, "aracın motorunu çalıştıramaz.")
            else
                exports.global:sendLocalDoAction(thePlayer, "aracın motoru çalışmıştır.")
                setVehicleEngineState(theVehicle, true)
                cache:setVehicleData(theVehicle, "engine", 1)
            end
        end, 1500, 1, source, vehicle)
    else
        setVehicleOverrideLights(vehicle, 1)
        setVehicleEngineState(vehicle, false)
        cache:setVehicleData(dbid, "engine", 0)
        exports.global:sendLocalMeAction(source, "aracın motorunu durdurur ve anahtarı cebine atar.")
    end
end
addEvent("vehicle.toggle.engine", true)
addEventHandler("vehicle.toggle.engine", root, toggleVehicleEngine)