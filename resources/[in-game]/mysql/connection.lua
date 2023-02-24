-- MySQL sınıfı tanımlama
MySQL = {}
MySQL.__index = MySQL

-- MYSQL BİLGİLERİ
MySQL.database = 'roleplay'
MySQL.username = 'root'
MySQL.password = ''
MySQL.hostname = '127.0.0.1'
MySQL.port = 3306

-- Yeni bir MySQL nesnesi oluşturma işlevi
function MySQL:new(database, username, password, hostname, port)
    local obj = {}
    setmetatable(obj, MySQL)

    -- Veritabanına bağlanma
    obj.connection = dbConnect("mysql", "dbname=" .. database .. ";host=" .. hostname .. ";port=" .. port, username, password)
    if obj.connection then
        outputDebugString('database connection successful')
    else
        outputDebugString('database connection failed')
    end

    function getConn() return obj.connection end

    return obj
end

-- MySQL sorgusu çalıştırma işlevi
function MySQL:query(sql, callback)
    local query = dbQuery(self.connection, sql)
    local result, num_affected_rows, last_insert_id = dbPoll(query, -1)

    if result == nil then
        outputDebugString("MySQL query error: " .. dbErrorMessage())
        return false
    end

    if callback then
        callback(result, num_affected_rows, last_insert_id)
    end

    return result, num_affected_rows, last_insert_id
end

-- MySQL nesnesini kapatma işlevi
function MySQL:close()
    dbConnectionFree(self.connection)
end

MySQL:new(MySQL.database,MySQL.username,MySQL.password,MySQL.hostname,MySQL.port)