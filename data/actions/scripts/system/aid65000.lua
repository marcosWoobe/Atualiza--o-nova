function onUse(cid, item)
	if getPlayerStorageValue(cid, 65000) ~= 1 then
		doPlayerAddItem(cid, 11638, 1)
		setPlayerStorageValue(cid, 65000, 1)
		doPlayerSendTextMessage(cid, 27, "Parabéns você acabou de completar a quest box " .. getItemNameById(11638) .. ".")
	else
		doPlayerSendTextMessage(cid, 27, "Você já recebeu esta recompensa.")
	end
return true
end