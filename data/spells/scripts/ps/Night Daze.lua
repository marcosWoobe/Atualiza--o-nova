function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Night Daze")

return true
end