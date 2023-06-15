permissions = {
	{"Üyeleri Yönet","manage_members"},
	{"Maaşları Düzenle","manage_payouts"},
	{"Birlik Kasası Yönetimi","manage_bank"},
	{"Kayıtları Görüntüle","show_logs"},
	{"Birlik Envanter Yönetimi","manage_inventory"},
	{"Rütbe Yetkilerini Düzenle","manage_ranks"},
	{"Birlik Notunu Düzenle","manage_note"},
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

function hasPermission(perm_table,permission)
	for i,v in ipairs(perm_table) do
		if v==permission then return true end
	end
	return false
end