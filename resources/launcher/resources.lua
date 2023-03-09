local launcher = {}
launcher.__index = launcher

function launcher:new(name, priority)
    local resource = {}
    setmetatable(resource, launcher)
    resource.name = name
    resource.priority = priority or 0
    return resource
end

function launcher:launch()
    print("Starting "..self.name)
    Resource.getFromName(self.name):start()
end

-- Resource listesi
local resources = {
    -- isim, sıra/öncelik
    launcher:new("mysql", 1),
    launcher:new("cache", 2),
    launcher:new("fonts", 3),
    launcher:new("account", 4),
    launcher:new("items", 5),
    launcher:new("admins", 6),
    launcher:new("vehicleslibrary", 7),
}

table.sort(resources, function(a,b) return a.priority < b.priority end)

for _, resource in ipairs(resources) do
    resource:launch()
end
