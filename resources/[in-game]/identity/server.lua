local identity = class("IDENTITY")

function identity:init()
    self.identitys = {}
	self.maxPlayers = getMaxPlayers()

	addEventHandler("onPlayerJoin", resourceRoot, function() self:onJoin(source) end)
	addEventHandler("onPlayerQuit", resourceRoot, function() self:onQuit(source) end)
end

function identity:onJoin(player)
	local identity

	for i = 1, self.maxPlayers do
		if not self.identitys[i] then
			identity = i
			break
		end
	end

	if identity then
		self.identitys[identity] = player
		player:setID("player" .. identity)
		player:setData("playerid", identity)
	end
end

function identity:onQuit(player)
	local identity = tonumber(player:getData("playerid"))
	self.identitys[identity] = nil
	collectgarbage("collect")
end

identity:new()