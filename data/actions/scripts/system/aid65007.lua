function onUse(cid, item)
	if getPlayerStorageValue(cid, 65007) ~= 1 then
		local item1 = doPlayerAddItem(cid, 11447, 3)
		local item2 = doPlayerAddItem(cid, 11442, 3)
		local item3 = doPlayerAddItem(cid, 11441, 3)
		doItemSetAttribute(item1, "unique", getCreatureName(cid))
		doItemSetAttribute(item2, "unique", getCreatureName(cid))
		doItemSetAttribute(item3, "unique", getCreatureName(cid))
		setPlayerStorageValue(cid, 65007, 1)
		doPlayerSendTextMessage(cid, 27, "Parabéns você acabou é um novo treinador e ganhou recompensas por iniciar.")
	else
		doPlayerSendTextMessage(cid, 27, "Você já recebeu esta recompensa.")
	end
return true
end