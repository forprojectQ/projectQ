--[[
-- Player // Oyuncu
    "online" --> Oyuncu hesaba girince belirlenir. (true/false)
    "admin" --> Oyuncunun admin levelini belirler. (sayı // 1 REHBER)
    "account.id" --> Oyuncun hesabının id. (sayı)
    "account.name" --> Oyununcun hesap ismi. (yazı)
    "account.limit" --> Oyuncunun açabilcğei max hesap limiti. (sayı) (standart 3 sqlden ayarlanır.)
    "dbid" --> Oyuncunun karakterinin id. (sayı)
    "money" --> Oyuncunun karakterinin parası. (sayı)
    "hunger" --> Oyuncunun karakterinin açlık seviyesi. (sayı)
    "thirst" --> Oyuncunun karakterinin susuzluk seviyesi. (sayı)
    "characterDatas" --> Oyuncunu bazı karakter bilgileri. (tablo)
    characterDatas = {
        age=Oyuncunu karakterinin yaşı (sayı),
        height=Oyuncunu karakterinin boyu (sayı),
        weight=Oyuncunu karakterinin kilosu (sayı),
        gender=Oyuncunu karakterinin cinsiyeti (sayı) (1= erkek,2=kadın),
    }

--]]