localPlayer:setData("message.target", nil)

bindKey("b", "down", "chatbox", "LocalOOC")
bindKey("u" , "down" , "chatbox", "quickreply")

addEventHandler("onClientKey", root, 
    function(button)
        if button == "y" then
            cancelEvent()
        end
    end
)

addEvent("play.effectPM", true)
addEventHandler("play.effectPM", root, 
    function()
        Sound("assets/pmEffect.mp3")
    end
)

addCommandHandler("clearchat",
	function()
		for i = 1, 50 do
			outputChatBox(" ")
		end
	end, false, false
)