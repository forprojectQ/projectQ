local identity = class("IDENTITY")

function identity:init()
    self.identitys = {}
	self.maxPlayers = getMaxPlayers()

	addEventHandler("onPlayerJoin", root, function(player) self:onJoin(player) end)
	addEventHandler("onPlayerQuit", root, function(player) self:onQuit(player) end)
end

function identity:onJoin()
	local identity

	for i = 1, self.maxPlayers do
		if not self.identitys[i] then
			identity = i
			break
		end
	end

	if identity then
		self.identitys[identity] = source
		source:setID("player" .. identity)
		source:setData("playerid", identity)
	end
end

function identity:onQuit()
	local identity = tonumber(source:getData("playerid"))
	self.identitys[identity] = nil
	collectgarbage("collect")
end

identity:new()