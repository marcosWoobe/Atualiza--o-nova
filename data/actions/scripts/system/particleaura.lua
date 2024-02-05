function onUse(cid, item)

	if getItemAttribute(getPlayerSlotItem(cid, 8).uid, "premier") == 1 then
		doPlayerSendTextMessage(cid, 27, "Este Pokémon já possui Particle Aura.")
	else
		doItemSetAttribute(getPlayerSlotItem(cid, 8).uid, "premier", 1)
	end

return true
end