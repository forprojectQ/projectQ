local launcher = {}
launcher.__index = launcher
local _print = outputDebugString

function launcher:new(name, priority)
    local resource = {}
    setmetatable(resource, launcher)
    resource.name = name
    resource.priority = priority or 0
    return resource
end

-- Resource listesi
local resources = {
    -- isim, sıra/öncelik
    launcher:new("mysql", 1),
    launcher:new("cache", 2),
    launcher:new("dxlibrary", 3),
    launcher:new("fonts", 4),
    launcher:new("global", 5),
    launcher:new("identity", 6),
    launcher:new("account", 7),
    launcher:new("items", 8),
    launcher:new("admins", 9),
    launcher:new("vehicleslibrary", 10),
    launcher:new("cursor", 11),
    launcher:new("living", 12),
    launcher:new("vehicles", 13),
    launcher:new("essantials", 14),
    launcher:new("chat", 15),
}

local loaded = 0
local max = #resources
local delay = 0

addEventHandler ("onPlayerConnect", getRootElement(), function()
    if max ~= loaded then
        cancelEvent(true, "Tüm sistemler başlatılmamış, lütfen biraz bekleyin.")
    end
end)

function launcher:launch()
    setTimer(function()
        loaded = loaded + 1
        _print("Resource "..self.name.." started. "..loaded.."/"..max.."")
        Resource.getFromName(self.name):start()
    end, delay * 1000, 1)
end

table.sort(resources, function(a,b) return a.priority < b.priority end)

for index, resource in ipairs(resources) do
    resource:launch()
    delay = delay + 2
end