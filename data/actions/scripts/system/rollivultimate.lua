function onUse(cid, item, frompos, item2, topos)
	if getCreatureSummons(cid)[1] then return doPlayerSendTextMessage(cid, 27, "Volte seu pok�mon para a pok�ball para usar este item.") end
	if doPlayerRemoveItem(cid, 18420, 1) then
		doItemSetAttribute(item2.uid, "ivAtk", math.random(20, 31))
		doItemSetAttribute(item2.uid, "ivDef", math.random(20, 31))
		doItemSetAttribute(item2.uid, "ivSpAtk", math.random(20, 31))
		doItemSetAttribute(item2.uid, "ivAgi", math.random(20, 31))
		doItemSetAttribute(item2.uid, "ivHP", math.random(20, 31))
		doPlayerSendTextMessage(cid, 27, "Parab�ns voc� rodou os IVS do seu pok�mon.")
	return true
	end
return true
end