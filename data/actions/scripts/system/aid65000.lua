function onUse(cid, item)
	if getPlayerStorageValue(cid, 65000) ~= 1 then
		doPlayerAddItem(cid, 11638, 1)
		setPlayerStorageValue(cid, 65000, 1)
		doPlayerSendTextMessage(cid, 27, "Parab�ns voc� acabou de completar a quest box " .. getItemNameById(11638) .. ".")
	else
		doPlayerSendTextMessage(cid, 27, "Voc� j� recebeu esta recompensa.")
	end
return true
end