local tableBoost = {
[17266] = {type1 = "fire"},
[17267] = {type1 = "water", type2 = "ice"},
[17268] = {type1 = "grass", type2 = "bug"},
[17269] = {type1 = "electric"},
[17270] = {type1 = "psychic", type2 = "fairy"},
[17271] = {type1 = "ghost", type2 = "poison"},
[17272] = {type1 = "fighting", type2 = "normal"},
[17273] = {type1 = "ground", type2 = "rock"},
[17274] = {type1 = "flying", type2 = "dragon"},
[17275] = {type1 = "steel", type2 = "crystal"},

}

function onUse(cid, item, frompos, item2, topos)
	local name = getItemAttribute(item2.uid, "poke")
	local boost = getItemAttribute(item2.uid, "boost") or 0
	local boosts = 0
	if (tableBoost[item.itemid].type1 and (pokes[name].type == tableBoost[item.itemid].type1)) or (tableBoost[item.itemid].type2 and (pokes[name].type2 == tableBoost[item.itemid].type2)) then
		-- if boost >= 50 then
			-- doPlayerSendTextMessage(cid, 27, "Esse Pok�mon j� alcan�ou o boost m�ximo.")
		-- else
			doSetItemAttribute(item2.uid, "boost", boost + 1)
			doPlayerSendTextMessage(cid, 27, "Parab�ns o boost do seu Pok�mon aumentou em: +" .. boost + 1 .. ".")
		-- return true
		-- end
	else
		if tableBoost[item.itemid].type1 and tableBoost[item.itemid].type2 then
			doPlayerSendTextMessage(cid, 27, "Voc� s� pode usar essa mat�ria em um pok�mon do elemento: ".. tableBoost[item.itemid].type1 .. " ou " .. tableBoost[item.itemid].type2 .. ".")
		else
			doPlayerSendTextMessage(cid, 27, "Voc� s� pode usar essa mat�ria em um pok�mon do elemento: ".. tableBoost[item.itemid].type1 .. ".")
		end
	return true
	end
return true
end