function onCastSpell(cid, var)
	if isSummon(cid) then return true end

	docastspell(cid, "Ingrain")
return true
end