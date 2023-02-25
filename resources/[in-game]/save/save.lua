local _print = outputDebugString

save = {

    mysql = exports.mysql:getConn(),

    set = function(self)

        local data = source:getData('characterDatas')

        if data then
            
            local pos = table.concat({source.position.x, source.position.y, source.position.z,source.interior, source.dimension},",")

            local money, model, hunger, thirst, dbid = source:getData('money'), source.model, source:getData('hunger'), source:getData('thirst'), source:getData('dbid')

            local query = self.mysql:exec("UPDATE `characters` SET `money`='"..(money).."', `model`='"..(model).."', `hunger`='"..(hunger).."', `thirst`='"..(thirst).."', `pos`='"..(pos).."'  WHERE `id`='"..(dbid).."'")
            
            if not query then
                _print('failed to save, '..source.name)
            end

        end

    end,

    index = function(self)

        self.apply = function(...) self:set(...) end

        addEvent('save.player', true)
        addEventHandler('save.player', root, self.apply)

        addEventHandler('onPlayerQuit', root, self.apply)
        
    end,
}
instance = new(save)
instance:index()
