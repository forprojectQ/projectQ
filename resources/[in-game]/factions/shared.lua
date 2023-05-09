permissions = {
    [1] = "Üyeleri Yönet",
    [2] = "Maaşları Düzenle",
    [3] = "Birlik Kasası Yönetimi",
    [4] = "Kayıtları Görüntüle",
    [5] = "Birlik Envanter Yönetimi",
    [6] = "Rütbe Yetkilerini Düzenle",
    [7] = "Birlik Notunu Düzenle"
}

types = {
    [1] = "Devlet Oluşumu",
    [2] = "Sivil Oluşum",
    [3] = "Kriminal Oluşum",
}

function getPermName(ID)
    return permissions[ID] or "null"
end

function getTypeName(ID)
    return types[ID] or "null"
end