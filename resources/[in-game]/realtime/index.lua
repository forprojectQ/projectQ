local getRealTime = getRealTime
local setTime = setTime
real = {
    set = function(self)
        self.time = getRealTime() 
        self.hour = self.time.hour 
        self.minute = self.time.minute 
        setTime(self.hour,self.minute) 
    end,

    index = function(self)
        self.apply = function(...) self:set(...) end
        Timer(self.apply,60000,0)
    end,
}
instance = new(real)
instance:index()