function onUse(cid, item)
	if getPlayerStorageValue(cid, 65008) >= 100 then
		addPokeToPlayer(cid, "Bulbasaur", 0, "poke", false, false)
		setPlayerStorageValue(cid, 65008, getPlayerStorageValue(cid, 65008)-100)
	else
		doPlayerSendTextMessage(cid, 27, "Parabéns você concluiu a quantidade de requisitos")
	end
return true
end