fonts = {
    list = {
        ['RobotoB']= 'assets/RobotoB.ttf',
        ['Roboto']= 'assets/Roboto.ttf',
    },

    -- oluşturulan fontlar
    font_cache = {},
    
    get = function(self,name,size)
        local size = size or 9
        local font_konum = self.list[name]

        -- eğer cache'de belirtlilen isim  ve size'da font varsa, tekrar oluşturma.
        if self.font_cache[name.." "..size] then return self.font_cache[name.." "..size] end

        if font_konum then
            self.font_cache[name.." "..size] = DxFont(font_konum, size)
        end 

        return self.font_cache[name.." "..size]
    end,

    index = function(self)
        function get(name,size) return self:get(name,size) end
    end,
}
instance = new(fonts)
instance:index()