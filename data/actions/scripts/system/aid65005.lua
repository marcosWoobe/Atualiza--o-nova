function onUse(cid, item)
	if getPlayerStorageValue(cid, 65005) ~= 1 then
		doPlayerAddItem(cid, 11641, 1)
		setPlayerStorageValue(cid, 65005, 1)
		doPlayerSendTextMessage(cid, 27, "Parab�ns voc� acabou de completar a quest box " .. getItemNameById(11641) .. ".")
	else
		doPlayerSendTextMessage(cid, 27, "Voc� j� recebeu esta recompensa.")
	end
return true
end