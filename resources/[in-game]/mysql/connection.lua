-- MySQL sınıfı tanımlama
mysql = {}
mysql.__index = mysql
mysql.otherConnecions = {}

-- MYSQL BİLGİLERİ
mysql.database = 'roleplay'
mysql.username = 'root'
mysql.password = ''
mysql.hostname = '127.0.0.1'
mysql.port = 3306

-- ID sorgusu yapılcak table isimleri.
mysql.id_tables = {
    "accounts","characters","items"
}
-- idlerin depolancağı tablo.
mysql.id_cache = {}

-- Yeni bir MySQL nesnesi oluşturma işlevi
function mysql:new(database, username, password, hostname, port)
    -- Veritabanına bağlanma
    self.connection = dbConnect("mysql", "dbname=" .. database .. ";host=" .. hostname .. ";port=" .. port, username, password)
    if self.connection then
        outputDebugString('database connection successful')
        self:loadIDCache(1)
    else
        outputDebugString('database connection failed')
    end
    return true
end

function mysql:loadIDCache(i)
    local v = self.id_tables[i]
    if not v then print("! MYSQL ID CACHED") return end
    self.id_cache[v]={}
    dbQuery(function(qh,index,tablename)
        local res, rows, err = dbPoll(qh, 0)
        self.id_cache[tablename]=res[1] and res[1].id or 0

        self:loadIDCache(index+1)
    end,{i,v},self.connection,"SELECT `id` FROM "..v.." ORDER BY id DESC LIMIT 1")
end

-- exports.mysql:getNewID("accounts")
function mysql:getNewID(tablename)
    local id = mysql.id_cache[tablename]
    if not id then return false end

    mysql.id_cache[tablename] = mysql.id_cache[tablename]+1
    return mysql.id_cache[tablename]
end

-- exports.mysql:getConn() // exports.mysql:getConn("connection_name")
function mysql:getConn(connectionName)
    return self.otherConnecions[connectionName] or self.connection
end

-- exports.mysql:newConnect("connection_name","tag=0;log=0")
function mysql:newConnect(connectionName,options)
    if not connectionName then return false end
    if self.otherConnecions[connectionName] then return self.otherConnecions[connectionName] end
    self.otherConnecions[connectionName] = dbConnect("mysql", "dbname=" .. self.database .. ";host=" .. self.hostname .. ";port=" .. self.port, self.username, self.password,options)
    return self.otherConnecions[connectionName]
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


function getConn(...)
    return mysql:getConn(...)
end
function newConnect(...)
    return mysql:newConnect(...)
end
function getNewID(...)
    return mysql:getNewID(...)
end

mysql:new(mysql.database,mysql.username,mysql.password,mysql.hostname,mysql.port)
