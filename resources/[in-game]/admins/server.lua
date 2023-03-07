local komut_cache = {}
local cache = exports.cache

addEventHandler("onResourceStart",resourceRoot,function()
    komutlari_isle()
end)

function komut_fonksiyon(oyuncu,cmd,...)
    local komut_index = komut_cache[cmd]
    if not komut_index then return end
    local komut = komutlar[komut_index]
    if not komut then return end
    local hesap_ismi = cache:getAccountData(oyuncu:getData("account.id"),"name")
    local serial = oyuncu.serial
    local oyuncu_yetki_level = oyuncu:getData("admin") or 0   

    if komut.yetki and oyuncu_yetki_level < komut.yetki then return end
    if komut.hesap and komut.hesap:match(hesap_ismi) ~= hesap_ismi then return end
    if komut.serial and komut.serial:match(serial) ~= serial then return end

    komut.fnc(oyuncu,{...})
end

function komutlari_isle()
    for i,v in ipairs(komutlar) do
        local k = split(v.komut,",")
        for _,komut in ipairs(k) do
            komut_cache[komut]=i
            addCommandHandler(komut,komut_fonksiyon)
        end
    end
end