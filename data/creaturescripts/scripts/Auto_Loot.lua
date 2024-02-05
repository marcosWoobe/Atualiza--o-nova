--[[
	Auto Loot System by Danyel Varejão
	Created in 02/07/2017
]]

function onLogin(cid)
	registerCreatureEvent(cid, "Auto_Loot_Login")
	registerCreatureEvent(cid, "Auto_Loot_Kill")
	return true
end

function onKill(cid, target, lastHit)
	if isPlayer(cid) and isMonster(target) then
		if getPlayerStorageValue(cid, AutoLoot.Storage_On_Items) == 1 and #AutoLoot.getPlayerList(cid) > 0 then
			addEvent(AutoLoot.Items, 500, cid, getCreaturePosition(target))
		end
		if getPlayerStorageValue(cid, AutoLoot.Storage_On_Gold) == 1 then
			addEvent(AutoLoot.Gold, 500, cid, getCreaturePosition(target))
		end
		if getPlayerStorageValue(cid, AutoLoot.Storage_On_Items) == 1 or getPlayerStorageValue(cid, AutoLoot.Storage_On_Gold) == 1 then
			addEvent(AutoLoot.Message, 500, cid)
		end
	end
	return true
end