function formatMoney(amount)
    if tonumber(amount) then
        local left,num,right = string.match(tostring(amount),'^([^%d]*%d)(%d*)(.-)$')
        return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
    end
    return "0"
end

function getTimeStamp()
    return os.date('%Y-%m-%d %H:%M:%S')
end