fonts = {}
fonts.__index = fonts

function fonts:new()
    local obj = {}
    setmetatable(obj, fonts)

    obj.cache = {}

    obj.list = {
        ['RobotoB'] = 'assets/RobotoB.ttf',
        ['Roboto'] = 'assets/Roboto.ttf',
        ['AwesomeSolid'] = 'assets/FontAwesomeSolid.otf',
        ['AwesomeRegular'] = 'assets/FontAwesomeRegular.otf'
    }

    --// https://fontawesome.com/search?m=free&o=r
    obj.icons = {
        ['user'] = '',
        ['key'] = '',
        ['person-circle-plus'] = '',
        ['arrow-right'] = '',
        ['moon'] = '',
        ['mail'] = '@',
        ['sun'] = '',
        ['light'] = '',
        ['login'] = '',
        ['location'] = '',
        ['github'] = '',
        ['palette'] = '',
        ['load'] = '',
        ['fork'] = '',
        ['volume-off'] = '',
        ['hand-holding-heart'] = '',
        ['skull'] = '',
        ['volume-on'] = '',
        ['heart'] = '',
        ['plus'] = '+',
        ['eye'] = '',
        ['eye-slash'] = '',
        ['person'] = '',
        ['person-dress'] = ''
    }

    return obj
end

function fonts:getFont(name, size)
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

function fonts:getIcon(name)
    return self.icons[name]
end

local myFonts = fonts:new()

function getFont(name, size)
  return myFonts:getFont(name, size)
end

function getIcon(name)
  return myFonts:getIcon(name)
end