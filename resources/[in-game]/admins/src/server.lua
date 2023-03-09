local commands_cache = {}
local cache = exports.cache

function command_function(player, command, ...)
    local index = commands[command]
    if not index then return end
    local cmd = commands[index]
    if not cmd then return end
    local username = cache:getAccountData(player:getData("account.id"), "name")
    local serial = player.serial
    local level = oyuncu:getData("admin") or 0

    if cmd.access and level < cmd.access then return end
    if cmd.account and cmd.account:match(username) ~= username then return end
    if cmd.serial and cmd.serial:match(serial) ~= serial then return end

    cmd.func(player, {...})
end

function process()
    for index, value in ipairs(commands) do
        local cmd = split(value.command, ",")
        for _, command in ipairs(cmd) do
            commands_cache[command] = index
            addCommandHandler(command, command_function)
        end
    end
end

addEventHandler("onResourceStart",resourceRoot,function()
    process()
end)