fonts = {}
fonts.__index = fonts

function fonts:new()
    local obj = {}
    setmetatable(obj, fonts)

    obj.cache = {}

    obj.list = {
        ['RobotoB'] = 'assets/RobotoB.ttf',
        ['Roboto'] = 'assets/Roboto.ttf'
    }

    return obj
end

function fonts:get(name, size)
    local size = size or 9
    local name = name or 'Roboto'
    local path = self.list[name]

    -- eğer cache'de belirtlilen isim ve size'da font varsa, tekrar oluşturma.
    if self.cache[name..' '..size] then return self.cache[name..' '..size] end

    if path then
        self.cache[name..' '..size] = DxFont(path, size)
    end 

    return self.cache[name..' '..size]
end

local myFonts = fonts:new()
function get(name, size) 
  return myFonts:get(name, size) 
end