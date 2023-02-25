-- MySQL sınıfı tanımlama
mysql = {}
mysql.__index = mysql

-- MYSQL BİLGİLERİ
mysql.database = 'roleplay'
mysql.username = 'root'
mysql.password = ''
mysql.hostname = '127.0.0.1'
mysql.port = 3306

-- Yeni bir MySQL nesnesi oluşturma işlevi
function mysql:new(database, username, password, hostname, port)
    local obj = {}
    setmetatable(obj, mysql)

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
function mysql:query(sql, callback)
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
function mysql:close()
    dbConnectionFree(self.connection)
end

mysql:new(mysql.database,mysql.username,mysql.password,mysql.hostname,mysql.port)