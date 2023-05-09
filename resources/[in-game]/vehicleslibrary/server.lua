local conn = exports.mysql:getConn()
local cache = exports.cache


function getSqlText(t)
    local sql = ""
    for key,v in pairs(t) do
        sql = sql..key.."='"..(v).."',"
    end  
    return sql:sub(1,-2) 
end    

addEvent("vehicle.library.edit", true)
addEventHandler("vehicle.library.edit", root, function(id, info)
    local sql = getSqlText(info)
    local sql = sql..",updatedby='"..(cache:getAccountData(source,"id")).."',updatedate=current_timestamp()"
    local query = dbExec(conn, "UPDATE vehicles_library SET "..sql.." WHERE id=?", id)

    if query then
        source:outputChat("[!]#ffffff Araç veri tabanına başarılı bir şekilde kaydedildi.", 111, 72, 201, true)
        source:outputChat("[!]#ffffff Değişikler araçlara işlendi.", 111, 72, 201, true)
        for _, vehicle in ipairs(Element.getAllByType("vehicle")) do
            local vehInfo = vehicle:getData("info")
            if vehInfo then
                if vehInfo.library_id == id then
                    local dbid = vehicle:getData("dbid")
                    exports.vehicles:reloadVehicle(dbid)
                end
            end
        end
    else
        source:outputChat("[!]#ffffff Araç veri tabanına kayedilirken bir sorun oluştu.", 111, 72, 201, true)
    end
end)

addEvent("vehicle.library.create", true)
addEventHandler("vehicle.library.create", root, function(info)
    local sql = getSqlText(info)
    local sql = sql..",updatedby='"..(cache:getAccountData(source,"id")).."',updatedate=current_timestamp()"
    local query = dbExec(conn, "INSERT INTO vehicles_library SET "..sql)   
    if query then
        source:outputChat("[!]#ffffff Araç veri tabanına başarılı bir şekilde kaydedildi.", 111, 72, 201, true)
    else
        source:outputChat("[!]#ffffff Araç veri tabanına kayedilirken bir sorun oluştu.", 111, 72, 201, true)
    end
end)