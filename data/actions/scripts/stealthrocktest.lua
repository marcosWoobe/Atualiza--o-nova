function onUse(cid, item, fromPos, item2, toPos)

	local attacker, min, max = getItemAttribute(item.uid, "attacker"), getItemAttribute(item.uid, "min"), getItemAttribute(item.uid, "max")
	if attacker and min and max then
		local cpos = toPos
		cpos.stackpos = 253
		crid = getThingFromPos(cpos).uid
		doSendMsg(cid, crid)
		local damage = math.random(min, max)
		
		doSendMagicEffect(toPos, 44)
		doCreatureAddHealth(crid, -damage)
		doSendAnimatedText(getThingPos(crid), damage, COLOR_BROWN)
		addPlayerDano(crid, getCreatureByName(attacker), damage)
		
		--doSendMsg(cid, attacker.. ", ".. min.. ", "..max)
	end
return true
end