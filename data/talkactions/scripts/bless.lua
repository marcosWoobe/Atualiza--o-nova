function onSay(cid, words, param)
	if getPlayerStorageValue(cid, 48722) == 0 then
		if getPlayerItemCount(cid, 2160) >= 100 then
			if doPlayerRemoveItem(cid, 2160, 100) then
				setPlayerStorageValue(cid, 48722, 1)
				doPlayerSendTextMessage(cid, 27, "Parab�ns voc� acabou de adquirir sua bless.")
			end
		else
			doPlayerSendTextMessage(cid, 27, "Voc� n�o possui dinheiro suficiente.")
		end
	else
		doPlayerSendTextMessage(cid, 27, "Voc� j� possui Bless.")
	end
return true
end	