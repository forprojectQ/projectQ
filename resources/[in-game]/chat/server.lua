local keyWords = {
    [":)"] = "gülümser.",
    [":D"] = "kahkaha atar.",
    [";)"] = "göz kırpar.",
    ["O.o"] = "sol kaşını havaya kaldırır.",
    ["o.O"] = "sağ kaşını havaya kaldırır.",
}

addEventHandler("onPlayerChat", root, 
    function(message, messageType)
        if source:getData("online") then
            if messageType == 0 then
                if keyWords[message] then
                    exports.global:sendLocalMeAction(source,  keyWords[message])
                else
                    exports.global:sendLocalText(source, message)
                end
            elseif messageType == 1 then
                exports.global:sendLocalMeAction(source, message)
            end
        end
        cancelEvent()
    end
)

addCommandHandler("do", 
    function(player, command, ...)
        if player:getData("online") then
            if (...) then
                local message = table.concat({...}, " ")
                exports.global:sendLocalDoAction(player, message)
            end
        end
    end, false, false
)

addCommandHandler("me", 
    function(player, command, ...)
        if player:getData("online") then
            if (...) then
                local message = table.concat({...}, " ")
                exports.global:sendLocalMeAction(player, message)
            end
        end
    end, false, false
)

addCommandHandler("pm", 
    function(player, command, target, ...)
        if player:getData("online") then
            if target and (...) then
                local targetPlayer = exports.global:findPlayer(target)
                if targetPlayer then
                    local message = table.concat({...}, " ")
                    triggerClientEvent(targetPlayer, "play.effectPM", targetPlayer)
                    targetPlayer:setData("message.target", player)
                    player:outputChat("Giden PM: "..message.." ("..targetPlayer.name:gsub("_", " ")..")", 206, 172, 61)
                    targetPlayer:outputChat("Gelen PM: "..message.." ("..player.name:gsub("_", " ")..")", 206, 172, 61)
                else
                    player:outputChat("[!] Oyuncu giriş yapmamış veya yanlış ID tuşladınız.", 206, 172, 61)
                end
            else
                player:outputChat("Kullanım: /"..(command).." [ID] [İleti]", 206, 172, 61)
            end
        end
    end, false, false
)

function quickReply(player, command, ...)
    if player:getData("online") then
        if (...) then
            local targetPlayer = player:getData("message.target") or nil
            if targetPlayer then
                local message = table.concat({...}, " ")
                triggerClientEvent(targetPlayer, "play.effectPM", targetPlayer)
                targetPlayer:setData("message.target", player)
                player:outputChat("Giden PM: "..message.." ("..targetPlayer.name:gsub("_", " ")..")", 206, 172, 61)
                targetPlayer:outputChat("Gelen PM: "..message.." ("..player.name:gsub("_", " ")..")", 206, 172, 61)
            else
                player:outputChat("Kimse sana PM atmamış :(", 206, 172, 61)
            end
        end
    end
end
addCommandHandler("qr", quickReply, false, false)
addCommandHandler("quickreply", quickReply)

function localOOC(player, command, ...)
    if player:getData("online") then
        --// yoruldum :(
    end
end
addCommandHandler("b", localOOC, false, false)
addCommandHandler("LocalOOC", localOOC)