function formatMoney(amount)
    local left,num,right = string.match(tostring(amount),'^([^%d]*%d)(%d*)(.-)$')
    return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end