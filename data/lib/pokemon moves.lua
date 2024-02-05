const_distance_delay = 56

function setPokemonStatus(cid, status, time, damage, first, attacker)
	if not isCreature(cid) then return true end
	if isSummon(cid) then
		master = getCreatureMaster(cid)
		ball = getPlayerSlotItem(master, CONST_SLOT_FEET)
	else
		master = 0
		ball = false
	end
	local storage = storages.status[status]
	local pos1 = getThingPosWithDebug(cid)
	local pos2 = getThingPosWithDebug(cid)
	pos2.y = pos2.y - 1
	if first then
		setPlayerStorageValue(cid, storage, time)
	else
		if getPlayerStorageValue(cid, storage) - 1 == time then
			setPlayerStorageValue(cid, storage, time)
		else
			return true
		end
	end
	if ball ~= false then
		doItemSetAttribute(ball.uid, status, time)
		doItemSetAttribute(ball.uid, status.."Damage", damage)
	end
	if status == "sleep" then
		if time <= 0 then
			doRegainSpeed(cid)
			doCreatureSetNoMove(cid, false)
		return true
		end
		doChangeSpeed(cid, -getCreatureSpeed(cid))
		
		doCreatureSetNoMove(cid, true)
		if damage == 32 then
			doSendMagicEffect(pos1, 32)
		else
			doSendMagicEffect(pos1, 22)
		end
		if not isPlayer(cid) then
			if getCreatureCondition(cid, CONDITION_OUTFIT) then
				doRemoveCondition(cid, CONDITION_OUTFIT)
			end
		end
		doSendAnimatedText(pos1, "SLEEP", 16)
	elseif status == "paralyze" then
		if time <= 0 then
			doRegainSpeed(cid)
			doCreatureSetNoMove(cid, false)
		return true
		end
		doChangeSpeed(cid, -getCreatureSpeed(cid))
		
		doCreatureSetNoMove(cid, true)
		doSendAnimatedText(pos1, "PARALYZE", 16)
		if damage == 486 then
			doSendMagicEffect(pos1, 486)
		elseif damage == 48 then
			doSendMagicEffect(pos1, 48)
		elseif damage == 501 then
			doSendMagicEffect(pos2, 501)
		end
	elseif status == "stun" then
		if time <= 0 then
			doRegainSpeed(cid)
		return true
		end
		if isPlayer(cid) then
			if PlayerSpeed <= getCreatureSpeed(cid) then
				doChangeSpeed(cid, -getCreatureSpeed(cid)/2)
			end
		else
			if getCreatureBaseSpeed(cid) <= getCreatureSpeed(cid) then
				doChangeSpeed(cid, -getCreatureSpeed(cid)/2)
			end
		end
		doSendAnimatedText(pos1, "STUN", 16)
		if damage == 6 then
			doSendMagicEffect(pos1, 137)
		elseif damage == 1274 then
			doSendMagicEffect(pos1, 1274)
		elseif damage == 424 then
			doSendMagicEffect(pos1, 424)
		elseif damage == 22 then
			doSendMagicEffect(pos1, 22)
		elseif damage == 48 then
			doSendMagicEffect(pos1, 48)
		elseif damage == 274 then
			doSendMagicEffect(pos1, 274)
		elseif damage == 307 then
			doSendMagicEffect(pos1, 307)
		elseif damage == 147 then
			doSendMagicEffect(pos1, 147)
		elseif damage == 145 then
			doSendMagicEffect(pos1, 145)
		end
	elseif status == "string" then
		if time <= 0 then
			doRegainSpeed(cid)
		return true
		end
		doSendMagicEffect(pos1, 150)
		if isPlayer(cid) then
			if PlayerSpeed <= getCreatureSpeed(cid) then
				doChangeSpeed(cid, -getCreatureSpeed(cid)/2)
			end
		else
			if getCreatureBaseSpeed(cid) <= getCreatureSpeed(cid) then
				doChangeSpeed(cid, -getCreatureSpeed(cid)/2)
			end
		end
	elseif status == "blind" then
		if time <= 0 then return true end
		doSendMagicEffect(pos1, 34)
		doSendAnimatedText(pos1, "BLIND ", 30)
	elseif status == "confusion" then
		if time <= 0 then return true end
		if damage == 31 then
			doSendMagicEffect(pos2, damage)
		else
			doSendMagicEffect(pos1, damage)
		end
		doAddCondition(cid, confusioncondition)
	elseif status == "poison" then
		if time <= 0 then return true end
		if getCreatureHealth(cid) - math.floor(damage) <= 0 then
			doCreatureAddHealth(cid, -getCreatureHealth(cid) + 1)
			doSendAnimatedText(pos1, "POISON "..damage, COLOR_PURPLE+1)
			doSendMagicEffect(pos1, 8)
		else
			doCreatureAddHealth(cid, -math.floor(damage))
			doSendAnimatedText(pos1, "POISON "..damage, COLOR_PURPLE+1)
			doSendMagicEffect(pos1, 8)
		end
	elseif status == "burn" then
		if time <= 0 then return true end
		doCreatureAddHealth(cid, -math.floor(damage))
		doSendAnimatedText(pos1, "BURN "..damage, 144)
		doSendMagicEffect(pos1, 15)
	elseif status == "leechSeed" then
		if time <= 0 then return true end
		if not isCreature(attacker) then return true end
		if not isNumberPair(time) then
			if getCreatureHealth(cid) - damage <= 0 then
				hit = getCreatureHealth(cid)
			else
				hit = damage
			end
			doSendAnimatedText(getThingPos(attacker), "+"..hit, 35)
			doSendAnimatedText(pos1, "-"..hit, 180)
			doSendMagicEffect(pos1, 45)
			doCreatureAddHealth(attacker, hit)
			doCreatureAddHealth(cid, -hit)
		end
	elseif status == "speedDown" then
		if time <= 0 then
			doRegainSpeed(cid)
		return true
		end
		if isPlayer(cid) then
			if PlayerSpeed <= getCreatureSpeed(cid) then
				doChangeSpeed(cid, -getCreatureSpeed(cid)/2)
			end
		else
			if getCreatureBaseSpeed(cid) <= getCreatureSpeed(cid) then
				doChangeSpeed(cid, -getCreatureSpeed(cid)/2)
			end
		end
	elseif status == "fear" then
		if time <= 0 then
			setCreatureTargetDistance(cid, getCreatureDefaultTargetDistance(cid))
		return true
		end
		if getCreatureTargetDistance(cid) < 6 then
			setCreatureTargetDistance(cid, 6)
		end
		local function doSendMagicEffect(cid)
			if not isCreature(cid) then return true end
			doSendMagicEffect(pos1, 169)
		end
		for i = 0, 1 do
			addEvent(doSendMagicEffect, i * 500, cid)
		end
	elseif status == "involved" then
		if time <= 0 then return true end
		if isNumberPair(time) then
			doCreatureAddHealth(cid, -damage, 1392, 180)
			doChangeSpeed(cid, -getCreatureSpeed(cid))
			doCreatureSetNoMove(cid, false)
		else
			doRegainSpeed(cid)
			doCreatureSetNoMove(cid, true)
		end
	elseif status == "silence" then
		if time <= 0 then return true end
		doSendMagicEffect(pos1, damage)
	elseif status == "rage" then
		if time <= 0 then return true end
		doSendMagicEffect(pos1, 13)
	elseif status == "harden" then
		if time <= 0 then return true end
		doSendMagicEffect(pos1, damage)
	elseif status == "strafe" then
		if time <= 0 then return true end
		if isCreature(getMasterTarget(cid)) then
			doCreatureCastSpell(cid, "melee")
		end
		doSendMagicEffect(pos1, 14)
	elseif status == "speedUp" then
		if time <= 0 then
			doRegainSpeed(cid)
		return true
		end
		if isPlayer(cid) then
			if PlayerSpeed >= getCreatureSpeed(cid) then
				doChangeSpeed(cid, getCreatureSpeed(cid))
			end
		else
			if getCreatureBaseSpeed(cid) >= getCreatureSpeed(cid) then
				doChangeSpeed(cid, getCreatureSpeed(cid))
			end
		end
	end
	if isCreature(master) then
		doOTCSendPokemonHealth(master)
	end
	addEvent(setPokemonStatus, 1000, cid, status, time - 1, damage, false, attacker)
end

function doClearPokemonStatus(cid)
	for i = 1, #allStatus do
		setPokemonStatus(cid, allStatus[i], 0, 131, true, 0)
	end
end

function getPokemonStatus(cid, status)
	local storage = storages.status[status]
	if getPlayerStorageValue(cid, storage) and getPlayerStorageValue(cid, storage) > 0 then
		return true
	else
		return false
	end
end

function doClearBallStatus(ball)
	for i = 1, #allStatus do
		doItemEraseAttribute(ball, allStatus[i])
	end
end

function getBallStatus(ball, status)
	if getItemAttribute(ball, status) and getItemAttribute(ball, status) > 0 then
		return true
	else
		return false
	end
end

function doSendMoveEffectUp(cid, shoteffect)
	if not isCreature(cid) then return true end
	local fromPos = getThingPosWithDebug(cid)
	local toPos = {x = fromPos.x - math.random(5, 7), y = fromPos.y - math.random(5, 7), z = fromPos.z}
	doSendDistanceShoot(fromPos, toPos, shoteffect)
end

function doSendMoveEffectDown(cid, effect, shoteffect)
	if not isCreature(cid) then return true end
	local myPos = getThingPosWithDebug(cid)
	local toPos = {x = myPos.x + math.random(-4, 4), y = myPos.y + math.random(-4, 4), z = myPos.z}
	local fromPos = {x = toPos.x - 6, y = toPos.y - 6, z = toPos.z}
	if getThingFromPos(toPos).itemid ~= 0 then
		doSendMagicEffect(toPos, effect)
		if shoteffect then
			doSendDistanceShoot(fromPos, toPos, shoteffect)
		end
	end
end

function doFrontalCombatHealth(cid, pos, type, min, max, effect, shoteffect)
	local target = (isCreature(getMasterTarget(cid)) and getMasterTarget(cid) or 0)
	local direction = getCreatureDirectionToTarget(cid, target)
	local function doSendFrontalCombat(cid, turn, randomarea)
		if not isCreature(cid) then return true end
		local randomiclist = {
			[1] = {11, 12, 3, 4, 1, 18, 10, 2, 7, 15},
			[2] = {13, 11, 3, 17, 2, 9, 10, 1, 18, 4},
			[3] = {10, 4, 2, 15, 1, 19, 13, 3, 14, 6},
			[4] = {14, 17, 2, 18, 3, 19, 15, 1, 13, 7},
			[5] = {6, 15, 3, 17, 1, 12, 19, 2, 16, 13}
		}
		local info = {
			[0] = {
				[1] = {x = pos.x, y = pos.y - 1, z = pos.z},
				[2] = {x = pos.x - 1, y = pos.y - 2, z = pos.z},
				[3] = {x = pos.x + 1, y = pos.y - 2, z = pos.z},
				[4] = {x = pos.x, y = pos.y - 3, z = pos.z},
				[5] = {x = pos.x - 2, y = pos.y - 3, z = pos.z},
				[6] = {x = pos.x + 2, y = pos.y - 3, z = pos.z},
				[7] = {x = pos.x - 3, y = pos.y - 4, z = pos.z},
				[8] = {x = pos.x - 1, y = pos.y - 4, z = pos.z},
				[9] = {x = pos.x + 1, y = pos.y - 4, z = pos.z},
				[10] = {x = pos.x + 3, y = pos.y - 4, z = pos.z},
				[11] = {x = pos.x, y = pos.y - 5, z = pos.z},
				[12] = {x = pos.x - 4, y = pos.y - 5, z = pos.z},
				[13] = {x = pos.x - 2, y = pos.y - 5, z = pos.z},
				[14] = {x = pos.x + 2, y = pos.y - 5, z = pos.z},
				[15] = {x = pos.x + 4, y = pos.y - 5, z = pos.z},
				[16] = {x = pos.x - 3, y = pos.y - 6, z = pos.z},
				[17] = {x = pos.x - 1, y = pos.y - 6, z = pos.z},
				[18] = {x = pos.x + 1, y = pos.y - 6, z = pos.z},
				[19] = {x = pos.x + 3, y = pos.y - 6, z = pos.z},
			},
			[1] = {
				[1] = {x = pos.x + 1, y = pos.y, z = pos.z},
				[2] = {x = pos.x + 2, y = pos.y + 1, z = pos.z},
				[3] = {x = pos.x + 2, y = pos.y - 1, z = pos.z},
				[4] = {x = pos.x + 3, y = pos.y, z = pos.z},
				[5] = {x = pos.x + 3, y = pos.y + 2, z = pos.z},
				[6] = {x = pos.x + 3, y = pos.y - 2, z = pos.z},
				[7] = {x = pos.x + 4, y = pos.y + 3, z = pos.z},
				[8] = {x = pos.x + 4, y = pos.y + 1, z = pos.z},
				[9] = {x = pos.x + 4, y = pos.y - 1, z = pos.z},
				[10] = {x = pos.x + 4, y = pos.y - 3, z = pos.z},
				[11] = {x = pos.x + 5, y = pos.y, z = pos.z},
				[12] = {x = pos.x + 5, y = pos.y - 4, z = pos.z},
				[13] = {x = pos.x + 5, y = pos.y - 2, z = pos.z},
				[14] = {x = pos.x + 5, y = pos.y + 2, z = pos.z},
				[15] = {x = pos.x + 5, y = pos.y + 4, z = pos.z},
				[16] = {x = pos.x + 6, y = pos.y - 3, z = pos.z},
				[17] = {x = pos.x + 6, y = pos.y - 1, z = pos.z},
				[18] = {x = pos.x + 6, y = pos.y + 1, z = pos.z},
				[19] = {x = pos.x + 6, y = pos.y + 3, z = pos.z},
			},
			[2] = {
				[1] = {x = pos.x, y = pos.y + 1, z = pos.z},
				[2] = {x = pos.x + 1, y = pos.y + 2, z = pos.z},
				[3] = {x = pos.x - 1, y = pos.y + 2, z = pos.z},
				[4] = {x = pos.x, y = pos.y + 3, z = pos.z},
				[5] = {x = pos.x + 2, y = pos.y + 3, z = pos.z},
				[6] = {x = pos.x - 2, y = pos.y + 3, z = pos.z},
				[7] = {x = pos.x + 3, y = pos.y + 4, z = pos.z},
				[8] = {x = pos.x + 1, y = pos.y + 4, z = pos.z},
				[9] = {x = pos.x - 1, y = pos.y + 4, z = pos.z},
				[10] = {x = pos.x - 3, y = pos.y + 4, z = pos.z},
				[11] = {x = pos.x, y = pos.y + 5, z = pos.z},
				[12] = {x = pos.x - 4, y = pos.y + 5, z = pos.z},
				[13] = {x = pos.x - 2, y = pos.y + 5, z = pos.z},
				[14] = {x = pos.x + 2, y = pos.y + 5, z = pos.z},
				[15] = {x = pos.x + 4, y = pos.y + 5, z = pos.z},
				[16] = {x = pos.x - 3, y = pos.y + 6, z = pos.z},
				[17] = {x = pos.x - 1, y = pos.y + 6, z = pos.z},
				[18] = {x = pos.x + 1, y = pos.y + 6, z = pos.z},
				[19] = {x = pos.x + 3, y = pos.y + 6, z = pos.z},
			},
			[3] = {
				[1] = {x = pos.x - 1, y = pos.y, z = pos.z},
				[2] = {x = pos.x - 2, y = pos.y - 1, z = pos.z},
				[3] = {x = pos.x - 2, y = pos.y + 1, z = pos.z},
				[4] = {x = pos.x - 3, y = pos.y, z = pos.z},
				[5] = {x = pos.x - 3, y = pos.y - 2, z = pos.z},
				[6] = {x = pos.x - 3, y = pos.y + 2, z = pos.z},
				[7] = {x = pos.x - 4, y = pos.y - 3, z = pos.z},
				[8] = {x = pos.x - 4, y = pos.y - 1, z = pos.z},
				[9] = {x = pos.x - 4, y = pos.y + 1, z = pos.z},
				[10] = {x = pos.x - 4, y = pos.y + 3, z = pos.z},
				[11] = {x = pos.x - 5, y = pos.y, z = pos.z},
				[12] = {x = pos.x - 5, y = pos.y - 4, z = pos.z},
				[13] = {x = pos.x - 5, y = pos.y - 2, z = pos.z},
				[14] = {x = pos.x - 5, y = pos.y + 2, z = pos.z},
				[15] = {x = pos.x - 5, y = pos.y + 4, z = pos.z},
				[16] = {x = pos.x - 6, y = pos.y - 3, z = pos.z},
				[17] = {x = pos.x - 6, y = pos.y - 1, z = pos.z},
				[18] = {x = pos.x - 6, y = pos.y + 1, z = pos.z},
				[19] = {x = pos.x - 6, y = pos.y + 3, z = pos.z},
			}
		}
		local area = info[direction][randomiclist[randomarea][turn+1]]
		if getTopCreature(area).uid > 0 and isCreature(getTopCreature(area).uid) then
			doTargetCombatHealth(cid, getTopCreature(area).uid, type, -min, -max, 1392)
		end
		doSendMagicEffect(area, effect)
		if shoteffect then
			doSendDistanceShoot(getThingPosWithDebug(cid), area, shoteffect)
		end
	end
	local randomarea = math.random(1, 5)
	for i = 0, 9 do
		addEvent(doSendFrontalCombat, i * 100, cid, i, randomarea)
	end
	local area = {
		[0] = frontalN,
		[1] = frontalE,
		[2] = frontalS,
		[3] = frontalW
	}
	doAreaCombatHealth(cid, type, getThingPosWithDebug(cid), area[getCreatureDirectionToTarget(cid, target)], -min, -max, 1392)
end

function doCastform(cid, name)
   local cforms = {
      ["Sunny Day"] = 2104,
      ["Rain Dance"] = 2105,
      ["Hail"] = 2106,
   }
   if getCreatureName(cid) ~= "Castform" then return true end
   doSetCreatureOutfit(cid, {lookType= cforms[name]}, -1)
   setPlayerStorageValue(cid, 23821, cforms[name])
   local mid = getCreatureMaster(cid)
   if mid then
      doUpdateMoves(mid)
   end
end

function doRemoveConditionSecurity(cid, condition)
   if not isCreature(cid) then return true end
   return doRemoveCondition(cid, CONDITION_OUTFIT)
end

function getCreatureHealthSecurity(cid)
   if not isCreature(cid) then return 0 end
   return getCreatureHealth(cid) or 0
end

function doHealArea(cid, min, max, pid)
	-- if getPlayerStorageValue(cid, STORAGE_HEALBLOCK) == 1 then return true end
	
   if isInArea(getThingPosWithDebug(cid), {x=2449,y=2611,z=8}, {x=2491,y=2654,z=8}) then doSendMagicEffect(getThingPosWithDebug(cid), 301) return true end
   if isSummon(cid) and isSummon(pid) then
      local p1,p2 = getCreatureMaster(cid), getCreatureMaster(pid)
      if isInDuel(p1) and not isInDuel(p2) then
         return true
      end
   end
   local amount = math.random(min, max)
   if (getCreatureHealth(cid) + amount) >= getCreatureMaxHealth(cid) then
      amount = -(getCreatureHealth(cid)-getCreatureMaxHealth(cid))
   end
   if getCreatureHealth(cid) ~= getCreatureMaxHealth(cid) then
      doCreatureAddHealth(cid, amount)
      doSendAnimatedText(getThingPosWithDebug(cid), "+"..amount.."", 65)
   end
end

function doMoveAreaWithSteal(cid, area, dmg, spell, min, max, eff)
	-- if getPlayerStorageValue(cid, STORAGE_HEALBLOCK) == 1 then return true end
   if not isCreature(cid) then return true end
   local totalDano = 0
   local pos = getPosfromArea(cid, area)
   if pos and #pos > 0 then
      for i = 1,#pos do
         local thingPos = {x=pos[i].x,y=pos[i].y,z=pos[i].z,stackpos=253}
         local c = getThingFromPosWithProtect(thingPos)
         if c > 0 then
            local lifeb = getCreatureHealthSecurity(c)
            doMoveDano2(cid, c, dmg, min, max, ret, spell)
            local lifea = getCreatureHealthSecurity(c)
            totalDano = totalDano + (lifeb - lifea)
            doSendMagicEffect(thingPos, eff)
         end
      end
   end
   if totalDano > 0 then
      local hptomax = getCreatureMaxHealth(cid) - getCreatureHealth(cid)
      local heal = math.min(hptomax, math.ceil(totalDano / 2))
      doCreatureAddHealth(cid, heal)
      doSendAnimatedText(getThingPosWithDebug(cid), "+"..heal, 65)
   end
end

pullArea = {
   {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
   {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
   {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
   {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
   {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
   {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
   {1, 1, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1, 1},
   {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
   {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
   {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
   {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
   {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
   {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
}

function getClosestFreeTile2(cid, dist, limit)
   if dist > limit then return 'none' end
   local pos = getThingPosWithDebug(cid)
   for x=-dist,dist do
      for y=-dist,dist do
         local checkPos = {x=pos.x+x, y = pos.y+y, z=pos.z}
         if isWalkable(checkPos, true, true, true, true) then
            return checkPos
         end
      end
   end
   return getClosestFreeTile2(cid, dist+1, limit)
end

function PullMove(cid, area, spell, stopt, condition, condtime, reteff) -- by uissu

   local ret = {}
   ret.id = 0
   ret.attacker = cid
   ret.cd = condtime or 0
   ret.eff = reteff or 0
   ret.check = 0
   ret.first = true
   ret.cond = condition or ""

   local pos = getPosfromArea(cid, area)
   if pos and #pos > 0 then
      for i = 1, #pos do
         local thing = {x=pos[i].x,y=pos[i].y,z=pos[i].z,stackpos=253}
         local c = getThingFromPosWithProtect(thing)
         if c > 0 then
            if ehMonstro(c) then
               if not isInArray(conditionImune, getCreatureName(c)) and not isWild(cid) then
                  local topos = getClosestFreeTile2(cid, 1, 1)
                  if topos ~= 'none' then
					-- if isInArray({"Dummy", "Darkrai"}, doCorrectString(getCreatureName(c))) then
						-- return false
					-- else
						doTeleportThing(c, topos)
					-- end
                  end
                  stopNow(c, stopt)
               end
               doMoveDano2(cid, c, NORMALDAMAGE, 0, 0, ret, spell)
            elseif isSummon(c) then
               local master = getCreatureMaster(c)
               if isSummon(cid) then
                  if getPlayerStorageValue(master, 52480) >= 1 and getPlayerStorageValue(master, 52481) >= 0 then
                     local masterCid = getCreatureMaster(cid)
                     if isDuelingAgainst(masterCid, master) then
                        local topos = getClosestFreeTile2(cid, 1, 1)
                        if topos ~= 'none' then
                           doTeleportThing(c, topos)
                        end
                        doMoveDano2(cid, c, NORMALDAMAGE, 0, 0, ret, spell)
                        stopNow(c, stopt)
                     end
                  end
               else
                  --doTeleportThing(c, getClosestFreeTile(cid, getThingPosWithDebug(cid))) wild não puxar
                  doMoveDano2(cid, c, NORMALDAMAGE, 0, 0, ret, spell)
                  stopNow(c, stopt)
               end
            end
         end
      end
   end
end

function doForceDanoSpeel(cid, moveName)
   local name = doCorrectString(getCreatureName(cid))
   local masterLevel = (isSummon(cid) and getPlayerLevel(getCreatureMaster(cid)) or getPokemonLevelByName(name))
   min = (getMoveForce(name, moveName) / 2) + (masterLevel * 1.5) --alterado v1.6
   max = getMoveForce(name, moveName) + (masterLevel * 1.5) --min + (isSummon(cid) and getMasterLevel(cid) or getPokemonLevel(cid))
   return math.random(min, max)
end

function doForceDano(cid)
   local name = doCorrectString(getCreatureName(cid))
   local masterLevel = (isSummon(cid) and getPlayerLevel(getCreatureMaster(cid)) or getPokemonLevelByName(name))
   min = (getMoveForce(name, moveName) / 2) + (masterLevel * 1.5) --alterado v1.6
   max = getMoveForce(name, moveName) + (masterLevel * 1.5) --min + (isSummon(cid) and getMasterLevel(cid) or getPokemonLevel(cid))
   return math.random(min, max)
end

function isShredTEAM(cid)
   if getPlayerStorageValue(cid, 637500) >= 1 then
      return true
   end
   return false
end

--//////////////////////////////////////////////////////////////////////////////////////////////////////////--
local function getSubName(cid, target)
   if not isCreature(cid) then return "" end
   if getCreatureName(cid) == "Ditto" and pokes[getPlayerStorageValue(cid, 1010)] and getPlayerStorageValue(cid, 1010) ~= "Ditto" then
      return getPlayerStorageValue(cid, 1010)
   elseif pokeHaveReflect(cid) and isCreature(target) then
      return getCreatureName(target)
   else                                                                --alterado v1.6.1
      return getCreatureName(cid)
   end
end

local function getThingName(cid)
   if not isCreature(cid) then return "" end   --alterado v1.6
   return getCreatureName(cid)
end


function getMasterTarget(cid)
   if isCreature(cid) and getPlayerStorageValue(cid, 21101) ~= -1 then
      return getPlayerStorageValue(cid, 21101)     --alterado v1.6
   end
   if isSummon(cid) then
      return getCreatureTarget(getCreatureMaster(cid))
   else
      return getCreatureTarget(cid)
   end
end
--////////////////////////////////////////////////////////////////////////////////////////////////////////--

function docastspell(cid, spell, reflectName, targetR, reflectForce)

   local target = targetR or 0
   local getDistDelay = 0
   local myPos = getThingPosWithDebug(cid)
   local myDirection = getCreatureDirectionToTarget(cid, target)
   local targetPos = isCreature(target) and getThingPos(target) or nil
   if not isCreature(cid) or getCreatureHealth(cid) <= 0 then return false end
   if (getPokemonStatus(cid, "sleep") or getPokemonStatus(cid, "silence") or getPokemonStatus(cid, "fear")) and getPlayerStorageValue(cid, 21100) <= -1 then return true end

   if isCreature(getMasterTarget(cid)) then
      target = getMasterTarget(cid)
      getDistDelay = getDistanceBetween(getThingPosWithDebug(cid), getThingPosWithDebug(target)) * const_distance_delay
   end

   if isMonster(cid) and not isSummon(cid) then
      if getCreatureCondition(cid, CONDITION_EXHAUST) then
         return true
      end
      doCreatureAddCondition(cid, wildexhaust)
   end

   local mydir = isCreature(target) and getCreatureDirectionToTarget(cid, target) or getCreatureLookDir(cid)
   local name = getCreatureName(cid)
   if isMega(cid) then
      name = getPlayerStorageValue(cid, storages.isMega)
   end
   if reflectName and reflectName ~= "" then
      name = reflectName
   end
   name = doCorrectString(name)

   if getPlayerStorageValue(cid, 23821) > 1 then
      name = cft[getPlayerStorageValue(cid, 23821)][1]
   end
   if getPlayerStorageValue(cid, 39440) == 1 then
      name = 'Light Abra'
   end
   local tablem = getTableMove(name, spell) --alterado v1.6

   if getPlayerStorageValue(cid, "TMID") and spell == getPlayerStorageValue(cid, "TMID") then
      local ball = getPlayerSlotItem(getCreatureMaster(cid), 8)
      tablem = getTMTable(ball.uid)
   end

   local min = 0
   local max = 0

   --- FEAR / ROAR ---
   if (isWithFear(cid)) and getPlayerStorageValue(cid, 21100) <= -1 and getPlayerStorageValue(cid, 237273) <= -1 then
      return true                                      --alterado v1.6!!
   end
   ----------------------------min= 1000 +
   if tablem then   --alterado v1.6
      local masterLevel = (isSummon(cid) and getPlayerLevel(getCreatureMaster(cid)) or getPokemonLevelByName(doCorrectString(getCreatureName(cid))))

      local mutiplay = 1 + (masterLevel/300)

      -- local nshiny = {'Shiny Ursaring','Shiny Electivire','Shiny Flygon','Shiny Magmortar','Shiny Dragonite','Shiny Swampert','Shiny Sceptile','Shiny Heracross','Shiny Infernape'}

      -- if string.find(getCreatureName(cid):lower(), "shiny") and not isInArray(nshiny, getCreatureName(cid)) then
      -- mutiplay = mutiplay + 0.5
      -- end

      -- local tf = 1
      -- if (tablem and tablem.f) then tf = tablem.f end

      -- min = getSpecialAttack(cid) * tf * mutiplay
      local force = tableMoves[spell].force
      if not force then
         print("Move sem force adicionado " .. spell)
      end
   --  if isInDuel(getCreatureMaster(cid)) then
   --	   doRemoveCountPokemon(getCreatureMaster(cid))
   --  end
	-- if isInDuel(getCreatureMaster(cid)) then
		-- minAtk = getAttack(cid) * ((force / 2) * mutiplay)
		-- maxAtk = minAtk + (isSummon(cid) and getMasterLevel(cid) or getPokemonLevel(cid))
	-- else
		-- minAtk = getAttack(cid) * (force * mutiplay)
		-- maxAtk = minAtk + (isSummon(cid) and getMasterLevel(cid) or getPokemonLevel(cid))
	-- end
	-- if isInDuel(getCreatureMaster(cid)) then
		-- minSpAtk = getSpecialAttack(cid) * (force / 2) * mutiplay
		-- maxSpAtk = minSpAtk + (isSummon(cid) and getMasterLevel(cid) or getPokemonLevel(cid))
	-- else
		-- minSpAtk = getSpecialAttack(cid) * (force * mutiplay)
		-- maxSpAtk = minSpAtk + (isSummon(cid) and getMasterLevel(cid) or getPokemonLevel(cid))
	-- end
	if isInDuel(getCreatureMaster(cid)) then
		min = getSpecialAttack(cid) * (force / 2) * mutiplay
		max = min + (isSummon(cid) and getMasterLevel(cid) or getPokemonLevel(cid))
	else
		min = getSpecialAttack(cid) * (force * mutiplay)
		max = min + (isSummon(cid) and getMasterLevel(cid) or getPokemonLevel(cid))
	end
	
	

      if spell == "Selfdestruct" then
         min = getCreatureHealth(cid)
         max = getCreatureHealth(cid)
      end
		if spell == "Explosion" then
			min = getCreatureHealth(cid) / 10
			max = getCreatureHealth(cid) / 10
		end

      if not isSummon(cid) and not isInArray({"Demon Puncher", "Demon Kicker"}, spell) then --alterado v1.7
         doCreatureSay(cid, string.upper(spell).."!", TALKTYPE_MONSTER)
      end
      if isNpcSummon(cid) then
         local mnn = {" use ", " "}
         local use = mnn[math.random(#mnn)]
         doCreatureSay(getCreatureMaster(cid), getPlayerStorageValue(cid, 1007)..","..use..""..doCorrectString(spell).."!", 1)
      end
   end

   --- FOCUS ----------------------------------
   if getPlayerStorageValue(cid, 253) >= 0 and (tablem and tablem.f ~= 0) then
      min = min * 2
      max = max * 2
      setPlayerStorageValue(cid, 253, -1)
      sendOpcodeStatusInfo(cid)
   end
   --- Shredder Team -------------------------------
   if getPlayerStorageValue(cid, 637501) >= 1 then
      if #getCreatureSummons(cid) == 1 then
         docastspell(getCreatureSummons(cid)[1], spell)
      elseif #getCreatureSummons(cid) == 2 then
         docastspell(getCreatureSummons(cid)[1], spell)
         docastspell(getCreatureSummons(cid)[2], spell)
      end
   end
   ------------------Miss System--------------------------
   if getPokemonStatus(cid, "confusion") or getPokemonStatus(cid, "stun") or getPokemonStatus(cid, "blind") then
      if not isInArray(noMissMove, spell) and getPlayerStorageValue(cid, 21100) <= -1 then
         if not string.find(spell, "Mega") then
            -- if math.random(1, 100) > 33 then
               doSendAnimatedText(getThingPosWithDebug(cid), "MISS", 215)
               return false
            -- end
         end
      end
   end
   ---------------GHOST DAMAGE-----------------------
   ghostDmg = GHOSTDAMAGE
   psyDmg = PSYCHICDAMAGE

   if getPlayerStorageValue(cid, 999457) >= 1 and (tablem and tablem.f ~= 0 and (tablem.t == "ghost" or tablem.t == "psychic")) then
      psyDmg = MIRACLEDAMAGE
      ghostDmg = DARK_EYEDAMAGE
      addEvent(setPlayerStorageValue, 50, cid, 999457, -1)
   end
   --------------------REFLECT----------------------
   setPlayerStorageValue(cid, 21100, -1)
   if not isInArray({"Psybeam", "Sand Attack", "Flamethrower", "Heal Bell"}, spell) then
      setPlayerStorageValue(cid, 21101, -1)
   end
   setPlayerStorageValue(cid, 21102, spell)
   ---------------------------------------------------

	local lvlBP = 0
	if isSummon(cid) then
		lvlBP = getMasterLevel(cid)
	else
		if getCreatureName(cid) and pokes[getCreatureName(cid)] then
			lvlBP = pokes[getCreatureName(cid)].level
		end
   end

   local heldPercentBP = 1
   if isSummon(cid) then
      local heldx = getItemAttribute(getPlayerSlotItem(getCreatureMaster(cid), 8).uid, "xHeldItem")
      if heldx then
         local heldName, heldTier = string.explode(heldx, "|")[1], string.explode(heldx, "|")[2]
         if heldName == "X-Hellfire" or heldName == "X-Poison" then
            heldPercentBP = heldPoisonBurn[tonumber(heldTier)]
         end
      end
   end

   local pbdmg =  math.floor((lvlBP * 3)/2) * heldPercentBP

   if spell == "Reflect" or spell == "Mimic"  or spell == "Magic Coat" then

      if spell == "Magic Coat" then
         eff = 11
      elseif spell == "Mimic" then
         eff = 442
      else
         eff = 135
      end

      doSendMagicEffect(getThingPosWithDebug(cid), eff)
      setPlayerStorageValue(cid, storages.reflect, 1)
      sendOpcodeStatusInfo(cid)

   elseif spell == "melee" then

      if not isCreature(cid) then return true end
      if not isCreature(target) then return true end
      if getDistanceBetween(getThingPosWithDebug(cid), getThingPos(target)) > 1 then return true end

      doTargetCombatHealth(cid, target, 1, -50, -100, 3)
      --doDanoWithProtect(cid, 1, getThingPosWithDebug(target), 0, -50, -100, 3)

   elseif spell == "Quick Attack" then
      doDanoWithProtect(cid, NORMALDAMAGE, getThingPosWithDebug(target), 0, -min, -max, 111)

   elseif spell == "Razor Leaf" or spell == "Magical Leaf" then

      local eff = spell == "Razor Leaf" and 4 or 21

      local function throw(cid, target)
         if not isCreature(cid) or not isCreature(target) then return false end
         doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), eff)
         doDanoInTargetWithDelay(cid, target, GRASSDAMAGE, min, max, 79) 
      end

      addEvent(throw, 0, cid, target)
      addEvent(throw, 100, cid, target)

   elseif spell == "Fire Fist" then
        local function doSendMove(cid, turn)
            if not isCreature(cid) then
               return true
            end
            local turn = turn or 1
            local event = addEvent(doSendMove, 400, cid, turn + 1)
            doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 95)
			doDanoWithProtect(cid, FIREDAMAGE, getThingPosWithDebug(target), 0, -min, -max, 15)
            if turn == 5 or isSleeping(cid) then
               stopEvent(event)
			   doPantinOutfit(cid, 0, getPlayerStorageValue(cid, storages.isMega))
			   doRemoveCondition(cid, CONDITION_OUTFIT)
			   -- doCreatureSetNoMove(cid, false)
            end
        end
        doSendMove(cid)
		doSetCreatureOutfit(cid, {lookType = 2462}, -1)


   elseif spell == "Vine Whip" then

      local area = getThingPosWithDebug(cid)
      local dano = {}
      local effect = 255

      if mydir == 0 then
         area.x = area.x + 1
         area.y = area.y - 1
         dano = whipn
         effect = 80
      elseif mydir == 1 then
         area.x = area.x + 2
         area.y = area.y + 1
         dano = whipe
         effect = 83
      elseif mydir == 2 then
         area.x = area.x + 1
         area.y = area.y + 2
         dano = whips
         effect = 81
      elseif mydir == 3 then
         area.x = area.x - 1
         area.y = area.y + 1
         dano = whipw
         effect = 82
      end

      doSendMagicEffect(area, effect)
      doAreaCombatHealth(cid, GRASSDAMAGE, getThingPosWithDebug(cid), dano, -min, -max, 255)

   elseif spell == "Headbutt" then
      doAreaCombatHealth(cid, NORMALDAMAGE, getThingPosWithDebug(target), 0, -min, -max, 118)

   elseif spell == "Leech Seed" then
	local myPos = getThingPos(cid)
	local target = target or isCreature(getMasterTarget(cid)) and getMasterTarget(cid) or 0
	local targetPos = isCreature(target) and getThingPos(target) or nil 
	doSendDistanceShoot(myPos, targetPos, 1)
	doTargetCombatHealth(cid, target, STATUS_LEECHSEED, -min, -max, 45)

   elseif spell == "Worry Seed" then
		local myPos = getThingPos(cid)
		local target = target or isCreature(getMasterTarget(cid)) and getMasterTarget(cid) or 0
		local targetPos = isCreature(target) and getThingPos(target) or nil 
		doSendDistanceShoot(myPos, targetPos, 1)
		doTargetCombatHealth(cid, target, STATUS_LEECHSEED, -min, -max, 45)
		doAreaCombatHealth(cid, GRASSDAMAGE, getThingPosWithDebug(target), 0, -min, -max, 485)

	elseif spell == "Hone Claws" then
		local pos = getThingPosWithDebug(cid)
		pos.x = pos.x + 1
		doSendMagicEffect(pos, 911)
		if isSummon(cid) then
			doClearBallStatus(getPlayerSlotItem(getCreatureMaster(cid), 8).uid)
        end
        -- doClearPokemonStatus(cid)
		doClearPokemonStatus(cid)
		setPlayerStorageValue(cid, 253, 1)
		sendOpcodeStatusInfo(cid)
		
	elseif spell == "Void Sphere" then
		doSendDistanceShoot(getThingPosWithDebug(cid), getThingPos(target), 132)
		doSendMagicEffect(getThingPos(target), 1079)
		doTeleportThing(cid, getClosestFreeTile(target, getThingPosWithDebug(target)), false)

	elseif spell == "Foul Play" then
		doSendDistanceShoot(getThingPosWithDebug(cid), getThingPos(target), 144)
		doTargetCombatHealth(cid, target, DARKDAMAGE, -min, -max, 1097)
		
	elseif spell == "Flatter" then
		local pos = getThingPosWithDebug(cid)
		pos.x = pos.x + 1
		pos.y = pos.y + 1
		doSendMagicEffect(pos, 668)
		doAreaCombatHealth(cid, DARKDAMAGE, myPos, circle3x3, -min, -max, 940)
		doAreaCombatHealth(cid, STATUS_CONFUSION7, myPos, circle3x3, -31, -31, 1097)
	
	elseif spell == "Quash" then
		local pos = getThingPosWithDebug(cid)
		pos.x = pos.x + 3
		pos.y = pos.y + 2
		doSendMagicEffect(pos, 1066)
		doAreaCombatHealth(cid, DARKDAMAGE, getThingPosWithDebug(cid), storedArea1, -min, -max, 940)
		doAreaCombatHealth(cid, DARKDAMAGE, getThingPosWithDebug(cid), storedArea2, -min, -max, 941)
		addEvent(doAreaCombatHealth, 200, cid, DARKDAMAGE, getThingPosWithDebug(cid), storedArea1, -min, -max, 1392)
		addEvent(doAreaCombatHealth, 200, cid, DARKDAMAGE, getThingPosWithDebug(cid), storedDebugArea, nil, nil, 688)

   elseif spell == "Light Screen" then

      local pos = getPosfromArea(cid, BigArea2)
      local n = 0
      local crts = {}

      local function sendEff(cid)
         if not isCreature(cid) then return true end
         local pos = {x=getThingPosWithDebug(cid).x+1,y=getThingPosWithDebug(cid).y+1,z=getThingPosWithDebug(cid).z}
         doSendMagicEffect(pos, 816)
      end

      doRaiseStatus(cid, 2, 2, 200, 12)
      setPlayerStorageValue(cid, 253, 1)
      sendOpcodeStatusInfo(cid)
      doSendAnimatedText(getThingPosWithDebug(cid), "FOCUS!", COLOR_YELLOW)
      for i = 0, 9 do
         addEvent(sendEff, i*1250, cid)
      end

      while n < #pos do
         n = n+1
         local thing = {x=pos[n].x,y=pos[n].y,z=pos[n].z,stackpos=253}
         local pid = getThingFromPosWithProtect(thing)
         local pospid = getThingPosWithDebug(pid)
         local poscid = getThingPosWithDebug(cid)

         if isCreature(pid) then
            table.insert(crts,pid)
         end
      end
      for _,pid in pairs(crts) do
         if (isSummon(cid) and isSummon(pid) and canAttackOther(cid, pid) == "Cant") or (ehMonstro(cid) and ehMonstro(pid)) then
            doRaiseStatus(pid, 2, 2, 200, 12)
            setPlayerStorageValue(pid, 253, 1)
            for i=0,9 do
               addEvent(sendEff, i*1250, pid)
            end
         end
      end

   elseif spell == "Protection" then

      local pos = getPosfromArea(cid, BigArea2)
      local n = 0
      local crts = {}

      local function sendEff(cid)
         if not isCreature(cid) then return true end
         local pos = getThingPosWithDebug(cid)
         doSendMagicEffect(pos, 117)
      end

      if not isInArea(getThingPosWithDebug(cid), {x=126,y=767,z=6}, {x=148,y=789,z=6}) then

         for i = 0, 9 do
            addEvent(sendEff, i*1000, cid)
         end
         setPlayerStorageValue(cid, 9658783, 1)
         addEvent(setPlayerStorageValue, 10000, cid, 9658783, -1)

         while n < #pos do
            n = n+1
            local thing = {x=pos[n].x,y=pos[n].y,z=pos[n].z,stackpos=253}
            local pid = getThingFromPosWithProtect(thing)
            local pospid = getThingPosWithDebug(pid)
            local poscid = getThingPosWithDebug(cid)

            doSendMagicEffect(pos[n], 12)
            if isCreature(pid) then
               table.insert(crts,pid)
            end
         end
         for _,pid in pairs(crts) do
            if (isSummon(cid) and (isSummon(pid) or isPlayer(pid)) and canAttackOther(cid, pid) == "Cant") or (ehMonstro(cid) and ehMonstro(pid)) then
               setPlayerStorageValue(pid, 9658783, 1)
               addEvent(setPlayerStorageValue, 10000, pid, 9658783, -1)
               for i=0,9 do
                  addEvent(sendEff, i*1000, pid)
               end
            end
         end

      end
   elseif spell == "Solar Beam" then
      local function useSolarBeam(cid)
         if not isCreature(cid) then
            return true
         end
         if isSleeping(cid) and getPlayerStorageValue(cid, 3644587) >= 1 then
            return true
         end
         if isWithFear(cid) and getPlayerStorageValue(cid, 3644587) >= 1 then
            return true
         end
         local effect1 = 1392
         local effect2 = 1392
         local effect3 = 1392
         local effect4 = 1392
         local effect5 = 1392
         local area = {}
         local pos1 = getThingPosWithDebug(cid)
         local pos2 = getThingPosWithDebug(cid)
         local pos3 = getThingPosWithDebug(cid)
         local pos4 = getThingPosWithDebug(cid)
         local pos5 = getThingPosWithDebug(cid)
         if getCreatureLookDir(cid) == 1 then
            effect1 = 232
            effect2 = 233
            effect3 = 233
            effect4 = 233
            effect5 = 234
            pos1.x = pos1.x + 2
            pos1.y = pos1.y + 1
            pos2.x = pos2.x + 3
            pos2.y = pos2.y + 1
            pos3.x = pos3.x + 4
            pos3.y = pos3.y + 1
            pos4.x = pos4.x + 5
            pos4.y = pos4.y + 1
            pos5.x = pos5.x + 6
            pos5.y = pos5.y + 1
            area = solare
         elseif getCreatureLookDir(cid) == 0 then
            effect1 = 238
            effect2 = 240
            effect3 = 240
            effect4 = 239
            pos1.x = pos1.x + 1
            pos1.y = pos1.y - 1
            pos2.x = pos2.x + 1
            pos2.y = pos2.y - 3
            pos3.x = pos3.x + 1
            pos3.y = pos3.y - 4
            pos4.x = pos4.x + 1
            pos4.y = pos4.y - 5
            area = solarn
         elseif getCreatureLookDir(cid) == 2 then
            effect1 = 241
            effect2 = 242
            effect3 = 242
            effect4 = 243
            pos1.x = pos1.x + 1
            pos1.y = pos1.y + 2
            pos2.x = pos2.x + 1
            pos2.y = pos2.y + 3
            pos3.x = pos3.x + 1
            pos3.y = pos3.y + 4
            pos4.x = pos4.x + 1
            pos4.y = pos4.y + 5
            area = solars
         elseif getCreatureLookDir(cid) == 3 then
            effect1 = 235
            effect2 = 237
            effect3 = 237
            effect4 = 237
            effect5 = 236
            pos1.x = pos1.x - 1
            pos1.y = pos1.y + 1
            pos2.x = pos2.x - 3
            pos2.y = pos2.y + 1
            pos3.x = pos3.x - 4
            pos3.y = pos3.y + 1
            pos4.x = pos4.x - 5
            pos4.y = pos4.y + 1
            pos5.x = pos5.x - 6
            pos5.y = pos5.y + 1
            area = solarw
         end

         if effect1 ~= 1392 then
            doSendMagicEffect(pos1, effect1)
         end
         if effect2 ~= 1392 then
            doSendMagicEffect(pos2, effect2)
         end
         if effect3 ~= 1392 then
            doSendMagicEffect(pos3, effect3)
         end
         if effect4 ~= 1392 then
            doSendMagicEffect(pos4, effect4)
         end
         if effect5 ~= 1392 then
            doSendMagicEffect(pos5, effect5)
         end

         doAreaCombatHealth(cid, GRASSDAMAGE, getThingPosWithDebug(cid), area, -min, -max, 1392)
         -- doRegainSpeed(cid)
         setPlayerStorageValue(cid, 3644587, -1)
      end

      local function ChargingBeam(cid)
         if not isCreature(cid) then
            return true
         end
         if isSleeping(cid) and getPlayerStorageValue(cid, 3644587) >= 1 then
            return true
         end
         if isWithFear(cid) and getPlayerStorageValue(cid, 3644587) >= 1 then
            return true
         end
         local tab = {}

         for x = -2, 2 do
            for y = -2, 2 do
               local pos = getThingPosWithDebug(cid)
               pos.x = pos.x + x
               pos.y = pos.y + y
               if pos.x ~= getThingPosWithDebug(cid).x and pos.y ~= getThingPosWithDebug(cid).y then
                  table.insert(tab, pos)
               end
            end
         end
         doSendDistanceShoot(tab[math.random(#tab)], getThingPosWithDebug(cid), 37)
      end

      -- doChangeSpeed(cid, -getCreatureSpeed(cid))
      setPlayerStorageValue(cid, 3644587, 1)

      doSendMagicEffect(getThingPosWithDebug(cid), 132)
      if getPlayerStorageValue(cid, 847232) > os.time() then
         useSolarBeam(cid)
         setPlayerStorageValue(cid, 847232, 0)
      else
         addEvent(useSolarBeam, 1000, cid)
      end

   elseif spell == "Force Palm" then
      local function useSolarBeam(cid)
         if not isCreature(cid) then
            return true
         end
         if isSleeping(cid) and getPlayerStorageValue(cid, 3644587) >= 1 then
            return true
         end
         if isWithFear(cid) and getPlayerStorageValue(cid, 3644587) >= 1 then
            return true
         end
         local effect1 = 1392
         local effect2 = 1392
         local effect3 = 1392
         local effect4 = 1392
         local effect5 = 1392
         local area = {}
         local pos1 = getThingPosWithDebug(cid)
         local pos2 = getThingPosWithDebug(cid)
         local pos3 = getThingPosWithDebug(cid)
         local pos4 = getThingPosWithDebug(cid)
         local pos5 = getThingPosWithDebug(cid)
         if getCreatureLookDir(cid) == 1 then
            effect1 = 970
            effect2 = 971
            effect3 = 971
            effect4 = 971
            effect5 = 972
            pos1.x = pos1.x + 2
            pos1.y = pos1.y + 1
            pos2.x = pos2.x + 3
            pos2.y = pos2.y + 1
            pos3.x = pos3.x + 4
            pos3.y = pos3.y + 1
            pos4.x = pos4.x + 5
            pos4.y = pos4.y + 1
            pos5.x = pos5.x + 6
            pos5.y = pos5.y + 1
            area = solare
         elseif getCreatureLookDir(cid) == 0 then
            effect1 = 976
            effect2 = 978
            effect3 = 978
            effect4 = 977
            pos1.x = pos1.x + 1
            pos1.y = pos1.y - 1
            pos2.x = pos2.x + 1
            pos2.y = pos2.y - 3
            pos3.x = pos3.x + 1
            pos3.y = pos3.y - 4
            pos4.x = pos4.x + 1
            pos4.y = pos4.y - 5
            area = solarn
         elseif getCreatureLookDir(cid) == 2 then
            effect1 = 979
            effect2 = 980
            effect3 = 980
            effect4 = 981
            pos1.x = pos1.x + 1
            pos1.y = pos1.y + 2
            pos2.x = pos2.x + 1
            pos2.y = pos2.y + 3
            pos3.x = pos3.x + 1
            pos3.y = pos3.y + 4
            pos4.x = pos4.x + 1
            pos4.y = pos4.y + 5
            area = solars
         elseif getCreatureLookDir(cid) == 3 then
            effect1 = 973
            effect2 = 975
            effect3 = 975
            effect4 = 975
            effect5 = 974
            pos1.x = pos1.x - 1
            pos1.y = pos1.y + 1
            pos2.x = pos2.x - 3
            pos2.y = pos2.y + 1
            pos3.x = pos3.x - 4
            pos3.y = pos3.y + 1
            pos4.x = pos4.x - 5
            pos4.y = pos4.y + 1
            pos5.x = pos5.x - 6
            pos5.y = pos5.y + 1
            area = solarw
         end

         if effect1 ~= 1392 then
            doSendMagicEffect(pos1, effect1)
         end
         if effect2 ~= 1392 then
            doSendMagicEffect(pos2, effect2)
         end
         if effect3 ~= 1392 then
            doSendMagicEffect(pos3, effect3)
         end
         if effect4 ~= 1392 then
            doSendMagicEffect(pos4, effect4)
         end
         if effect5 ~= 1392 then
            doSendMagicEffect(pos5, effect5)
         end

         doAreaCombatHealth(cid, NORMALDAMAGE, getThingPosWithDebug(cid), area, -min, -max, 1392)
         doRegainSpeed(cid)
         setPlayerStorageValue(cid, 3644587, -1)
      end

      local function ChargingBeam(cid)
         if not isCreature(cid) then
            return true
         end
         if isSleeping(cid) and getPlayerStorageValue(cid, 3644587) >= 1 then
            return true
         end
         if isWithFear(cid) and getPlayerStorageValue(cid, 3644587) >= 1 then
            return true
         end
         local tab = {}

         for x = -2, 2 do
            for y = -2, 2 do
               local pos = getThingPosWithDebug(cid)
               pos.x = pos.x + x
               pos.y = pos.y + y
               if pos.x ~= getThingPosWithDebug(cid).x and pos.y ~= getThingPosWithDebug(cid).y then
                  table.insert(tab, pos)
               end
            end
         end
         doSendDistanceShoot(tab[math.random(#tab)], getThingPosWithDebug(cid), 37)
      end

      doChangeSpeed(cid, -getCreatureSpeed(cid))
      setPlayerStorageValue(cid, 3644587, 1) --alterado v1.6  n sei pq mas tava dando debug o.O

      local pos = getThingPosWithDebug(cid)
      pos.x = pos.x + 2
      pos.y = pos.y + 2
      doSendMagicEffect(pos, 869)
      if getPlayerStorageValue(cid, 847232) > os.time() then
         useSolarBeam(cid)
         setPlayerStorageValue(cid, 847232, 0)
      else
         addEvent(useSolarBeam, 1000, cid)
      end

   elseif spell == "Sleep Powder" then
	doAreaCombatHealth(cid, STATUS_SLEEP, myPos, circle2x2, -6, -6, 27)

   elseif spell == "Stun Spore" then
		doAreaCombatHealth(cid, STATUS_STUN7, myPos, circle2x2, -6, -6, 85)

   elseif spell == "Poison Powder" then
		doAreaCombatHealth(cid, STATUS_POISON10, myPos, circle2x2, -min, -max, 84)

   elseif spell == "Bullet Seed" then
	  	local myPos = getThingPosWithDebug(cid)
		doFrontalCombatHealth(cid, myPos, GRASSDAMAGE, min, max, 45, 1)

   elseif spell == "Body Slam" then
      doAreaCombatHealth(cid, NORMALDAMAGE, getThingPosWithDebug(target), 0, -min, -max, 118)
	  
	elseif spell == "Leaf Storm" then
        local function doSendMove(cid, turn)
            if not isCreature(cid) then
                return true
            end
            local turn = turn or 1
            local event = addEvent(doSendMove, 50, cid, turn + 1)
        local myPos = getThingPosWithDebug(cid)
        local pos = {x = myPos.x + math.random(-6, 6), y = myPos.y + math.random(-5, 5), z = myPos.z}
        if getThingFromPos(pos).itemid ~= 0 then
            doSendDistanceShoot(getThingPosWithDebug(cid), pos, 4)
            doSendMagicEffect(pos, 79)
        end
            if turn == 20 or isSleeping(cid) then
                stopEvent(event)
            end
        end
        doSendMove(cid)
		addEvent(doAreaCombatHealth, 1000, cid, GRASSDAMAGE, myPos, square4x4, -min, -max, 1392)

   elseif spell == "Scratch" then
      doDanoWithProtect(cid, NORMALDAMAGE, getThingPos(target), 0, -min, -max, 142)
   elseif spell == "Ember" then
      doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), (isMega(cid) and getMegaID(cid) == "X") and 78 or 3)
      doDanoInTargetWithDelay(cid, target, FIREDAMAGE, min, max, (isMega(cid) and getMegaID(cid) == "X") and 584 or 15)
   elseif spell == "Signal Beam" then
      local function doSendMove(cid, area)
         if not isCreature(cid) then return true end
         if isSleeping(cid) then return true end
         doAreaCombatHealth(cid, BUGDAMAGE, myPos, area, -min, -max, -1)
      end
      local info = {
         [0] = {299, solarBeamN, {x = myPos.x + 1, y = myPos.y - 1, z = myPos.z}},
         [1] = {300, solarBeamE, {x = myPos.x + 6, y = myPos.y + 1, z = myPos.z}},
         [2] = {298, solarBeamS, {x = myPos.x + 1, y = myPos.y + 6, z = myPos.z}},
         [3] = {301, solarBeamW, {x = myPos.x - 1, y = myPos.y + 1, z = myPos.z}}
      }
      doSendMagicEffect(info[myDirection][3], info[myDirection][1])
      addEvent(doSendMove, 2000, cid, info[myDirection][2])

   elseif spell == "Scald" then
	local myPos = isCreature(cid) and getThingPosWithDebug(cid) or nil
	local myDirection = getCreatureDirectionToTarget(cid, target)
		local info = {
			[0] = {365, throwerN, {x = myPos.x + 1, y = myPos.y - 1, z = myPos.z}},
			[1] = {368, throwerE, {x = myPos.x + 3, y = myPos.y + 1, z = myPos.z}},
			[2] = {366, throwerS, {x = myPos.x + 1, y = myPos.y + 3, z = myPos.z}},
			[3] = {367, throwerW, {x = myPos.x - 1, y = myPos.y + 1, z = myPos.z}}
		}
		doSendMagicEffect(info[myDirection][3], info[myDirection][1])
		doAreaCombatHealth(cid, FIREDAMAGE, myPos, info[myDirection][2], -min, -max, 503)
	 
   elseif spell == "Magma Fist" then
         local myPos = getThingPosWithDebug(cid)
         local myDirection = getCreatureDirectionToTarget(cid, target)
         local info = {
            [0] = {601, cannon3N, {x = myPos.x + 1, y = myPos.y - 1, z = myPos.z}},
            [1] = {603, cannon3E, {x = myPos.x + 4, y = myPos.y + 1, z = myPos.z}},
            [2] = {602, cannon3S, {x = myPos.x + 1, y = myPos.y + 4, z = myPos.z}},
            [3] = {604, cannon3W, {x = myPos.x - 1, y = myPos.y + 1, z = myPos.z}}
         }
         doSendMagicEffect(info[myDirection][3], info[myDirection][1])
         doAreaCombatHealth(cid, FIREDAMAGE, myPos, info[myDirection][2], -min, -max, -1)
	 
   elseif spell == "Flamethrower" then
	local myPos = isCreature(cid) and getThingPosWithDebug(cid) or nil
	local myDirection = getCreatureDirectionToTarget(cid, target)
		local info = {
			[0] = {55, throwerN, {x = myPos.x + 1, y = myPos.y - 1, z = myPos.z}},
			[1] = {58, throwerE, {x = myPos.x + 3, y = myPos.y + 1, z = myPos.z}},
			[2] = {56, throwerS, {x = myPos.x + 1, y = myPos.y + 3, z = myPos.z}},
			[3] = {57, throwerW, {x = myPos.x - 1, y = myPos.y + 1, z = myPos.z}}
		}
		doSendMagicEffect(info[myDirection][3], info[myDirection][1])
		doAreaCombatHealth(cid, FIREDAMAGE, myPos, info[myDirection][2], -min, -max, 1392)
		-- doAreaCombatHealth(cid, STATUS_BURN10, myPos, info[myDirection][2], -min, -max, 1392)

   elseif spell == "Fireball" then
	local target = target or isCreature(getMasterTarget(cid)) and getMasterTarget(cid) or 0
	local myPos = getThingPosWithDebug(cid) 
	local targetPos = isCreature(target) and getThingPos(target) or nil
    doSendDistanceShoot(myPos, targetPos, 3)
    doAreaCombatHealth(cid, FIREDAMAGE, targetPos, circle2x2, -min, -max, 6)
	-- doAreaCombatHealth(cid, STATUS_BURN10, myPos, circle2x2, -min, -max, 1392)
    doTargetCombatHealth(cid, target, FIREDAMAGE, -min, -max, 6)

   elseif spell == "Fire Fang" then
	local target = target or isCreature(getMasterTarget(cid)) and getMasterTarget(cid) or 0
	local targetPos = isCreature(target) and getThingPos(target) or nil
	local myPos = isCreature(cid) and getThingPosWithDebug(cid) or nil
	local pos = getThingPos(target)
	pos.x = pos.x +1
	pos.y = pos.y +1
	doSendMagicEffect(pos, 666)
	doTargetCombatHealth(cid, target, FIREDAMAGE, -min, -max, 1392)
	-- doTargetCombatHealth(cid, target, STATUS_BURN10, -min, -max, 1392)
	

   elseif spell == "Fire Blast" then
	local myPos = getThingPosWithDebug(cid)
	local pokeLevel = getMasterLevel(cid)
	local myDirection = isCreature(target) and getCreatureDirectionToTarget(cid, target) or getCreatureLookDir(cid)
    local function doSendMove(cid, area, effect, turn)
        if not isCreature(cid) then return true end
        if isSleeping(cid) then return true end
        doAreaCombatHealth(cid, FIREDAMAGE, area, line1x1, -min, -max, 36)
		-- doAreaCombatHealth(cid, STATUS_BURN10, area, line1x1, -min, -max, 1392)
        doSendMagicEffect(area, effect)
    end
    for i = 0, 5 do
        local info = {
            [0] = {60, {x = myPos.x, y = myPos.y - (i+1), z = myPos.z}},
            [1] = {61, {x = myPos.x + (i+1), y = myPos.y, z = myPos.z}},
            [2] = {62, {x = myPos.x, y = myPos.y + (i+1), z = myPos.z}},
            [3] = {63, {x = myPos.x - (i+1), y = myPos.y, z = myPos.z}}
        }
        addEvent(doSendMove, i * 300, cid, info[myDirection][2], info[myDirection][1], i+1)
    end


   elseif spell == "Rage" then

      local ret = {}
      ret.id = cid
      ret.cd = 15
      ret.eff = 13
      ret.check = 0
      ret.buff = spell
      ret.first = true

      doCondition2(ret)

   elseif spell == "Flame Burst" then
	  	local myPos = getThingPosWithDebug(cid)
		doFrontalCombatHealth(cid, myPos, FIREDAMAGE, min, max, (isMega(cid) and getMegaID(cid) == "X") and 584 or 6, (isMega(cid) and getMegaID(cid) == "X") and 78 or 3)
   elseif spell == "Dragon Claw" then
      local topos = getThingPos(target)
      topos.x = topos.x + 1
      topos.y = topos.y + 1
      doSendMagicEffect(topos, 641)
      doDanoWithProtect(cid, DRAGONDAMAGE, getThingPosWithDebug(target), 0, -min, -max, 1392)

   elseif spell == "Wing Attack" then
      local myPos = getThingPosWithDebug(cid)
      local myDirection = isCreature(target) and getCreatureDirectionToTarget(cid, target) or getCreatureLookDir(cid)
      local info = {
         [0] = {128, {x = myPos.x + 1, y = myPos.y - 1, z = myPos.z}, {x = myPos.x, y = myPos.y - 1, z = myPos.z}},
         [1] = {129, {x = myPos.x + 2, y = myPos.y + 1, z = myPos.z}, {x = myPos.x + 1, y = myPos.y, z = myPos.z}},
         [2] = {131, {x = myPos.x + 1, y = myPos.y + 2, z = myPos.z}, {x = myPos.x, y = myPos.y + 1, z = myPos.z}},
         [3] = {130, {x = myPos.x - 1, y = myPos.y + 1, z = myPos.z}, {x = myPos.x - 1, y = myPos.y, z = myPos.z}}
      }
      doSendMagicEffect(info[myDirection][2], info[myDirection][1])
      doAreaCombatHealth(cid, FLYINGDAMAGE, info[myDirection][3], line1x1, -min, -max, 1392)

   elseif spell == "Magma Storm" then
      local myPos = getThingPosWithDebug(cid)
      local function doSendMove(cid, area, effect)
         if not isCreature(cid) then
            return true
         end
         doAreaCombatHealth(cid, FIREDAMAGE, myPos, area, -min, -max, effect)
		 -- doAreaCombatHealth(cid, STATUS_BURN10, myPos, area, -min, -max, 1392)
      end
      for i = 0, 3 do
         local areas = {square1x1, magmaStorm1, magmaStorm2, magmaStorm4, magmaStorm4}
         local effects = (isMega(cid) and getMegaID(cid) == "X") and {584, 583, 584, 583} or doCorrectString(getCreatureName(cid)) == "Shiny Magmortar" and {584, 583, 584, 583} or {6, 645, 36, 676} 
         addEvent(doSendMove, i * 500, cid, areas[i + 1], effects[i + 1], i + 1)
      end

   elseif spell == "Bubbles" then

      doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 2)
      doDanoInTargetWithDelay(cid, target, WATERDAMAGE, min, max, 68) --alterado v1.7

   elseif spell == "Clamp" then

      doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 2)
      doDanoInTargetWithDelay(cid, target, WATERDAMAGE, min, max, 53)  --alterado v1.7

   elseif spell == "Water Gun" then
   
	local myPos = getThingPosWithDebug(cid)
	local myDirection = getCreatureDirectionToTarget(cid, target)
    local info = {
        [0] = {74, missile6N, {x = myPos.x, y = myPos.y - 1, z = myPos.z}},
        [1] = {69, missile6E, {x = myPos.x + 6, y = myPos.y, z = myPos.z}},
        [2] = {77, missile6S, {x = myPos.x, y = myPos.y + 6, z = myPos.z}},
        [3] = {72, missile6W, {x = myPos.x - 1, y = myPos.y, z = myPos.z}}
    }
    doSendMagicEffect(info[myDirection][3], info[myDirection][1])
    doAreaCombatHealth(cid, WATERDAMAGE, myPos, info[myDirection][2], -min, -max, 1392)

   elseif spell == "Waterball" then

      doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 2)
      doDanoWithProtectWithDelay(cid, target, WATERDAMAGE, min, max, 68, waba)

   elseif spell == "Aqua Tail" then

      doFaceOpposite(cid)
      doAreaCombatHealth(cid, WATERDAMAGE, getThingPosWithDebug(target), 0, -min, -max, 68)

   elseif spell == "Dragon Tail" then
      doFaceOpposite(cid)
      doDanoWithProtect(cid, DRAGONDAMAGE, getThingPosWithDebug(target), 0, -min, -max, 160)


   elseif spell == "Hydro Cannon" then
	local myPos = getThingPosWithDebug(cid)
	local pokeLevel = getMasterLevel(cid)
	local myDirection = isCreature(target) and getCreatureDirectionToTarget(cid, target) or getCreatureLookDir(cid)
    local function doSendMove(cid, area, effect, turn)
        if not isCreature(cid) then return true end
        if isSleeping(cid) then return true end
        doAreaCombatHealth(cid, WATERDAMAGE, area, line1x1, -min, -max, 68)
        doSendMagicEffect(area, effect)
    end
    for i = 0, 5 do
        local info = {
            [0] = {64, {x = myPos.x, y = myPos.y - (i+1), z = myPos.z}},
            [1] = {65, {x = myPos.x + (i+1), y = myPos.y, z = myPos.z}},
            [2] = {66, {x = myPos.x, y = myPos.y + (i+1), z = myPos.z}},
            [3] = {67, {x = myPos.x - (i+1), y = myPos.y, z = myPos.z}}
        }
        addEvent(doSendMove, i * 300, cid, info[myDirection][2], info[myDirection][1], i+1)
    end

   elseif spell == "Harden" or spell == "Calm Mind" or spell == "Defense Curl" or spell == "Charm" then
      --alterado v1.4
      if spell == "Calm Mind" then
         eff = 133
      elseif spell == "Charm" then
         eff = 147
      else
         eff = 144
      end

      local ret = {}
      ret.id = cid
      ret.cd = 8
      ret.eff = eff
      ret.check = 0
      ret.buff = spell
      ret.first = true

      doCondition2(ret)

	elseif spell == "Bubble Blast" or spell == "Brine" then

	  	local myPos = getThingPosWithDebug(cid)
		doFrontalCombatHealth(cid, myPos, WATERDAMAGE, min, max, 68, 2)
	elseif spell == "Gastro Acid" then 
	  	local myPos = getThingPosWithDebug(cid)
		doFrontalCombatHealth(cid, myPos, POISONDAMAGE, min, max, 637, 81)
	elseif spell == "Venomous Gale" then
	local function doSendMove(cid, turn)
	if not isCreature(cid) then
		return true
	end
	local turn = turn or 1
	local event = addEvent(doSendMove, 150, cid, turn + 1)
	local area1 = {flare1, flare2, flare3, flare4, flare5, flare6, flare1, flare2, flare3, flare4, flare5, flare6, flare1, flare2, flare3, flare4, flare5, flare6, flare1, flare2, flare3, flare4, flare5, flare6}
	doAreaCombatHealth(cid, POISONDAMAGE, getThingPosWithDebug(cid), area1[turn], -min, -max, 844)
	if turn == 24 or isSleeping(cid) then
		doAppear(cid)
		stopEvent(event)
	end
	end
	doSendMove(cid)
	doDisapear(cid)
	local pos = getThingPosWithDebug(cid)
	pos.x = pos.x + 1
	pos.y = pos.y + 1
	doSendMagicEffect(pos, 905)

   elseif spell == "Rock Wrecker" then

      local pos = getThingPosWithDebug(cid)
      pos.x = pos.x+1
      pos.y = pos.y+1
      sendEffWithProtect(cid, pos, 244)

      local function doSendBubble(cid, pos)
         if not isCreature(cid) then return true end
         if isWithFear(cid) and getPlayerStorageValue(cid, 3644587) >= 1 then return true end
         if isSleeping(cid) and getPlayerStorageValue(cid, 3644587) >= 1 then return true end
         doSendDistanceShoot(getThingPosWithDebug(cid), pos, 37)
         doSendMagicEffect(pos, 270)
      end
      --alterado!!
      for a = 1, 20 do
         local lugar = {x = pos.x + math.random(-4, 4), y = pos.y + math.random(-3, 3), z = pos.z}
         addEvent(doSendBubble, 1000 + a * 25, cid, lugar)
      end
      addEvent(doDanoWithProtect, 1150, cid, ROCKDAMAGE, pos, waterarea, -min, -max, 1392)

   elseif spell == "Ominous Wind" then
      local pos = getThingPosWithDebug(cid)
      pos.x = pos.x +2
      pos.y = pos.y +2
      doSendMagicEffect(pos, 880)
      doAreaCombatHealth(cid, GHOSTDAMAGE, myPos, square2x2, -min, -max, -1)

   elseif spell == "Hydropump" then
      local pos = getThingPosWithDebug(cid)
      -- doSendCreatureJump(cid)
      local function doSendBubble(cid, pos)
         if not isCreature(cid) then
            return true
         end
         if isWithFear(cid) and getPlayerStorageValue(cid, 3644587) >= 1 then
            return true
         end
         if isSleeping(cid) and getPlayerStorageValue(cid, 3644587) >= 1 then
            return true
         end
         doSendDistanceShoot(getThingPosWithDebug(cid), pos, 2)
         doSendMagicEffect(pos, 53)
      end
      for a = 1, 20 do
         local lugar = {x = pos.x + math.random(-4, 4), y = pos.y + math.random(-3, 3), z = pos.z}
         addEvent(doSendBubble, a * 25, cid, lugar)
      end
      addEvent(doDanoWithProtect, 150, cid, WATERDAMAGE, pos, waterarea, -min, -max, -1)



   elseif spell == "Flame Circle" then
	local myPos = getThingPosWithDebug(cid)
    local area1 = {WF11, WF12, WF13, WF14, WF15, WF16, WF17, WF18}
    local area2 = {WF21, WF22, WF23, WF24, WF25, WF26, WF27, WF28, WF29, WF210, WF211, WF212, WF213, WF214, WF215, WF216}
    local area3 = {WF31, WF32, WF33, WF34, WF35, WF36, WF37, WF38, WF39, WF310, WF311, WF312, WF313, WF314, WF315, WF316, WF317, WF318, WF319, WF320, WF321, WF322, WF323, WF324}
    for i = 0, 7 do
        addEvent(doAreaCombatHealth, i * 300, cid, FIREDAMAGE, myPos, area1[i+1], -min, -max, 6)
    end
    for i = 0, 15 do
        addEvent(doAreaCombatHealth, i * 160, cid, FIREDAMAGE, myPos, area2[i+1], -min, -max, 6)
    end
    for i = 0, 23 do
        addEvent(doAreaCombatHealth, i * 110, cid, FIREDAMAGE, myPos, area3[i+1], -min, -max, 6)
    end


   elseif spell == "String Shot" then

    doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 23)
	doTargetCombatHealth(cid, target, STATUS_STUN7, -6, -6, 137)

   elseif spell == "Bug Bite" then
        -- doSendMagicEffect(getThingPosWithDebug(target), 244)
        doDanoInTargetWithDelay(cid, target, BUGDAMAGE, min, max, 8)
   elseif spell == "Super Sonic" then
		doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 23)
		doTargetCombatHealth(cid, target, STATUS_CONFUSION10, -31, -31, 137)

	elseif spell == "Whirlwind" then
		local function doFall(cid)
			for rocks = 1, 42 do
				addEvent(fall, rocks * 35, cid, master, FLYINGDAMAGE, -1, 1142)
			end
		end
	addEvent(doFall, 450, cid)
    addEvent(doAreaCombatHealth, 2000, cid, FLYINGDAMAGE, getThingPosWithDebug(cid), BigArea2New, -min, -max, -1)
	doAreaCombatHealth(cid, STATUS_STUN7, myPos, circle4x4, -424, -424, 1392)
   elseif spell == "Swagger" then
	  doAreaCombatHealth(cid, STATUS_STUN7, myPos, circle3x3, -1283, -1283, 1283)
	  
	elseif spell == "Flip Turn" then
		local pos = getThingPosWithDebug(cid)
		pos.x = pos.x + 1
		pos.y = pos.y + 1
		doSendMagicEffect(pos, 1275)
		doAreaCombatHealth(cid, STATUS_STUN7, myPos, circle3x3, -1274, -1274, 1274)
	
   -- elseif spell == "Razor Wind" then --BOTAR PRA FUNCIONAR

      -- area = {SL1, SL2, SL3, SL4}

      -- for i = 0, 3 do
         -- addEvent(doMoveInArea2, i*300, cid, 131, area[i+1], NORMALDAMAGE, min, max, spell)
      -- end

   elseif spell == "Psybeam" then

      for i = 1, 6 do
         local info = {
            [0] = {108, {x = myPos.x, y = myPos.y - i, z = myPos.z}},
            [1] = {106, {x = myPos.x + i, y = myPos.y, z = myPos.z}},
            [2] = {109, {x = myPos.x, y = myPos.y + i, z = myPos.z}},
            [3] = {107, {x = myPos.x - i, y = myPos.y, z = myPos.z}}
         }
         doAreaCombatHealth(cid, PSYCHICDAMAGE, info[myDirection][2], nil, -min, -max, info[myDirection][1])
      end

   elseif spell == "Sand Attack" then
         local p = getThingPosWithDebug(cid)
         local d = isCreature(target) and getCreatureDirectionToTarget(cid, target) or getCreatureLookDir(cid)

         function sendAtk(cid, area, areaEff, eff)
            if isCreature(cid) then
               if not isSightClear(p, area, false) then return true end                                             --testar o atk!!
               doAreaCombatHealth(cid, GROUNDDAMAGE, areaEff, 0, 0, 0, eff)
               doAreaCombatHealth(cid, GROUNDDAMAGE, area, whirl3, -min, -max, 1392)
			   doAreaCombatHealth(cid, STATUS_BLIND, area, whirl3, -6, -6, 1392)
            end
         end

         for a = 0, 5 do

            local t = {
               [0] = {120, {x=p.x, y=p.y-(a+1), z=p.z}, {x=p.x, y=p.y-(a+1), z=p.z}},
               [1] = {121, {x=p.x+(a+1), y=p.y, z=p.z}, {x=p.x+(a+1), y=p.y, z=p.z}},
               [2] = {122, {x=p.x, y=p.y+(a+1), z=p.z}, {x=p.x, y=p.y+(a+1), z=p.z}},
               [3] = {119, {x=p.x-(a+1), y=p.y, z=p.z}, {x=p.x-(a+1), y=p.y, z=p.z}}
            }
            addEvent(sendAtk, 200*a, cid, t[d][2], t[d][3], t[d][1])
         end	

   elseif spell == "Torment" then
		doAreaCombatHealth(cid, STATUS_SILENCE, myPos, circle3x3, -219, -219, 219)
		setPlayerStorageValue(cid, 253, 1)
		sendOpcodeStatusInfo(cid)
		if isSummon(cid) then
			doClearBallStatus(getPlayerSlotItem(getCreatureMaster(cid), 8).uid)
		end
		doClearPokemonStatus(cid)
	  
	elseif spell == "Confusion" then
		doAreaCombatHealth(cid, PSYCHICDAMAGE, myPos, circle3x3, -min, -max, 136)
		doAreaCombatHealth(cid, STATUS_CONFUSION10, myPos, circle3x3, -31, -31, 1392)
   
	elseif spell == "Night Shade" then
		local pos = getThingPosWithDebug(cid)
		pos.x = pos.x + 1
		pos.y = pos.y + 1
		doSendMagicEffect(pos, 667)
		doAreaCombatHealth(cid, PSYCHICDAMAGE, myPos, circle3x3, -min, -max, 428)
		doAreaCombatHealth(cid, STATUS_CONFUSION10, myPos, circle3x3, -31, -31, 1392)
   
   elseif spell == "Horn Attack" then
      doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 15)
      doDanoInTargetWithDelay(cid, target, NORMALDAMAGE, min, max, 3)

   elseif spell == "Poison Sting" then
      doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 15)
      doDanoInTargetWithDelay(cid, target, POISONDAMAGE, min, max, 8)

   elseif spell == "Fury Cutter" then
    local function doSendMove(cid)
        if not isCreature(cid) then return true end
        if isSleeping(cid) then return true end
        local myPos = isCreature(cid) and getThingPosWithDebug(cid) or nil
        local myDirection = getCreatureDirectionToTarget(cid, target)
        local info = {
            [0] = {128, {x = myPos.x + 1, y = myPos.y - 1, z = myPos.z}, {x = myPos.x, y = myPos.y - 1, z = myPos.z}},
            [1] = {129, {x = myPos.x + 2, y = myPos.y + 1, z = myPos.z}, {x = myPos.x + 1, y = myPos.y, z = myPos.z}},
            [2] = {131, {x = myPos.x + 1, y = myPos.y + 2, z = myPos.z}, {x = myPos.x, y = myPos.y + 1, z = myPos.z}},
            [3] = {130, {x = myPos.x - 1, y = myPos.y + 1, z = myPos.z}, {x = myPos.x - 1, y = myPos.y, z = myPos.z}}
        }
        doSendMagicEffect(info[myDirection][2], info[myDirection][1])
        doAreaCombatHealth(cid, BUGDAMAGE, info[myDirection][3], line1x1, -min, -max, 1392)
    end
    for i = 0, 1 do
        addEvent(doSendMove, i * 200, cid)
    end

	elseif spell == "Red Fury" then
    local function doSendMove(cid)
        if not isCreature(cid) then return true end
        if isSleeping(cid) then return true end
        local myPos = isCreature(cid) and getThingPosWithDebug(cid) or nil
        local myDirection = getCreatureDirectionToTarget(cid, target)
        local info = {
            [0] = {247, {x = myPos.x + 1, y = myPos.y - 1, z = myPos.z}, {x = myPos.x, y = myPos.y - 1, z = myPos.z}},
            [1] = {250, {x = myPos.x + 2, y = myPos.y + 1, z = myPos.z}, {x = myPos.x + 1, y = myPos.y, z = myPos.z}},
            [2] = {249, {x = myPos.x + 1, y = myPos.y + 2, z = myPos.z}, {x = myPos.x, y = myPos.y + 1, z = myPos.z}},
            [3] = {251, {x = myPos.x - 1, y = myPos.y + 1, z = myPos.z}, {x = myPos.x - 1, y = myPos.y, z = myPos.z}}
        }
        doSendMagicEffect(info[myDirection][2], info[myDirection][1])
        doAreaCombatHealth(cid, BUGDAMAGE, info[myDirection][3], line1x1, -min, -max, 1392)
    end
    for i = 0, 1 do
        addEvent(doSendMove, i * 200, cid)
    end

   elseif spell == "Pin Missile" then
	  	local myPos = getThingPosWithDebug(cid)
		doFrontalCombatHealth(cid, myPos, BUGDAMAGE, min, max, 7, 13)
	elseif spell == "Rock Polish" then
        doRaiseStatus(cid, 0, 2, 200, 6)
        local function sendEffect(cid)
            local pos = getThingPosWithDebug(cid)
            pos.x = pos.x + 1
            pos.y = pos.y + 1
            doSendMagicEffect(pos, 1322)
        end
        for i = 0, 5 do
            addEvent(sendEffect, i * 1000, cid)
        end

   elseif spell == "Strafe" or spell == "Agility" then

      local ret = {}
      ret.id = cid
      ret.cd = 15
      ret.eff = 14
      ret.check = 0
      ret.buff = spell
      ret.first = true

      doCondition2(ret)

   elseif spell == "Gust" then
	local myPos = getThingPosWithDebug(cid)
    local myDirection = getCreatureDirectionToTarget(cid, target)
    local function doSendMove(cid, turn)
        if not isCreature(cid) then return true end
        if isSleeping(cid) then return true end
        local info = {
            [0] = {x = myPos.x, y = myPos.y - turn, z = myPos.z},
            [1] = {x = myPos.x + turn, y = myPos.y, z = myPos.z},
            [2] = {x = myPos.x, y = myPos.y + turn, z = myPos.z},
            [3] = {x = myPos.x - turn, y = myPos.y, z = myPos.z}
        }
        doAreaCombatHealth(cid, FLYINGDAMAGE, info[myDirection], nil, -min, -max, 1392)
        if not isNumberPair(turn) then
            doSendMagicEffect(info[myDirection], 42)
        end
    end
    for i = 0, 4 do
        addEvent(doSendMove, i * 150, cid, i+1)
    end
   elseif spell == "Drill Peck" then
	if not isCreature(cid) then return true end
 	local target = target or isCreature(getMasterTarget(cid)) and getMasterTarget(cid) or 0
	local targetPos = isCreature(target) and getThingPos(target) or nil
	doTargetCombatHealth(cid, target, FLYINGDAMAGE, -min, -max, 148)
	
   elseif spell == "Tornado" then
        local function doSendMove(cid, turn)
            if not isCreature(cid) then
                return true
            end
            local turn = turn or 1
            local event = addEvent(doSendMove, 50, cid, turn + 1)
        local myPos = getThingPosWithDebug(cid)
        local pos = {x = myPos.x + math.random(-4, 4), y = myPos.y + math.random(-4, 4), z = myPos.z}
        if getThingFromPos(pos).itemid ~= 0 then
            doSendMagicEffect(pos, 42)
            doSendDistanceShoot(myPos, pos, 22)
        end
            if turn == 21 or isSleeping(cid) then
                stopEvent(event)
            end
        end
        doSendMove(cid)
		addEvent(doAreaCombatHealth, 1000, cid, FLYINGDAMAGE, myPos, square4x4, -min, -max, 1392)
	    

   elseif spell == "Bite" or tonumber(spell) == 5 then

      doDanoWithProtect(cid, DARKDAMAGE, getThingPosWithDebug(target), 0, -min, -max, 146)

   elseif spell == "Super Fang" then

      doDanoWithProtect(cid, NORMALDAMAGE, getThingPosWithDebug(target), 0, -min, -max, 244)

    elseif spell == "Poison Fang" then
        doSendMagicEffect(getThingPosWithDebug(target), 115)
        doDanoInTargetWithDelay(cid, target, POISONDAMAGE, min, max, 114)

   elseif spell == "Sting Gun" or spell == "Gunk Shot" then

      local function doGun(cid, target)
         if not isCreature(cid) or not isCreature(target) then return true end    --alterado v1.7
         doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 13)
         doDanoInTargetWithDelay(cid, target, POISONDAMAGE, min, max, 8)  --alterado v1.7
      end

      setPlayerStorageValue(cid, 3644587, 1)
      addEvent(setPlayerStorageValue, 200, cid, 3644587, 1)
      for i = 0, 2 do
         addEvent(doGun, i*100, cid, target)
      end

	elseif spell == "Acid" then

		doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 14)
		doDanoInTargetWithDelay(cid, target, POISONDAMAGE, min, max, 20)    --alterado v1.7

	elseif spell == "Fear" then
		doAreaCombatHealth(cid, STATUS_FEAR, myPos, circle3x3, -139, -139, 1392)
		
	elseif spell == "Roar" then
		doAreaCombatHealth(cid, STATUS_FEAR, myPos, circle3x3, -115, -115, 1392)
	  


   elseif spell == "Poison Tail" then

        local pos = getThingPosWithDebug(cid)
        pos.x = pos.x + 1
        pos.y = pos.y + 1
        doSendMagicEffect(pos, 667)
        doAreaCombatHealth(cid, POISONDAMAGE, myPos, square2x2, -min, -max, 906)

   elseif spell == "Iron Tail" then

      doFaceOpposite(cid)
      doDanoWithProtect(cid, STEELDAMAGE, getThingPosWithDebug(target), 0, -min, -max, 160)

   elseif spell == "Thunder Shock" then

      doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 40)
      doDanoInTargetWithDelay(cid, target, ELECTRICDAMAGE, min, max, 48)   --alterado v1.7

   elseif spell == "Thunder Bolt" or spell == "Thunderbolt" then

      --alterado v1.7
      local function doThunderFall(cid, frompos, target)
         if not isCreature(target) or not isCreature(cid) then return true end
         local pos = getThingPosWithDebug(target)
         local ry = math.abs(frompos.y - pos.y)
         doSendDistanceShoot(frompos, getThingPosWithDebug(target), 41)
         addEvent(doDanoInTarget, ry * 11, cid, target, ELECTRICDAMAGE, min, max, 48) --alterado v1.7
      end

      local function doThunderUp(cid, target)
         if not isCreature(target) or not isCreature(cid) then return true end
         local pos = getThingPosWithDebug(target)
         local mps = getThingPosWithDebug(cid)
         local xrg = math.floor((pos.x - mps.x) / 2)
         local topos = mps
         topos.x = topos.x + xrg
         local rd =  7
         topos.y = topos.y - rd
         doSendDistanceShoot(getThingPosWithDebug(cid), topos, 41)
         addEvent(doThunderFall, rd * 49, cid, topos, target)
      end

      setPlayerStorageValue(cid, 3644587, 1)
      addEvent(setPlayerStorageValue, 350, cid, 3644587, -1)
      for thnds = 1, 2 do
         addEvent(doThunderUp, thnds * 155, cid, target)
      end

   elseif spell == "Thunder Wave" then
	local myPos = getThingPos(cid)
	local myDirection = getCreatureDirectionToTarget(cid, target)
    local info = {
        [0] = thunderwave5N,
        [1] = thunderwave5E,
        [2] = thunderwave5S,
        [3] = thunderwave5W
    }
    doAreaCombatHealth(cid, ELECTRICDAMAGE, myPos, info[myDirection], -min, -max, 48)

   elseif spell == "Thunder" then
	  
	local myPos = getThingPos(cid)
	local effectPos = {x = myPos.x + 1, y = myPos.y, z = myPos.z}
	doSendMagicEffect(effectPos, 453)
	doAreaCombatHealth(cid, STATUS_PARALYZE, myPos, square4x4, -48, -48, 1392)	
	doAreaCombatHealth(cid, ELECTRICDAMAGE, myPos, thunderr, -min, -max, 48)

   elseif spell == "Web Shot" then
	doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 23)
	doAreaCombatHealth(cid, BUGDAMAGE, getThingPosWithDebug(target), 0, -min, -max, 274)
	doAreaCombatHealth(cid, STATUS_STUN7, getThingPosWithDebug(target), 0, -274, -274, 274)


   elseif spell == "Wood Hammer" then

      doDanoInTargetWithDelay(cid, target, GRASSDAMAGE, min, max, 514)   --alterado v1.7

   elseif spell == "Mega Kick" then

      doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 39)
      doDanoInTargetWithDelay(cid, target, FIGHTINGDAMAGE, min, max, 113)

   elseif spell == "Double Kick" then

      doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 39)
      doDanoInTargetWithDelay(cid, target, FIGHTINGDAMAGE, min, max, 113)   --alterado v1.7

   elseif spell == "Thunder Punch" then
      doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 39)
      -- doSendMagicEffect(getThingPosWithDebug(target), 453)
      doDanoInTargetWithDelay(cid, target, ELECTRICDAMAGE, min, max, 48)

   elseif spell == "Comet Punch" then

      doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 39)
      doSendMagicEffect(getThingPosWithDebug(target), 112)
      doDanoInTargetWithDelay(cid, target, ELECTRICDAMAGE, min, max, 118) --alterado v1.7

	elseif spell == "Electric Storm" then
    local function doSendMoveDown(cid)
        if not isCreature(cid) then return true end
        for i = 0, 20 do
            addEvent(doSendMoveEffectDown, i * 50, cid, 48, 41)
        end
    end
    local function doSendMoveDamage(cid)
        if not isCreature(cid) then return true end
        doAreaCombatHealth(cid, ELECTRICDAMAGE, myPos, square4x4, -min, -max, 1392)
    end
    for i = 0, 20 do
        addEvent(doSendMoveEffectUp, i * 50, cid, 41)
    end
    addEvent(doSendMoveDown, 500, cid)
    addEvent(doSendMoveDamage, 1500, cid)
	doAreaCombatHealth(cid, STATUS_STUN7, myPos, square4x4, -48, -48, 1392)	


   elseif spell == "Curse" then
	-- if getPlayerStorageValue(cid, STORAGE_CURSE) == 1 then
		-- doCreatureAddHealth(cid, -getCreatureMaxHealth(cid) / 10)
	-- else
		-- return false
	-- end
     
      doSendMagicEffect(myPos, 13)
      doSendMagicEffect(myPos, 526)
      local function teste(cid)
         if not isCreature(cid) then
            return true
         end
         for i = 0, 13 do
            addEvent(doAreaCombatHealth, i * 500, cid, GHOSTDAMAGE, myPos, square6x6, -min, -max, -1)
         end
      end
      addEvent(teste, 3000, cid)


   elseif spell == "Hex" then
	if getPlayerStorageValue(cid, STORAGE_CURSE) == 0 then
		setPlayerStorage(cid, STORAGE_CURSE, 1)
	end
      local out = {
	
         ["Gengar"] = {2201, 2054},
         ["Dusknoir"] = {1937, 1907},
         ["Dusclops"] = {1959, 1906}
      }

      local function eff(cid)
         if not isCreature(cid) then
            return true
         end
         setPlayerStorageValue(cid, 9658783, -1)
         doSetCreatureOutfit(cid, {lookType = (getMegaID(cid) == "X" and 2201 or out[getCreatureName(cid)][2])}, -1)
		 doAreaCombatHealth(cid, GHOSTDAMAGE, myPos, circle3x3, -min, -max, 528)
      end

      if out[getCreatureName(cid)] then
         doSetCreatureOutfit(cid, {lookType = out[getCreatureName(cid)][1]}, -1)
      end

      setPlayerStorageValue(cid, 9658783, 1)
      doRaiseStatus(cid, 0, 0, 100, 5)
      addEvent(eff, 5000, cid)

   elseif spell == "Shadow Panic" then
      local pos = getThingPosWithDebug(cid)
      pos.x = pos.x + 3
      pos.y = pos.y + 2
      doSendMagicEffect(pos, 1038)
      setPlayerStorageValue(cid, 253, 1)
	  doAreaCombatHealth(cid, STATUS_SILENCE, myPos, square3x3, -219, -219, 1392)
	  

      elseif spell == "Shadow Blast" then
         -- for rocks = 1, 40 do
            -- addEvent(fall, rocks * 50, cid, master, GHOSTDAMAGE, -1, 1040)
         -- end
        local function doSendMove(cid, turn)
            if not isCreature(cid) then
                return true
            end
            local turn = turn or 1
            local event = addEvent(doSendMove, 50, cid, turn + 1)
        local myPos = getThingPosWithDebug(cid)
        local pos = {x = myPos.x + math.random(0, 8), y = myPos.y + math.random(0, 8), z = myPos.z}
        if getThingFromPos(pos).itemid ~= 0 then
            doSendMagicEffect(pos, 1040)
        end
            if turn == 40 or isSleeping(cid) then
                stopEvent(event)
				
            end
        end
		
        doSendMove(cid)
		addEvent(doAreaCombatHealth, 1000, cid, GHOSTDAMAGE, myPos, square4x4, -min, -max, 1392)

      elseif spell == "Shadow Cannon" then
         local function doSendMove(cid, area, effectarea, effect, turn)
            if not isCreature(cid) then
               return true
            end
            -- if getPokemonStatus(cid, "sleep") then return true end
            doAreaCombatHealth(cid, GHOSTDAMAGE, area, line1x1, min, max, 265)
            doSendMagicEffect(effectarea, effect)
         end
         for i = 0, 5 do
            local info = {
               [0] = {1039, {x = myPos.x, y = myPos.y - (i + 1), z = myPos.z}, {x = myPos.x + 1, y = myPos.y - i, z = myPos.z}},
               [1] = {1039, {x = myPos.x + (i + 1), y = myPos.y, z = myPos.z}, {x = myPos.x + (i + 2), y = myPos.y + 1, z = myPos.z}},
               [2] = {1039, {x = myPos.x, y = myPos.y + (i + 1), z = myPos.z}, {x = myPos.x + 1, y = myPos.y + (i + 2), z = myPos.z}},
               [3] = {1039, {x = myPos.x - (i + 1), y = myPos.y, z = myPos.z}, {x = myPos.x - i, y = myPos.y + 2, z = myPos.z}}
            }
            addEvent(doSendMove, i * 300, cid, info[myDirection][2], info[myDirection][3], info[myDirection][1], i + 1)
         end

      elseif spell == "Outrage" then
         local config = {
            outfit = {
               --["pokemon_name"] = outfit,
               ["Salamence"] = 1914,
               ["Shiny Dragonite"] = 2217,
               ["Ampharos"] = 2497,
               ["Sceptile"] = 2427,
               ["Charizard"] = 2064,
               ["Kingdra"] = 2250
            },
            AOE = {
               times = 3, --Quantas vezes o golpe AOE será usado.
               interval = 1500, --Intervalo de tempo, em milésimos de segundo, entre cada golpe AOE.
               combat = DRAGONDAMAGE, --Elemento.
               spell = {
                  --Uma tabela deverá ser configurada com a área e efeito da parte com socos, e a outra com a parte do efeito do Draco Meteor.
                  {area = OutrageArea1, effect = 112}, --{area = área do dano AOE, effect = efeito}
                  {area = OutrageArea2, effect = 483}
               }
            }
         }

         local function doOutrage(cid, times)
            if not isCreature(cid) then
               return true
            end
            for i = 1, #config.AOE.spell do
               doMoveInArea2(
               cid,
               config.AOE.spell[i].effect,
               config.AOE.spell[i].area,
               config.AOE.combat,
               min,
               max,
               spell
               )
            end
            times = times - 1
            if times <= 0 then
               local rounds = math.random(4, 7)
               rounds = rounds + math.floor(getPokemonLevel(cid) / 35)
               local ret = {}
               ret.id = cid
               ret.cd = rounds
               ret.check = getPlayerStorageValue(cid, conds["Confusion"])
               ret.cond = "Confusion"
               doCondition2(ret)
               return true
            end
            addEvent(doOutrage, config.AOE.interval, cid, times)
         end
         local function doSetCreatureOutfit2(cid, outfit, time)
            if not isCreature(cid) then
               return true
            end
            return doSetCreatureOutfit(cid, outfit, time)
         end

         local ret = {}
         ret.id = cid
         ret.cd = config.AOE.interval / 1000 * config.AOE.times
         ret.eff = 0
         ret.check = 0
         ret.buff = spell
         ret.first = true
         doCondition2(ret)
         local name = getCreatureName(cid)
         local megaName = "Mega " .. name .. (getCreatureName(cid) == "Charizard" and " X" or "")
         if config.outfit[name] then
            if getPlayerStorageValue(cid, storages.isMega) ~= -1 then
               if isInArray({"Charizard", "Blaziken", "Ampharos"}, name) then
                  setPlayerStorageValue(cid, 213712, 1) -- stop pantinoutfit
                  addEvent(setPlayerStorageValue, (config.AOE.interval * config.AOE.times) + 99, cid, 213712, -1)
                  addEvent(doPantinOutfit, (config.AOE.interval * config.AOE.times) + 100, cid, 0, megaName)
               else
                  addEvent(
                  doSetCreatureOutfit2,
                  config.AOE.interval * config.AOE.times,
                  cid,
                  {lookType = megasConf[megaName].out},
                  -1
                  )
                  addEvent(checkOutfitMega, config.AOE.interval * config.AOE.times, cid, megaName)
               end
               doRemoveConditionSecurity(cid, CONDITION_OUTFIT)
            end
            doSetCreatureOutfit(cid, {lookType = config.outfit[name]}, -1)
            addEvent(doRemoveConditionSecurity, config.AOE.interval * config.AOE.times, cid, CONDITION_OUTFIT)
         end
         local ret2 = {}
         ret2.id = cid
         ret2.cd = config.AOE.interval / 1000 * config.AOE.times
         ret2.eff = 144
         ret2.check = 0
         ret2.buff = spell
         ret2.first = true
         doCondition2(ret2) -- harden

         addEvent(doOutrage, config.AOE.interval, cid, config.AOE.times)

      elseif spell == "Dig" then

    local function doReturn(cid)
        if not isCreature(cid) then return true end
        setCreatureVisibility(cid, false)
        -- doClearPokemonStatus(cid)
        doAreaCombatHealth(cid, GROUNDDAMAGE, getThingPosWithDebug(cid), circle2x2, -min, -max, 118)
    end
    local function doReturnEffect(cid)
        if not isCreature(cid) then return true end
        doSendMagicEffect(getThingPosWithDebug(cid), 510)
    end
    setCreatureVisibility(cid, true)
    doSendMagicEffect(myPos, 510)
    addEvent(doReturn, 3000, cid)
    addEvent(doReturnEffect, 2750, cid)
		 
    elseif spell == "Extrasensory" then
        local function doSendMove(cid, turn)
            if not isCreature(cid) then
                return true
            end
            local turn = turn or 1
            local event = addEvent(doSendMove, 50, cid, turn + 1)
        local myPos = getThingPosWithDebug(cid)
        local pos = {x = myPos.x + math.random(-4, 4), y = myPos.y + math.random(-4, 4), z = myPos.z}
        if getThingFromPos(pos).itemid ~= 0 then
            doSendMagicEffect(pos, 484)
        end
            if turn == 21 or isSleeping(cid) then
                stopEvent(event)
            end
        end
        doSendMove(cid)
		addEvent(doAreaCombatHealth, 1000, cid, PSYCHICDAMAGE, myPos, square4x4, -min, -max, 1392)
		

		
	elseif spell == "Mud Sport" then
        local function doSendMove(cid, turn)
            if not isCreature(cid) then
                return true
            end
            local turn = turn or 1
            local event = addEvent(doSendMove, 100, cid, turn + 1)
			local target = target or isCreature(getMasterTarget(cid)) and getMasterTarget(cid) or 0
			local targetPos = isCreature(target) and getThingPos(target) or nil
			local myPos = isCreature(cid) and getThingPos(cid) or nil
			doSendDistanceShoot(myPos, targetPos, 6)
			doTargetCombatHealth(cid, target, GROUNDDAMAGE, -min, -max, 34)
			doTargetCombatHealth(cid, target, STATUS_BLIND, -6, -6, 1392)
            if turn == 5 or isSleeping(cid) then
                stopEvent(event)
            end
        end
        doSendMove(cid)

      elseif spell == "Discharge" then
        local function doSendMove(cid, turn)
            if not isCreature(cid) then
                return true
            end
            local turn = turn or 1
            local event = addEvent(doSendMove, 50, cid, turn + 1)
        local myPos = getThingPosWithDebug(cid)
        local pos = {x = myPos.x + math.random(-4, 4), y = myPos.y + math.random(-4, 4), z = myPos.z}
        if getThingFromPos(pos).itemid ~= 0 then
            doSendMagicEffect(pos, 453)
        end
            if turn == 21 or isSleeping(cid) then
                stopEvent(event)
            end
        end
        doSendMove(cid) 
		addEvent(doAreaCombatHealth, 1000, cid, ELECTRICDAMAGE, myPos, square4x4, -min, -max, 1392)
		
		
		  
		 

      -- elseif spell == "Dragon Flight" or spell == "Blaze Kick" or spell == "ExtremeSpeed" then

         -- local effs={
            -- ["Dragon Flight"] = {365, 23, DRAGONDAMAGE},
            -- ["Blaze Kick"] = {357, 92, FIREDAMAGE},
            -- ["ExtremeSpeed"] = {3, 50, NORMALDAMAGE, 51},
         -- }

         -- local function sendeffs(cid, target, n)
            -- if not isCreature(cid) then return true end
            -- if not isCreature(target) then return true end
            -- doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), getCreatureName(cid) == "Shiny Arcanine" and effs[spell][4] or effs[spell][2])
         -- end

         -- sendeffs(cid, target, 1)

         -- local topos = getThingPosWithDebug(target)
         -- if spell ~= "ExtremeSpeed" then
            -- topos.x = topos.x+1
         -- else
            -- doSendMagicEffect(getThingPosWithDebug(cid), 211)
         -- end

         -- local function dosomething(cid, topos, eff1, target, eff3, min, max)
            -- if not isCreature(cid) or not isCreature(target) then return true end
            -- doSendMagicEffect(topos, eff1)
            -- doTeleportThing(cid, getClosestFreeTile(target, getThingPosWithDebug(target)), false)
            -- doDanoInTargetWithDelay(cid, target, eff3, min, max, 255)
         -- end

         -- addEvent(dosomething,250,cid, topos, effs[spell][1], target, effs[spell][3], min, max)
	elseif spell == "ExtremeSpeed" then
    local target = target or isCreature(getMasterTarget(cid)) and getMasterTarget(cid) or 0
    local myPos = isCreature(cid) and getThingPosWithDebug(cid) or nil
    local targetPos = isCreature(target) and getThingPos(target) or nil
    local randomPos = getClosestFreeTile(cid, targetPos)
    local function doSendMove(cid, target, turn)
        if not isCreature(cid) or not isCreature(target) then return true end
        if isSleeping(cid) then return true end
        if turn == 1 then
            doSendDistanceShoot(myPos, targetPos, 68)
            doSendMagicEffect(myPos, 211)
            doChangeSpeed(cid, -getCreatureSpeed(cid))
            doCreatureSetNoMove(cid, true)
            setCreatureVisibility(cid, true)
        elseif turn == 2 then
            doSendDistanceShoot(randomPos, targetPos, 68)
            doSendMagicEffect(randomPos, 211)
            doTargetCombatHealth(cid, target, NORMALDAMAGE, -min, -max, 1392)
        elseif turn == 3 then
            doSendDistanceShoot(targetPos, myPos, 68)
            doSendMagicEffect(myPos, 211)
            doRegainSpeed(cid)
            doCreatureSetNoMove(cid, false)
            setCreatureVisibility(cid, false)
        end
    end
    for i = 0, 2 do
        addEvent(doSendMove, i * 500, cid, target, i+1)
    end
	elseif spell == "Blaze Kick" then
    local target = target or isCreature(getMasterTarget(cid)) and getMasterTarget(cid) or 0
    local myPos = isCreature(cid) and getThingPosWithDebug(cid) or nil
    local targetPos = isCreature(target) and getThingPos(target) or nil
    local randomPos = getClosestFreeTile(cid, targetPos)
    local function doSendMove(cid, target, turn)
        if not isCreature(cid) or not isCreature(target) then return true end
        if isSleeping(cid) then return true end
        if turn == 1 then
            doSendDistanceShoot(myPos, targetPos, 95)
            -- doSendMagicEffect(myPos, 211)
            doChangeSpeed(cid, -getCreatureSpeed(cid))
            doCreatureSetNoMove(cid, true)
            setCreatureVisibility(cid, true)
        elseif turn == 2 then
            doSendDistanceShoot(randomPos, targetPos, 95)
            -- doSendMagicEffect(randomPos, 211)
            doTargetCombatHealth(cid, target, NORMALDAMAGE, -min, -max, 1392)
        elseif turn == 3 then
            doSendDistanceShoot(targetPos, myPos, 95)
            -- doSendMagicEffect(myPos, 211)
            doRegainSpeed(cid)
            doCreatureSetNoMove(cid, false)
            setCreatureVisibility(cid, false)
        end
    end
    for i = 0, 2 do
        addEvent(doSendMove, i * 500, cid, target, i+1)
    end
	


      elseif spell == "Magic Bounce" then

         local sto = 128328
         if getPlayerStorageValue(cid, sto) < 0 then
            setPlayerStorageValue(cid, sto, getCreatureLookDir(cid))
            doSetCreatureOutfit(cid, {lookType = 2481+getCreatureLookDir(cid)}, -1)
         else
            setPlayerStorageValue(cid, sto, -1)
            doSetCreatureOutfit(cid, {lookType = 2177}, -1)
         end

      elseif spell == "Shadow Claw" then
         for rocks = 1, 42 do
            addEvent(fall, rocks * 60, cid, master, GHOSTDAMAGE, -1, math.random(860, 861))
         end

         for i = 0, 5 do
            addEvent(doAreaCombatHealth, i * 500, cid, GHOSTDAMAGE, myPos, BigArea2New, -min, -max, -1)
            -- doAreaCombatHealth(cid, ICEDAMAGE, getThingPosWithDebug(cid), splash, -min, -max, 1222)
         end

      elseif spell == "Frenzy Plant" then
        local function doSendMove(cid, turn)
            if not isCreature(cid) then
                return true
            end
            local turn = turn or 1
            local event = addEvent(doSendMove, 50, cid, turn + 1)
        local myPos = getThingPosWithDebug(cid)
        local pos = {x = myPos.x + math.random(-4, 4), y = myPos.y + math.random(-4, 4), z = myPos.z}
        if getThingFromPos(pos).itemid ~= 0 then
            doSendMagicEffect(pos, 486)
        end
            if turn == 21 or isSleeping(cid) then
                stopEvent(event)
            end
        end
        doSendMove(cid) 
		addEvent(doAreaCombatHealth, 1000, cid, GRASSDAMAGE, myPos, square4x4, -min, -max, 1392)
		doAreaCombatHealth(cid, STATUS_PARALYZE, myPos, square4x4, -486, -486, 1392)
		 
		 
		 

    elseif spell == "Web Rain" then
    local function doSendMoveDown(cid)
        if not isCreature(cid) then return true end
        for i = 0, 20 do
            addEvent(doSendMoveEffectDown, i * 50, cid, 274, 23)
        end
    end
    local function doSendMoveDamage(cid)
        if not isCreature(cid) then return true end
        doAreaCombatHealth(cid, ROCKDAMAGE, myPos, square4x4, -min, -max, 1392)
    end
    for i = 0, 20 do
        addEvent(doSendMoveEffectUp, i * 50, cid, 23)
    end
    addEvent(doSendMoveDown, 500, cid)
    addEvent(doSendMoveDamage, 1500, cid)
	doAreaCombatHealth(cid, STATUS_STUN7, myPos, square4x4, -274, -274, 1392)

      elseif spell == "Spider Web" then
	  	local myPos = getThingPosWithDebug(cid) 
		doFrontalCombatHealth(cid, myPos, BUGDAMAGE, min, max, 274, 23)
		doFrontalCombatHealth(cid, myPos, STATUS_STUN7, 274, 274, -1, -1)

      elseif spell == "Mud Shot" then
	  	local target = target or isCreature(getMasterTarget(cid)) and getMasterTarget(cid) or 0
		local targetPos = isCreature(target) and getThingPos(target) or nil
		local myPos = isCreature(cid) and getThingPos(cid) or nil
		doSendDistanceShoot(myPos, targetPos, 6)
		doTargetCombatHealth(cid, target, GROUNDDAMAGE, -min, -max, 34)
		doTargetCombatHealth(cid, target, STATUS_BLIND, -6, -6, 1392)
	  
      elseif spell == "Mud Slap" then
	  	local target = target or isCreature(getMasterTarget(cid)) and getMasterTarget(cid) or 0
		local targetPos = isCreature(target) and getThingPos(target) or nil
		local myPos = isCreature(cid) and getThingPos(cid) or nil
		doSendDistanceShoot(myPos, targetPos, 6)
		doTargetCombatHealth(cid, target, GROUNDDAMAGE, -min, -max, 34)
		doTargetCombatHealth(cid, target, STATUS_BLIND, -6, -6, 1392)


      elseif spell == "Metal Burst" then
         local function doSendMove(cid, turn)
            if not isCreature(target) then
               return true
            end
            local turn = turn or 1
            local event = addEvent(doSendMove, 1000, cid, turn + 1)
			local target = target or isCreature(getMasterTarget(cid)) and getMasterTarget(cid) or 0
			local targetPos = isCreature(target) and getThingPos(target) or nil
			local myPos = isCreature(cid) and getThingPosWithDebug(cid) or nil
			doSendDistanceShoot(myPos, targetPos, 94)
			doTargetCombatHealth(cid, target, STEELDAMAGE, -min, -max, 258)
            if turn == 10 or isSleeping(cid) then
               stopEvent(event)
            end
         end
         doSendMove(cid)
		 
		 

	elseif spell == "Rollout" or spell == "Fire Spin" then
         local RollOuts = {
			["Voltorb"] = {lookType = 287},
			["Electrode"] = {lookType = 286},
			["Sandshrew"] = {lookType = 284},
			["Sandslash"] = {lookType = 285},
			["Phanpy"] = {lookType = 480},
			["Donphan"] = {lookType = 482},
			["Miltank"] = {lookType = 481},
			["Golem"] = {lookType = 288},
			["Omastar"] = {lookType = 1245},
			["Shiny Electrode"] = {lookType = 513},
			["Shiny Golem"] = {lookType = 648},
			["Shiny Voltorb"] = {lookType = 514},
			["Shiny Sandslash"] = {lookType = 1506}
    }

         local function setOutfit(cid, outfit)
            if isCreature(cid) and getCreatureCondition(cid, CONDITION_OUTFIT) == true then
               if getCreatureOutfit(cid).lookType == outfit then
                  doRemoveCondition(cid, CONDITION_OUTFIT)
                  if getCreatureName(cid) == "Ditto" and pokes[getPlayerStorageValue(cid, 1010)] and getPlayerStorageValue(cid, 1010) ~= "Ditto" then
                     if isSummon(cid) then
                        local item = getPlayerSlotItem(getCreatureMaster(cid), 8)
                        doSetCreatureOutfit(cid, {lookType = getItemAttribute(item.uid, "transOutfit")}, -1)   --alterado v1.8
                     end
                  end
               end
            end
         end

         local name = doCorrectString(getCreatureName(cid))

         if RollOuts[name] then
            doSetCreatureOutfit(cid, RollOuts[name], -1)   --alterado v1.6.1
         end

         local outfit = getCreatureOutfit(cid).lookType

         local function roll(cid, outfit)
            if not isCreature(cid) then return true end
            if isSleeping(cid) then return true end
            if RollOuts[name] then
               doSetCreatureOutfit(cid, RollOuts[name], -1)
            end
            doDanoWithProtect(cid, spell == "Fire Spin" and FIREDAMAGE or ROCKDAMAGE, getThingPosWithDebug(cid), splash, -min, -max, 1392)
         end

         setPlayerStorageValue(cid, 3644587, 1)
         addEvent(setPlayerStorageValue, 15001, cid, 3644587, -1)
         setPlayerStorageValue(cid, STORAGE_STEAMROLLER, 1)
         -- addEvent(setPlayerStorageValue, STORAGE_STEAMROLLER, cid, 3644587, -1)
         doRaiseStatus(cid, 0,0,200, 15)
         for r = 0, 19 do  --8
            addEvent(roll, 750 * r, cid, outfit)
         end
         addEvent(setOutfit, 15001, cid, outfit)
		 
		elseif spell == "Steamroller" then	
			doAreaCombatHealth(cid, STATUS_STUN7, myPos, steamRoller, -307, -307, 111)
			setPlayerStorageValue(cid, STORAGE_STEAMROLLER, -1)


      elseif spell == "Bulldoze" then

         local p = getThingPosWithDebug(cid)
         local d = isCreature(target) and getCreatureDirectionToTarget(cid, target) or getCreatureLookDir(cid)

         function sendAtk(cid, area, areaEff, eff)
            if isCreature(cid) then
               if not isSightClear(p, area, false) then return true end                                             --testar o atk!!
               doAreaCombatHealth(cid, GROUNDDAMAGE, areaEff, 0, 0, 0, eff)
               doAreaCombatHealth(cid, GROUNDDAMAGE, area, whirl3, -min, -max, 1392)
            end
         end

         for a = 0, 5 do

            local t = {
               [0] = {126, {x=p.x, y=p.y-(a+1), z=p.z}, {x=p.x+1, y=p.y-(a+1), z=p.z}},
               [1] = {124, {x=p.x+(a+1), y=p.y, z=p.z}, {x=p.x+(a+1), y=p.y+1, z=p.z}},
               [2] = {125, {x=p.x, y=p.y+(a+1), z=p.z}, {x=p.x+1, y=p.y+(a+1), z=p.z}},
               [3] = {123, {x=p.x-(a+1), y=p.y, z=p.z}, {x=p.x-(a+1), y=p.y+1, z=p.z}}
            }
            addEvent(sendAtk, 325*a, cid, t[d][2], t[d][3], t[d][1])
         end		


	elseif spell == "Absolute Zero" then
		local myPos = getThingPos(cid)
		-- doAreaCombatHealth(cid, STATUS_PARALYZE, myPos, square1x1, -501, -501, 1392)
		-- doAreaCombatHealth(cid, STATUS_SILENCE, myPos, square1x1, -501, -501, 1392)
		doAreaCombatHealth(cid, ICEDAMAGE, myPos, square1x1, -min, -max, 1392)

      elseif spell == "Frost Power" then
         doAreaCombatHealth(cid, ICEDAMAGE, getThingPosWithDebug(cid), splash, -min, -max, 1392)

         local sps = getThingPosWithDebug(cid)
         sps.x = sps.x+1
         sps.y = sps.y+1
         doSendMagicEffect(sps, 369)

      elseif spell == "Earthshock" or spell == "Earth Power" then
         local eff = getSubName(cid, target) == "Crystal Onix" and 369 or 127 --alterado v1.6.1
         local dmgType = getSubName(cid, target) == "Crystal Onix" and CRYSTALDAMAGE or GROUNDDAMAGE

         doAreaCombatHealth(cid, dmgType, getThingPosWithDebug(cid), splash, -min, -max, 1392)

         local sps = getThingPosWithDebug(cid)
         sps.x = sps.x + 1
         sps.y = sps.y + 1
         doSendMagicEffect(sps, eff)

      elseif spell == "Earthquake" then
         local function doSendMove(cid, turn)
            if not isCreature(cid) then
               return true
            end

            local turn = turn or 1
            local event = addEvent(doSendMove, 400, cid, turn + 1)
            if isInArray({"Crystal Onix"}, doCorrectString(getCreatureName(cid))) then
               doAreaCombatHealth(cid, CRYSTALDAMAGE, getThingPosWithDebug(cid), earthQuakeGrande, -min, -max, 404)
			elseif isInArray({"Shiny Flygon"}, doCorrectString(getCreatureName(cid))) then
				doAreaCombatHealth(cid, GROUNDDAMAGE, getThingPosWithDebug(cid), earthQuakeGrande, -min, -max, 118)
			elseif isInArray({"Camerupt", "Venusaur"}, isMega(cid) and doCorrectString(getCreatureName(cid))) then  
				doAreaCombatHealth(cid, GROUNDDAMAGE, getThingPosWithDebug(cid), earthQuakeGrande, -min, -max, 118)
            else
               doAreaCombatHealth(cid, GROUNDDAMAGE, getThingPosWithDebug(cid), earthQuakePequeno, -min, -max, 118)
            end
            if turn == 15 or isSleeping(cid) then
               stopEvent(event)
            end
         end
         doSendMove(cid)

      elseif spell == "Stomp" then

         local ret = {}
         ret.id = 0
         ret.attacker = cid
         ret.cd = 9
         ret.check = 0
         ret.eff = 34
         ret.spell = spell
         ret.cond = "Stun"

         doMoveInArea2(cid, 118, stomp, GROUNDDAMAGE, min, max, spell, ret)

	elseif spell == "Toxic Spikes" then
	local myPos = isCreature(cid) and getThingPosWithDebug(cid) or nil
	local target = target or isCreature(getMasterTarget(cid)) and getMasterTarget(cid) or 0
    local targetPos = isCreature(target) and getThingPos(target) or nil
	
	
    local function doSendMove(cid, target)
        if not isCreature(cid) or not isCreature(target) then return true end
        if isSleeping(cid) then return true end
        doTargetCombatHealth(cid, target, POISONDAMAGE, -min, -max, 114)
        doSendDistanceShoot(myPos, targetPos, 15)
    end
    for i = 0, 2 do
        addEvent(doSendMove, i * 250, cid, target)
    end
      elseif spell == "Horn Drill" then

	local myPos = isCreature(cid) and getThingPosWithDebug(cid) or nil
	local target = target or isCreature(getMasterTarget(cid)) and getMasterTarget(cid) or 0
    local targetPos = isCreature(target) and getThingPos(target) or nil
	
	
    local function doSendMove(cid, target)
        if not isCreature(cid) or not isCreature(target) then return true end
        if isSleeping(cid) then return true end
        doTargetCombatHealth(cid, target, NORMALDAMAGE, -min, -max, 3)
        doSendDistanceShoot(myPos, targetPos, 25)
    end
    for i = 0, 2 do
        addEvent(doSendMove, i * 250, cid, target)
    end
	 

      elseif spell == "Doubleslap" then

         doAreaCombatHealth(cid, NORMALDAMAGE, getThingPosWithDebug(target), 0, -min, -max, 148)

      elseif spell == "Lovely Kiss" then
	  	local target = target or isCreature(getMasterTarget(cid)) and getMasterTarget(cid) or 0
		local targetPos = isCreature(target) and getThingPos(target) or nil
		local myPos = isCreature(cid) and getThingPos(cid) or nil
		doSendDistanceShoot(myPos, targetPos, 16)
		doTargetCombatHealth(cid, target, GROUNDDAMAGE, -min, -max, 34)
		doTargetCombatHealth(cid, target, STATUS_STUN7, -147, -147, 1392)

      elseif spell == "Sing" then
		doAreaCombatHealth(cid, STATUS_SLEEP, myPos, circle2x2, -22, -22, 22)

      elseif spell == "Multislap" then

         doAreaCombatHealth(cid, NORMALDAMAGE, getThingPosWithDebug(cid), splash, -min, -max, 3)

      elseif spell == "Metronome" then

         local spells = {{"Shadow Storm", GHOSTDAMAGE}, {"Electric Storm", ELECTRICDAMAGE}, {"Magma Storm", FIREDAMAGE}, {"Blizzard", ICEDAMAGE}, {"Meteor Mash", STEELDAMAGE}, {"Leaf Storm", GRASSDAMAGE}, {"Hydro Pump", WATERDAMAGE}, {"Falling Rocks", ROCKDAMAGE}}

         local randommove = math.random(1, #spells)
         local pos = getThingPosWithDebug(cid)
         pos.y = pos.y - 1

         doSendMagicEffect(pos, 161)

         local function doMetronome(cid, skill)
            if not isCreature(cid) then return true end
            local skillname = spells[skill][1]
            docastspell(cid, skillname)
            local dmg = spells[skill][2]
            if isInArray({"Shadow Storm", "Electric Storm", "Blizzard", "Falling Rocks"}, skillname) then
               addEvent(doDanoWithProtect,1400,cid, dmg, getThingPosWithDebug(cid), waterarea, -min, -max, 1392)
            elseif isInArray({"Meteor Mash", "Leaf Storm", "Hydro Pump"}, skillname) then
               doDanoWithProtect(cid, dmg, getThingPosWithDebug(cid), waterarea, -min, -max, 1392)
            elseif isInArray({"Magma Storm"}, skillname) then
      local myPos = getThingPosWithDebug(cid)
      local function doSendMove(cid, area, effect)
         if not isCreature(cid) then
            return true
         end
         doAreaCombatHealth(cid, FIREDAMAGE, myPos, area, -min, -max, effect)
      end
      for i = 0, 3 do
         local areas = {square1x1, magmaStorm1, magmaStorm2, magmaStorm4, magmaStorm4}
         local effects = (isMega(cid) and getMegaID(cid) == "X") and {584, 583, 584, 583} or doCorrectString(getCreatureName(cid)) == "Shiny Magmortar" and {584, 583, 584, 583} or {6, 645, 36, 676} 
         addEvent(doSendMove, i * 500, cid, areas[i + 1], effects[i + 1], i + 1)
      end
            end
         end

         addEvent(doMetronome, 500, cid, randommove)

      elseif spell == "Hidden Power" then

         local spells = {
            {"Psy Pulse", "Alakazam"},
            {"Ember", "Charizard"},
            {"Shadow Ball", "Gengar"},
            {"Thunderbolt", "Electabuzz"},
            {"Rock Slide", "Golem"},
            {"Razor Leaf", "Venusaur"},
            {"BubbleBeam", "Empoleon"},
            {"Ice Shards", "Glalie"},
            {"Acid", "Seviper"},
            {"Aura Sphere", "Lucario"},
            {"Dazzling Gleam", "Gardevoir"},
            {"Dragon Flight", "Shiny Flygon"},
            {"Dark Sphere", "Sableye"},
            {"ExtremeSpeed", "Shiny Arcanine"},
         }

         local r = math.random(#spells)
         docastspell(cid, spells[r][1], spells[r][2], getCreatureTarget(cid))

      elseif spell == "Sketch 1" or spell == "Hidden Power" then

         local spells = {"Psy Pulse", "Shadow Ball", "Thunderbolt", "Ember", "Rock Throw", "Razor Leaf", "Bubbles", "Ice Shards", "Egg Bomb", "Poison Bomb"}

         local random = math.random(1, #spells)

         local randommove = spells[random]
         local pos = getThingPosWithDebug(cid)
         pos.y = pos.y - 1

         doSendMagicEffect(pos, 0)

         local function doMetronome(cid, skill)
            if not isCreature(cid) then return true end
            docastspell(cid, skill)
         end

         addEvent(doMetronome, 200, cid, randommove)

      elseif spell == "Sketch 2" then

         local spells = {"Mud Bomb", "Cyber Pulse", "Dark Pulse", "Rock Slide", "Magical Leaf", "Fireball", "Waterball", "Feather Dance"}

         local random = math.random(1, #spells)

         local randommove = spells[random]
         local pos = getThingPosWithDebug(cid)
         pos.y = pos.y - 1

         doSendMagicEffect(pos, 0)

         local function doMetronome(cid, skill)
            if not isCreature(cid) then return true end
            docastspell(cid, skill)
         end

         addEvent(doMetronome, 200, cid, randommove)

      elseif spell == "Sketch 3" then

         local spells = {"Poison Gas", "Earthquake", "Petal Tornado", "Electro Field", "Flame Wheel"}

         local random = math.random(1, #spells)

         local randommove = spells[random]
         local pos = getThingPosWithDebug(cid)
         pos.y = pos.y - 1

         doSendMagicEffect(pos, 0)

         local function doMetronome(cid, skill)
            if not isCreature(cid) then return true end
            docastspell(cid, skill)
         end

         addEvent(doMetronome, 200, cid, randommove)

      elseif spell == "Sketch 4" then

         local spells = {"Thunder", "Night Slash", "Confusion", "Air Slash", "Confusion", "Night Shade"}

         local random = math.random(1, #spells)

         local randommove = spells[random]
         local pos = getThingPosWithDebug(cid)
         pos.y = pos.y - 1

         doSendMagicEffect(pos, 0)

         local function doMetronome(cid, skill)
            if not isCreature(cid) then return true end
            docastspell(cid, skill)
         end

         addEvent(doMetronome, 200, cid, randommove)

      elseif spell == "Sketch 5" then

         local spells = {"Solar Beam", "Bullet Seed", "Raging Blast", "Fire Blast", "Bubble Blast", "Hydro Cannon", "Pin Missile"}

         local random = math.random(1, #spells)

         local randommove = spells[random]
         local pos = getThingPosWithDebug(cid)
         pos.y = pos.y - 1

         doSendMagicEffect(pos, 0)

         local function doMetronome(cid, skill)
            if not isCreature(cid) then return true end
            docastspell(cid, skill)
         end

         addEvent(doMetronome, 200, cid, randommove)

      elseif spell == "Sketch 6" then

         local spells = {"Shockwave", "Petal Dance", "Hyper Beam", "Zap Cannon", "Aurora Beam", "Ice Beam", "Ground Chop"}

         local random = math.random(1, #spells)

         local randommove = spells[random]
         local pos = getThingPosWithDebug(cid)
         pos.y = pos.y - 1

         doSendMagicEffect(pos, 0)

         local function doMetronome(cid, skill)
            if not isCreature(cid) then return true end
            docastspell(cid, skill)
         end

         addEvent(doMetronome, 200, cid, randommove)

      elseif spell == "Sketch 7" then

         local spells = {"Fear", "Sunny Day", "Scary Face", "Skull Bash", "Cotton Spore", "Sleep Powder"}

         local random = math.random(1, #spells)

         local randommove = spells[random]
         local pos = getThingPosWithDebug(cid)
         pos.y = pos.y - 1

         doSendMagicEffect(pos, 0)

         local function doMetronome(cid, skill)
            if not isCreature(cid) then return true end
            docastspell(cid, skill)
         end

         addEvent(doMetronome, 200, cid, randommove)

      elseif spell == "Sketch 8" then

         local spells = {"Reflect", "Charm", "Agility", "Safeguard", "Synthesis", "Emergency Call", "Healarea", "Sing"}

         local random = math.random(1, #spells)

         local randommove = spells[random]
         local pos = getThingPosWithDebug(cid)
         pos.y = pos.y - 1

         doSendMagicEffect(pos, 0)

         local function doMetronome(cid, skill)
            if not isCreature(cid) then return true end
            docastspell(cid, skill)
         end

         addEvent(doMetronome, 200, cid, randommove)

      elseif spell == "Sketch 9" then

         local spells = {"Psychic", "Epicenter", "Mortal Gas", "Hydro Pump", "Muddy Water"}

         local random = math.random(1, #spells)

         local randommove = spells[random]
         local pos = getThingPosWithDebug(cid)
         pos.y = pos.y - 1

         doSendMagicEffect(pos, 0)

         local function doMetronome(cid, skill)
            if not isCreature(cid) then return true end
            docastspell(cid, skill)
         end

         addEvent(doMetronome, 200, cid, randommove)

      elseif spell == "Sketch 10" then

         local spells = {"Focus Blast", "Blizzard", "Shadow Storm", "Falling Rocks", "Meteor Mash", "Electric Storm", "Hydro Dance", "Magma Storm", "Draco Meteor", "Psy Impact"}

         local random = math.random(1, #spells)

         local randommove = spells[random]
         local pos = getThingPosWithDebug(cid)
         pos.y = pos.y - 1

         doSendMagicEffect(pos, 0)

         local function doMetronome(cid, skill)
            if not isCreature(cid) then return true end
            docastspell(cid, skill)
         end

         addEvent(doMetronome, 200, cid, randommove)
      elseif spell == "Morph" then
         if getCreatureName(cid) == "Shiny Abra" then
            if getPlayerStorageValue(cid, 39440) == 1 then
               doSetCreatureOutfit(cid, {lookType = 491}, -1)
               setPlayerStorageValue(cid, 39440, 0)
            else
               doSetCreatureOutfit(cid, {lookType = 1742}, -1)
               setPlayerStorageValue(cid, 39440, 1)
            end
         end
         local master = getCreatureMaster(cid)
         doUpdateMoves(master)
      elseif spell == "Focus" or spell == "Charge" or spell == "Swords Dance" or spell == "Focus Energy" or spell == "Nasty Plot" or spell == "Mind Reader" or spell == "Growth" then
         if spell == "Charge" then
            doSendMagicEffect(getThingPosWithDebug(cid), 177)
         elseif spell == "Swords Dance" then
            local pos = getThingPosWithDebug(cid)
            pos.x = pos.x + 1
            doSendMagicEffect(pos, 303)
         elseif spell == "Mind Reader" then
            local pos = getThingPosWithDebug(cid)
            pos.x = pos.x + 1
            doSendMagicEffect(pos, 303)
            if isSummon(cid) then
               doClearBallStatus(getPlayerSlotItem(getCreatureMaster(cid), 8).uid)
            end
            doClearPokemonStatus(cid)
         elseif spell == "Focus Energy" then
            doSendMagicEffect(getThingPosWithDebug(cid), 132)
         elseif spell == "Nasty Plot" then
            doSendMagicEffect(getThingPosWithDebug(cid), 445)
         elseif spell == "Growth" then
            doSendMagicEffect(getThingPosWithDebug(cid), 177)
         else
            doSendMagicEffect(getThingPosWithDebug(cid), 132)
         end
         setPlayerStorageValue(cid, 253, 1)
         sendOpcodeStatusInfo(cid)

      elseif spell == "Grass Knot" then
        local function doSendMove(cid, turn)
            if not isCreature(cid) then
               return true
            end
            if not isCreature(target) then
               return true
            end
            local turn = turn or 1
            local event = addEvent(doSendMove, 150, cid, turn + 1)
			if not target then return true end
            doSendDistanceShoot(myPos, getThingPos(target), 8)
            local pos = getThingPos(target)
            pos.x = pos.x + 1
            pos.y = pos.y + 1
            doSendMagicEffect(pos, 304)
            doAreaCombatHealth(cid, GRASSDAMAGE, getThingPosWithDebug(target), 0, -min, -max, -1)
            if turn == 2 then
               stopEvent(event)
            end
         end
         doSendMove(cid)

      elseif spell == "Hyper Voice" then

         local ret = {}
         ret.id = 0
         ret.attacker = cid
         ret.cd = 9
         ret.check = 0
         ret.eff = 22
         ret.spell = spell
         ret.cond = "Stun"

         doMoveInArea2(cid, 22, db2, NORMALDAMAGE, min, max, spell, ret)

      elseif spell == "Stockpile" then

         local outStock = {
            ["Mawile"] = {1859,1950, 1951, 1952},
            ["Mega Mawile"] = {2071, 2072, 2073, 2074},
         }

         local ta = isMega(cid) and outStock["Mega Mawile"] or outStock["Mawile"]
         if not getPlayerStorageValue(cid, 72373) or getPlayerStorageValue(cid, 72373) < 0 then setPlayerStorageValue(cid, 72373, 0) end
         setPlayerStorageValue(cid, 72373, math.min(3,getPlayerStorageValue(cid, 72373)+1))
         doSetCreatureOutfit(cid, {lookType = ta[getPlayerStorageValue(cid, 72373)+1]}, -1)

      elseif spell == "Swallow" then
		
         local outStock = {
            ["Mawile"] = {1859,1950, 1951, 1952},
            ["Mega Mawile"] = {2071, 2072, 2073, 2074},
         }
         local ta = isMega(cid) and outStock["Mega Mawile"] or outStock["Mawile"]
         if not getPlayerStorageValue(cid, 72373) or getPlayerStorageValue(cid, 72373) < 0 then setPlayerStorageValue(cid, 72373, 0) end

         local min = (getCreatureMaxHealth(cid) * 33 * getPlayerStorageValue(cid, 72373)) / 100
         local max = (getCreatureMaxHealth(cid) * 33 * getPlayerStorageValue(cid, 72373)) / 100


         if getPlayerStorageValue(cid, 72373) == 0 then
            doSendAnimatedText(getThingPosWithDebug(cid), "FAIL!", COLOR_PINK)
         else
            doSendMagicEffect(getThingPosWithDebug(cid), 132)
            doHealArea(cid, min, max)
         end

         setPlayerStorageValue(cid, 72373, 0)
         doSetCreatureOutfit(cid, {lookType = ta[getPlayerStorageValue(cid, 72373)+1]}, -1)

      elseif spell == "Spit Up" then

         local outStock = {
            ["Mawile"] = {1859,1950, 1951, 1952},
            ["Mega Mawile"] = {2071, 2072, 2073, 2074},
         }
         local ta = isMega(cid) and outStock["Mega Mawile"] or outStock["Mawile"]
         if not getPlayerStorageValue(cid, 72373) or getPlayerStorageValue(cid, 72373) < 0 then setPlayerStorageValue(cid, 72373, 0) end

         local a = isCreature(target) and getCreatureDirectionToTarget(cid, target) or getCreatureLookDir(cid)
         local p = getThingPosWithDebug(cid)
         local t = {
            [0] = {354, {x=p.x+1, y=p.y-1, z=p.z}},
            [1] = {353, {x=p.x+6, y=p.y+1, z=p.z}},
            [2] = {354, {x=p.x+1, y=p.y+6, z=p.z}},
            [3] = {353, {x=p.x-1, y=p.y+1, z=p.z}},
         }


         local min = min * getPlayerStorageValue(cid, 72373)
         local max = max * getPlayerStorageValue(cid, 72373)

         if getPlayerStorageValue(cid, 72373) == 0 then
            doSendAnimatedText(getThingPosWithDebug(cid), "FAIL!", COLOR_PINK)
         else
            doMoveInArea2(cid, 0, triplo6, NORMALDAMAGE, min, max, spell)
            doSendMagicEffect(t[a][2], t[a][1])
         end

         setPlayerStorageValue(cid, 72373, 0)
         doSetCreatureOutfit(cid, {lookType = ta[getPlayerStorageValue(cid, 72373)+1]}, -1)


      elseif spell == "Restore" or spell == "Selfheal" or spell == "Moonlight" then
	  
		 -- if getPlayerStorageValue(cid, STORAGE_HEALBLOCK) == 1 then return true end
         if isPlayer(cid) and isInArea(getThingPosWithDebug(cid), {x=2449,y=2611,z=8}, {x=2491,y=2654,z=8}) then return true end

         local min = (getCreatureMaxHealth(cid) * 75) / 100
         local max = (getCreatureMaxHealth(cid) * 85) / 100

         doSendMagicEffect(getThingPosWithDebug(cid), 132)
         doHealArea(cid, min, max)

      elseif spell == "Aqua Ring" or spell == "Ingrain" then
	  -- if getPlayerStorageValue(cid, STORAGE_HEALBLOCK) == 1 then return true end
         local min = (getCreatureMaxHealth(cid) * 75) / 100
         local max = (getCreatureMaxHealth(cid) * 85) / 100

         local function doHealRing(cid, min, max)
            if not isCreature(cid) then
               return true
            end
            if isInArea(getThingPosWithDebug(cid), {x = 2449, y = 2611, z = 8}, {x = 2491, y = 2654, z = 8}) then
               doSendMagicEffect(getThingPosWithDebug(cid), 301)
               return true
            end
            local amount = math.random(min, max)
            if (getCreatureHealth(cid) + amount) >= getCreatureMaxHealth(cid) then
               amount = -(getCreatureHealth(cid) - getCreatureMaxHealth(cid))
            end
            if getCreatureHealth(cid) ~= getCreatureMaxHealth(cid) then
               doCreatureAddHealth(cid, amount)
               doSendAnimatedText(getThingPosWithDebug(cid), "+" .. amount .. "", 65)
               doSendMagicEffect(getThingPosWithDebug(cid), spell == "Ingrain" and 433 or 278)
            end
         end

         for x = 0, 19 do
            addEvent(doHealRing, x * 500, cid, math.floor(min / 20), math.floor(max / 20))
         end

      elseif spell == "Healarea" or spell == "Wish" or spell == "Healing Wish" then
		-- if getPlayerStorageValue(cid, STORAGE_HEALBLOCK) == 1 then return true end
         local min = (getCreatureMaxHealth(cid) * (spell == "Healing Wish" and 90 or 50)) / 100
         local max = (getCreatureMaxHealth(cid) * (spell == "Healing Wish" and 100 or 60)) / 100

         local area = spell == "Healarea" and heal or BigArea2
         local pos = getPosfromArea(cid, area)
         local n = 0
         doHealArea(cid, min, max)

         while n < #pos do
            n = n+1
            thing = {x=pos[n].x,y=pos[n].y,z=pos[n].z,stackpos=253}
            local pid = getThingFromPosWithProtect(thing)

            doSendMagicEffect(pos[n], 12)
            if isCreature(pid) then
               if isSummon(cid) and (isSummon(pid) or isPlayer(pid)) then
                  if canAttackOther(cid, pid) == "Cant" then
                     doHealArea(pid, min, max, cid)
                  end
               elseif ehMonstro(cid) and ehMonstro(pid) then
                  doHealArea(pid, min, max, cid)
               end
            end
         end

      elseif spell == "Milk Drink" then
		-- if getPlayerStorageValue(cid, STORAGE_HEALBLOCK) == 1 then return true end
         local min = (getCreatureMaxHealth(cid) * 50) / 100
         local max = (getCreatureMaxHealth(cid) * 60) / 100

         local pos = getPosfromArea(cid, heal)
         local n = 0
         doHealArea(cid, min, max)

         while n < #pos do
            n = n+1
            thing = {x=pos[n].x,y=pos[n].y,z=pos[n].z,stackpos=253}
            local pid = getThingFromPosWithProtect(thing)

            doSendMagicEffect(pos[n], 12)
            if isCreature(pid) then
               if isSummon(cid) and (isSummon(pid) or isPlayer(pid)) then
                  if canAttackOther(cid, pid) == "Cant" then
                     doHealArea(pid, min, max, cid)
                  end
               elseif ehMonstro(cid) and ehMonstro(pid) then
                  doHealArea(pid, min, max, cid)
               end
            end
         end

      elseif spell == "Toxic" then
         -- local ret = {id = 0, cd = 13, check = 0, damage = pbdmg, cond = "Poison"}
         local ret = {}
         ret.cd = 10
         ret.eff = 8
         ret.damage = pbdmg
         ret.cond = "Poison"
         local function doSendMove(cid, turn)
            if not isCreature(cid) then
               return true
            end
            local turn = turn or 1
            local event = addEvent(doSendMove, 300, cid, turn + 1)
            local area = {square1x1Bug, toxic2}
            -- doAreaCombatHealth(cid, WATERDAMAGE, getThingPosWithDebug(cid), area1[turn], -min, -max, eff[turn])
            doMoveInArea2(cid, 114, area[turn], POISONDAMAGE, min, max, spell, ret)
            if turn == 2 then
               stopEvent(event)
            end
         end
         doSendMove(cid)

      elseif spell == "Leech Life" then
         local function getCreatureHealthSecurity(cid)
            if not isCreature(cid) then return 0 end
            return getCreatureHealth(cid) or 0
         end
         local life = getCreatureHealthSecurity(target)

         doAreaCombatHealth(cid, BUGDAMAGE, getThingPosWithDebug(target), 0, -min, -max, 244)

         local newlife = life - getCreatureHealthSecurity(target)

         doSendMagicEffect(getThingPosWithDebug(cid), 14)
         if newlife >= 1 then
            if isCreature(cid) then
               doCreatureAddHealth(cid, newlife)
            end
            doSendAnimatedText(getThingPosWithDebug(cid), "+"..newlife.."", 32)
         end

      elseif spell == "Absorb" then
         local function getCreatureHealthSecurity(cid)
            if not isCreature(cid) then return 0 end
            return getCreatureHealth(cid) or 0
         end
         local life = getCreatureHealthSecurity(target)

         doAreaCombatHealth(cid, GRASSDAMAGE, getThingPosWithDebug(target), 0, -min, -max, 14)

         local newlife = life - getCreatureHealthSecurity(target)

         doSendMagicEffect(getThingPosWithDebug(cid), 14)
         if newlife >= 1 then
            if isCreature(cid) then
               doCreatureAddHealth(cid, newlife)
            end
            doSendAnimatedText(getThingPosWithDebug(cid), "+"..newlife.."", 32)
         end

      elseif spell == "Drain Punch" then
         local function getCreatureHealthSecurity(cid)
            if not isCreature(cid) then return 0 end
            return getCreatureHealth(cid) or 0
         end
         local life = getCreatureHealthSecurity(target)

         doAreaCombatHealth(cid, FIGHTINGDAMAGE, getThingPosWithDebug(target), 0, -min, -max, 112)

         local newlife = life - getCreatureHealthSecurity(target)

         doSendMagicEffect(getThingPosWithDebug(cid), 14)
         if newlife >= 1 then
            if isCreature(cid) then
               doCreatureAddHealth(cid, newlife)
            end
            doSendAnimatedText(getThingPosWithDebug(cid), "+"..newlife.."", 32)
         end

      elseif spell == "Poison Bomb" then

         doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 14)
         doDanoWithProtectWithDelay(cid, target, POISONDAMAGE, min, max, 20, bombWee2)

      elseif spell == "Sludge Bomb" then -- uissu

         doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 6)
         doDanoWithProtectWithDelay(cid, target, POISONDAMAGE, min, max, 114, bombWee2)

      elseif spell == "Petal Blizzard" then -- uissu
         local master = isSummon(cid) and getCreatureMaster(cid) or cid

         local function doFall(cid)
            for rocks = 1, 42 do --62
               addEvent(fall, rocks * 35, cid, master, GRASSDAMAGE, 14, 689)
            end
         end

         for up = 1, 10 do
            addEvent(upEffect, up * 75, cid, 14)
         end
         addEvent(doFall, 450, cid)
         addEvent(doAreaCombatHealth, 1400, cid, GRASSDAMAGE, getThingPosWithDebug(cid), square4x4, -min, -max, 1392)

      elseif spell == "Swamp Mist" then

         local pos = getPosfromArea(cid, croakmist)
         for x=0,19 do
            if pos and #pos > 0 then
               for i = 1, #pos do
                  addEvent(doDanoWithProtect,x*500,cid, POISONDAMAGE, pos[i], 0, -min, -max, 470, ret)
               end
            end
         end

      elseif spell == "Poison Gas" then
         local function doSendMove(cid, turn)
            if not isCreature(cid) then
               return true
            end

            local turn = turn or 1
            local event = addEvent(doSendMove, 400, cid, turn + 1)
            doAreaCombatHealth(cid, POISONDAMAGE, getThingPosWithDebug(cid), earthQuakePequeno, -min, -max, 114)
			
            if turn == 18 or isSleeping(cid) then
               stopEvent(event)
            end
         end
         doSendMove(cid)
		 doAreaCombatHealth(cid, STATUS_POISON10, myPos, circle2x2, -min, -max, 1392)
		 

	elseif spell == "Petal Dance" then

		local myPos = getThingPosWithDebug(cid)
		doFrontalCombatHealth(cid, myPos, GRASSDAMAGE, min, max, 79, 21)
	elseif spell == "Vital Throw" then
		local myPos = getThingPosWithDebug(cid)
		doFrontalCombatHealth(cid, myPos, FIGHTINGDAMAGE, min, max, 111, 26)
		 
      elseif spell == "Focus Blast" then
         local p = getThingPosWithDebug(cid)
         local d = isCreature(target) and getCreatureDirectionToTarget(cid, target) or getCreatureLookDir(cid)

         function sendAtk(cid, area, eff)
            if isCreature(cid) then
               if not isSightClear(p, area, false) then
                  return true
               end
               doAreaCombatHealth(cid, FIGHTINGDAMAGE, area, whirl3, -min, -max, 1392)
            end
         end

         function sendEff(cid, area, eff)
            if isCreature(cid) then
               if not isSightClear(p, area, false) then
                  return true
               end
               doAreaCombatHealth(cid, FIGHTINGDAMAGE, area, 0, 0, 0, eff)
            end
         end

         for a = 0, 5 do
            local t = {
               [0] = {399, {x = p.x, y = p.y - (a + 1), z = p.z}},
               [1] = {399, {x = p.x + (a + 1), y = p.y, z = p.z}},
               [2] = {399, {x = p.x, y = p.y + (a + 1), z = p.z}},
               [3] = {399, {x = p.x - (a + 1), y = p.y, z = p.z}}
            }

            local teff = {
               [0] = {399, {x = p.x + 1, y = p.y - (a), z = p.z}},
               [1] = {399, {x = p.x + (a + 2), y = p.y + 1, z = p.z}},
               [2] = {399, {x = p.x + 1, y = p.y + (a + 2), z = p.z}},
               [3] = {399, {x = p.x - (a), y = p.y + 1, z = p.z}}
            }
            addEvent(sendAtk, 250 * a, cid, t[d][2], 1392)
            addEvent(sendEff, 250 * a, cid, teff[d][2], (a == 0 or a == 2 or a == 4) and teff[d][1] or 1392)
         end

      elseif spell == "Counter Punch" then
 
         local rev = getThingPosWithDebug(cid)
         rev.x = rev.x+1
         rev.y = rev.y+1
         doSendMagicEffect(rev, getCreatureName(cid) == "Lucario" and 560 or getCreatureName(cid) == "Shiny Lucario" and 561 or 99)
         doAreaCombatHealth(cid, FIGHTINGDAMAGE, getThingPosWithDebug(cid), splash, -min, -max, 1392)

      elseif spell == "Revenge" then
         local function doSendMove(cid, turn)
            if not isCreature(cid) then
               return true
            end
            local turn = turn or 1
            local event = addEvent(doSendMove, 400, cid, turn + 1)
            local area1 = {square1x1, square1x1, square1x1, square1x1, square1x1}
            local eff = {292, 293, 294, 295, 296}
            local pos = getThingPosWithDebug(cid)
            pos.x = pos.x + 1
            pos.y = pos.y + 1
            doSendMagicEffect(pos, eff[turn])
            doAreaCombatHealth(cid, FIGHTINGDAMAGE, getThingPosWithDebug(cid), area1[turn], -min, -max, -1)
            if turn == 5 or isSleeping(cid) then
               stopEvent(event)
            end
         end
         doSendMove(cid)
		 
		elseif spell == "Fogo Pequeno" then
			doAreaCombatHealth(cid, FIREDAMAGE, getThingPosWithDebug(cid), square1x1, -min, -max, 15)
		
		elseif spell == "Fogo Grande" then
		-- doSetCreatureOutfit(cid, {lookType = 4284}, 1000)
            local pos = getThingPosWithDebug(cid)
            pos.x = pos.x 
            pos.y = pos.y
            doSendMagicEffect(pos, 1298)
		local function doSendMove(cid, turn)
            if not isCreature(cid) then
               return true
            end
            local turn = turn or 1
            local event = addEvent(doSendMove, 350, cid, turn + 1)
            local area1 = {armadilhaGrande1, armadilhaGrande2, armadilhaGrande3, armadilhaGrande4, armadilhaGrande5, armadilhaGrande1, armadilhaGrande2, armadilhaGrande3, armadilhaGrande4, armadilhaGrande5}
            local area2 = {armadilhaGrande1Debug, armadilhaGrande2Debug, armadilhaGrande3Debug, armadilhaGrande4Debug, armadilhaGrande5Debug, armadilhaGrande1Debug, armadilhaGrande2Debug, armadilhaGrande3Debug, armadilhaGrande4Debug, armadilhaGrande5Debug}

            doAreaCombatHealth(cid, FIREDAMAGE, getThingPosWithDebug(cid), area1[turn], -min, -max, -1)
            doAreaCombatHealth(cid, FIREDAMAGE, getThingPosWithDebug(cid), area2[turn], nil, nil, 645)
            if turn == 10 or isSleeping(cid) then
               stopEvent(event)
            end
         end
         addEvent(doSendMove, 1100, cid)
		elseif spell == "Raio Grande" then
		-- doSetCreatureOutfit(cid, {lookType = 4284}, 1000)
            local pos = getThingPosWithDebug(cid)
            pos.x = pos.x 
            pos.y = pos.y
            doSendMagicEffect(pos, 1296)
		local function doSendMove(cid, turn)
            if not isCreature(cid) then
               return true
            end
            local turn = turn or 1
            local event = addEvent(doSendMove, 350, cid, turn + 1)
            local area1 = {armadilhaGrande1, armadilhaGrande2, armadilhaGrande3, armadilhaGrande4, armadilhaGrande5}
            local area2 = {armadilhaGrande1Debug, armadilhaGrande2Debug, armadilhaGrande3Debug, armadilhaGrande4Debug, armadilhaGrande5Debug}
            doAreaCombatHealth(cid, ELECTRICDAMAGE, getThingPosWithDebug(cid), area1[turn], -min, -max, -1)
            doAreaCombatHealth(cid, ELECTRICDAMAGE, getThingPosWithDebug(cid), area2[turn], nil, nil, 646)
            if turn == 5 or isSleeping(cid) then
               stopEvent(event)
            end
         end
         addEvent(doSendMove, 1100, cid)
		elseif spell == "Raio Pequeno" then
            local pos = getThingPosWithDebug(cid)
            pos.x = pos.x 
            pos.y = pos.y
            doSendMagicEffect(pos, 897)
		local function doSendMove(cid, turn)
            if not isCreature(cid) then
               return true
            end
            local turn = turn or 1
            local event = addEvent(doSendMove, 350, cid, turn + 1)
            local area1 = {armadilhaGrande1, armadilhaGrande2, armadilhaGrande3, armadilhaGrande4, armadilhaGrande5}
            doAreaCombatHealth(cid, ELECTRICDAMAGE, getThingPosWithDebug(cid), area1[turn], -min, -max, 48)
            if turn == 5 or isSleeping(cid) then
               stopEvent(event)
            end
         end
         addEvent(doSendMove, 1100, cid)
		elseif spell == "Gelo Grande" then
            local pos = getThingPosWithDebug(cid)
            pos.x = pos.x 
            pos.y = pos.y
            doSendMagicEffect(pos, 896)
		local function doSendMove(cid, turn)
            if not isCreature(cid) then
               return true
            end
            local turn = turn or 1
            local event = addEvent(doSendMove, 350, cid, turn + 1)
            local area1 = {armadilhaGrande1, armadilhaGrande2, armadilhaGrande3, armadilhaGrande4, armadilhaGrande5}
            doAreaCombatHealth(cid, ICEDAMAGE, getThingPosWithDebug(cid), area1[turn], -min, -max, 478)
            if turn == 5 or isSleeping(cid) then
               stopEvent(event)
            end
         end
         addEvent(doSendMove, 1100, cid)
		 

      elseif spell == "Close Combat" then
         setPlayerStorageValue(cid, 253, 1)
         sendOpcodeStatusInfo(cid)
         doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 39)
         doDanoInTargetWithDelay(cid, target, FIGHTINGDAMAGE, -min, -max, 269) --alterado v1.7
         doSendAnimatedText(getThingPosWithDebug(cid), "FOCUS", 144)

      elseif spell == "Sandstorm" then
         local master = isSummon(cid) and getCreatureMaster(cid) or cid
         ------------
         local ret = {}
         ret.id = 0
         ret.attacker = cid
         ret.cd = 9
         ret.check = 0
         ret.eff = 34
         ret.cond = "Silence"
         ---
         local function doFall(cid)
            for rocks = 1, 42 do
               addEvent(fall, rocks * 35, cid, master, GROUNDDAMAGE, 55, 341)
            end
         end
         ---
         local function doRain(cid)
            if isSummon(cid) then
               doClearBallStatus(getPlayerSlotItem(getCreatureMaster(cid), 8).uid)
            end
            doClearPokemonStatus(cid)
            ---
			if doCorrectString(getCreatureName(cid)) == "Tyranitar" and isMega(cid) then
				doMoveInArea2(cid, -1, confusion, ROCKDAMAGE, 0, 0, spell, ret)
			else
				doMoveInArea2(cid, -1, confusion, GROUNDDAMAGE, 0, 0, spell, ret)
			end
         end
         ---
         setPlayerStorageValue(cid, 253, 1) --focus
         sendOpcodeStatusInfo(cid)
         doSendMagicEffect(getThingPosWithDebug(cid), 132)
         -- doClearBallStatus(getPlayerSlotItem(getCreatureMaster(cid), 8).uid)
         doClearPokemonStatus(cid)
         addEvent(doFall, 200, cid)
         addEvent(doRain, 1000, cid)

      elseif spell == "Powder Snow" then
         snowP = getThingPosWithDebug(cid)

         local ret = {}
         ret.id = 0
         ret.attacker = cid
         ret.cd = 10
         ret.check = 0
         ret.eff = 43
         ret.spell = spell
         ret.cond = "Slow"

         doMoveInArea2(cid, 297, check, ICEDAMAGE, min, max, spell, ret)
         doSendMagicEffect({x = snowP.x + 1, y = snowP.y, z = snowP.z}, 206)

      elseif spell == "Slash" then

         doAreaCombatHealth(cid, NORMALDAMAGE, getThingPosWithDebug(target), 0, -min, -max, 159)

      elseif spell == "X-Scissor" then
         local info = {
            [0] = {286, xScissorN, {x = myPos.x + 1, y = myPos.y, z = myPos.z}},
            [1] = {289, xScissorE, {x = myPos.x + 2, y = myPos.y + 1, z = myPos.z}},
            [2] = {287, xScissorS, {x = myPos.x + 1, y = myPos.y + 2, z = myPos.z}},
            [3] = {288, xScissorW, {x = myPos.x, y = myPos.y + 1, z = myPos.z}}
         }
         doSendMagicEffect(info[myDirection][3], info[myDirection][1])
         doAreaCombatHealth(cid, BUGDAMAGE, myPos, info[myDirection][2], -min, -max, 1392)

      elseif spell == "Psychic" then

         doDanoWithProtect(cid, psyDmg, getThingPosWithDebug(cid), selfArea2, min, max, 133)

      elseif spell == "Pay Day" then

         --alterado v1.7
         local function doThunderFall(cid, frompos, target)
            if not isCreature(target) or not isCreature(cid) then return true end
            local pos = getThingPosWithDebug(target)
            local ry = math.abs(frompos.y - pos.y)
            doSendDistanceShoot(frompos, getThingPosWithDebug(target), 39)
            addEvent(doDanoInTarget, ry * 11, cid, target, NORMALDAMAGE, min, max, 28)  --alterado v1.7
         end

         local function doThunderUp(cid, target)
            if not isCreature(target) or not isCreature(cid) then return true end
            local pos = getThingPosWithDebug(target)
            local mps = getThingPosWithDebug(cid)
            local xrg = math.floor((pos.x - mps.x) / 2)
            local topos = mps
            topos.x = topos.x + xrg
            local rd =  7
            topos.y = topos.y - rd
            doSendDistanceShoot(getThingPosWithDebug(cid), topos, 39)
            addEvent(doThunderFall, rd * 49, cid, topos, target)
         end

         setPlayerStorageValue(cid, 3644587, 1)
         addEvent(setPlayerStorageValue, 350, cid, 3644587, -1)
         for thnds = 1, 2 do
            addEvent(doThunderUp, thnds * 155, cid, target)
         end

		elseif spell == "Disarming Voice" then
	local myPos = getThingPos(cid)
	local myDirection = getCreatureDirectionToTarget(cid, target)
    local info = {
        [0] = psywaveN,
        [1] = psywaveE,
        [2] = psywaveS,
        [3] = psywaveW
    }
    doAreaCombatHealth(cid, STATUS_STUN7, myPos, info[myDirection], -22, -22, 1392)
    doAreaCombatHealth(cid, FAIRYDAMAGE, myPos, info[myDirection], -min, -max, 22)
			
      elseif spell == "Psywave" then

         doMoveInArea2(cid, 133, db2, psyDmg, min, max, spell)

      elseif spell == "Triple Kick" or spell == "Triple Kick Lee" then

         doDanoWithProtect(cid, FIGHTINGDAMAGE, getThingPosWithDebug(target), 0, -min, -max, 110)

      elseif spell == "Karate Chop" then

         doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 39)
         doDanoInTargetWithDelay(cid, target, FIGHTINGDAMAGE, -min, -max, 113)  --alterado v1.7

      elseif spell == "Ground Chop" then
         local function doSendMove(cid, area, effectarea, effect, turn)
            if not isCreature(cid) then
               return true
            end
            -- if getPokemonStatus(cid, "sleep") then return true end
            doAreaCombatHealth(cid, GROUNDDAMAGE, area, line1x1, -min, -max, 1392)
            doSendMagicEffect(effectarea, effect)
         end
         for i = 0, 5 do
            local info = {
               [0] = {
                  294,
                  {x = myPos.x, y = myPos.y - (i + 1), z = myPos.z},
                  {x = myPos.x + 1, y = myPos.y - i, z = myPos.z}
               },
               [1] = {
                  294,
                  {x = myPos.x + (i + 1), y = myPos.y, z = myPos.z},
                  {x = myPos.x + (i + 2), y = myPos.y + 1, z = myPos.z}
               },
               [2] = {
                  294,
                  {x = myPos.x, y = myPos.y + (i + 1), z = myPos.z},
                  {x = myPos.x + 1, y = myPos.y + (i + 2), z = myPos.z}
               },
               [3] = {
                  294,
                  {x = myPos.x - (i + 1), y = myPos.y, z = myPos.z},
                  {x = myPos.x - i, y = myPos.y + 1, z = myPos.z}
               }
            }
            addEvent(doSendMove, i * 300, cid, info[myDirection][2], info[myDirection][3], info[myDirection][1], i + 1)
         end
      elseif spell == "Mega Punch" then

         doDanoWithProtectWithDelay(cid, target, FIGHTINGDAMAGE, min, max, 112)

      elseif spell == "Tri Flames" then

         local ret = {}
         ret.id = 0
         ret.attacker = cid
         ret.cd = 9
         ret.check = 0
         ret.eff = 39
         ret.cond = "Silence"

         doMoveInArea2(cid, 6, triflames, FIREDAMAGE, min, max, spell, ret)

      elseif spell == "War Dog" then

         local ret = {}
         ret.id = cid
         ret.cd = 15
         ret.eff = 28
         ret.check = 0
         ret.buff = spell
         ret.first = true

         doCondition2(ret)

	elseif spell == "Bulk Up" then
		local function doSendMove(cid, turn)
		if not isCreature(cid) then
		return true
		end
		local turn = turn or 1
		local event = addEvent(doSendMove, 800, cid, turn + 1)
		local pos = getThingPosWithDebug(cid)
		doSendMagicEffect(pos, 476)
		if turn == 15 or isSleeping(cid) then
			stopEvent(event)
		end
		end
		doSendMove(cid)
		doRaiseStatus(cid, 2, 2, 0, 10)

      elseif spell == "Hypnosis" then
	  	local target = target or isCreature(getMasterTarget(cid)) and getMasterTarget(cid) or 0
		local targetPos = isCreature(target) and getThingPos(target) or nil
		local myPos = isCreature(cid) and getThingPos(cid) or nil
		doSendDistanceShoot(myPos, targetPos, 24)
		doTargetCombatHealth(cid, target, PSYCHICDAMAGE, -min, -max, 1392)
		doTargetCombatHealth(cid, target, STATUS_SLEEP, -6, -6, 1392)

      elseif spell == "Dizzy Punch" then

         local rounds = getPokemonLevel(cid) / 12
         rounds = rounds + 2

         local ret = {}
         ret.id = target
         ret.attacker = cid
         ret.check = getPlayerStorageValue(target, conds["Confusion"])
         ret.cd = rounds
         ret.cond = "Confusion"

         doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 26)
         doDanoWithProtect(cid, FIGHTINGDAMAGE, getThingPosWithDebug(target), 0, -min, -max, 112)
         addEvent(doMoveDano2, 50, cid, target, NORMALDAMAGE, 0, 0, ret, spell)

      elseif spell == "Ice Punch" then
         local ret = {}
         ret.id = target
         ret.attacker = cid
         ret.cd = 9
         ret.eff = 43
         ret.check = getPlayerStorageValue(target, conds["Slow"])
         ret.first = true
         ret.cond = "Slow"

         doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 28)
         doSendMagicEffect(getThingPosWithDebug(target), 450)
         doDanoWithProtectWithDelay(cid, target, ICEDAMAGE, min, max, 43)
         addEvent(doMoveDano2, 50, cid, target, ICEDAMAGE, 0, 0, ret, spell)

      elseif spell == "Ice Beam" then
         local a = isCreature(target) and getCreatureDirectionToTarget(cid, target) or getCreatureLookDir(cid)
         local p = getThingPosWithDebug(cid)
         local t = {
            [0] = {97, {x = p.x + 1, y = p.y - 1, z = p.z}},
            [1] = {96, {x = p.x + 6, y = p.y + 1, z = p.z}},
            [2] = {97, {x = p.x + 1, y = p.y + 6, z = p.z}},
            [3] = {96, {x = p.x - 1, y = p.y + 1, z = p.z}}
         }

         local ret = {}
         ret.id = 0
         ret.attacker = cid
         ret.cd = 9
         ret.eff = 43
         ret.check = 0
         ret.first = true
         ret.cond = "Slow"

         doMoveInArea2(cid, 0, triplo6, ICEDAMAGE, min, max, spell, ret)
         doSendMagicEffect(t[a][2], t[a][1])

      elseif spell == "Kinesis" then
        local ret = {}
        ret.id = 0
        ret.attacker = cid
        ret.cd = math.random(0, 3)
        ret.check = getPlayerStorageValue(target, conds["Stun"])
        ret.eff = 1392
        ret.spell = spell
        ret.cond = "Stun"

        -- doSendMagicEffect(getThingPosWithDebug(cid), 513)
        doMoveInArea2(cid, 1392, confusion, PSYCHICDAMAGE, min, max, spell, ret)
        -- doMoveDano2(cid, target, PSYCHICDAMAGE, min, max, ret, spell)
        local myPos = getThingPosWithDebug(cid)
        local function doSendMove(cid, area, effect)
            if not isCreature(cid) then
                return true
            end
            doAreaCombatHealth(cid, PSYCHICDAMAGE, myPos, area, -min, -max, effect)
        end
        for i = 0, 5 do
            local areas = {kinesisArea, kinesisArea, kinesisArea, kinesisArea, kinesisArea, kinesisArea}
            local effects = {1392, 1392, 1392, 1392, 1392, 1392}
            addEvent(doSendMove, i * 300, cid, areas[i + 1], effects[i + 1], i + 1)
        end

      elseif spell == "Psy Pulse" or spell == "Cyber Pulse" or spell == "Dark Pulse" then
         damage = skill == "Dark Pulse" and DARKDAMAGE or PSYCHICDAMAGE

         local function doPulse(cid, eff)
            if not isCreature(cid) then
               return true
            end
            doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 3)
            doDanoInTargetWithDelay(cid, target, damage, min, max, eff) --alterado v1.7
         end

         if spell == "Cyber Pulse" then
            eff = 11
         elseif spell == "Dark Pulse" then
            eff = 47 --efeito n eh esse mas... ;p
         else
            eff = 133
         end

         addEvent(doPulse, 0, cid, eff)
         addEvent(doPulse, 250, cid, eff)

      elseif spell == "Psyusion" then

local function doSendMove(cid, turn)
   if not isCreature(cid) then
      return true
   end
   local turn = turn or 1
   local event = addEvent(doSendMove, 400, cid, turn + 1)
   local area1 = {psy1, psy2, psy3, psy4, psy5}
   local eff = {136, 133, 136, 133, 137}
   doAreaCombatHealth(cid, PSYCHICDAMAGE, getThingPosWithDebug(cid), area1[turn], -min, -max, eff[turn])
   doAreaCombatHealth(cid, STATUS_CONFUSION10, myPos, area1[turn], -31, -31, 1392)
   if turn == 5 or isSleeping(cid) then
      stopEvent(event)
   end
end
doSendMove(cid)

      elseif spell == "Triple Punch" then

         doDanoWithProtect(cid, FIGHTINGDAMAGE, getThingPosWithDebug(target), 0, -min, -max, 110)

      elseif spell == "Fist Machine" then

         local function doSendMove(cid)
            if not isCreature(cid) then
               return true
            end
            -- if getPokemonStatus(cid, "sleep") then return true end
            local myPos = isCreature(cid) and getThingPosWithDebug(cid) or nil
            local myDirection = getCreatureDirectionToTarget(cid, target)
            local info = {
               [0] = {217, {x = myPos.x, y = myPos.y - 1, z = myPos.z}, {x = myPos.x, y = myPos.y - 1, z = myPos.z}},
               [1] = {215, {x = myPos.x + 3, y = myPos.y, z = myPos.z}, {x = myPos.x + 1, y = myPos.y, z = myPos.z}},
               [2] = {218, {x = myPos.x, y = myPos.y + 3, z = myPos.z}, {x = myPos.x, y = myPos.y + 1, z = myPos.z}},
               [3] = {216, {x = myPos.x - 1, y = myPos.y, z = myPos.z}, {x = myPos.x - 1, y = myPos.y, z = myPos.z}}
            }
            doSendMagicEffect(info[myDirection][2], info[myDirection][1])
            doAreaCombatHealth(cid, FIGHTINGDAMAGE, info[myDirection][3], line1x1, -min, -max, -1)
         end
         for i = 0, 3 do
            addEvent(doSendMove, i * 100, cid)
         end

      elseif spell == "Bullet Punch" then
         local function doSendMove(cid)
            if not isCreature(cid) then
               return true
            end
            -- if getPokemonStatus(cid, "sleep") then return true end
            local myPos = isCreature(cid) and getThingPosWithDebug(cid) or nil
            local myDirection = getCreatureDirectionToTarget(cid, target)
            local info = {
               [0] = {536, {x = myPos.x, y = myPos.y - 1, z = myPos.z}, {x = myPos.x, y = myPos.y - 1, z = myPos.z}},
               [1] = {534, {x = myPos.x + 3, y = myPos.y, z = myPos.z}, {x = myPos.x + 1, y = myPos.y, z = myPos.z}},
               [2] = {537, {x = myPos.x, y = myPos.y + 3, z = myPos.z}, {x = myPos.x, y = myPos.y + 1, z = myPos.z}},
               [3] = {535, {x = myPos.x - 1, y = myPos.y, z = myPos.z}, {x = myPos.x - 1, y = myPos.y, z = myPos.z}}
            }
			local info2  = {
               [0] = {565, {x = myPos.x, y = myPos.y - 1, z = myPos.z}, {x = myPos.x, y = myPos.y - 1, z = myPos.z}},
               [1] = {563, {x = myPos.x + 3, y = myPos.y, z = myPos.z}, {x = myPos.x + 1, y = myPos.y, z = myPos.z}},
               [2] = {566, {x = myPos.x, y = myPos.y + 3, z = myPos.z}, {x = myPos.x, y = myPos.y + 1, z = myPos.z}},
               [3] = {564, {x = myPos.x - 1, y = myPos.y, z = myPos.z}, {x = myPos.x - 1, y = myPos.y, z = myPos.z}}
            }
            local info3 = {
               [0] = {217, {x = myPos.x, y = myPos.y - 1, z = myPos.z}, {x = myPos.x, y = myPos.y - 1, z = myPos.z}},
               [1] = {215, {x = myPos.x + 3, y = myPos.y, z = myPos.z}, {x = myPos.x + 1, y = myPos.y, z = myPos.z}},
               [2] = {218, {x = myPos.x, y = myPos.y + 3, z = myPos.z}, {x = myPos.x, y = myPos.y + 1, z = myPos.z}},
               [3] = {216, {x = myPos.x - 1, y = myPos.y, z = myPos.z}, {x = myPos.x - 1, y = myPos.y, z = myPos.z}}
            }
			if isInArray({"Lucario", "Mega Lucario"}, doCorrectString(getCreatureName(cid))) then
				doSendMagicEffect(info[myDirection][2], info[myDirection][1])
				doAreaCombatHealth(cid, FIGHTINGDAMAGE, info[myDirection][3], line1x1, -min, -max, -1)
			elseif doCorrectString(getCreatureName(cid)) == "Shiny Lucario" then
				doSendMagicEffect(info2[myDirection][2], info2[myDirection][1])
				doAreaCombatHealth(cid, FIGHTINGDAMAGE, info2[myDirection][3], line1x1, -min, -max, -1)
			else
				doSendMagicEffect(info3[myDirection][2], info3[myDirection][1])
				doAreaCombatHealth(cid, FIGHTINGDAMAGE, info2[myDirection][3], line1x1, -min, -max, -1)
			end
         end
         for i = 0, 3 do
            addEvent(doSendMove, i * 100, cid)
         end
		 
      elseif spell == "Arm Thrust" then

         local function doSendMove(cid)
            if not isCreature(cid) then
               return true
            end
            -- if getPokemonStatus(cid, "sleep") then return true end
            local myPos = isCreature(cid) and getThingPosWithDebug(cid) or nil
            local myDirection = getCreatureDirectionToTarget(cid, target)
            local info = {
               [0] = {217, {x = myPos.x, y = myPos.y - 1, z = myPos.z}, {x = myPos.x, y = myPos.y - 1, z = myPos.z}},
               [1] = {215, {x = myPos.x + 3, y = myPos.y, z = myPos.z}, {x = myPos.x + 1, y = myPos.y, z = myPos.z}},
               [2] = {218, {x = myPos.x, y = myPos.y + 3, z = myPos.z}, {x = myPos.x, y = myPos.y + 1, z = myPos.z}},
               [3] = {216, {x = myPos.x - 1, y = myPos.y, z = myPos.z}, {x = myPos.x - 1, y = myPos.y, z = myPos.z}}
            }
            doSendMagicEffect(info[myDirection][2], info[myDirection][1])
            doAreaCombatHealth(cid, FIGHTINGDAMAGE, info[myDirection][3], lineBullet, -min, -max, -1)
         end
         for i = 0, 3 do
            addEvent(doSendMove, i * 100, cid)
         end

      elseif spell == "Destroyer Hand" then
		local myPos = getThingPosWithDebug(cid)
		doFrontalCombatHealth(cid, myPos, FIGHTINGDAMAGE, min, max, 111, 26)
	  elseif spell == "Heavy Metal" then
		doAreaCombatHealth(cid, STEELDAMAGE, myPos, storedArea1, -min, -max, 1105)
		
	  elseif spell == "Gravity" then
		
		local ret = {}
         ret.id = 0
         ret.attacker = cid
         ret.cd = 6
         ret.check = 0
         ret.eff = 34
         ret.spell = spell
         ret.cond = "Stun"
         doMoveInArea2(cid, 118, stomp, GROUNDDAMAGE, min, max, spell, ret)

      elseif spell == "Rock Throw" then
         local effD = getSubName(cid, target) == "Crystal Onix" and 70 or 11
         local eff = getSubName(cid, target) == "Crystal Onix" and 403 or 44 --alterado v1.6.1
         local dmgType = getSubName(cid, target) == "Crystal Onix" and CRYSTALDAMAGE or ROCKDAMAGE

         doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), effD)
         doDanoInTargetWithDelay(cid, target, dmgType, min, max, eff) --alterado v1.7

      elseif spell == "Volcano Shot" then

         local effD = 59
         local eff = 476
         local dmgType = FIREDAMAGE

         local function doRockFall(cid, frompos, target)
            if not isCreature(target) or not isCreature(cid) then return true end
            local pos = getThingPosWithDebug(target)
            local ry = math.abs(frompos.y - pos.y)
            doSendDistanceShoot(frompos, getThingPosWithDebug(target), effD)

            local ret = {}
            ret.id = target
            ret.attacker = cid
            ret.cd = 9
            ret.eff = 255
            ret.check = getPlayerStorageValue(target, conds["Slow"])
            ret.spell = spell
            ret.cond = "Slow"

            addEvent(doMoveDano2, ry * 11, cid, target, dmgType, 0, 0, ret, spell)
            addEvent(doDanoInTarget, ry * 11, cid, target, dmgType, min, max, eff) --alterado v1.7
         end

         local function doRockUp(cid, target)
            if not isCreature(target) or not isCreature(cid) then return true end
            local pos = getThingPosWithDebug(target)
            local mps = getThingPosWithDebug(cid)
            local xrg = math.floor((pos.x - mps.x) / 2)
            local topos = mps
            topos.x = topos.x + xrg
            local rd =  7
            topos.y = topos.y - rd
            doSendDistanceShoot(getThingPosWithDebug(cid), topos, effD)
            addEvent(doRockFall, rd * 49, cid, topos, target)
         end

         setPlayerStorageValue(cid, 3644587, 1)
         addEvent(setPlayerStorageValue, 350, cid, 3644587, -1)
         addEvent(doRockUp, 155, cid, target)

      elseif spell == "Rock Slide" or spell == "Stone Edge" then
         atk = {
            ["Rock Slide"] = {11, 44, 70, 403},
            ["Stone Edge"] = {11, 270}
         }

         local effD = getSubName(cid, target) == "Crystal Onix" and atk[spell][3] or atk[spell][1]
         local eff = getSubName(cid, target) == "Crystal Onix" and atk[spell][4] or atk[spell][2] --alterado v1.6.1
         local dmgType = getSubName(cid, target) == "Crystal Onix" and CRYSTALDAMAGE or ROCKDAMAGE

         --alterado v1.7
         local function doRockFall(cid, frompos, target)
            if not isCreature(target) or not isCreature(cid) then
               return true
            end
            local pos = getThingPosWithDebug(target)
            local ry = math.abs(frompos.y - pos.y)
            doSendDistanceShoot(frompos, getThingPosWithDebug(target), effD)
            addEvent(doDanoInTarget, ry * 11, cid, target, dmgType, min, max, eff) --alterado v1.7
         end

         local function doRockUp(cid, target)
            if not isCreature(target) or not isCreature(cid) then
               return true
            end
            local pos = getThingPosWithDebug(target)
            local mps = getThingPosWithDebug(cid)
            local xrg = math.floor((pos.x - mps.x) / 2)
            local topos = mps
            topos.x = topos.x + xrg
            local rd = 7
            topos.y = topos.y - rd
            doSendDistanceShoot(getThingPosWithDebug(cid), topos, effD)
            addEvent(doRockFall, rd * 49, cid, topos, target)
         end

         setPlayerStorageValue(cid, 3644587, 1)
         addEvent(setPlayerStorageValue, 350, cid, 3644587, -1)
         for thnds = 1, 2 do
            addEvent(doRockUp, thnds * 155, cid, target)
         end

      elseif spell == "Scrap Throw" then
         -- atk = {
         -- ["Rock Slide"] = {11, 44, 0, 403},
         -- ["Stone Edge"] = {11, 270}
         -- }


         --alterado v1.7
         local function doRockFall(cid, frompos, target)
            if not isCreature(target) or not isCreature(cid) then
               return true
            end
            local pos = getThingPosWithDebug(target)
            local ry = math.abs(frompos.y - pos.y)
            doSendDistanceShoot(frompos, getThingPosWithDebug(target), 157)
            addEvent(doDanoInTarget, ry * 11, cid, target, STEELDAMAGE, min, max, 258) --alterado v1.7
         end

         local function doRockUp(cid, target)
            if not isCreature(target) or not isCreature(cid) then
               return true
            end
            local pos = getThingPosWithDebug(target)
            local mps = getThingPosWithDebug(cid)
            local xrg = math.floor((pos.x - mps.x) / 2)
            local topos = mps
            topos.x = topos.x + xrg
            local rd = 7
            topos.y = topos.y - rd
            doSendDistanceShoot(getThingPosWithDebug(cid), topos, 157)
            addEvent(doRockFall, rd * 49, cid, topos, target)
         end

         -- setPlayerStorageValue(cid, 3644587, 1)
         -- addEvent(setPlayerStorageValue, 350, cid, 3644587, -1)
         for thnds = 1, 2 do
            addEvent(doRockUp, thnds * 155, cid, target)
         end

      elseif spell == "Falling Rocks" then
         -- local effD = getSubName(cid, target) == "Crystal Onix" and 70 or 11
         -- local eff = getSubName(cid, target) == "Crystal Onix" and 369 or 44 --alterado v1.6.1
         -- local dmgType = getSubName(cid, target) == "Crystal Onix" and CRYSTALDAMAGE or ROCKDAMAGE

         -- local master = isSummon(cid) and getCreatureMaster(cid) or cid
         ----------

         -- local function doFall(cid)
            -- for rocks = 1, 62 do
               -- addEvent(fall, rocks * 35, cid, master, dmgType, effD, eff)
            -- end
         -- end

         -- for up = 1, 10 do
            -- addEvent(upEffect, up * 75, cid, effD)
         -- end
         -- addEvent(doFall, 450, cid)
         -- addEvent(doDanoWithProtect, 1400, cid, dmgType, getThingPosWithDebug(cid), waterarea, -min, -max, 1392)
    local function doSendMoveDown(cid)
        if not isCreature(cid) then return true end
        for i = 0, 20 do
            addEvent(doSendMoveEffectDown, i * 50, cid, 44, 11)
        end
    end
    local function doSendMoveDamage(cid)
        if not isCreature(cid) then return true end
        doAreaCombatHealth(cid, ROCKDAMAGE, myPos, square4x4, -min, -max, 1392)
    end
    for i = 0, 20 do
        addEvent(doSendMoveEffectUp, i * 50, cid, 8)
    end
    addEvent(doSendMoveDown, 500, cid)
    addEvent(doSendMoveDamage, 1500, cid)
		 

      elseif spell == "Selfdestruct" then

         if isSummon(cid) then setPlayerStorageValue(getCreatureMaster(cid), 23283, 1) end -- storage de usou self para o statsChange.lua
         doDanoWithProtect(cid, NORMALDAMAGE, getThingPosWithDebug(cid), selfArea2, -min, -max, 5)
         setPlayerStorageValue(getCreatureMaster(cid), 23283, -1)
         if isSummon(cid) then
            local master = getCreatureMaster(cid)
            checkGiveUp(master)
            if isInDuel(master) then
               doRemoveCountPokemon(master)
            end
         end
         doKillWildPoke(cid, cid)

      elseif spell == "Explosion" then

         if isSummon(cid) then setPlayerStorageValue(getCreatureMaster(cid), 23283, 1) end -- storage de usou self para o statsChange.lua
         doDanoWithProtect(cid, NORMALDAMAGE, getThingPosWithDebug(cid), selfArea2, -min, -max, 5)
         setPlayerStorageValue(getCreatureMaster(cid), 23283, -1)
         if isSummon(cid) then
            local master = getCreatureMaster(cid)
            checkGiveUp(master)
            if isInDuel(master) then
               doRemoveCountPokemon(master)
            end
         end
         doKillWildPoke(cid, cid)


      elseif spell == "Crusher Stomp" then

         local pL = getThingPosWithDebug(cid)
         pL.x = pL.x+5
         pL.y = pL.y+1
         -----------------
         local pO = getThingPosWithDebug(cid)
         pO.x = pO.x-3
         pO.y = pO.y+1
         ------------------
         local pN = getThingPosWithDebug(cid)
         pN.x = pN.x+1
         pN.y = pN.y+5
         -----------------
         local pS = getThingPosWithDebug(cid)
         pS.x = pS.x+1
         pS.y = pS.y-3

         local po = {pL, pO, pN, pS}
         local po2 = {
            {x = pL.x, y = pL.y-1, z = pL.z},
            {x = pO.x, y = pO.y-1, z = pO.z},
            {x = pN.x-1, y = pN.y, z = pN.z},
            {x = pS.x-1, y = pS.y, z = pS.z},
         }

         local ret = {}
         ret.id = 0
         ret.attacker = cid
         ret.cd = 9
         ret.check = 0
         ret.eff = 34
         ret.spell = spell
         ret.cond = "Stun"

         for i = 1, 4 do
            doSendMagicEffect(po[i], 127)
            doAreaCombatHealth(cid, GROUNDDAMAGE, po2[i], crusher, -min, -max, 255)
         end
         doMoveInArea2(cid, 118, stomp, GROUNDDAMAGE, min, max, spell, ret)

      elseif spell == "Water Pulse" then
         doDanoWithProtect(cid, WATERDAMAGE, getThingPosWithDebug(cid), selfArea2, -min, -max, 290)

      elseif spell == "Sonicboom" then

         local function doBoom(cid)
            if not isCreature(cid) then return true end
            doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 33)
            doDanoInTargetWithDelay(cid, target, NORMALDAMAGE, min, max, 3)   --alterado v1.7
         end

         addEvent(doBoom, 0, cid)
         addEvent(doBoom, 250, cid)

      elseif spell == "Stickmerang" then

         doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 34)
         doDanoInTargetWithDelay(cid, target, FLYINGDAMAGE, min, max, 212)  --alterado v1.7

      elseif spell == "Iron Spiner" then

         local function sendStickEff(cid, dir)
            if not isCreature(cid) then return true end
            local effpos = getPosByDir(getThingPosWithDebug(cid), dir)
            effpos.x = effpos.x+1
            effpos.y = effpos.y+1
            doAreaCombatHealth(cid, STEELDAMAGE, getPosByDir(getThingPosWithDebug(cid), dir), 0, -min, -max, 1392)
            doSendMagicEffect(effpos, 492)
         end

         local function doStick(cid)
            if not isCreature(cid) then return true end
            local t = {
               [1] = SOUTHWEST,
               [2] = SOUTH,
               [3] = SOUTHEAST,
               [4] = EAST,
               [5] = NORTHEAST,
               [6] = NORTH,
               [7] = NORTHWEST,
               [8] = WEST,
               [9] = SOUTHWEST,
            }
            for a = 1, 9 do
               addEvent(sendStickEff, a * 140, cid, t[a])
            end
         end

         doStick(cid, false, cid)
		 
      elseif spell == "Impale" then

         local function sendStickEff(cid, dir)
            if not isCreature(cid) then return true end
            local effpos = getPosByDir(getThingPosWithDebug(cid), dir)
            effpos.x = effpos.x+1
            effpos.y = effpos.y+1
            doAreaCombatHealth(cid, STEELDAMAGE, getPosByDir(getThingPosWithDebug(cid), dir), 0, -min, -max, 1392)
            doSendMagicEffect(effpos, 492)
         end

         local function doStick(cid)
            if not isCreature(cid) then return true end
            local t = {
               [1] = SOUTHWEST,
               [2] = SOUTH,
               [3] = SOUTHEAST,
               [4] = EAST,
               [5] = NORTHEAST,
               [6] = NORTH,
               [7] = NORTHWEST,
               [8] = WEST,
               [9] = SOUTHWEST,
            }
            for a = 1, 9 do
               addEvent(sendStickEff, a * 140, cid, t[a])
            end
         end

         doStick(cid, false, cid)

      elseif spell == "Stickslash" then

         local function sendStickEff(cid, dir)
            if not isCreature(cid) then return true end
            doAreaCombatHealth(cid, FLYINGDAMAGE, getPosByDir(getThingPosWithDebug(cid), dir), 0, -min, -max, 212)
         end

         local function doStick(cid)
            if not isCreature(cid) then return true end
            local t = {
               [1] = SOUTHWEST,
               [2] = SOUTH,
               [3] = SOUTHEAST,
               [4] = EAST,
               [5] = NORTHEAST,
               [6] = NORTH,
               [7] = NORTHWEST,
               [8] = WEST,
               [9] = SOUTHWEST,
            }
            for a = 1, 9 do
               addEvent(sendStickEff, a * 140, cid, t[a])
            end
         end

         doStick(cid, false, cid)




      elseif spell == "Pluck" then

         doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 39)
         doDanoInTargetWithDelay(cid, target, FLYINGDAMAGE, min, max, 111)  --alterado v1.7

      elseif spell == "Magnet Field" then

         local ret = {}
         ret.id = 0
         ret.attacker = cid
         ret.check = 0
         ret.eff = 48
         ret.cd = math.random(3, 6)
         ret.cond = "Slow"

         doMoveInArea2(cid, 48, magnetfield, ELECTRICDAMAGE, min, max, spell, ret)

      elseif spell == "Tri-Attack" then

         local rand = {{"Slow", 43}, {"Stun", 48}, {"Burn", 355}}
         local r = math.random(1,3)

         local ret = {}
         ret.id = target
         ret.im = 0
         ret.attacker = cid
         ret.cd = 9
         ret.eff = rand[r][2]
         ret.check = 0
         ret.spell = spell
         ret.cond = rand[r][1]
         ret.damage = pbdmg
         ret.tickt = 750

         local function doAttack(cid, target, min, max)
            if not (isCreature(target) and isCreature(cid)) then return true end

            --doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 42)
            doSendMagicEffect(getThingPos(target), 263)
            doMoveDano2(cid, target, NORMALDAMAGE, -min, -max, {}, spell)
         end

         doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 42)
         doSendMagicEffect(getThingPos(target), 163)
         doMoveDano2(cid, target, NORMALDAMAGE, -min, -max, ret, spell)
         for i = 1, 2 do
            addEvent(doAttack, i*350, cid, target, min, max)      --alterado v1.7
         end

      elseif spell == "Fury Attack" then

         --alterado v1.7
         setPlayerStorageValue(cid, 3644587, 1)
         addEvent(setPlayerStorageValue, 600, cid, 3644587, -1)
         for i = 0, 2 do
            addEvent(doDanoInTargetWithDelay, i*300, cid, target, NORMALDAMAGE, min, max, 110)    --alterado v1.7
         end

      elseif spell == "Ice Ball" then

         if isCreature(target) then
            local ret = {}
            ret.id = target
            ret.attacker = cid
            ret.cd = 5
            ret.eff = 473
            ret.check = 0
            ret.spell = spell
            ret.cond = "Sleep"

            doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 28)
            addEvent(doMoveDano2, 100, cid, target, ICEDAMAGE, -min, -max, ret, spell)
         end


      elseif spell == "Weather Ball" then
         if not getPlayerStorageValue(cid, 23821) or getPlayerStorageValue(cid, 23821) < 1 then
            setPlayerStorageValue(cid, 23821, 0)
         end
         local a = getPlayerStorageValue(cid, 23821)
         doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), cft[a][4])
         doDanoInTargetWithDelay(cid, target, cft[a][5], min, max, cft[a][3])  --alterado v1.7

      elseif spell == "Ice Shards" then

         doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 28)
         doDanoInTargetWithDelay(cid, target, ICEDAMAGE, min, max, 43)  --alterado v1.7

      elseif spell == "Icy Wind" then

         local ret = {}
         ret.id = 0
         ret.attacker = cid
         ret.cd = 9
         ret.eff = 43
         ret.check = 0
         ret.first = true
         ret.cond = "Slow"

         doMoveInArea2(cid, 17, db2, ICEDAMAGE, min, max, spell, ret)

      elseif spell == "Aurora Beam" then
         local info = {
            [0] = {387, cannon3N, {x = myPos.x + 1, y = myPos.y - 1, z = myPos.z}},
            [1] = {386, cannon3E, {x = myPos.x + 6, y = myPos.y + 1, z = myPos.z}},
            [2] = {387, cannon3S, {x = myPos.x + 1, y = myPos.y + 6, z = myPos.z}},
            [3] = {386, cannon3W, {x = myPos.x - 1, y = myPos.y + 1, z = myPos.z}}
         }
         doSendMagicEffect(info[myDirection][3], info[myDirection][1])
         doAreaCombatHealth(cid, ICEDAMAGE, myPos, info[myDirection][2], -min, -max, 1392)

      elseif spell == "Rest" then

         if isInArea(getThingPosWithDebug(cid), {x=2449,y=2611,z=8}, {x=2491,y=2654,z=8}) then return true end

         local ret = {}
         ret.id = cid
         ret.cd = 6
         ret.eff = 1392
         ret.check = 0
         ret.buff = spell
         ret.first = true

         doCondition2(ret)

      elseif spell == "Sludge" then

         --alterado v1.7
         local function doSludgeFall(cid, frompos, target)
            if not isCreature(target) or not isCreature(cid) then return true end
            local pos = getThingPosWithDebug(target)
            local ry = math.abs(frompos.y - pos.y)
            doSendDistanceShoot(frompos, getThingPosWithDebug(target), 6)
            addEvent(doDanoInTargetWithDelay, ry * 11, cid, target, POISONDAMAGE, min, max, 116) --alterado v1.7
         end

         local function doSludgeUp(cid, target)
            if not isCreature(target) or not isCreature(cid) then return true end
            local pos = getThingPosWithDebug(target)
            local mps = getThingPosWithDebug(cid)
            local xrg = math.floor((pos.x - mps.x) / 2)
            local topos = mps
            topos.x = topos.x + xrg
            local rd =  7
            topos.y = topos.y - rd
            doSendDistanceShoot(getThingPosWithDebug(cid), topos, 6)
            addEvent(doSludgeFall, rd * 49, cid, topos, target)
         end

         setPlayerStorageValue(cid, 3644587, 1)
         addEvent(setPlayerStorageValue, 350, cid, 3644587, -1)
         for thnds = 1, 2 do
            addEvent(doSludgeUp, thnds * 155, cid, target)
         end                                               --alterado v1.5

      elseif spell == "Mud Bomb" then

         doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 6)  --alterado v1.8
         doDanoWithProtectWithDelay(cid, target, MUDBOMBDAMAGE, min, max, 116, bombWee2)

      elseif spell == "Mortal Gas" then

         local pos = getThingPosWithDebug(cid)

         local function doSendAcid(cid, pos)
            if not isCreature(cid) then return true end
            doSendDistanceShoot(getThingPosWithDebug(cid), pos, 14)
            doSendMagicEffect(pos, 114)
         end

         for b = 1, 3 do
            for a = 1, 20 do
               local lugar = {x = pos.x + math.random(-4, 4), y = pos.y + math.random(-3, 3), z = pos.z}
               addEvent(doSendAcid, a * 75, cid, lugar)
            end
         end
         doDanoWithProtect(cid, POISONDAMAGE, pos, waterarea, -min, -max, 1392)

	elseif spell == "Mega Horn" then
	  	local myPos = getThingPosWithDebug(cid)
		doFrontalCombatHealth(cid, myPos, FIGHTINGDAMAGE, min, max, 25, 8)
    elseif spell == "Rock Drill" then
		local myPos = getThingPosWithDebug(cid)
		doFrontalCombatHealth(cid, myPos, FIGHTINGDAMAGE, min, max, 44, 25)
	elseif spell == "Megahorn" then
		local myPos = getThingPosWithDebug(cid)
		doFrontalCombatHealth(cid, myPos, FIGHTINGDAMAGE, min, max, 8, 25)
		 
   elseif spell == "Rock Blast" then
      local pos = getThingPosWithDebug(cid)
      local function doSendBubble(cid, pos)
         if not isCreature(cid) then
            return true
         end
         if isWithFear(cid) and getPlayerStorageValue(cid, 3644587) >= 1 then
            return true
         end
         if isSleeping(cid) and getPlayerStorageValue(cid, 3644587) >= 1 then
            return true
         end
         doSendDistanceShoot(getThingPosWithDebug(cid), pos, 94)
         doSendMagicEffect(pos, 9)
      end
      for a = 0, 20 do
         local lugar = {x = pos.x + math.random(-4, 4), y = pos.y + math.random(-3, 3), z = pos.z}
         addEvent(doSendBubble, a * 50, cid, lugar)
      end
      addEvent(doDanoWithProtect, 150, cid, ROCKDAMAGE, pos, waterarea, -min, -max, -1)

      elseif spell == "Egg Bomb" then

         doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 12)
         doDanoWithProtectWithDelay(cid, target, NORMALDAMAGE, min, max, 5, crusher)

      elseif spell == "Super Vines" then

         stopNow(cid, 200)
         doCreatureSetLookDir(cid, 2)

         local effect = 0
         local pos = getThingPosWithDebug(cid)
         pos.x = pos.x + 1
         pos.y = pos.y + 1

         local effect = getSubName(cid, target) == "Tangela" and 213 or 229

         doSendMagicEffect(pos, effect)
         doDanoWithProtect(cid, GRASSDAMAGE, getThingPosWithDebug(cid), splash, -min, -max, 1392)
		 
      elseif spell == "Power Whip" then

         stopNow(cid, 200)
         doCreatureSetLookDir(cid, 2)

         local effect = 0
         local pos = getThingPosWithDebug(cid)
         pos.x = pos.x + 1
         pos.y = pos.y + 1

         local effect = getSubName(cid, target) == "Tangela" and 213 or 820
		 if isInArray({"Tangrowth"}, doCorrectString(getCreatureName(cid))) then
			PullMove(cid, pullArea, spell, 1000, nil, nil, 1392)
			-- function PullMove(cid, area, spell, stopt, condition, condtime, reteff) -- by uissu
		 end
         doSendMagicEffect(pos, effect)
         doDanoWithProtect(cid, GRASSDAMAGE, getThingPosWithDebug(cid), splash, -min, -max, 1392)
		 -- function PullMove(cid, area, spell, stopt, condition, condtime, reteff) -- by uissu
		 

      elseif spell == "Epicenter" then
			doMoveInArea2(cid, 127, epicenter, GROUNDDAMAGE, min, max, spell)

      elseif spell == "Bubblebeam" or spell == "BubbleBeam" then
         local function doSendMove(cid, target)
            if not isCreature(cid) or not isCreature(target) then
               return true
            end
            doTargetCombatHealth(cid, target, WATERDAMAGE, -min, -max, 1)
            doSendDistanceShoot(myPos, getThingPos(target), 2)
         end
         for i = 0, 2 do
            addEvent(doSendMove, i * 100, cid, target)
         end

      elseif  spell == "Swift" then

         local function sendSwift(cid, target)
            if not isCreature(cid) or not isCreature(target) then return true end
            doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 32)
            doDanoInTargetWithDelay(cid, target, NORMALDAMAGE, min, max, 3)   --alterado v1.7
         end

         addEvent(sendSwift, 100, cid, target)
         addEvent(sendSwift, 200, cid, target)

      elseif spell == "Spark" then

         doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 32)
         doDanoInTargetWithDelay(cid, target, ELECTRICDAMAGE, min, max, 48)    --alterado v1.7


      elseif  spell == "Mimic Wall" then

         local p = getThingPosWithDebug(cid)
         local dirr = getCreatureLookDir(cid)

         if dirr == 0 or dirr == 2 then
            item = 11439
         else
            item = 11440
         end

         local wall = {
            [0] = {{x = p.x, y = p.y-1, z = p.z}, {x = p.x+1, y = p.y-1, z = p.z}, {x = p.x-1, y = p.y-1, z = p.z}},
            [2] = {{x = p.x, y = p.y+1, z = p.z}, {x = p.x+1, y = p.y+1, z = p.z}, {x = p.x-1, y = p.y+1, z = p.z}},
            [1] = {{x = p.x+1, y = p.y, z = p.z}, {x = p.x+1, y = p.y+1, z = p.z}, {x = p.x+1, y = p.y-1, z = p.z}},
            [3] = {{x = p.x-1, y = p.y, z = p.z}, {x = p.x-1, y = p.y+1, z = p.z}, {x = p.x-1, y = p.y-1, z = p.z}},
         }

         for i = 1, 3 do
            if wall[dirr] then
               local t = wall[dirr]
               if hasTile(t[i]) and canWalkOnPos2(t[i], true, true, true, true, false) then  --alterado v1.6
                  local destroyed = false
                  for stack=0,20 do
                     local cpos = {x=t[i].x,y=t[i].y,z=t[i].z,stackpos=stack}
                     if getThingFromPos(cpos).itemid == item then
                        doRemoveItem(getThingFromPos(cpos).uid, 1)
                        doSendMagicEffect(t[i], 3)
                        destroyed = true
                     end
                  end
                  if not destroyed then
                     local walls = doCreateItem(item, 1, t[i])
                     doDecayItem(walls)
                  end
               end
            end
         end

    elseif spell == "Compass Slash" then
	local function doSendMove(cid, turn)
	if not isCreature(cid) then
		return true
	end
	local turn = turn or 1
	local event = addEvent(doSendMove, 100, cid, turn + 1)
	local pos = getThingPosWithDebug(cid)
	pos.x = pos.x + 2
	pos.y = pos.y + 1
	doSendMagicEffect(pos, 889)
	doAreaCombatHealth(cid, BUGDAMAGE, getThingPosWithDebug(cid), square1x1, -min, -max, 1392)
	if turn == 4 or isSleeping(cid) then
		stopEvent(event)
	end
	end
	doSendMove(cid)	
	elseif spell == "Payback" then
		local pos = getThingPosWithDebug(cid) 
		pos.x = pos.x + 3
		pos.y = pos.y + 3
		doSendMagicEffect(pos, 1393)
         local master = isSummon(cid) and getCreatureMaster(cid) or cid
         local ret = {}
         ret.id = 0
         ret.attacker = cid
         ret.cd = 7
         ret.eff = 1392
         ret.check = 0 
         ret.first = true
         ret.cond = "Slow"
		 doMoveInArea2(cid, 1392, BigArea2, DARKDAMAGE, min, max, spell, ret)
		 
		-- doAreaCombatHealth(cid, DARKDAMAGE, myPos, square4x4, -min, -max, 1392)
		

      elseif spell == "Shredder Team" or spell == "Double Team" or spell == "Split" then     --alterado v1.8 \/

         local team = {
            ["Scyther"] = 3,
            ["Shiny Scyther"] = 3,
            ["Scizor"] = 4,
            ["Shiny Gallade"] = 2,
            ["Xatu"] = 2,
            ["Shiny Xatu"] = 2,
            ["Yanma"] = 2,
            ["Gallade"] = 2,
            ["Luxray"] = 3,
            ["Lucario"] = 2,
            ["Unown Legion"] = 6,
         }

         local function RemoveTeam(cid, t)
            if not isCreature(cid) then return true end
            if t ~= 1 then
               doSendMagicEffect(getThingPosWithDebug(cid), 211)
               doRemoveCreature(cid)
            else
               doRemoveCondition(cid, CONDITION_OUTFIT)
            end
         end

         local function sendEff(cid, master, t)
            if isCreature(cid) and isCreature(master) and t > 0 and #getCreatureSummons(master) >= 2 then
               doSendMagicEffect(getThingPosWithDebug(cid), 86, master)
               addEvent(sendEff, 1000, cid, master, t-1)                        --alterado v1.9
            end
         end

         if getPlayerStorageValue(cid, 637500) >= 1 then
            return true
         end

         local master = getCreatureMaster(cid)
         local item = getPlayerSlotItem(master, 8)
         local life, maxLife = getCreatureHealth(cid), getCreatureMaxHealth(cid)
         local name = doCorrectString(getCreatureName(cid))
         local pos = getThingPosWithDebug(cid)
         local time = 12

         doItemSetAttribute(item.uid, "hp", (life/maxLife))

         local num = name:find("Rotom") and 2 or team[name]
         local pk = {}
         local function doCreatureAddHealthWithSecurity(cid, heal)
            if not isCreature(cid) then return true end
            doCreatureAddHealth(cid, heal)
         end
         local function setStorage(cid)
            if not isCreature(cid) then return true end
            setPlayerStorageValue(cid, 63012, 1)
            addEvent(setStorage, 1000, cid)
         end
         --doTeleportThing(cid, {x=4, y=3, z=10}, false)

         if team[name] or name:find("Rotom") then
            pk[1] = cid
            for b = 2, num do
               local nick = nil
               if getItemAttribute(item.uid, "nick") then
                  nick = getItemAttribute(item.uid, "nick")
               end
               local pokeSourceCode = doCreateMonsterNick(master, name, nick ~= nil and nick or retireShinyName(name), getThingPos(master), true)

               if pokeSourceCode == "Nao" then
                  doSendMsg(master, "Não há espaço para seu pokemon.")
                  return true
               end

               pk[b] = getCreatureSummons(master)[b]
               if isMega(cid) then
                  doSetCreatureOutfit(pk[b], {lookType = 2051}, -1) -- mega lucario
               end
               if getCreatureName(cid) == "Unown Legion" then
                  local unowns = {}
                  while #unowns < 6 do
                     local r = math.random(961,966)
                     if not isInArray(unowns, r) then
                        table.insert(unowns, r)
                     end
                  end
                  for i,v in pairs(pk) do
                     doSetCreatureOutfit(v, {lookType = unowns[i]}, -1)
                     setPlayerStorageValue(v, 17230, unowns[i])
                     setPlayerStorageValue(v, 17231, os.time()+time)
                  end
               end
               setPlayerStorageValue(pk[b], 510, name)
               setStorage(pk[b])
               adjustStatus(pk[b], getPlayerSlotItem(master, 8).uid, true, true, true, true)
               doCreatureAddHealthWithSecurity(pk[b], -(maxLife-life))
            end

            for a = 1, num do
               addEvent(doTeleportThing, math.random(0, 5), pk[a], getClosestFreeTile(pk[a], pos), false)
               --addEvent(doAdjustWithDelay, 5, master, pk[a], true, true, true)
               doSendMagicEffect(getThingPosWithDebug(pk[a]), 211)
               setPlayerStorageValue(pk[2], 637500, 1)
               doCreatureSetSkullType(pk[a], getCreatureSkullType(pk[1]))
               addEvent(RemoveTeam, time * 1000, pk[a], a)
            end
            sendEff(cid, master, time)     --alterado v1.9
            setPlayerStorageValue(master, 637501, 1)
            addEvent(setPlayerStorageValue, time * 1000, master, 637501, -2)
         end

		

      elseif spell == "Team Slice" or spell == "Team Claw" or spell == "Volt Fang" or spell == "Unown Strike" then

         local master = getCreatureMaster(cid)
         if #getCreatureSummons(master) < 2 or not isCreature(target) then return true end

         local summons = getCreatureSummons(master)
         local posis = {[1] = pos1, [2] = pos2, [3] = pos3, [4] = pos4}

         if getSubName(cid, target) == "Scyther" or getSubName(cid, target) == "Shiny Scyther" then  --alterado v1.6.1
            eff = 0
         elseif getSubName(cid, target) == "Luxray" then  --alterado v1.6.1
            eff = 70
         elseif getSubName(cid, target) == "Unown Legion" then  --alterado v1.6.1
            eff = 17
         else
            eff = 42  --alterado v1.5
         end

         local function danoSafe(cid, target, min, max)
            if not isCreature(cid) or not isCreature(target) then return true end
            doDanoInTarget(cid, target, spell == "Volt Fang" and ELECTRICDAMAGE or spell == "Unown Strike" and psyDmg or BUGDAMAGE, -min, -max, 0) --alterado v1.7
         end

         if #getCreatureSummons(master) >= 2 and isCreature(target) then
            if isCreature(cid) then
               addEvent(danoSafe, 500, cid, target, min, max) --alterado v1.7
               for i = 1, #summons do
                  posis[i] = getThingPosWithDebug(summons[i])
                  doDisapear(summons[i])
                  stopNow(summons[i], 670)
                  addEvent(doSendMagicEffect, 300, posis[i], 211)
                  addEvent(doSendDistanceShoot, 350, posis[i], getThingPosWithDebug(target), eff)
                  addEvent(doSendDistanceShoot, 450, getThingPosWithDebug(target), posis[i], eff)
                  addEvent(doSendDistanceShoot, 600, posis[i], getThingPosWithDebug(target), eff)
                  addEvent(doSendDistanceShoot, 650, getThingPosWithDebug(target), posis[i], eff)
                  addEvent(doAppear, 670, summons[i])
               end
            end
         end

      elseif spell == "Blizzard" then
         local master = isSummon(cid) and getCreatureMaster(cid) or cid
         local ret = {}
         ret.id = 0
         ret.attacker = cid
         ret.cd = 9
         ret.eff = 43
         ret.check = 0
         ret.first = true
         ret.cond = "Slow"
		 

         local function doFall(cid)
            for rocks = 1, 42 do
               addEvent(fall, rocks * 35, cid, master, ICEDAMAGE, 28, 52)
            end
         end

         for up = 1, 10 do
            addEvent(upEffect, up * 75, cid, 28)
         end --alterado v1.4
         addEvent(doFall, 450, cid)
         addEvent(doMoveInArea2, 1400, cid, 1392, BigArea2, ICEDAMAGE, min, max, spell, ret)

	  elseif spell == "Heal Block" then
		doSendMagicEffect(getThingPos(target), 570)
		setPlayerStorageValue(target, STORAGE_HEALBLOCK, 1)
		
	  elseif spell == "Guard Split" then
		doSendMagicEffect(getThingPosWithDebug(cid), 571)
		doSendMagicEffect(getThingPos(target), 571)
		local nick = doCorrectString(getCreatureName(target))
		setPlayerStorageValue(cid, 1002, pokes[nick].defense)
		
      elseif spell == "Meteor Mash" then
         local pos = getThingPosWithDebug(cid)
         pos.x = pos.x + 1
         pos.y = pos.y + 1
         doSendMagicEffect(pos, 473)
         doDanoWithProtect(cid, STEELDAMAGE, getThingPosWithDebug(cid), meteorMash1, -min, -max, 258)
         doDanoWithProtect(cid, STEELDAMAGE, getThingPosWithDebug(cid), meteorMash2, -min, -max, 9)


      elseif spell == "Draining Kiss" then
		
         local master = getCreatureMaster(cid) or 0
         local ret = {}
         ret.id = 0
         ret.attacker = cid
         ret.cd = 4
         ret.eff = 147
         ret.check = 0
         ret.spell = spell
         ret.cond = "Slow"
		 addEvent(doMoveInArea2, 800, cid, 1392, BigArea2, FAIRYDAMAGE, 0, 0, spell, ret)

         local pos = getThingPosWithDebug(cid)
         pos.x = pos.x + 1
         pos.y = pos.y
         doSendMagicEffect(pos, 797)

         for rocks = 1, 40 do
            addEvent(fall, rocks * 55, cid, master, FAIRYDAMAGE, -1, 147)
         end

         addEvent(doMoveAreaWithSteal, 800, cid, BigArea2, FAIRYDAMAGE, spell, min, max, 1392)
         addEvent(doMoveInArea2, 800, cid, 1392, BigArea2, FAIRYDAMAGE, 0, 0, spell, ret)

      elseif spell == "Great Love" or spell == "Heart Stamp" then
         local typed = spell == "Heart Stamp" and PSYCHICDAMAGE or FAIRYDAMAGE
         local master = getCreatureMaster(cid) or 0
         local ret = {}
         ret.id = 0
         ret.attacker = cid
         ret.cd = 10
         -- ret.eff = spell == "Heart Stamp" and 511 or 431
         ret.check = 0
         ret.spell = spell
         ret.cond = "Confusion"

         for rocks = 1, 40 do
            addEvent(fall, 500 + rocks * 55, cid, master, typed, -1, spell == "Heart Stamp" and 511 or 147)
         end

         if spell == "Great Love" then
            local effpos = getThingPosWithDebug(cid)
            effpos.x = effpos.x + 1
            effpos.y = effpos.y + 1
            doSendMagicEffect(effpos, 656)
         end

         addEvent(doMoveInArea2, 1200, cid, -1, BigArea2, typed, min, max, spell, ret)

      elseif spell == "Fire Punch" then
         doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 39)
         -- doSendMagicEffect(getThingPosWithDebug(target), 451)
         doDanoInTargetWithDelay(cid, target, FIREDAMAGE, min, max, 113) --alterado v1.7

      elseif spell == "Guillotine" then

         doDanoWithProtect(cid, NORMALDAMAGE, getThingPosWithDebug(target), 0, -min, -max, 146)

      elseif spell == "Hyper Beam" then --alterado v1.7 \/
         local myPos = getThingPosWithDebug(cid)
         local myDirection = getCreatureDirectionToTarget(cid, target)
         local info = {
            [0] = {422, cannon3N, {x = myPos.x + 1, y = myPos.y - 1, z = myPos.z}},
            [1] = {423, cannon3E, {x = myPos.x + 6, y = myPos.y + 1, z = myPos.z}},
            [2] = {422, cannon3S, {x = myPos.x + 1, y = myPos.y + 6, z = myPos.z}},
            [3] = {423, cannon3W, {x = myPos.x - 2, y = myPos.y + 1, z = myPos.z}}
         }
         doSendMagicEffect(info[myDirection][3], info[myDirection][1])
         doAreaCombatHealth(cid, NORMALDAMAGE, myPos, info[myDirection][2], -min, -max, -1)
      elseif spell == "Flash Cannon" then
         local myPos = getThingPosWithDebug(cid)
         local myDirection = getCreatureDirectionToTarget(cid, target)
         local info = {
            [0] = {430, cannon3N, {x = myPos.x + 1, y = myPos.y - 1, z = myPos.z}},
            [1] = {431, cannon3E, {x = myPos.x + 6, y = myPos.y + 1, z = myPos.z}},
            [2] = {430, cannon3S, {x = myPos.x + 1, y = myPos.y + 6, z = myPos.z}},
            [3] = {431, cannon3W, {x = myPos.x - 1, y = myPos.y + 1, z = myPos.z}}
         }
         doSendMagicEffect(info[myDirection][3], info[myDirection][1])
         doAreaCombatHealth(cid, STEELDAMAGE, myPos, info[myDirection][2], -min, -max, -1)

      elseif spell == "Acrobatics" then
         local a = isCreature(target) and getCreatureDirectionToTarget(cid, target) or getCreatureLookDir(cid)
         local p = getThingPosWithDebug(cid)
         local t = {
            [2] = {595, {x = p.x + 1, y = p.y - 1, z = p.z}, 0, -5},
            [3] = {594, {x = p.x + 5, y = p.y, z = p.z}, 5, 0},
            [0] = {596, {x = p.x + 1, y = p.y + 5, z = p.z}, 0, 5},
            [1] = {593, {x = p.x - 1, y = p.y, z = p.z}, -5, 0}
         }

         local function doTeleportMe(cid, pos)
            if not isCreature(cid) then
               return true
            end
            if canWalkOnPos(pos, false, true, true, true, true) then
               local tournarea = {{x = 127, y = 820, z = 6}, {x = 135, y = 828, z = 6}}
               if
               not (not isInArea(pos, tournarea[1], tournarea[2]) and
               isInArea(getThingPosWithDebug(cid), tournarea[1], tournarea[2]))
               then
                  doTeleportThing(cid, pos)
               end
            end
            doAppear(cid)

            if isMega(cid) then
               if getPlayerStorageValue(cid, storages.isMega) == "Mega Ampharos" then
                  doPantinOutfit(cid, 0, getPlayerStorageValue(cid, storages.isMega))
               else
                  if getPlayerStorageValue(cid, 625877) > 0 then
                     doSetCreatureOutfit(cid, {lookType = getPlayerStorageValue(cid, 625877)}, -1) -- iron defense
                  else
                     doSetCreatureOutfit(
                     cid,
                     {lookType = megasConf[getPlayerStorageValue(cid, storages.isMega)].out},
                     -1
                     )
                     checkOutfitMega(cid, getPlayerStorageValue(cid, storages.isMega))
                  end
               end
            end
         end

         doMoveInArea2(cid, -1, check, FIGHTINGDAMAGE, 0, 0, spell)
         doSendMagicEffect(t[a][2], t[a][1])
         -- local pos = getThingPosWithDebug(cid)
         -- doSendMagicEffect(pos, 307)
         doDisapear(cid)
         local tox, toy = t[a][3], t[a][4]
         local tournarea = {{x = 127, y = 820, z = 6}, {x = 135, y = 828, z = 6}}
         if tox ~= 0 then
            if tox > 0 then
               for xt = 0, tox do
                  local x = tox - xt
                  local pos = getThingPosWithDebug(cid)
                  pos.x = pos.x + x
                  if canWalkOnPos(pos, false, true, true, true, true) then
                     if
                     not (not isInArea(pos, tournarea[1], tournarea[2]) and
                     isInArea(getThingPosWithDebug(cid), tournarea[1], tournarea[2]))
                     then
                        return addEvent(doTeleportMe, 1000, cid, pos)
                     end
                  end
               end
            else
               for x = tox, 0 do
                  local pos = getThingPosWithDebug(cid)
                  pos.x = pos.x + x
                  if canWalkOnPos(pos, false, true, true, true, true) then
                     if
                     not (not isInArea(pos, tournarea[1], tournarea[2]) and
                     isInArea(getThingPosWithDebug(cid), tournarea[1], tournarea[2]))
                     then
                        return addEvent(doTeleportMe, 1000, cid, pos)
                     end
                  end
               end
            end
         elseif toy ~= 0 then
            if toy > 0 then
               for yt = 0, toy do
                  local y = toy - yt
                  local pos = getThingPosWithDebug(cid)
                  pos.y = pos.y + y
                  if canWalkOnPos(pos, false, true, true, true, true) then
                     if
                     not (not isInArea(pos, tournarea[1], tournarea[2]) and
                     isInArea(getThingPosWithDebug(cid), tournarea[1], tournarea[2]))
                     then
                        return addEvent(doTeleportMe, 1000, cid, pos)
                     end
                  end
               end
            else
               for y = toy, 0 do
                  local pos = getThingPosWithDebug(cid)
                  pos.y = pos.y + y
                  if canWalkOnPos(pos, false, true, true, true, true) then
                     if
                     not (not isInArea(pos, tournarea[1], tournarea[2]) and
                     isInArea(getThingPosWithDebug(cid), tournarea[1], tournarea[2]))
                     then
                        return addEvent(doTeleportMe, 1000, cid, pos)
                     end
                  end
               end
            end
         end

      elseif spell == "Aqua Jet" or spell == "Mach Punch" or (spell == "Steel Wing" and getCreatureName(cid) == "Skarmory") then
         local times = 4
         local speed = spell == "Steel Wing" and 250 or 450
         local a = isCreature(target) and getCreatureDirectionToTarget(cid, target) or getCreatureLookDir(cid)
         local p = getThingPosWithDebug(cid)
         -- doSendMagicEffect(p, 307)

         local function moveJet(cid, dir, spell)
            local p = getThingPosWithDebug(cid)
            local t = {
               ["Aqua Jet"] = { 
                  [0] = {519, {x = p.x, y = p.y - 1, z = p.z}, 0, -1},
                  [1] = {517, {x = p.x + 1, y = p.y + 1, z = p.z}, 1, 0},
                  [2] = {518, {x = p.x, y = p.y + 1, z = p.z}, 0, 1},
                  [3] = {520, {x = p.x - 1, y = p.y + 1, z = p.z}, -1, 0}
               },
               ["Steel Wing"] = {
                  [0] = {884, {x = p.x, y = p.y - 1, z = p.z}, 0, -1},
                  [1] = {882, {x = p.x + 1, y = p.y, z = p.z}, 1, 0},
                  [2] = {881, {x = p.x, y = p.y + 1, z = p.z}, 0, 1},
                  [3] = {883, {x = p.x - 1, y = p.y, z = p.z}, -1, 0}
               },
               ["Mach Punch"] = {
                  [0] = {597, {x = p.x, y = p.y - 1, z = p.z}, 0, -1},
                  [1] = {600, {x = p.x + 1, y = p.y + 1, z = p.z}, 1, 0},
                  [2] = {598, {x = p.x, y = p.y + 1, z = p.z}, 0, 1},
                  [3] = {599, {x = p.x - 1, y = p.y + 1, z = p.z}, -1, 0}
               }
            }

            if not isCreature(cid) then
               return true
            end
            doDisapear(cid)
            local dmgType = {["Aqua Jet"] = WATERDAMAGE, ["Mach Punch"] = FIGHTINGDAMAGE, ["Steel Wing"] = STEELDAMAGE}
            doMoveInArea2(cid, -1, wingatk, dmgType[spell], min, max, spell)
            doSendMagicEffect(t[spell][dir][2], t[spell][dir][1])
            local pos = {x = p.x + t[spell][dir][3], y = p.y + t[spell][dir][4], z = p.z}
            if canWalkOnPos(pos, false, true, true, true, true) then
               local tournarea = {{x = 127, y = 820, z = 6}, {x = 135, y = 828, z = 6}}
               if
               not (not isInArea(pos, tournarea[1], tournarea[2]) and
               isInArea(getThingPosWithDebug(cid), tournarea[1], tournarea[2]))
               then
                  doTeleportThing(cid, pos)
               end
            end
         end

         stopNow(cid, times * speed)
         doDisapear(cid)
         for x = 0, times do
            addEvent(moveJet, speed * x, cid, a, spell)
            addEvent(doAppear, (times * speed) + 200, cid)
         end

      elseif spell == "Fly" then
         local function doSendMove(cid, turn)
            if not isCreature(cid) then
               return true
            end
            local turn = turn or 1
            local event = addEvent(doSendMove, 500, cid, turn + 1)
            local outfit = {4729, 4730, 4731, 4732, 4733, 4734, 4735, 4736}
            doSetCreatureOutfit(cid, {lookType = outfit[turn]}, -1)
            if turn == 9 or isSleeping(cid) then
               stopEvent(event)
               doRemoveCondition(cid, CONDITION_OUTFIT)
            end
         end
         local pos = getThingPosWithDebug(cid)
         pos.x = pos.x + 2
         addEvent(doSendMagicEffect, 3800, pos, 1390)
         -- addEvent(doAreaCombatHealth, 3800, cid, FLYINGDAMAGE, getThingPosWithDebug(cid), BigArea2New, -min, -max, -1)
         doSendMove(cid)
         -- local master = getCreatureMaster(cid)
         -- local sid = getCreatureSummons(master)
         doAreaCombatHealth(cid, FLYINGDAMAGE, getThingPosWithDebug(cid), BigArea2New, -min, -max, -1)

      elseif spell == "Teeter Dance" then
         local ret = {}
         ret.id = target
         ret.attacker = cid
         ret.cd = 6
         ret.check = getPlayerStorageValue(target, conds["Confusion"])
         ret.cond = "Confusion"
         local function doSendMove(cid, turn)
            if not isCreature(cid) then
               return true
            end

            local turn = turn or 1
            local event = addEvent(doSendMove, 300, cid, turn + 1)
            local area1 = {toxic1, toxic2, toxic3, toxic4, toxic5, toxic1, toxic2, toxic3, toxic4, toxic5, toxic1, toxic2, toxic3, toxic4, toxic5}
            local eff = {22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22}
            doMoveInArea2(cid, eff[turn], area1[turn], PSYCHICDAMAGE, min, max, spell, ret)
            -- doAreaCombatHealth(cid, PSYCHICDAMAGE, getThingPosWithDebug(cid), area1[turn], -min, -max, eff[turn])
            if turn == 15 or isSleeping(cid) then
               stopEvent(event)
               -- print(event)
            end
         end
         doSendMove(cid)

      elseif spell == "Dragon Mist" or spell == "Steel Wing" or spell == "Shadow Sneak" or spell == "Flash Kick" then
         -- elseif spell ==  "Signal Beam" then  --alterado v1.7 \/
         -- local ret = {}
         -- ret.id = 0
         -- ret.attacker = cid
         -- ret.cd = 9
         -- ret.eff = 86
         -- ret.check = 0
         -- ret.spell = spell
         -- ret.cond = "Stun"
         -- local a = isCreature(target) and getCreatureDirectionToTarget(cid, target) or getCreatureLookDir(cid)
         -- local t = {
         -- [0] = 58,       --alterado v1.6
         -- [1] = 56,
         -- [2] = 58,
         -- [3] = 56,
         -- }
         -- doMoveInArea2(cid, t[a], reto4, BUGDAMAGE, 0, 0, spell, ret)
         -- doMoveInArea2(cid, 86, reto444, BUGDAMAGE, min, max, spell, ret)
         local a = isCreature(target) and getCreatureDirectionToTarget(cid, target) or getCreatureLookDir(cid)
         local p = getThingPosWithDebug(cid)
         local t = {
            [0] = {364, {x = p.x + 1, y = p.y - 1, z = p.z}, 0, -5},
            [1] = {361, {x = p.x + 5, y = p.y + 1, z = p.z}, 5, 0},
            [2] = {363, {x = p.x + 1, y = p.y + 5, z = p.z}, 0, 5},
            [3] = {362, {x = p.x - 1, y = p.y + 1, z = p.z}, -5, 0}
         }
         dmgType = DRAGONDAMAGE

         if spell == "Steel Wing" then
            t = {
               [0] = {369, {x = p.x + 1, y = p.y - 1, z = p.z}, 0, -5},
               --446 = skarmory
               [1] = {367, {x = p.x + 5, y = p.y + 1, z = p.z}, 5, 0},
               [2] = {366, {x = p.x + 1, y = p.y + 5, z = p.z}, 0, 5},
               [3] = {368, {x = p.x - 1, y = p.y + 1, z = p.z}, -5, 0}
            }
            dmgType = STEELDAMAGE
         end

         if spell == "Flash Kick" then
            t = {
               [0] = {829, {x = p.x + 1, y = p.y - 1, z = p.z}, 0, -5},
               [1] = {827, {x = p.x + 5, y = p.y + 1, z = p.z}, 5, 0},
               [2] = {830, {x = p.x + 1, y = p.y + 5, z = p.z}, 0, 5},
               [3] = {828, {x = p.x - 1, y = p.y + 1, z = p.z}, -5, 0}
            }
            dmgType = FIGHTINGDAMAGE
         end

         if spell == "Aqua Jet" then
            t = {
               [0] = {299, {x = p.x + 1, y = p.y - 1, z = p.z}, 0, -5},
               [1] = {296, {x = p.x + 5, y = p.y + 1, z = p.z}, 5, 0},
               [2] = {298, {x = p.x + 1, y = p.y + 5, z = p.z}, 0, 5},
               [3] = {297, {x = p.x - 1, y = p.y + 1, z = p.z}, -5, 0}
            }
            dmgType = WATERDAMAGE
         end

         if spell == "Shadow Sneak" then
            t = {
               [0] = {550, {x = p.x + 1, y = p.y - 1, z = p.z}, 0, -5},
               [1] = {548, {x = p.x + 5, y = p.y + 1, z = p.z}, 5, 0},
               [2] = {551, {x = p.x + 1, y = p.y + 5, z = p.z}, 0, 5},
               [3] = {549, {x = p.x - 1, y = p.y + 1, z = p.z}, -5, 0}
            }
            dmgType = GHOSTDAMAGE
         end

         local function doTeleportMe(cid, pos)
            if not isCreature(cid) then
               return true
            end
            if canWalkOnPos(pos, false, true, true, true, true) then
               local tournarea = {{x = 127, y = 820, z = 6}, {x = 135, y = 828, z = 6}}
               if
               not (not isInArea(pos, tournarea[1], tournarea[2]) and
               isInArea(getThingPosWithDebug(cid), tournarea[1], tournarea[2]))
               then
                  doTeleportThing(cid, pos)
               end
            end
            doAppear(cid)

            if isMega(cid) then
               if getPlayerStorageValue(cid, storages.isMega) == "Mega Ampharos" then
                  doPantinOutfit(cid, 0, getPlayerStorageValue(cid, storages.isMega))
               else
                  if getPlayerStorageValue(cid, 625877) > 0 then
                     doSetCreatureOutfit(cid, {lookType = getPlayerStorageValue(cid, 625877)}, -1) -- iron defense
                  else
                     doSetCreatureOutfit(
                     cid,
                     {lookType = megasConf[getPlayerStorageValue(cid, storages.isMega)].out},
                     -1
                     )
                     checkOutfitMega(cid, getPlayerStorageValue(cid, storages.isMega))
                  end
               end
            end
         end

         doMoveInArea2(cid, -1, triplo6, dmgType, min, max, spell)
         doSendMagicEffect(t[a][2], t[a][1])
         -- local pos = getThingPosWithDebug(cid)
         -- doSendMagicEffect(pos, 307)
         doDisapear(cid)
         local tox, toy = t[a][3], t[a][4]
         local tournarea = {{x = 127, y = 820, z = 6}, {x = 135, y = 828, z = 6}}
         if tox ~= 0 then
            if tox > 0 then
               for xt = 0, tox do
                  local x = tox - xt
                  local pos = getThingPosWithDebug(cid)
                  pos.x = pos.x + x
                  if canWalkOnPos(pos, false, true, true, true, true) then
                     if
                     not (not isInArea(pos, tournarea[1], tournarea[2]) and
                     isInArea(getThingPosWithDebug(cid), tournarea[1], tournarea[2]))
                     then
                        return addEvent(doTeleportMe, 300, cid, pos)
                     end
                  end
               end
            else
               for x = tox, 0 do
                  local pos = getThingPosWithDebug(cid)
                  pos.x = pos.x + x
                  if canWalkOnPos(pos, false, true, true, true, true) then
                     if
                     not (not isInArea(pos, tournarea[1], tournarea[2]) and
                     isInArea(getThingPosWithDebug(cid), tournarea[1], tournarea[2]))
                     then
                        return addEvent(doTeleportMe, 300, cid, pos)
                     end
                  end
               end
            end
         elseif toy ~= 0 then
            if toy > 0 then
               for yt = 0, toy do
                  local y = toy - yt
                  local pos = getThingPosWithDebug(cid)
                  pos.y = pos.y + y
                  if canWalkOnPos(pos, false, true, true, true, true) then
                     if
                     not (not isInArea(pos, tournarea[1], tournarea[2]) and
                     isInArea(getThingPosWithDebug(cid), tournarea[1], tournarea[2]))
                     then
                        return addEvent(doTeleportMe, 300, cid, pos)
                     end
                  end
               end
            else
               for y = toy, 0 do
                  local pos = getThingPosWithDebug(cid)
                  pos.y = pos.y + y
                  if canWalkOnPos(pos, false, true, true, true, true) then
                     if
                     not (not isInArea(pos, tournarea[1], tournarea[2]) and
                     isInArea(getThingPosWithDebug(cid), tournarea[1], tournarea[2]))
                     then
                        return addEvent(doTeleportMe, 300, cid, pos)
                     end
                  end
               end
            end
         end

      elseif spell == "Flash Cannon" then
         local myPos = getThingPosWithDebug(cid)
         local myDirection = getCreatureDirectionToTarget(cid, target)
         local info = {
            [0] = {430, cannon3N, {x = myPos.x + 1, y = myPos.y - 1, z = myPos.z}},
            [1] = {431, cannon3E, {x = myPos.x + 6, y = myPos.y + 1, z = myPos.z}},
            [2] = {430, cannon3S, {x = myPos.x + 1, y = myPos.y + 6, z = myPos.z}},
            [3] = {431, cannon3W, {x = myPos.x - 1, y = myPos.y + 1, z = myPos.z}}
         }
         doSendMagicEffect(info[myDirection][3], info[myDirection][1])
         doAreaCombatHealth(cid, STEELDAMAGE, myPos, info[myDirection][2], -min, -max, -1)

	elseif spell == "Thrash" then
		local myPos = getThingPosWithDebug(cid)
		doFrontalCombatHealth(cid, myPos, NORMALDAMAGE, min, max, 111, 10)
	elseif spell == "Splash" then

         doAreaCombatHealth(cid, WATERDAMAGE, getThingPosWithDebug(cid), splash, -min, -max, 1392)
         doSendMagicEffect(getThingPosWithDebug(cid), 53)

      elseif spell == "Dragon Breath" then

         doMoveInArea2(cid, 143, db2, DRAGONDAMAGE, min, max, spell)
		 
	elseif spell == "Muddy Water" then
        local function doSendMove(cid, turn)
            if not isCreature(cid) then
                return true
            end
            local turn = turn or 1
            local event = addEvent(doSendMove, 50, cid, turn + 1)
        local myPos = getThingPosWithDebug(cid)
        local pos = {x = myPos.x + math.random(-4, 4), y = myPos.y + math.random(-4, 4), z = myPos.z}
        if getThingFromPos(pos).itemid ~= 0 then
            doSendMagicEffect(pos, 440)
        end
            if turn == 21 or isSleeping(cid) then
                stopEvent(event)
            end
        end
        doSendMove(cid)
		addEvent(doAreaCombatHealth, 1000, cid, GROUNDDAMAGE, myPos, square4x4, -min, -max, 1392)

      elseif spell == "Grassy Terrain" then

         local ret = {}
         ret.id = 0
         ret.attacker = cid
         ret.check = 0
         ret.cd = math.random(4, 6)
         ret.cond = "Sleep"
         ret.eff = 512

         doMoveInArea2(cid, 512, selfArea1, GRASSDAMAGE, min, max, spell, ret)

      elseif spell == "Bamboo Spikes" then

         doMoveInArea2(cid, 512, muddy, GRASSDAMAGE, min, max, spell, ret)

      elseif spell == "Venom Motion" then

         local ret = {}
         ret.id = 0
         ret.attacker = cid
         ret.cd = 9
         ret.eff = 34
         ret.check = 0
         ret.spell = spell
         ret.cond = "Miss"

         doMoveInArea2(cid, 114, muddy, POISONDAMAGE, min, max, spell, ret)

      elseif spell == "Thunder Fang" or spell == "Lightning Axe" then

         local ret = {}
         ret.id = target
         ret.attacker = cid
         ret.cd = 9
         ret.eff = 48
         ret.check = 0
         ret.spell = spell
         ret.cond = "Slow"

         -- doSendMagicEffect(getThingPosWithDebug(target), 115)
         local pos = getThingPosWithDebug(target)
         pos.x = pos.x + 1
         pos.y = pos.y + 1
         doSendMagicEffect(pos, 662)
         doMoveDano2(cid, target, ELECTRICDAMAGE, -min, -max, ret, spell)


      elseif spell == "Zap Cannon" then
         local info = {
            [0] = {73, missile6N, {x = myPos.x, y = myPos.y - 1, z = myPos.z}},
            [1] = {74, missile6E, {x = myPos.x + 6, y = myPos.y, z = myPos.z}},
            [2] = {75, missile6S, {x = myPos.x, y = myPos.y + 6, z = myPos.z}},
            [3] = {76, missile6W, {x = myPos.x - 1, y = myPos.y, z = myPos.z}}
         }
         doSendMagicEffect(info[myDirection][3], info[myDirection][1])
         doAreaCombatHealth(cid, ELECTRICDAMAGE, myPos, info[myDirection][2], -min, -max, 1392)

      elseif spell == "Charge Beam" then

         local a = isCreature(target) and getCreatureDirectionToTarget(cid, target) or getCreatureLookDir(cid)
         local p = getThingPosWithDebug(cid)
         local t = {
            [0] = {73, {x=p.x, y=p.y-1, z=p.z}},
            [1] = {74, {x=p.x+6, y=p.y, z=p.z}},      --alterado v1.8
            [2] = {75, {x=p.x, y=p.y+6, z=p.z}},
            [3] = {76, {x=p.x-1, y=p.y, z=p.z}},
         }

         doMoveInArea2(cid, 0, triplo6, ELECTRICDAMAGE, min, max, spell)
         doSendMagicEffect(t[a][2], t[a][1])

      elseif spell == "Sacred Fire" then

         doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 3)
         doDanoWithProtectWithDelay(cid, target, SACREDDAMAGE, min, max, 143, sacred)    --alterado v1.6

      elseif spell == "Cross Chop" then

         doMoveInArea2(cid, 118, blaze, FIGHTINGDAMAGE, min, max, spell)
         addEvent(doMoveInArea2, 200, cid, 118, kick, FIGHTINGDAMAGE, min, max, spell)

      -- elseif spell == "Overheat" then

         -- doMoveInArea2(cid, 5, reto5, FIREDAMAGE, min, max, spell)
		 
		elseif spell == "Overheat" then
         local info = {
            [0] = {1402, missile4N, {x = myPos.x, y = myPos.y - 1, z = myPos.z}},
            [1] = {1404, missile4E, {x = myPos.x + 6, y = myPos.y, z = myPos.z}},
            [2] = {1405, missile4S, {x = myPos.x + 1, y = myPos.y + 5, z = myPos.z}},
            [3] = {1403, missile4W, {x = myPos.x - 1, y = myPos.y, z = myPos.z}}
         }
         doSendMagicEffect(info[myDirection][3], info[myDirection][1])
         doAreaCombatHealth(cid, FIREDAMAGE, myPos, info[myDirection][2], -min, -max, 1392)

		elseif spell == "Ancient Power" then

         local p = getThingPosWithDebug(cid)
         local d = isCreature(target) and getCreatureDirectionToTarget(cid, target) or getCreatureLookDir(cid)

         function sendAtk(cid, area, eff)
            if isCreature(cid) then
               if not isSightClear(p, area, false) then return true end
               doAreaCombatHealth(cid, ROCKDAMAGE, area, 0, 0, 0, eff)
               doAreaCombatHealth(cid, ROCKDAMAGE, area, whirl3, -min, -max, 137)
            end
         end

         for a = 0, 4 do

            local t = {
               [0] = {18, {x=p.x, y=p.y-(a+1), z=p.z}},           --alterado v1.4
               [1] = {18, {x=p.x+(a+1), y=p.y, z=p.z}},
               [2] = {18, {x=p.x, y=p.y+(a+1), z=p.z}},
               [3] = {18, {x=p.x-(a+1), y=p.y, z=p.z}}
            }
            addEvent(sendAtk, 300*a, cid, t[d][2], t[d][1])
         end

      elseif spell == "Twister" then
	  	local myPos = getThingPosWithDebug(cid)
		doFrontalCombatHealth(cid, myPos, DRAGONDAMAGE, min, max, 42, 28)

      elseif spell == "Multi-Kick" or spell == "High Jump Kick" then
	  	local myPos = getThingPosWithDebug(cid)
		doFrontalCombatHealth(cid, myPos, DRAGONDAMAGE, min, max, 113, 39)
    elseif spell == "Sky Uppercut" then
        local function sendEffect(cid)
            if not isCreature(cid) then
                return true
            end
            local pos = getThingPosWithDebug(cid)
            local lado = isCreature(target) and getCreatureDirectionToTarget(cid, target) or getCreatureLookDir(cid)
            local effes = {
                [0] = {effe1 = 489, effe2 = 635},
                [1] = {effe1 = 491, effe2 = 633},
                [2] = {effe1 = 490, effe2 = 636},
                [3] = {effe1 = 488, effe2 = 634}
            }
            if lado == 0 then
                local pos2 = pos
                pos2.y = pos2.y - 2
                pos2.x = pos2.x + 1
                doSendMagicEffect(pos2, effes[lado].effe1)
                pos.y = pos.y
                pos.x = pos.x + 1
            elseif lado == 1 then
                local pos2 = pos
                pos2.x = pos2.x + 3
                pos2.y = pos2.y + 1
                doSendMagicEffect(pos, effes[lado].effe1)
                pos.y = pos.y + 1
                pos.x = pos.x
            elseif lado == 2 then
                local pos2 = pos
                pos2.y = pos2.y + 3
                pos2.x = pos2.x + 1
                doSendMagicEffect(pos2, effes[lado].effe1)
                pos.y = pos.y
                pos.x = pos.x + 1
            elseif lado == 3 then
                local pos2 = pos
                pos2.x = pos2.x - 2
                pos2.y = pos2.y + 1
                doSendMagicEffect(pos2, effes[lado].effe1)
                pos.y = pos.y
                pos.x = pos.x
            end
            doSendMagicEffect(pos, effes[lado].effe2)
            doMoveInArea2(cid, -1, flamek, FIGHTINGDAMAGE, min, max, spell, ret)
        end
        sendEffect(cid)

      elseif spell == "Vacuum Wave" then
        local p = getThingPosWithDebug(cid)
        local d = isCreature(target) and getCreatureDirectionToTarget(cid, target) or getCreatureLookDir(cid)

        function sendAtk(cid, area, areaEff, eff)
            if isCreature(cid) then
                if not isSightClear(p, area, false) then
                    return true
                end
                doAreaCombatHealth(cid, GROUNDDAMAGE, areaEff, 0, 0, 0, eff)
                doAreaCombatHealth(cid, GROUNDDAMAGE, area, whirl3, -min, -max, 1392)
            end
        end

        for a = 0, 5 do
            local t = {
                [0] = {635, {x = p.x, y = p.y - (a + 1), z = p.z}, {x = p.x + 2, y = p.y - (a + 1), z = p.z}},
                [1] = {633, {x = p.x + (a + 1), y = p.y, z = p.z}, {x = p.x + (a + 1), y = p.y + 2, z = p.z}},
                [2] = {636, {x = p.x, y = p.y + (a + 1), z = p.z}, {x = p.x + 2, y = p.y + (a + 1), z = p.z}},
                [3] = {634, {x = p.x - (a + 1), y = p.y, z = p.z}, {x = p.x - (a + 1), y = p.y + 1, z = p.z}}
            }
            addEvent(sendAtk, 325 * a, cid, t[d][2], t[d][3], t[d][1])
        end

      elseif spell == "Hi Jump Kick" then

         doMoveInAreaMulti(cid, 39, 113, multi, multiDano, FIGHTINGDAMAGE, min, max)

      elseif spell == "Multi-Punch" then

         doMoveInAreaMulti(cid, 39, 112, multi, multiDano, FIGHTINGDAMAGE, min, max)

      elseif spell == "Squisky Licking" then

         -- local ret = {}
         -- ret.id = 0
         -- ret.attacker = cid
         -- ret.cd = 9
         -- ret.check = 0
         -- ret.eff = 0
         -- ret.spell = spell
         -- ret.cond = "Stun"

         -- local areas = {SL1, SL2, SL3, SL4}

         -- for i = 0, 3 do
            -- addEvent(doMoveInArea2, i*200, cid, 145, areas[i+1], NORMALDAMAGE, min, max, spell, ret)
         -- end

      elseif spell == "Lick" then
	  	local target = target or isCreature(getMasterTarget(cid)) and getMasterTarget(cid) or 0
		local targetPos = isCreature(target) and getThingPos(target) or nil
		local myPos = isCreature(cid) and getThingPos(cid) or nil
		-- doSendDistanceShoot(myPos, targetPos, 6)
		doTargetCombatHealth(cid, target, GROUNDDAMAGE, -min, -max, 145)
		doTargetCombatHealth(cid, target, STATUS_STUN7, -145, -145, 1392)
         -- local ret = {}
         -- ret.id = target
         -- ret.attacker = cid
         -- ret.cd = 9
         -- ret.check = getPlayerStorageValue(target, conds["Stun"])
         -- ret.eff = 0
         -- ret.spell = spell
         -- ret.cond = "Stun"

         -- doSendMagicEffect(getThingPosWithDebug(target), 145)      --alterado v1.4!
         -- addEvent(doMoveDano2, 100, cid, target, NORMALDAMAGE, 0, 0, ret, spell)

      elseif spell == "Bonemerang" then

         doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 7)
         doDanoInTargetWithDelay(cid, target, GROUNDDAMAGE, min, max, 227)  --alterado v1.7
         addEvent(doSendDistanceShoot, 250, getThingPosWithDebug(target), getThingPosWithDebug(cid), 7)

      elseif spell == "Bone Club" then

         doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 7)
         doDanoInTargetWithDelay(cid, target, GROUNDDAMAGE, min, max, 118)  --alterado v1.7

      elseif spell == "Bone Slash" then

         local function sendStickEff(cid, dir)
            if not isCreature(cid) then return true end
            doAreaCombatHealth(cid, GROUNDDAMAGE, getPosByDir(getThingPosWithDebug(cid), dir), 0, -min, -max, 117)
         end

         local function doStick(cid)
            if not isCreature(cid) then return true end
            local t = {
               [1] = SOUTHWEST,
               [2] = SOUTH,
               [3] = SOUTHEAST,
               [4] = EAST,
               [5] = NORTHEAST,
               [6] = NORTH,
               [7] = NORTHWEST,
               [8] = WEST,
               [9] = SOUTHWEST,
            }
            for a = 1, 9 do
               addEvent(sendStickEff, a * 140, cid, t[a])
            end
         end

         doStick(cid, false, cid)
         --alterado v1.4
      elseif spell == "Furious Legs" or spell == "Ultimate Champion" or spell == "Fighter Spirit" then

         local ret = {}
         ret.id = cid
         ret.cd = 15
         ret.eff = 13
         ret.check = 0
         ret.buff = spell
         ret.first = true

         doCondition2(ret)

      elseif spell == "Sludge Wave" then

         local p = getThingPosWithDebug(cid)
         local d = isCreature(target) and getCreatureDirectionToTarget(cid, target) or getCreatureLookDir(cid)

         local master = isSummon(cid) and getCreatureMaster(cid) or cid
         local ret = {}
         ret.id = 0
         ret.attacker = cid
         ret.cd = 9
         ret.eff = 34
         ret.check = 0
         ret.spell = spell
         ret.cond = "Miss"

         function sendAtk(cid, area, eff)
            if isCreature(cid) then
               if not isSightClear(p, area, false) then return true end
               doAreaCombatHealth(cid, POISONDAMAGE, area, 0, 0, 0, eff)
               doAreaCombatHealth(cid, POISONDAMAGE, area, whirl3, -min, -max, 114)
            end
         end

         for a = 0, 4 do

            local t = {
               [0] = {114, {x=p.x, y=p.y-(a+1), z=p.z}},           --alterado v1.4
               [1] = {114, {x=p.x+(a+1), y=p.y, z=p.z}},
               [2] = {114, {x=p.x, y=p.y+(a+1), z=p.z}},
               [3] = {114, {x=p.x-(a+1), y=p.y, z=p.z}}
            }
            addEvent(sendAtk, 300*a, cid, t[d][2], t[d][1])
         end

      elseif spell == "Sludge Rain" then
         local master = isSummon(cid) and getCreatureMaster(cid) or cid
         local ret = {}
         ret.id = 0
         ret.attacker = cid
         ret.cd = 9
         ret.eff = 34
         ret.check = 0
         ret.spell = spell
         ret.cond = "Miss"

         local function doFall(cid)
            for rocks = 1, 42 do
               addEvent(fall, rocks * 35, cid, master, POISONDAMAGE, 6, 116)
            end
         end

         for up = 1, 10 do
            addEvent(upEffect, up * 75, cid, 6)
         end

         addEvent(doFall, 450, cid)
         addEvent(doMoveInArea2, 1400, cid, 0, BigArea2, POISONDAMAGE, min, max, spell, ret)

      elseif spell == "Shadow Ball" then

         doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 18)

         local function doDamageWithDelay(cid, target)
            if not isCreature(cid) or not isCreature(target) then return true end
            if isSleeping(cid) then return false end
            if getPlayerStorageValue(cid, conds["Fear"]) >= 1 then return true end
            doAreaCombatHealth(cid, ghostDmg, getThingPosWithDebug(target), 0, -min, -max, 255)
            local pos = getThingPosWithDebug(target)
            pos.x = pos.x + 1
            doSendMagicEffect(pos, 140)
         end

         addEvent(doDamageWithDelay, 100, cid, target)

      elseif spell == "Shadow Punch" then

         local function doPunch(cid, target)
            if not isCreature(cid) or not isCreature(target) then return true end
            doAreaCombatHealth(cid, ghostDmg, getThingPosWithDebug(target), 0, -min, -max, 452)
         end

         addEvent(doPunch, 200, cid, target)

      elseif spell == "Brick Beak" then

         local ret = {}
         ret.id = 0
         ret.attacker = cid
         ret.cd = 5
         ret.eff = 88
         ret.check = 0
         ret.first = true
         ret.cond = "Sleep"

         local a = isCreature(target) and getCreatureDirectionToTarget(cid, target) or getCreatureLookDir(cid)
         local p = getThingPosWithDebug(cid)
         local t = {
            [0] = {90, {x=p.x+1, y=p.y-1, z=p.z}},
            [1] = {90, {x=p.x+2, y=p.y+1, z=p.z}},
            [2] = {90, {x=p.x+1, y=p.y+2, z=p.z}},
            [3] = {90, {x=p.x-1, y=p.y+1, z=p.z}},
         }

         doMoveInArea2(cid, 0, BrickBeak, FIGHTINGDAMAGE, min, max, spell, ret)
         doSendMagicEffect(t[a][2], t[a][1])


      elseif spell == "Shadow Storm" then
         -- addEvent(doMoveInArea2, 1400, cid, 2, BigArea2, GHOSTDAMAGE, min, max, spell)
         local master = isSummon(cid) and getCreatureMaster(cid) or cid

         local function doFall(cid)
            for rocks = 1, 42 do --62
               addEvent(fall, rocks * 35, cid, master, GHOSTDAMAGE, 18, 669)
            end
         end

         for up = 1, 10 do
            addEvent(upEffect, up * 75, cid, 18)
         end
         addEvent(doFall, 450, cid)
         local myPos = getThingPosWithDebug(cid)
         addEvent(doAreaCombatHealth, 1400, cid, GHOSTDAMAGE, myPos, square4x4, -min, -max, 1392)

      elseif spell == "Invisible" or spell == "Instant Teleportation" then

         doDisapear(cid)
         doSendMagicEffect(getThingPosWithDebug(cid), spell == "Invisible" and 134 or 211)
         if isMonster(cid) then
            local pos = getThingPosWithDebug(cid)                           --alterei!
            doTeleportThing(cid, {x=4, y=3, z=10}, false)
            doTeleportThing(cid, pos, false)
         end

         function doInvisCount(cid)
            if not isCreature(cid) then return true end
            if getCreatureMaster(cid) then sendOpcodeStatusInfo(getCreatureMaster(cid)) end
            if getPlayerStorageValue(cid, 17229) >= 1 then
               setPlayerStorageValue(cid, 17229, getPlayerStorageValue(cid, 17229) - 1)
               sendOpcodeStatusInfo(cid)
               return addEvent(doInvisCount,1000, cid)
            end
            return true
         end
	
         setPlayerStorageValue(cid, 17229, 5)
         doInvisCount(cid)
         addEvent(doAppear, 4000, cid)
      elseif spell == "Vanish" then

         doDisapear(cid)
         doSendMagicEffect(getThingPosWithDebug(cid), 134)
         if isMonster(cid) then
            local pos = getThingPosWithDebug(cid)                           --alterei!
            doTeleportThing(cid, {x=4, y=3, z=10}, false)
            doTeleportThing(cid, pos, false)
         end

         function doInvisCount(cid)
            if not isCreature(cid) then return true end
            if getCreatureMaster(cid) then sendOpcodeStatusInfo(getCreatureMaster(cid)) end
            if getPlayerStorageValue(cid, 17229) >= 1 then
               setPlayerStorageValue(cid, 17229, getPlayerStorageValue(cid, 17229) - 1)
               sendOpcodeStatusInfo(cid)
               return addEvent(doInvisCount,1000, cid)
            end
            return true
         end

         setPlayerStorageValue(cid, 17229, 5)
         doInvisCount(cid)
         addEvent(doAppear, 4000, cid)

      elseif spell == "Nightmare" then

         if not isSleeping(target) then
            doSendMagicEffect(getThingPosWithDebug(target), 3)
            doSendAnimatedText(getThingPosWithDebug(target), "FAIL", 155)
            return true
         end

         doDanoWithProtectWithDelay(cid, target, ghostDmg, -min, -max, 138)

      elseif spell == "Wake-Up Slap" then
         if isSleeping(target) then
            min = min * 2
            max = max * 2
         end

         doSendMagicEffect(
         {
            x = getThingPosWithDebug(target).x + 1,
            y = getThingPosWithDebug(target).y,
            z = getThingPosWithDebug(target).z
         },
         472
         )
         doMoveDano2(cid, target, FIGHTINGDAMAGE, -min, -max, ret, spell)

      elseif spell == "Dream Eater" then

         if not isSleeping(target) then
            doSendMagicEffect(getThingPosWithDebug(target), 3)
            doSendAnimatedText(getThingPosWithDebug(target), "FAIL", 155)
            return true
         end

         local function getCreatureHealthSecurity(cid)
            if not isCreature(cid) then return 0 end
            return getCreatureHealth(cid) or 0
         end
         local life = getCreatureHealthSecurity(target)

         doAreaCombatHealth(cid, psyDmg, getThingPosWithDebug(target), 0, -min, -max, 138)
         --doDanoWithProtectWithDelay(cid, target, psyDmg, -min, -max, 138)

         local newlife = life - getCreatureHealthSecurity(target)

         if newlife >= 1 then
            if isCreature(cid) then
               doCreatureAddHealth(cid, newlife)
            end
            doSendAnimatedText(getThingPosWithDebug(cid), "+"..newlife.."", 32)
         end	                                                          --alterado v1.6
         setPlayerStorageValue(cid, 95487, 1)
         doSendMagicEffect(getThingPosWithDebug(cid), 132)
         doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 39)

      elseif spell == "Dark Eye" or spell == "Miracle Eye" then

         doSendMagicEffect(getThingPosWithDebug(cid), 47)
         setPlayerStorageValue(cid, 999457, 1)

      elseif spell == "Elemental Hands" then

         if isSummon(cid) then
            if getCreatureOutfit(cid).lookType == 1301 then
               print("Error occurred with move 'Elemental Hands', outfit of hitmonchan is wrong")
               doPlayerSendTextMessage(getCreatureMaster(cid), MESSAGE_STATUS_CONSOLE_BLUE, "An error are ocurred... A msg is sent to gamemasters!")
               return true
            end        --proteçao pra n usar o move com o shiny hitmonchan com outfit diferente da do elite monchan do PO...

            local e = getCreatureMaster(cid)
            local name = getItemAttribute(getPlayerSlotItem(e, 8).uid, "poke")
            local hands = getItemAttribute(getPlayerSlotItem(e, 8).uid, "hands")
            if type(hands) ~= "number" then hands = 0 end
            if not hitmonchans[name] then return true end
            if not hitmonchans[name][hands] then return true end

            if hands == 4 then
               doItemSetAttribute(getPlayerSlotItem(e, 8).uid, "hands", 0)
               doSendMagicEffect(getThingPosWithDebug(cid), hitmonchans[name][0].eff)
               doSetCreatureOutfit(cid, {lookType = hitmonchans[name][0].out}, -1)
            else
               doItemSetAttribute(getPlayerSlotItem(e, 8).uid, "hands", hands+1)
               doSendMagicEffect(getThingPosWithDebug(cid), hitmonchans[name][hands+1].eff)
               doSetCreatureOutfit(cid, {lookType = hitmonchans[name][hands+1].out}, -1)
            end
         else
            if not getPlayerStorageValue(cid, 823413) then setPlayerStorageValue(cid, 823413, 0) end
            if getPlayerStorageValue(cid, 823413) < 0 then setPlayerStorageValue(cid, 823413, 0) end
            local name = getCreatureName(cid)
            local hands = getPlayerStorageValue(cid, 823413)
            if type(hands) ~= "number" then hands = 0 end
            if not hitmonchans[name] then return true end
            if not hitmonchans[name][hands] then return true end


            if hands == 4 then
               setPlayerStorageValue(cid, 823413, 0)
               doSendMagicEffect(getThingPosWithDebug(cid), hitmonchans[name][0].eff)
               doSetCreatureOutfit(cid, {lookType = hitmonchans[name][0].out}, -1)
            else
               setPlayerStorageValue(cid, 823413, getPlayerStorageValue(cid, 823413)+1)
               doSendMagicEffect(getThingPosWithDebug(cid), hitmonchans[name][hands+1].eff)
               doSetCreatureOutfit(cid, {lookType = hitmonchans[name][hands+1].out}, -1)
            end
         end

      elseif spell == "Crabhammer" then
         doDanoWithProtect(cid, WATERDAMAGE, getThingPosWithDebug(target), 0, -min, -max, 222)

      elseif spell == "Ancient Fury" then

         local ret = {}
         ret.id = cid
         ret.cd = 15
         ret.eff = 0
         ret.check = 0
         ret.buff = spell
         ret.first = true

         doCondition2(ret)

      elseif spell == "Divine Punishment" then
         local roardirections = {
            [NORTH] = {SOUTH},
            [SOUTH] = {NORTH},
            [WEST] = {EAST},
            [EAST] = {WEST}
         }

         local function divineBack(cid)
            if not isCreature(cid) then
               return true
            end
            local uid = checkAreaUid(getCreaturePosition(cid), check, 1, 1)
            for _, pid in pairs(uid) do
               dirrr = getCreatureDirectionToTarget(pid, cid)
               delay = getNextStepDelay(pid, 0)
               if
               isSummon(cid) and
               (isMonster(pid) or (isSummon(pid) and canAttackOther(cid, pid) == "Can") or
               (isPlayer(pid) and canAttackOther(cid, pid) == "Can")) and
               pid ~= cid
               then
                  setPlayerStorageValue(pid, 654878, 1)
                  doChangeSpeed(pid, -getCreatureSpeed(pid))
                  doChangeSpeed(pid, 100)
                  doPushCreature(pid, roardirections[dirrr][1], 1, 0)
                  doChangeSpeed(pid, -getCreatureSpeed(pid))
                  addEvent(setPlayerStorageValue, 6450, pid, 654878, -1)
                  addEvent(doRegainSpeed, 6450, pid)
               elseif
                  isMonster(cid) and (isSummon(pid) or (isPlayer(pid) and #getCreatureSummons(pid) <= 0)) and
                  pid ~= cid
                  then
                     setPlayerStorageValue(pid, 654878, 1)
                     doChangeSpeed(pid, -getCreatureSpeed(pid))
                     doChangeSpeed(pid, 100)
                     doPushCreature(pid, roardirections[dirrr][1], 1, 0)
                     doChangeSpeed(pid, -getCreatureSpeed(pid))
                     addEvent(doRegainSpeed, 6450, pid)
                     addEvent(setPlayerStorageValue, 6450, pid, 654878, -1)
                  end
               end
            end

            local function doDivine(cid, min, max, spell, rounds, area)
               if not isCreature(cid) then
                  return true
               end
               local ret = {}
               ret.id = 0
               ret.attacker = cid
               ret.check = 0
               ret.cd = rounds
               ret.cond = "Confusion"

               for i = 1, 9 do
                  addEvent(doMoveInArea2, i * 500, cid, 137, area[i], PSYCHICDAMAGE, min, max, spell, ret)
               end
            end

            local rounds = math.random(9, 12)
            local area = {punish1, punish2, punish3, punish1, punish2, punish3, punish1, punish2, punish3}

            local posi = getThingPosWithDebug(cid)
            posi.x = posi.x + 1
            posi.y = posi.y + 1

            setPlayerStorageValue(cid, 2365487, 1)
            addEvent(setPlayerStorageValue, 4600, cid, 2365487, -1) --alterado v1.4
            doDisapear(cid)
            doChangeSpeed(cid, -getCreatureSpeed(cid))
            doSendMagicEffect(posi, 393)
            addEvent(doAppear, 4600, cid)
            addEvent(doRegainSpeed, 4600, cid)

            local uid = checkAreaUid(getCreaturePosition(cid), check, 1, 1)
            for _, pid in pairs(uid) do
               if isSummon(cid) and (isMonster(pid) or (isSummon(pid) and canAttackOther(cid, pid) == "Can") or (isPlayer(pid) and canAttackOther(cid, pid) == "Can")) and pid ~= cid then
                  doChangeSpeed(pid, -getCreatureSpeed(pid))
               elseif isMonster(cid) and (isSummon(pid) or (isPlayer(pid) and #getCreatureSummons(pid) <= 0)) and pid ~= cid then
                  doChangeSpeed(pid, -getCreatureSpeed(pid))
               end
            end

            addEvent(divineBack, 2100, cid)
            addEvent(doDivine, 2200, cid, min, max, spell, rounds, area)

         elseif spell == "Withdraw" then

            local function regainOutfit(cid)
               if not isCreature(cid) then return true end
               if getCreatureName(cid) == "Torkoal" then
                  doSetCreatureOutfit(cid, {lookType = 1941}, -1)
               end
               setPlayerStorageValue(cid, conds["Silence"], -1)
               sendOpcodeStatusInfo(cid)
            end


            if getCreatureName(cid) == "Torkoal" then
               doSetCreatureOutfit(cid, {lookType = 1939}, -1)
            end
            sendOpcodeStatusInfo(cid)
            local hpToHeal = math.floor(getCreatureMaxHealth(cid) / 4)
            doCreatureAddHealth(cid, hpToHeal)
            doSendAnimatedText(getThingPosWithDebug(cid), "+"..hpToHeal, 32)

            addEvent(regainOutfit,5000,cid)
            setPlayerStorageValue(cid, conds["Silence"], 5)
            setPlayerStorageValue(cid, 9658783, 1)
            addEvent(setPlayerStorageValue,5000,cid, 9658783, -1)
            stopNow(cid, 5000)

         elseif isInArray({"Camouflage", "Acid Armor", "Iron Defense", "Minimize"}, spell) then
            local function regainOutfit(cid)
               if not isCreature(cid) then
                  return true
               end
               doSetCreatureOutfit(cid, {lookType = megasConf[getPlayerStorageValue(cid, storages.isMega)].out}, -1)
               checkOutfitMega(cid, getPlayerStorageValue(cid, storages.isMega))
            end

            local timeB = 10
            local ret = {}
            ret.id = cid
            ret.cd = timeB
            ret.eff = 1392
            ret.check = 0
            ret.buff = spell
            ret.first = true

            if isMega(cid) then
               addEvent(regainOutfit, timeB * 1001, cid)
               addEvent(regainOutfit, (timeB + 1) * 1000, cid)
            end
            doCondition2(ret)

         elseif spell == "Shadowave" then
            -- doMoveInArea2(cid, 265, db2, DARKDAMAGE, min, max, spell)
            local myDirection = getCreatureDirectionToTarget(cid, target)
            local info = {
               [0] = psywaveN,
               [1] = psywaveE,
               [2] = psywaveS,
               [3] = psywaveW
            }
            doAreaCombatHealth(cid, DARKDAMAGE, myPos, info[myDirection], -min, -max, 265)

         elseif spell == "Play Rough" then

            local rounds = math.random(4, 7)
            rounds = rounds + math.floor(getPokemonLevel(cid) / 35)

            local ret = {}
            ret.id = target
            ret.attacker = cid
            ret.cd = rounds
            ret.check = getPlayerStorageValue(target, conds["Confusion"])
            ret.cond = "Confusion"

            doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 39)
            addEvent(doSendMagicEffect, 100, getThingPosWithDebug(target), 286)
            addEvent(doMoveDano2, 100, cid, target, FAIRYDAMAGE, -min, -max, ret, spell)

         elseif spell == "Confuse Ray" then

            local rounds = math.random(4, 7)
            rounds = rounds + math.floor(getPokemonLevel(cid) / 35)

            local ret = {}
            ret.id = target
            ret.attacker = cid
            ret.cd = rounds
            ret.check = getPlayerStorageValue(target, conds["Confusion"])
            ret.cond = "Confusion"

            posi = getThingPosWithDebug(target)
            posi.y = posi.y+1

            doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 265)
            addEvent(doSendMagicEffect, 100, posi, 222)
            addEvent(doMoveDano2, 100, cid, target, GHOSTDAMAGE, -min, -max, ret, spell)

         elseif spell == "Leaf Blade" then
            local a = getThingPosWithDebug(target)
            posi = {x = a.x + 1, y = a.y + 1, z = a.z}

            doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 39)
            addEvent(doSendMagicEffect, 200, posi, 304)
            doDanoWithProtectWithDelay(cid, target, GRASSDAMAGE, -min, -max, -1, LeafBlade)

         elseif spell == "Air Vortex" then

            doSetCreatureOutfit(cid, {lookType = 2046}, -1)
            addEvent(doRemoveConditionSecurity,12600,cid,CONDITION_OUTFIT)

            local rounds = 20

            local function hurricane(cid)
               if not isCreature(cid) then return true end
               if isSleeping(cid) and getPlayerStorageValue(cid, 3644587) >= 1 then return false end
               if isWithFear(cid) and getPlayerStorageValue(cid, 3644587) >= 1 then return true end
               doMoveInArea2(cid, 42, bombWee1, FLYINGDAMAGE, min, max, spell)
            end

            --doSetCreatureOutfit(cid, {lookType = 1398}, 10000)

            setPlayerStorageValue(cid, 3644587, 1)
            addEvent(setPlayerStorageValue, rounds*600, cid, 3644587, -1)
            stopNow(cid, rounds*600)
            PullMove(cid, pullArea, spell, rounds*600, "Sleep", rounds*600 / 1000, 0)
            for i = 0, rounds do
               addEvent(hurricane, i*600, cid)                                --alterado v1.4
            end


         elseif spell == "Vine Grap" then

            local effpos = getThingPosWithDebug(cid)
            effpos.x = effpos.x+1
            effpos.y = effpos.y+1
            local effect = getSubName(cid, target) == "Tangela" and 213 or 229
            stopNow(cid, 1000)
            doSendMagicEffect(effpos, effect)
            PullMove(cid, pullArea, spell, 1000, "Slow", 15, 104)
            doMoveInArea2(cid, 0, confusion, GRASSDAMAGE, min, max, spell)

         elseif spell == "Eruption" or spell == "Eerie Impulse" then
            local effpos = getThingPosWithDebug(cid)
            effpos.x = effpos.x + 1
            effpos.y = effpos.y + 1

            atk = {
               ["Eruption"] = {281, FIREDAMAGE, 34},
               ["Eerie Impulse"] = {171, ELECTRICDAMAGE, 48}
            }

            stopNow(cid, 1000)
            PullMove(cid, pullArea, spell, 1000, "Slow", 15, atk[spell][3])
            doSendMagicEffect(effpos, atk[spell][1])
            doMoveInArea2(cid, -1, confusion, atk[spell][2], min, max, spell)
			
    elseif spell == "Dazzling Gleam" then -- uissu
        doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 16)
        doDanoInTargetWithDelay(cid, target, FAIRYDAMAGE, -min, -max, 246)
        addEvent(doSendDistanceShoot, 50, getThingPosWithDebug(cid), getThingPosWithDebug(target), 16)
        addEvent(doDanoInTargetWithDelay, 50, cid, target, FAIRYDAMAGE, -min, -min, 246)

         elseif spell == "Draco Meteor" then
            local effD = 5
            local eff = 398
            local master = isSummon(cid) and getCreatureMaster(cid) or cid

            local function doFall(cid)
               for rocks = 5, 42 do
                  addEvent(fall, rocks * 35, cid, master, DRAGONDAMAGE, effD, eff)
               end
            end

            for up = 1, 10 do
               addEvent(upEffect, up * 75, cid, effD)
            end
            addEvent(doFall, 450, cid)
            addEvent(doDanoWithProtect, 1400, cid, DRAGONDAMAGE, getThingPosWithDebug(cid), waterarea, -min, -max, -1)


         elseif spell == "Dragon Pulse" then
            local p = getThingPosWithDebug(cid)
            local d = isCreature(target) and getCreatureDirectionToTarget(cid, target) or getCreatureLookDir(cid)

            function sendAtk(cid, area)
               if isCreature(cid) then
                  if not isSightClear(p, area, false) then
                     return true
                  end
                  doAreaCombatHealth(cid, DRAGONDAMAGE, area, pulse2, -min, -max, 1392)
               end
            end

            for a = 0, 3 do
               local t = {
                  [0] = {376, {x = p.x, y = p.y - (a + 1), z = p.z}},
                  [1] = {376, {x = p.x + (a + 1), y = p.y, z = p.z}},
                  [2] = {376, {x = p.x, y = p.y + (a + 1), z = p.z}},
                  [3] = {376, {x = p.x - (a + 1), y = p.y, z = p.z}}
               }
               addEvent(sendAtk, 300 * a, cid, t[d][2])
               addEvent(doDanoWithProtect, 400 * a, cid, DRAGONDAMAGE, t[d][2], pulse2, 0, 0, 376)
               addEvent(doDanoWithProtect, 400 * a, cid, DRAGONDAMAGE, t[d][2], pulse1, 0, 0, t[d][1])
            end

         elseif spell == "Aura Sphere" then
            doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 3)
            doDanoInTargetWithDelay(cid, target, FIGHTINGDAMAGE, min, max, 538)
         elseif spell == "Shadow Sphere" then
			local pos = getThingPos(target)
			pos.x = pos.x + 2
			pos.y = pos.y + 2
            doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 3)
            addEvent(doSendMagicEffect, 250, pos, 862)
            doDanoInTargetWithDelay(cid, target, GHOSTDAMAGE, min, max, 1392) --alterado v1.7
         elseif spell == "Psy Ball" then
            doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 3)
            doDanoInTargetWithDelay(cid, target, PSYCHICDAMAGE, min, max, 682) --alterado v1.7
         elseif spell == "SmokeScreen" then

            local ret = {}
            ret.id = 0
            ret.attacker = cid
            ret.cd = 9
            ret.eff = 34
            ret.check = 0
            ret.spell = spell
            ret.cond = "Miss"

            local function smoke(cid)
               if not isCreature(cid) then return true end
               if isSleeping(cid) and getPlayerStorageValue(cid, 3644587) >= 1 then return false end
               if isWithFear(cid) and getPlayerStorageValue(cid, 3644587) >= 1 then return true end
               doMoveInArea2(cid, 34, confusion, NORMALDAMAGE, 0, 0, spell, ret)
            end

            setPlayerStorageValue(cid, 3644587, 1)
            addEvent(setPlayerStorageValue, 1000, cid, 3644587, -1)
            for i = 0, 2 do
               addEvent(smoke, i*500, cid)
            end

         elseif spell == "Faint Attack" then --alterado v1.5
            -- local ret = {}
            -- ret.id = 0
            -- ret.attacker = cid
            -- ret.cd = 9
            -- ret.eff = 139
            -- ret.check = 0
            -- ret.spell = spell
            -- ret.cond = "Stun"

            doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 39)
            doDanoInTargetWithDelay(cid, target, DARKDAMAGE, min, max, 138)
            -- addEvent(doMoveDano2, 150, cid, target, DARKDAMAGE, 0, 0, ret, spell)

         elseif spell == "Sucker Punch" then --alterado v1.5
            doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 39)
            doDanoInTargetWithDelay(cid, target, DARKDAMAGE, min, max, 269) --alterado v1.7

         elseif spell == "Assurance" then
            local function doSendMove(cid, area, effectarea, effect, turn)
               if not isCreature(cid) then
                  return true
               end
               doAreaCombatHealth(cid, DARKDAMAGE, area, line1x1, -min, -max, -1)
               doSendMagicEffect(effectarea, effect)
            end
            for i = 0, 5 do
               local info = {
                  [0] = {342, {x = myPos.x, y = myPos.y - (i + 1), z = myPos.z}, {x = myPos.x + 1, y = (myPos.y - 2) - i, z = myPos.z}},
               [1] = {256, {x = myPos.x + (i + 1), y = myPos.y, z = myPos.z}, {x = myPos.x + (i + 2), y = myPos.y + 1, z = myPos.z}},
            [2] = {344, {x = myPos.x, y = myPos.y + (i + 1), z = myPos.z}, {x = myPos.x + 1, y = myPos.y + (i + 2), z = myPos.z}},
         [3] = {343, {x = myPos.x - (i + 1), y = myPos.y, z = myPos.z}, {x = (myPos.x - 1) - i, y = myPos.y + 1, z = myPos.z}}
   }
   addEvent(doSendMove, i * 300, cid, info[myDirection][2], info[myDirection][3], info[myDirection][1], i + 1)
end

	elseif spell == "Scary Face" then
	local p = getThingPosWithDebug(cid)
	doSendMagicEffect({x=p.x+1, y=p.y+1, z=p.z}, 352)
	-- doAreaCombatHealth(cid, STATUS_STUN, myPos, circle4x4, -6, -6, 1392)
	doAreaCombatHealth(cid, STATUS_STUN7, myPos, circle3x3, -0, -0, 1392)
	-- doMoveInArea2(cid, 1392, electro, NORMALDAMAGE, 0, 0, spell, ret)

	elseif spell == "Surf" then
        local function doSendMove(cid, turn)
            if not isCreature(cid) then
                return true
            end
            local turn = turn or 1
            local event = addEvent(doSendMove, 50, cid, turn + 1)
        local myPos = getThingPosWithDebug(cid)
        local pos = {x = myPos.x + math.random(-4, 4), y = myPos.y + math.random(-4, 4), z = myPos.z}
        if getThingFromPos(pos).itemid ~= 0 then
            doSendMagicEffect(pos, 371)
        end
            if turn == 21 or isSleeping(cid) then
                stopEvent(event)
            end
        end
        doSendMove(cid)
		addEvent(doAreaCombatHealth, 1000, cid, WATERDAMAGE, myPos, square4x4, -min, -max, 1392)
		
elseif spell == "Fissure" then
        local function doSendMove(cid, turn)
            if not isCreature(cid) then
                return true
            end
            local turn = turn or 1
            local event = addEvent(doSendMove, 50, cid, turn + 1)
        local myPos = getThingPosWithDebug(cid)
        local pos = {x = myPos.x + math.random(-4, 4), y = myPos.y + math.random(-4, 4), z = myPos.z}
        if getThingFromPos(pos).itemid ~= 0 then
            doSendMagicEffect(pos, 271)
        end
            if turn == 21 or isSleeping(cid) then
                stopEvent(event)
            end
        end
        doSendMove(cid)
		addEvent(doAreaCombatHealth, 1000, cid, GROUNDDAMAGE, myPos, square4x4, -min, -max, 1392)
		
	elseif spell == "Black Hole" then
        local function doSendMove(cid, turn)
            if not isCreature(cid) then
                return true
            end
            local turn = turn or 1
            local event = addEvent(doSendMove, 50, cid, turn + 1)
        local myPos = getThingPosWithDebug(cid)
        local pos = {x = myPos.x + math.random(-4, 4), y = myPos.y + math.random(-4, 4), z = myPos.z}
        if getThingFromPos(pos).itemid ~= 0 then
            doSendMagicEffect(pos, 649)
			doSendDistanceShoot(myPos, pos, 140)
        end
            if turn == 20 or isSleeping(cid) then
                stopEvent(event)
            end
        end
        doSendMove(cid)
		addEvent(doAreaCombatHealth, 1000, cid, DARKDAMAGE, myPos, square4x4, -min, -max, 1392)
		PullMove(cid, pullArea, spell, 1000, "Slow", 8, 1392)

		-- function PullMove(cid, area, spell, stopt, condition, condtime, reteff) -- by uissu


-- elseif spell == "Moonblast" or spell == "Bright Light" then

-- local ret = {}
-- ret.id = 0
-- ret.attacker = cid
-- ret.cd = 9
-- ret.check = 0
-- ret.eff = 255
-- ret.cond = "Silence"
--
-- local p = getThingPosWithDebug(cid)
-- doSendMagicEffect(p, spell == "Moonblast" and 532 or 456)

-- if isSummon(cid) then
-- doClearBallStatus(getPlayerSlotItem(getCreatureMaster(cid), 8).uid)
-- end
-- doClearPokemonStatus(cid)
-- doMoveInArea2(cid, 0, electro, FAIRYDAMAGE, min, max, spell, ret)
--setPlayerStorageValue(cid, 253, 1)  --focus

elseif spell == "Moonblast" or spell == "Bright Light" then
--setPlayerStorageValue(cid, 253, 1)  --focus
local ret = {}
ret.id = 0
ret.attacker = cid
ret.cd = 9
ret.check = 0
ret.eff = 1392
ret.cond = "Silence"
----
local p = getThingPosWithDebug(cid)
p.x = p.x + 1
doSendMagicEffect(p, spell == "Moonblast" and 611 or 456)
---
if isSummon(cid) then
   doClearBallStatus(getPlayerSlotItem(getCreatureMaster(cid), 8).uid)
end
doClearPokemonStatus(cid)
doMoveInArea2(cid, 1392, electro, FAIRYDAMAGE, min, max, spell, ret)

elseif spell == "Sunny Day" then

local p = getThingPosWithDebug(cid)
doSendMagicEffect({x = p.x + 1, y = p.y, z = p.z}, 661)

if isSummon(cid) then
   doClearBallStatus(getPlayerSlotItem(getCreatureMaster(cid), 8).uid)
end
doClearPokemonStatus(cid)
setPlayerStorageValue(cid, 253, 1) --focus
sendOpcodeStatusInfo(cid)
doAreaCombatHealth(cid, STATUS_SILENCE, myPos, square4x4, -2, -2, 1392)
setPlayerStorageValue(cid, 847232, os.time() + 9)
if isInArray(specialabilities["chlorophyll"], getCreatureName(cid)) then
   doRaiseStatus(cid, 0, 0, 200, 10)
end
doCastform(cid, spell)

elseif spell == "Taunt" then
local ret = {}
ret.id = 0
ret.attacker = cid
ret.cd = 4
ret.eff = 1392
ret.check = 0
ret.spell = spell
ret.cond = "Silence"

local function doSendMove(cid, turn)
   if not isCreature(cid) then
      return true
   end
   local turn = turn or 1
   local event = addEvent(doSendMove, 300, cid, turn + 1)
   local area1 = {rock5, rock4, rock3, rock2, rock1, rock5, rock4, rock3, rock2, rock1, rock5, rock4, rock3, rock2, rock1, rock5, rock4, rock3, rock2, rock1, rock5, rock4, rock3, rock2, rock1}
   -- doAreaCombatHealth(cid, ELECTRICDAMAGE, getThingPosWithDebug(cid), area1[turn], -min, -max, 219)
   doMoveInArea2(cid, 219, area1[turn], DARKDAMAGE, 0, 0, spell, ret)
	if isSummon(cid) then
		doClearBallStatus(getPlayerSlotItem(getCreatureMaster(cid), 8).uid)
	end
	doClearPokemonStatus(cid)
   if turn == 25 or isSleeping(cid) then
      stopEvent(event)
   end
end
doSendMove(cid)
setPlayerStorageValue(cid, 253, 1)
sendOpcodeStatusInfo(cid)

elseif isInArray({"Pursuit", "U-Turn", "Shell Attack"}, spell) then

local atk = {
   ["Pursuit"] = {17, DARKDAMAGE},
   ["U-Turn"] = {19, BUGDAMAGE},
   ["Shell Attack"] = {45, BUGDAMAGE}      --alterado v1.5
}

local pos = getThingPosWithDebug(cid)
local p = getThingPosWithDebug(target)
local newPos = getClosestFreeTile(target, p)

local eff = getSubName(cid, target) == "Shiny Arcanine" and atk[spell][3] or atk[spell][1] --alterado v1.6.1

local damage = atk[spell][2]
-----------
doDisapear(cid)
doChangeSpeed(cid, -getCreatureSpeed(cid))
-----------
addEvent(doSendMagicEffect, 300, pos, 211)
addEvent(doSendDistanceShoot, 400, pos, p, eff)
addEvent(doSendDistanceShoot, 400, newPos, p, eff)
addEvent(doDanoInTarget, 400, cid, target, damage, -min, -max, 0)
addEvent(doSendDistanceShoot, 800, p, pos, eff)
addEvent(doSendMagicEffect, 850, pos, 211)
addEvent(doRegainSpeed, 1000, cid)
addEvent(doAppear, 1000, cid)

elseif spell == "Egg Rain" then

local effD = 12
local eff = 5
local master = isSummon(cid) and getCreatureMaster(cid) or cid
------------

local function doFall(cid)
   for rocks = 1, 62 do
      addEvent(fall, rocks*35, cid, master, ROCKDAMAGE, effD, eff)
   end
end

for up = 1, 10 do
   addEvent(upEffect, up*75, cid, effD)
end
addEvent(doFall, 450, cid)
addEvent(doDanoWithProtect, 1400, cid, NORMALDAMAGE, getThingPosWithDebug(cid), waterarea, -min, -max, 0)


elseif spell == "Crow Swarm" then
        local function doSendMove(cid, turn)
            if not isCreature(cid) then
                return true
            end
            local turn = turn or 1
            local event = addEvent(doSendMove, 50, cid, turn + 1)
        local myPos = getThingPosWithDebug(cid)
        local pos = {x = myPos.x + math.random(-4, 4), y = myPos.y + math.random(-4, 4), z = myPos.z}
        if getThingFromPos(pos).itemid ~= 0 then
			if doCorrectString(getCreatureName(cid)) == "Shiny Honchkrow" then
				doSendMagicEffect(pos, 1394)
			else
				doSendMagicEffect(pos, 591)
			end
        end
            if turn == 20 or isSleeping(cid) then
                stopEvent(event)
            end
        end
        doSendMove(cid)
		addEvent(doAreaCombatHealth, 1000, cid, DARKDAMAGE, myPos, square4x4, -min, -max, 1392)
		

elseif spell == "Stampade" then

        local function doSendMove(cid, turn)
            if not isCreature(cid) then
                return true
            end
            local turn = turn or 1
            local event = addEvent(doSendMove, 50, cid, turn + 1)
        local myPos = getThingPosWithDebug(cid)
        local pos = {x = myPos.x + math.random(-4, 4), y = myPos.y + math.random(-4, 4), z = myPos.z}
        if getThingFromPos(pos).itemid ~= 0 then
			doSendMagicEffect(pos, 187)
        end
            if turn == 20 or isSleeping(cid) then
                stopEvent(event)
            end
        end
        doSendMove(cid)
		addEvent(doAreaCombatHealth, 1000, cid, DARKDAMAGE, myPos, square4x4, -min, -max, 1392)


elseif spell == "Stampage" then

        local function doSendMove(cid, turn)
            if not isCreature(cid) then
                return true
            end
            local turn = turn or 1
            local event = addEvent(doSendMove, 50, cid, turn + 1)
        local myPos = getThingPosWithDebug(cid)
        local pos = {x = myPos.x + math.random(-4, 4), y = myPos.y + math.random(-4, 4), z = myPos.z}
        if getThingFromPos(pos).itemid ~= 0 then
			doSendMagicEffect(pos, 194)
        end
            if turn == 20 or isSleeping(cid) then
                stopEvent(event)
            end
        end
        doSendMove(cid)
		addEvent(doAreaCombatHealth, 1000, cid, DARKDAMAGE, myPos, square4x4, -min, -max, 1392)


elseif spell == "Stampede" then

local master = getCreatureMaster(cid) or 0
local ret = {}
ret.id = 0
ret.attacker = cid
ret.cd = 9
ret.eff = 1392
ret.check = 0
ret.spell = spell
ret.cond = "Paralyze"
if doCorrectString(getCreatureName(cid)) == "Shiny Gogoat" then
for rocks = 1, 42 do
   addEvent(fall, rocks*35, cid, master, NORMALDAMAGE, -1, math.random(1372, 1373))
end
else
for rocks = 1, 42 do
   addEvent(fall, rocks*35, cid, master, NORMALDAMAGE, -1, 194)
end
end

addEvent(doMoveInArea2, 500, cid, 1392, BigArea2, GRASSDAMAGE, min, max, spell, ret)

elseif spell == "Barrier" then
-- if not isCreature(cid) then
   local function sendAtk(cid)
      if not isCreature(cid) then
         return true
      end
      if getCreatureName(cid) ~= "Unown Legion" then
         doRemoveCondition(cid, CONDITION_OUTFIT)
      end
      setPlayerStorageValue(cid, 9658783, -1)
      setPlayerStorageValue(cid, 734276, -1)
      setPlayerStorageValue(cid, conds["Silence"], -1)
      sendOpcodeStatusInfo(cid)
   end

   setPlayerStorageValue(cid, 734276, 1)
   setPlayerStorageValue(cid, 9658783, 1)
   pos = getThingPosWithDebug(cid)

   local function doSendEff(cid)
      if not isCreature(cid) then
         return true
      end
      local pos = getThingPosWithDebug(cid)
      doSendMagicEffect({x = pos.x + 3, y = pos.y + 3, z = pos.z}, 1029)
   end

   setPlayerStorageValue(cid, conds["Silence"], 5)
   sendOpcodeStatusInfo(cid)
   if getCreatureName(cid) ~= "Unown Legion" then
      doSetCreatureOutfit(cid, {lookType = 2210}, -1)
   end
   for i = 0, 4 do
      addEvent(doSendEff, i * 1000, cid)
   end
   addEvent(sendAtk, 5000, cid)
   stopNow(cid, 5000)
-- end

elseif spell == "Air Cutter" then
local p = getThingPosWithDebug(cid)
local d = isCreature(target) and getCreatureDirectionToTarget(cid, target) or getCreatureLookDir(cid)

function sendAtk(cid, area)
   if isCreature(cid) then
      if not isSightClear(p, area, false) then
         return true
      end
      doAreaCombatHealth(cid, FLYINGDAMAGE, area, whirl3, -min, -max, 1392)
   end
end

for a = 0, 5 do
   local t = {
      [0] = {128, {x = p.x, y = p.y - (a + 1), z = p.z}, {x = p.x + 1, y = p.y - (a + 1), z = p.z}},
      [1] = {129, {x = p.x + (a + 1), y = p.y, z = p.z}, {x = p.x + (a + 2), y = p.y + 1, z = p.z}},
      [2] = {131, {x = p.x, y = p.y + (a + 1), z = p.z}, {x = p.x + 1, y = p.y + (a + 2), z = p.z}},
      [3] = {130, {x = p.x - (a + 1), y = p.y, z = p.z}, {x = p.x - (a + 1), y = p.y + 1, z = p.z}}
   }
   addEvent(doSendMagicEffect, 300 * a, t[d][3], t[d][1])
   addEvent(sendAtk, 300 * a, cid, t[d][2])
end

elseif spell == "Venom Gale" then

local area = {gale1, gale2, gale3, gale4, gale3, gale2, gale1}

for i = 0, 6 do
   addEvent(doMoveInArea2, i*400, cid, 138, area[i+1], POISONDAMAGE, min, max, spell)
end

elseif spell == "Crunch" then

doMoveInArea2(cid, 146, Crunch1, DARKDAMAGE, min, max, spell)
addEvent(doMoveInArea2, 300, cid, 146, Crunch2, DARKDAMAGE, min, max, spell)

elseif spell == "Ice Fang" then
local ret = {}
ret.id = target
ret.attacker = cid
ret.cd = 9
ret.eff = 43
ret.check = 0
ret.spell = spell
ret.cond = "Slow"

local pos = getThingPosWithDebug(target)
pos.x = pos.x + 1
pos.y = pos.y + 1
doSendMagicEffect(pos, 658)
doSendMagicEffect(getThingPosWithDebug(target), 43)
doMoveDano2(cid, target, ICEDAMAGE, -min, -max, ret, spell)

    elseif spell == "Psyshock" or spell == "Ground Collapse" then
        local p = getThingPosWithDebug(cid)
        local d = isCreature(target) and getCreatureDirectionToTarget(cid, target) or getCreatureLookDir(cid)

        function sendAtk(cid, area, eff)
            if isCreature(cid) then
                if not isSightClear(p, area, false) then
                    return true
                end
                doAreaCombatHealth(cid, spell == "Psyshock" and PSYCHICDAMAGE or GROUNDDAMAGE, area, 0, 0, 0, eff) --alterado v1.4
                doAreaCombatHealth(cid, spell == "Psyshock" and PSYCHICDAMAGE or GROUNDDAMAGE, area, whirl3, -min, -max, 1392) --alterado v1.4
            end
        end

        for a = 0, 4 do
            local t = {
                [0] = {250, {x = p.x, y = p.y - (a + 1), z = p.z}}, --alterado v1.4
                [1] = {250, {x = p.x + (a + 1), y = p.y, z = p.z}},
                [2] = {250, {x = p.x, y = p.y + (a + 1), z = p.z}},
                [3] = {250, {x = p.x - (a + 1), y = p.y, z = p.z}}
            }
            addEvent(sendAtk, 370 * a, cid, t[d][2], spell == "Psyshock" and 250 or 590)
        end

elseif spell == "Hurricane" then

local function hurricane(cid)
   if not isCreature(cid) then return true end
   if isSleeping(cid) and getPlayerStorageValue(cid, 3644587) >= 1 then return false end
   if isWithFear(cid) and getPlayerStorageValue(cid, 3644587) >= 1 then return true end
   doMoveInArea2(cid, 42, bombWee1, FLYINGDAMAGE, min, max, spell)
end

doSetCreatureOutfit(cid, {lookType = 975}, 10000)

setPlayerStorageValue(cid, 3644587, 1)
addEvent(setPlayerStorageValue, 17*600, cid, 3644587, -1)
for i = 1, 17 do
   addEvent(hurricane, i*600, cid)                                --alterado v1.4
end

elseif spell == "Aromateraphy" or spell == "Emergency Call" then

eff = spell == "Aromateraphy" and 14 or 13

doAreaCombatHealth(cid, GRASSDAMAGE, getThingPosWithDebug(cid), bombWee3, 0, 0, eff)
if isSummon(cid) then
   doClearBallStatus(getPlayerSlotItem(getCreatureMaster(cid), 8).uid)
end
doClearPokemonStatus(cid)

local uid = checkAreaUid(getThingPosWithDebug(cid), confusion, 1, 1)
for _,pid in pairs(uid) do
   if isCreature(pid) then
      if ehMonstro(cid) and ehMonstro(pid) and pid ~= cid then
         doCureStatus(pid, "all")
      elseif isSummon(cid) and ((isSummon(pid) and canAttackOther(cid, pid) == "Cant") or (isPlayer(pid) and canAttackOther(cid, pid) == "Cant")) and pid ~= cid then
         if isSummon(pid) then
            doCureBallStatus(getPlayerSlotItem(getCreatureMaster(pid), 8).uid, "all")
         end
         doCureStatus(pid, "all")
      end
   end
end

elseif spell == "Synthesis" or spell == "Roost" then
-- if getPlayerStorageValue(cid, STORAGE_HEALBLOCK) == 1 then return true end
local min = (getCreatureMaxHealth(cid) * 45) / 100
local max = (getCreatureMaxHealth(cid) * 60) / 100

if isPlayer(cid) and isInArea(getThingPosWithDebug(cid), {x=2449,y=2611,z=8}, {x=2491,y=2654,z=8}) then return true end

doSendMagicEffect(getThingPosWithDebug(cid), 39)
doHealArea(cid, min, max)

elseif spell == "Cotton Spore" then
local ret = {}
ret.id = 0
ret.attacker = cid
ret.cd = 9
ret.eff = 0
ret.check = 0
ret.spell = spell
ret.cond = "Stun"

doMoveInArea2(cid, 85, confusion, GRASSDAMAGE, 0, 0, spell, ret)

elseif spell == "Peck" then
sendDistanceShootWithProtect(cid, getThingPosWithDebug(cid), getThingPosWithDebug(target), 39)
doDanoInTargetWithDelay(cid, target, FLYINGDAMAGE, min, max, 3)

-- elseif spell == "Night Daze" then

-- local pos = getThingPosWithDebug(cid)
-- local eff = 265
-- local dmg = DARKDAMAGE

-- local function doSendBubble(cid, pos)
   -- if not isCreature(cid) then return true end
   -- doSendDistanceShoot(getThingPosWithDebug(cid), pos, 39)
   -- doSendMagicEffect(pos, eff)
-- end
-- for a = 1, 20 do
   -- local r1 = math.random(-4, 4)
   -- local r2 = r1 == 0 and choose(-3, -2, -1, 2, 3) or math.random(-3, 3)
   
   -- local lugar = {x = pos.x + r1, y = pos.y + r2, z = pos.z}
   -- addEvent(doSendBubble, a * 25, cid, lugar)
-- end
-- addEvent(doDanoWithProtect, 150, cid, dmg, pos, waterarea, -min, -max, 1392)

elseif spell == "Night Daze" then
	local myPos = getThingPosWithDebug(cid)
    local function doSendMove(cid)
        if not isCreature(cid) then return true end
        if isSleeping(cid) then return true end
        local myPos = getThingPosWithDebug(cid)
        local pos = {x = myPos.x + math.random(-4, 4), y = myPos.y + math.random(-4, 4), z = myPos.z}
        if getThingFromPos(pos).itemid ~= 0 then
            doSendDistanceShoot(myPos, pos, 39)
            doSendMagicEffect(pos, 265)
        end
    end
    for i = 0, 20 do
        addEvent(doSendMove, i * 50, cid)
    end
    doAreaCombatHealth(cid, DARKDAMAGE, myPos, square4x4, -min, -max, 1392)

elseif spell == "Rolling Kick" then
local pos = getThingPosWithDebug(cid)
-- local out = getSubName(cid, target) == "Hitmontop" and 464 or 1156

local function doSendBubble(cid, pos)
   if not isCreature(cid) then
      return true
   end
   doSendDistanceShoot(getThingPosWithDebug(cid), pos, 39)
   doSendMagicEffect(pos, 113)
end

for a = 1, 20 do
   local r1 = math.random(-4, 4)
   local r2 = r1 == 0 and choose(-3, -2, -1, 2, 3) or math.random(-3, 3)
   --
   local lugar = {x = pos.x + r1, y = pos.y + r2, z = pos.z}
   addEvent(doSendBubble, a * 25, cid, lugar)
end
      local ret = {}
      ret.id = 0
      ret.attacker = cid
      ret.eff = 253
      ret.check = 0
      ret.cd = 6
      ret.cond = "Silence"

      doMoveInArea2(cid, 1392, BigArea2, FIGHTINGDAMAGE, min, max, spell, ret) 

elseif spell == "Safeguard" then

local function eff(cid)
   if not isCreature(cid) then return true end
   doSendMagicEffect(getThingPosWithDebug(cid), 1)
   sendOpcodeStatusInfo(cid)
   setPlayerStorageValue(cid, 234247, getPlayerStorageValue(cid, 234247)-1)
end

for x=0,7 do
   addEvent(eff,x*1000,cid)
end

setPlayerStorageValue(cid, 234247, 8)

if isSummon(cid) then
   doClearBallStatus(getPlayerSlotItem(getCreatureMaster(cid), 8).uid)
end
doClearPokemonStatus(cid)

elseif spell == "Air Slash" then
local myPos = getThingPosWithDebug(cid)
local info = {
   [1] = {286, 286, {x = myPos.x + 1, y = myPos.y, z = myPos.z}},
   [2] = {289, 289, {x = myPos.x + 2, y = myPos.y + 1, z = myPos.z}},
   [3] = {287, 287, {x = myPos.x + 1, y = myPos.y + 2, z = myPos.z}},
   [4] = {288, 288, {x = myPos.x, y = myPos.y + 1, z = myPos.z}}
}
for i = 1, 4 do
   doSendMagicEffect(info[i][3], info[i][1])
   addEvent(doSendMagicEffect, 400, info[i][3], info[i][2])
end
doAreaCombatHealth(cid, FLYINGDAMAGE, myPos, circle2x2, -min, -max, 1392)
addEvent(doAreaCombatHealth, 400, cid, FLYINGDAMAGE, myPos, circle2x2, -min, -max, 1392)

    elseif spell == "Circle Throw" then
        local function doSendMove(cid, turn)
            if not isCreature(cid) then
                return true
            end
            local turn = turn or 1
            local event = addEvent(doSendMove, 600, cid, turn + 1)
            local pos = getThingPosWithDebug(cid)
            pos.x = pos.x + 2
            pos.y = pos.y + 2
            doSendMagicEffect(pos, 1012)
            doAreaCombatHealth(cid, FIGHTINGDAMAGE, getThingPosWithDebug(cid), square2x2, -min, -max, 1392)
            if turn == 2 or isSleeping(cid) then
                stopEvent(event)
            end
        end
        doSendMove(cid)

elseif spell == "Feather Dance" then

local function doPulse(cid, eff)
   if not isCreature(cid) or not isCreature(target) then return true end
   doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 9)
   doDanoInTargetWithDelay(cid, target, FLYINGDAMAGE, -min, -max, eff)   --alterado v1.7
end

addEvent(doPulse, 0, cid, 137)
addEvent(doPulse, 100, cid, 137)


elseif spell == "Tailwind" then

local ret = {}
ret.id = cid
ret.cd = 10
ret.eff = 137
ret.check = 0
ret.buff = spell
ret.first = true

doCondition2(ret)

elseif spell == "Tackle" then
doDanoWithProtect(cid, NORMALDAMAGE, getThingPosWithDebug(target), 0, -min, -max, 111)

elseif spell == "Giga Drain" then
if not isCreature(cid) then return true end
local life = getCreatureHealth(target) or 0

doDanoWithProtect(cid, GRASSDAMAGE, getThingPosWithDebug(target), 0, -min, -max, 258)

local newlife = life - (getCreatureHealth(target) or 0)

doSendMagicEffect(getThingPosWithDebug(cid), 14)
if newlife >= 1 then
   doCreatureAddHealth(cid, newlife)
   doSendAnimatedText(getThingPosWithDebug(cid), "+"..newlife.."", 32)
end

elseif spell == "Bug Fighter" then

local ret = {}
ret.id = cid
ret.cd = 10
ret.eff = 0
ret.check = 0
ret.buff = spell
ret.first = true

doCondition2(ret)

	elseif spell == "Metal Claw" then
		if not isCreature(cid) then return true end
		local myPos = getThingPosWithDebug(cid)
		local myDirection = isCreature(target) and getCreatureDirectionToTarget(cid, target) or getCreatureLookDir(cid)
		local info = {
			[0] = {259, {x = myPos.x + 1, y = myPos.y - 1, z = myPos.z}, {x = myPos.x, y = myPos.y - 1, z = myPos.z}},
			[1] = {261, {x = myPos.x + 2, y = myPos.y + 1, z = myPos.z}, {x = myPos.x + 1, y = myPos.y, z = myPos.z}},
			[2] = {260, {x = myPos.x + 1, y = myPos.y + 2, z = myPos.z}, {x = myPos.x, y = myPos.y + 1, z = myPos.z}},
			[3] = {262, {x = myPos.x - 1, y = myPos.y + 1, z = myPos.z}, {x = myPos.x - 1, y = myPos.y, z = myPos.z}}
		}
		doSendMagicEffect(info[myDirection][2], info[myDirection][1])
		doAreaCombatHealth(cid, FLYINGDAMAGE, info[myDirection][3], line1x1, -min, -max, 1392)
		doSendAnimatedText(getThingPosWithDebug(cid), "FOCUS", 144)
		setPlayerStorageValue(cid, 253, 1)
		sendOpcodeStatusInfo(cid)

elseif spell == "Power Gem" then
local p = getThingPosWithDebug(cid)
local d = isCreature(target) and getCreatureDirectionToTarget(cid, target) or getCreatureLookDir(cid)

function sendAtk(cid, area)
   if isCreature(cid) then
      if not isSightClear(p, area, false) then
         return true
      end
      doAreaCombatHealth(cid, ROCKDAMAGE, area, pulse2, -min, -max, 1392)
      doAreaCombatHealth(cid, ROCKDAMAGE, area, pulse1, 0, 0, 228)
      doAreaCombatHealth(cid, ROCKDAMAGE, area, pulse1, 0, 0, 264)
   end
end

for a = 0, 3 do
   local t = {
      [0] = {228, {x = p.x, y = p.y - (a + 1), z = p.z}},
      [1] = {228, {x = p.x + (a + 1), y = p.y, z = p.z}},
      [2] = {228, {x = p.x, y = p.y + (a + 1), z = p.z}},
      [3] = {228, {x = p.x - (a + 1), y = p.y, z = p.z}}
   }
   addEvent(sendAtk, 400 * a, cid, t[d][2])
end

elseif spell == "Octazooka" then

local ret = {}
ret.id = 0
ret.attacker = cid
ret.cd = 9
ret.check = 0
ret.eff = 34
ret.cond = "Silence"


doMoveInAreaMulti(cid, 6, 116, multi, multiDano, WATERDAMAGE, min, max)
doMoveInArea2(cid, 0, multiDano, WATERDAMAGE, 0, 0, spell, ret)


elseif spell == "Take Down" then

doMoveInArea2(cid, 111, reto5, NORMALDAMAGE, min, max, spell)

elseif spell == "Yawn" then

local ret = {}
ret.id = target
ret.attacker = cid
ret.cd = math.random(9, 15)
ret.check = getPlayerStorageValue(target, conds["Sleep"])
ret.first = true
ret.cond = "Sleep"

doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 11)
addEvent(doMoveDano2, 2000, cid, target, NORMALDAMAGE, 0, 0, ret, spell)

elseif spell == "Tongue Hook" or spell == "Croak Hook" then

sendDistanceShootWithProtect(cid, getThingPosWithDebug(cid), getThingPosWithDebug(target), 38)
if not isConditionImune(target) then
   addEvent(doTeleportThing, 200, target, getClosestFreeTile(cid, getThingPosWithDebug(cid)), true)
end
addEvent(sendDistanceShootWithProtect, 200, cid, getThingPosWithDebug(target), getThingPosWithDebug(cid), 38)


elseif spell == "Tongue Grap" then

local function distEff(cid, target)
   if not isCreature(cid) or not isCreature(target) or not isSilence(target) then return true end  --alterado v1.6
   sendDistanceShootWithProtect(cid, getThingPosWithDebug(target), getThingPosWithDebug(cid), 38)
end

local ret = {}
ret.id = target
ret.attacker = cid
ret.cd = 10
ret.check = getPlayerStorageValue(target, conds["Sleep"])
ret.eff = 185
ret.cond = "Sleep"

sendDistanceShootWithProtect(cid, getThingPosWithDebug(cid), getThingPosWithDebug(target), 38)
addEvent(doMoveDano2, 100, cid, target, NORMALDAMAGE, 0, 0, ret, spell)

for i = 1, 10 do
   addEvent(distEff, i*930, cid, target)
end

elseif spell == "Struggle Bug" then

local function sendFireEff(cid, dir)
   if not isCreature(cid) then return true end
   doDanoWithProtect(cid, BUGDAMAGE, getPosByDir(getThingPosWithDebug(cid), dir), 0, -min, -max, 105)
end

local function doWheel(cid)
   if not isCreature(cid) then return true end
   local t = {
      [1] = SOUTH,
      [2] = SOUTHEAST,
      [3] = EAST,
      [4] = NORTHEAST,
      [5] = NORTH,        --alterado v1.5
      [6] = NORTHWEST,
      [7] = WEST,
      [8] = SOUTHWEST,
   }
   for a = 1, 8 do
      addEvent(sendFireEff, a * 200, cid, t[a])
   end
end

doWheel(cid, false, cid)

elseif spell == "Low Kick" then

doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 39)
doDanoInTargetWithDelay(cid, target, FIGHTINGDAMAGE, min, max, 113)	--alterado v1.7

elseif spell == "Present" then

local function sendHeal(cid)
   if isCreature(cid) and isCreature(target) then
      doAreaCombatHealth(cid, NORMALDAMAGE, getThingPosWithDebug(target), crusher, min, max, 5)
      doSendAnimatedText(getThingPosWithDebug(target), "HEALTH!", 65)
   end
end

doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 31)
if math.random(1, 100) >= 10 then
   doDanoWithProtectWithDelay(cid, target, NORMALDAMAGE, min, max, 5, crusher)
else
   addEvent(sendHeal, 100, cid)
end

elseif spell == "Inferno" then
        local function doSendMove(cid, turn)
            if not isCreature(cid) then
                return true
            end
            local turn = turn or 1
            local event = addEvent(doSendMove, 50, cid, turn + 1)
        local myPos = getThingPosWithDebug(cid)
        local pos = {x = myPos.x + math.random(-4, 4), y = myPos.y + math.random(-4, 4), z = myPos.z}
        if getThingFromPos(pos).itemid ~= 0 then
            doSendMagicEffect(pos, 676)
        end
            if turn == 21 or isSleeping(cid) then
                stopEvent(event)
            end
        end
        doSendMove(cid)
		addEvent(doAreaCombatHealth, 1000, cid, FIREDAMAGE, myPos, square4x4, -min, -max, 1392)

elseif spell == "Wrap" or spell == "Bind" then
local ret = {}
ret.id = target
ret.attacker = cid
ret.cd = 10
ret.check = getPlayerStorageValue(target, conds["Sleep"])
ret.eff = 354
ret.cond = "Sleep"

doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 14)
addEvent(doMoveDano2, 100, cid, target, NORMALDAMAGE, 0, 0, ret, spell)

elseif spell == "Rock n'Roll" then

local pos = getThingPosWithDebug(cid)
local areas = {rock1, rock2, rock3, rock4, rock5, rock4, rock3, rock2, rock1}
local ret = {}
ret.id = 0
ret.attacker = cid
ret.cd = 9
ret.eff = 1
ret.check = 0
ret.spell = spell
ret.cond = "Miss"

for i = 0, 8 do
   addEvent(doMoveInArea2, i*400, cid, 1, areas[i+1], NORMALDAMAGE, min, max, spell, ret)
   addEvent(doMoveInArea2, i*410, cid, 1, areas[i+1], NORMALDAMAGE, 0, 0, spell)
end

elseif spell == "Sheer Cold" then
local pos = getThingPosWithDebug(cid)
local areas = {rock1, rock2, rock3, rock4, rock5}
local ret = {}
ret.id = 0
ret.attacker = cid
ret.cd = 5
ret.eff = 478
ret.check = 0
ret.first = true
ret.cond = "Sleep"

local function sendAtk(cid)
   if isCreature(cid) then
      setPlayerStorageValue(cid, 9658783, -1)
      for i = 0, 4 do
         addEvent(doMoveInArea2, i * 400, cid, 478, areas[i + 1], ICEDAMAGE, min, max, spell, ret)
         -- addEvent(doMoveInArea2, i * 600, cid, 43, areas[i + 1], ICEDAMAGE, 0, 0, spell, ret)
      end
   end
end

-- doSendMagicEffect(getThingPosWithDebug(cid), 393)
setPlayerStorageValue(cid, 9658783, 1)
stopNow(cid, 1400)
addEvent(sendAtk, 1400, cid)

elseif spell == "Power Wave" or spell == "Future Sight" then
local pos = getThingPosWithDebug(cid)
local areas = {rock1, rock2, rock3, rock4, rock5}

local ret = {}
ret.id = 0
ret.attacker = cid
ret.cd = 5
ret.eff = 264
ret.check = 0
ret.first = true
ret.cond = "Stun"

sendOpcodeStatusInfo(cid)
setPlayerStorageValue(cid, conds["Silence"], 2)
local function sendAtk(cid)
   if isCreature(cid) then
      setPlayerStorageValue(cid, conds["Silence"], -1)
      sendOpcodeStatusInfo(cid)
      if isMega(cid) then
         doSetCreatureOutfit(cid, {lookType = 2050}, -1)
      else
         doRemoveCondition(cid, CONDITION_OUTFIT)
      end
      setPlayerStorageValue(cid, 9658783, -1)
      local dmgType = PSYCHICDAMAGE
      for i = 0, 4 do
         if isInArray({"Alakazam"}, doCorrectString(getCreatureName(cid))) then
            addEvent(doMoveInArea2, i * 400, cid, 579, areas[i + 1], dmgType, min, max, spell, ret)
            addEvent(doMoveInArea2, i * 410, cid, 579, areas[i + 1], dmgType, 0, 0, spell)
         else
            addEvent(doMoveInArea2, i * 400, cid, 264, areas[i + 1], dmgType, min, max, spell, ret)
            addEvent(doMoveInArea2, i * 410, cid, 264, areas[i + 1], dmgType, 0, 0, spell)
         end
      end
   end
end

local outT = {
   ["Slowking"] = 463,
   ["Xatu"] = 976,
   ["Shiny Xatu"] = 1813,
   ["Shiny Alakazam"] = 582,
   ["Alakazam"] = 2058
}
if outT[getCreatureName(cid)] then
   doSetCreatureOutfit(cid, {lookType = outT[getCreatureName(cid)]}, -1)
end
setPlayerStorageValue(cid, 9658783, 1)
addEvent(sendAtk, 2000, cid)


elseif spell == "Heal Bell" then

if isSummon(cid) then
   doClearBallStatus(getPlayerSlotItem(getCreatureMaster(cid), 8).uid)
end
doClearPokemonStatus(cid)

local areas = {rock1, rock2, rock3, rock4, rock5, rock1, rock2, rock3, rock4, rock5, rock1, rock2, rock3, rock4, rock5, rock1, rock2, rock3, rock4, rock5, rock1, rock2, rock3, rock4, rock5}
local ret = {}
ret.id = cid
ret.cd = 10
ret.eff = 0
ret.check = 0
ret.buff = spell
ret.first = true

doCondition2(ret)

for i = 0, 22 do
   addEvent(doMoveInArea2, i*400, cid, 33, areas[i+1], NORMALDAMAGE, 0, 0, spell)
end

elseif spell == "Ground Crusher" then

local pos = getThingPosWithDebug(cid)
local areas = {rock1, rock2, rock3, rock4, rock5}
local ret = {}
ret.id = 0
ret.attacker = cid
ret.cd = 12
ret.eff = 0
ret.check = 0
ret.spell = spell
ret.cond = "Stun"

local function endMove(cid)
   if isCreature(cid) then
      doRemoveCondition(cid, CONDITION_OUTFIT)
   end
end

doSetCreatureOutfit(cid, {lookType = 1449}, -1)
stopNow(cid, 16*360)
addEvent(endMove, 16*360, cid)
----
for i = 0, 4 do
   addEvent(doMoveInArea2, i*350, cid, 100, areas[i+1], GROUNDDAMAGE, min, max, spell, ret)
   addEvent(doMoveInArea2, i*360, cid, 100, areas[i+1], GROUNDDAMAGE, 0, 0, spell, ret)
end
for i = 4, 8 do
   local a = i-3
   addEvent(doMoveInArea2, i*350, cid, 100, areas[a], GROUNDDAMAGE, min, max, spell, ret)
   addEvent(doMoveInArea2, i*360, cid, 100, areas[a], GROUNDDAMAGE, 0, 0, spell, ret)
end
for i = 8, 12 do
   local a = i-7
   addEvent(doMoveInArea2, i*350, cid, 100, areas[a], GROUNDDAMAGE, min, max, spell, ret)
   addEvent(doMoveInArea2, i*360, cid, 100, areas[a], GROUNDDAMAGE, 0, 0, spell, ret)
end
for i = 12, 16 do
   local a = i-11
   addEvent(doMoveInArea2, i*350, cid, 100, areas[a], GROUNDDAMAGE, min, max, spell, ret)
   addEvent(doMoveInArea2, i*360, cid, 100, areas[a], GROUNDDAMAGE, 0, 0, spell, ret)
end
for i = 16, 20 do
   local a = i-15
   addEvent(doMoveInArea2, i*350, cid, 100, areas[a], GROUNDDAMAGE, min, max, spell, ret)
   addEvent(doMoveInArea2, i*360, cid, 100, areas[a], GROUNDDAMAGE, 0, 0, spell, ret)
end

elseif spell == "Stored Power" then
-- local p = getThingPosWithDebug(cid)
-- doSendMagicEffect({x=p.x+1, y=p.y, z=p.z}, 289)
-- addEvent(doMoveInArea2, 1400, cid, 54, storedArea1, PSYCHICDAMAGE, min, max, spell)
-- addEvent(doMoveInArea2, 1400, cid, 220, storedArea2, PSYCHICDAMAGE, min, max, spell)

doAreaCombatHealth(cid, PSYCHICDAMAGE, getThingPosWithDebug(cid), storedArea1, -min, -max, 253)
doAreaCombatHealth(cid, PSYCHICDAMAGE, getThingPosWithDebug(cid), storedArea2, -min, -max, 426)

elseif spell == "Psy Impact" then
local master = getCreatureMaster(cid) or 0
local ret = {}
ret.id = 0
ret.attacker = cid
ret.cd = 9
ret.eff = 0
ret.check = 0
ret.spell = spell
ret.cond = "Miss"

for rocks = 1, 20 do
   addEvent(fall, rocks * 55, cid, master, PSYCHICDAMAGE, -1, math.random(670, 675))
end

addEvent(doMoveInArea2, 500, cid, -1, BigArea2, PSYCHICDAMAGE, min, max, spell, ret) --Verificar esse -1 se não dá merda.

elseif spell == "Two Face Shock" then

local atk = {
   [1] = {179, ICEDAMAGE},
   [2] = {127, GROUNDDAMAGE}
}

local rand = math.random(1, 2)

doAreaCombatHealth(cid, atk[rand][2], getThingPosWithDebug(cid), splash, -min, -max, 255)

local sps = getThingPosWithDebug(cid)
sps.x = sps.x+1
sps.y = sps.y+1
doSendMagicEffect(sps, atk[rand][1])


elseif spell == "Boomburst" then

local pos = getThingPosWithDebug(cid)
local poses = {{},{},{},{},{},{},{}}
local impar = {1,3,5,7,9,11}

for x=-3,3 do
   for y=-3,3 do
      table.insert(poses[x+4], {x=pos.x+x,y=pos.y+y,z=pos.z})
   end
end

local function sendDmg(cid, pos, eff)
   if not isCreature(cid) then return true end
   local poseff = {x=pos.x+1,y=pos.y+1,z=pos.z}
   doAreaCombatHealth(cid, NORMALDAMAGE, pos, 1, -min, -max, 255)
   doSendMagicEffect(poseff, eff)
end

for i,v in pairs(poses) do
   for u=1,#v do
      addEvent(sendDmg,1000+i*250,cid,v[u],(isInArray(impar, u) and isInArray(impar, i)) and 288 or 255)
   end
end

doDisapear(cid)
addEvent(doAppear,1000,cid)
doSendMagicEffect(pos, 400)

elseif spell == "Stealth Rock" then
local rockids = {3650}
local poss = {}
local impar = {1,3,5,7,9,11,13,15,17,19,21,23,25,27,29,31,33,35,37,39,41,43,45,47,49,51,53,55,57,59,61,63,65,67,69,71,73,75,77,79,81,83,85,87,89}
local pos = getThingPosWithDebug(cid)
local counter = 0

for x=-7,7 do
   for y=-5,5 do
      counter = counter + 1
      if math.ceil(counter/2) ~= counter/2 then
         table.insert(poss, {x=pos.x+x,y=pos.y+y,z=pos.z})
      end
   end
end

function removeStones(pos)
   local t = getTileItemById(pos, 3650)
   if t then
      doRemoveItem(t.uid, 1)
      doSendMagicEffect(pos, 3)
   end
end

for i,topos in pairs(poss) do
   doSendDistanceShoot(getThingPosWithDebug(cid), topos, 11)
   if isWalkable(topos) then
      local stone = doCreateItem(rockids[math.random(#rockids)], topos)
      if isSummon(cid) then
         doItemSetAttribute(stone, "attacker", getCreatureName(getCreatureMaster(cid)))
      end
      doItemSetAttribute(stone, "min", min)
      doItemSetAttribute(stone, "max", max)
      addEvent(removeStones, 20000, topos)
      doSendMagicEffect(topos, 44)
   end
end

elseif spell == "Heat Wave" then
local poses = {}
local impar = {
   1,
   3,
   5,
   7,
   9,
   11,
   13,
   15,
   17,
   19,
   21,
   23,
   25,
   27,
   29,
   31,
   33,
   35,
   37,
   39,
   41,
   43,
   45,
   47,
   49,
   51,
   53,
   55,
   57,
   59,
   61,
   63,
   65,
   67,
   69,
   71,
   73,
   75,
   77,
   79,
   81,
   83,
   85,
   87,
   89
}
local pos = getThingPosWithDebug(cid)

for x = -4, 4 do
   for y = -4, 4 do
      table.insert(poses, {x = pos.x + x, y = pos.y + y, z = pos.z})
   end
end

local function sendDmg(cid, pos, eff)
   if not isCreature(cid) then
      return true
   end
   doAreaCombatHealth(cid, FIREDAMAGE, pos, 0, -min, -max, 1392)
   doSendMagicEffect(pos, eff)
end

local rounds, interval = 19, 600

for x = 0, rounds do
   for i, v in pairs(poses) do
      addEvent(sendDmg, x * interval, cid, v, isInArray(impar, i) and 1392 or 503)
   end
end

if getCreatureName(cid) == "Torkoal" then
   doSetCreatureOutfit(cid, {lookType = 2202}, -1)
   addEvent(doRemoveCondition, rounds * interval, cid, CONDITION_OUTFIT)
   doRaiseStatus(cid, 1.5, 1.5, 200, rounds)
end

    elseif spell == "Sky Attack" then
        for rocks = 1, 40 do
            addEvent(fall, rocks * 25, cid, master, FLYINGDAMAGE, -1, 934)
        end
        doAreaCombatHealth(cid, FLYINGDAMAGE, getThingPosWithDebug(cid), BigArea2New, -min, -max, -1)

elseif spell == "Head Smash" then
	-- upEffect(cid, 158)
	-- addEvent(downEffect, 1000, cid, 158)
	addEvent(doMoveInArea2, 1000, cid, 1396, headSmash, ROCKDAMAGE, min, max, spell)

elseif spell == "Creepy Lick" then	
	local ret = {}
	ret.id = target
	ret.attacker = cid
	ret.cd = 10
	ret.eff = 1392
	ret.check = 0
	ret.spell = spell
	ret.cond = "Paralyze"
	local pos = getThingPos(target)
	-- pos.x = pos.x 
	pos.y = pos.y
	doSendMagicEffect(pos, 1398)
	doTeleportThing(cid, pos, false)
	doMoveDano2(cid, target, NORMALDAMAGE, 0, 0, ret, spell)
	
elseif spell == "Superpower" then
	local pos2 = getThingPosWithDebug(cid)
	pos2.x = pos2.x + 3
	pos2.y = pos2.y + 3
	doSendMagicEffect(pos2, 1036)
	local pos = getThingPosWithDebug(cid)
	pos.x = pos.x + 3
	pos.y = pos.y + 2
	addEvent(doSendMagicEffect, 500, pos, 1310)
local function doSendMove(cid, turn)
   if not isCreature(cid) then
      return true
   end
   local turn = turn or 1
   local event = addEvent(doSendMove, 200, cid, turn + 1)
   -- local area1 = {square4x4, square4x4, square4x4, square4x4, square4x4, square4x4, square4x4, square4x4, square4x4}
   -- local eff = {278, 53, 68, 290, 278}
   doAreaCombatHealth(cid, FIGHTINGDAMAGE, getThingPosWithDebug(cid), square4x4, -min, -max, 1392)
   if turn == 9 then
      stopEvent(event)
   end
end
addEvent(doSendMove, 700, cid)

elseif spell == "Aerial Ace" then
-- addEvent(doMoveInArea2, 1000, cid, -1, BigArea2, FLYINGDAMAGE, min, max, spell)
local eff = {286, 287, 288, 289}

for rocks = 1, 40 do
   addEvent(fall, rocks * 25, cid, master, FLYINGDAMAGE, -1, eff[math.random(1, 4)])
end
addEvent(doAreaCombatHealth, 1000, cid, FLYINGDAMAGE, getThingPosWithDebug(cid), BigArea2New, -min, -max, -1)

elseif spell == "Electro Field" or spell == "Petal Tornado" or spell == "Flame Wheel" or spell == "Bug Buzz" then --alterado v1.8
        local atk = {
            --[atk] = {distance, eff, damage}
            ["Electro Field"] = {41, 207, ELECTRICDAMAGE},
            ["Petal Tornado"] = {14, 54, GRASSDAMAGE},
            ["Flame Wheel"] = {3, 6, FIREDAMAGE}, --alterado v1.9
            ["Bug Buzz"] = {39, 86, BUGDAMAGE}
        }

        local function sendDist(cid, posi1, posi2, eff, delay, j, i)
            if posi1 and posi2 and isCreature(cid) then
                addEvent(sendDistanceShootWithProtect, delay, cid, posi1, posi2, eff) --alterado v1.6
            end
        end

        local function sendDano(cid, pos, eff, delay, min, max, j, i)
            if pos and isCreature(cid) then
                addEvent(doDanoWithProtect, delay, cid, atk[spell][3], pos, 0, -min, -max, eff, ret) --alterado v1.6
            end
        end

        local function doTornado(cid)
            if not isCreature(cid) then
                return true
            end
            local p = getThingPosWithDebug(cid)
            local pos1 = {
                [1] = {
                    {x = p.x, y = p.y + 4, z = p.z},
                    {x = p.x + 1, y = p.y + 4, z = p.z},
                    {x = p.x + 2, y = p.y + 3, z = p.z},
                    {x = p.x + 3, y = p.y + 2, z = p.z},
                    {x = p.x + 4, y = p.y + 1, z = p.z},
                    {x = p.x + 4, y = p.y, z = p.z}
                },
                [2] = {
                    {x = p.x, y = p.y + 3, z = p.z},
                    {x = p.x + 1, y = p.y + 3, z = p.z},
                    {x = p.x + 2, y = p.y + 2, z = p.z},
                    {x = p.x + 3, y = p.y + 1, z = p.z},
                    {x = p.x + 3, y = p.y, z = p.z}
                },
                [3] = {
                    {x = p.x, y = p.y + 2, z = p.z},
                    {x = p.x + 1, y = p.y + 2, z = p.z},
                    {x = p.x + 2, y = p.y + 1, z = p.z},
                    {x = p.x + 2, y = p.y, z = p.z}
                },
                [4] = {
                    {x = p.x, y = p.y + 1, z = p.z},
                    {x = p.x + 1, y = p.y + 1, z = p.z},
                    {x = p.x + 1, y = p.y, z = p.z}
                }
            }

            local pos2 = {
                [1] = {
                    {x = p.x, y = p.y - 4, z = p.z},
                    {x = p.x - 1, y = p.y - 4, z = p.z},
                    {x = p.x - 2, y = p.y - 3, z = p.z},
                    {x = p.x - 3, y = p.y - 2, z = p.z},
                    {x = p.x - 4, y = p.y - 1, z = p.z},
                    {x = p.x - 4, y = p.y, z = p.z}
                },
                [2] = {
                    {x = p.x, y = p.y - 3, z = p.z},
                    {x = p.x - 1, y = p.y - 3, z = p.z},
                    {x = p.x - 2, y = p.y - 2, z = p.z},
                    {x = p.x - 3, y = p.y - 1, z = p.z},
                    {x = p.x - 3, y = p.y, z = p.z}
                },
                [3] = {
                    {x = p.x, y = p.y - 2, z = p.z},
                    {x = p.x - 1, y = p.y - 2, z = p.z},
                    {x = p.x - 2, y = p.y - 1, z = p.z},
                    {x = p.x - 2, y = p.y, z = p.z}
                },
                [4] = {
                    {x = p.x, y = p.y - 1, z = p.z},
                    {x = p.x - 1, y = p.y - 1, z = p.z},
                    {x = p.x - 1, y = p.y, z = p.z}
                }
            }

            local pos3 = {
                [1] = {
                    {x = p.x + 4, y = p.y, z = p.z},
                    {x = p.x + 4, y = p.y - 1, z = p.z},
                    {x = p.x + 3, y = p.y - 2, z = p.z},
                    {x = p.x + 2, y = p.y - 3, z = p.z},
                    {x = p.x + 1, y = p.y - 4, z = p.z},
                    {x = p.x, y = p.y - 4, z = p.z}
                },
                [2] = {
                    {x = p.x + 3, y = p.y, z = p.z},
                    {x = p.x + 3, y = p.y - 1, z = p.z},
                    {x = p.x + 2, y = p.y - 2, z = p.z},
                    {x = p.x + 1, y = p.y - 3, z = p.z},
                    {x = p.x, y = p.y - 3, z = p.z}
                },
                [3] = {
                    {x = p.x + 2, y = p.y, z = p.z},
                    {x = p.x + 2, y = p.y - 1, z = p.z},
                    {x = p.x + 1, y = p.y - 2, z = p.z},
                    {x = p.x, y = p.y - 2, z = p.z}
                },
                [4] = {
                    {x = p.x + 1, y = p.y, z = p.z},
                    {x = p.x + 1, y = p.y - 1, z = p.z},
                    {x = p.x, y = p.y - 1, z = p.z}
                }
            }

            local pos4 = {
                [1] = {
                    {x = p.x - 4, y = p.y, z = p.z},
                    {x = p.x - 4, y = p.y + 1, z = p.z},
                    {x = p.x - 3, y = p.y + 2, z = p.z},
                    {x = p.x - 2, y = p.y + 3, z = p.z},
                    {x = p.x - 1, y = p.y + 4, z = p.z},
                    {x = p.x, y = p.y + 4, z = p.z}
                },
                [2] = {
                    {x = p.x - 3, y = p.y, z = p.z},
                    {x = p.x - 3, y = p.y + 1, z = p.z},
                    {x = p.x - 2, y = p.y + 2, z = p.z},
                    {x = p.x - 1, y = p.y + 3, z = p.z},
                    {x = p.x, y = p.y + 3, z = p.z}
                },
                [3] = {
                    {x = p.x - 2, y = p.y, z = p.z},
                    {x = p.x - 2, y = p.y + 1, z = p.z},
                    {x = p.x - 1, y = p.y + 2, z = p.z},
                    {x = p.x, y = p.y + 2, z = p.z}
                },
                [4] = {
                    {x = p.x - 1, y = p.y, z = p.z},
                    {x = p.x - 1, y = p.y + 1, z = p.z},
                    {x = p.x, y = p.y + 1, z = p.z}
                }
            }

            for j = 1, 4 do
                for i = 1, 6 do --41/207  -- 14/54
                    addEvent(sendDist, 350, cid, pos1[j][i], pos1[j][i + 1], atk[spell][1], i * 330)
                    addEvent(sendDano, 350, cid, pos1[j][i], atk[spell][2], i * 300, min, max)
                    addEvent(sendDano, 350, cid, pos1[j][i], atk[spell][2], i * 310, 0, 0)
                    ---
                    addEvent(sendDist, 350, cid, pos2[j][i], pos2[j][i + 1], atk[spell][1], i * 330)
                    addEvent(sendDano, 350, cid, pos2[j][i], atk[spell][2], i * 300, min, max)
                    addEvent(sendDano, 350, cid, pos2[j][i], atk[spell][2], i * 310, 0, 0)
                    ----
                    addEvent(sendDist, 800, cid, pos3[j][i], pos3[j][i + 1], atk[spell][1], i * 330)
                    addEvent(sendDano, 800, cid, pos3[j][i], atk[spell][2], i * 300, min, max)
                    addEvent(sendDano, 800, cid, pos3[j][i], atk[spell][2], i * 310, 0, 0)
                    ---
                    addEvent(sendDist, 800, cid, pos4[j][i], pos4[j][i + 1], atk[spell][1], i * 330)
                    addEvent(sendDano, 800, cid, pos4[j][i], atk[spell][2], i * 300, min, max)
                    addEvent(sendDano, 800, cid, pos4[j][i], atk[spell][2], i * 310, 0, 0)
                end
            end
        end

        if spell == "Electro Field" then
            addEvent(doMoveInArea2, 1000, cid, 0, electro, ELECTRICDAMAGE, 0, 0, spell, ret)
        end

        if spell == "Bug Buzz" then
            local ret = {}
            ret.id = target
            ret.attacker = cid
            ret.cd = 9
            ret.eff = 86
            ret.check = 0
            ret.spell = spell
            ret.cond = "Stun"
            addEvent(doMoveInArea2, 1000, cid, 0, electro, BUGDAMAGE, 0, 0, spell, ret)
        end

        for b = 0, 2 do
            addEvent(doTornado, b * 1500, cid)
        end

elseif spell == "Echoed Voice" then
local p = getThingPosWithDebug(cid)
local d = isCreature(target) and getCreatureDirectionToTarget(cid, target) or getCreatureLookDir(cid)

function sendAtk(cid, area)
   if isCreature(cid) then
      if not isSightClear(p, area, false) then
         return true
      end
      doAreaCombatHealth(cid, NORMALDAMAGE, area, pulse2, -min, -max, 1392)
      doAreaCombatHealth(cid, ROCKDAMAGE, area, pulse1, 0, 0, 39)
   end
end

for a = 0, 5 do
   local t = {
      [0] = {39, {x = p.x, y = p.y - (a + 1), z = p.z}},
      [1] = {39, {x = p.x + (a + 1), y = p.y, z = p.z}},
      [2] = {39, {x = p.x, y = p.y + (a + 1), z = p.z}},
      [3] = {39, {x = p.x - (a + 1), y = p.y, z = p.z}}
   }
   addEvent(sendAtk, 400 * a, cid, t[d][2])
end

elseif spell == "Electro Field" then
local function doSendMove(cid, turn)
   if not isCreature(cid) then
      return true
   end
   local turn = turn or 1
   local event = addEvent(doSendMove, 150, cid, turn + 1)
   local area1 = {
      flare1,
      flare2,
      flare3,
      flare4,
      flare5,
      flare6,
      flare1,
      flare2,
      flare3,
      flare4,
      flare5,
      flare6,
      flare1,
      flare2,
      flare3,
      flare4,
      flare5,
      flare6,
      flare1,
      flare2,
      flare3,
      flare4,
      flare5,
      flare6,
      flare1
   }
   local eff = {207,207,207,207,207,207,207,207,207,207,207,207,207,207,207,207,207,207,207,207,207,207,207,207,207}
   doAreaCombatHealth(cid, ELECTRICDAMAGE, getThingPosWithDebug(cid), area1[turn], -min, -max, eff[turn])
   if turn == 24 or isSleeping(cid) then
      stopEvent(event)
   end
end
doSendMove(cid)

   elseif spell == "Waterfall" then
	local myPos = getThingPosWithDebug(cid)
    local area1 = {WF11, WF12, WF13, WF14, WF15, WF16, WF17, WF18}
    local area2 = {WF21, WF22, WF23, WF24, WF25, WF26, WF27, WF28, WF29, WF210, WF211, WF212, WF213, WF214, WF215, WF216}
    local area3 = {WF31, WF32, WF33, WF34, WF35, WF36, WF37, WF38, WF39, WF310, WF311, WF312, WF313, WF314, WF315, WF316, WF317, WF318, WF319, WF320, WF321, WF322, WF323, WF324}
    for i = 0, 7 do
        addEvent(doAreaCombatHealth, i * 300, cid, WATERDAMAGE, myPos, area1[i+1], -min, -max, 290)
    end
    for i = 0, 15 do
        addEvent(doAreaCombatHealth, i * 160, cid, WATERDAMAGE, myPos, area2[i+1], -min, -max, 290)
    end
    for i = 0, 23 do
        addEvent(doAreaCombatHealth, i * 110, cid, WATERDAMAGE, myPos, area3[i+1], -min, -max, 290)
    end



elseif spell == "Flare Blitz" then
local function doSendMove(cid, turn)
   if not isCreature(cid) then
      return true
   end
   local turn = turn or 1
   local event = addEvent(doSendMove, 100, cid, turn + 1)
   local area1 = {
      flare1,
      flare2,
      flare3,
      flare4,
      flare5,
      flare6,
      flare1,
      flare2,
      flare3,
      flare4,
      flare5,
      flare6,
      flare1,
      flare2,
      flare3,
      flare4,
      flare5,
      flare6,
      flare1,
      flare2,
      flare3,
      flare4,
      flare5,
      flare6,
      flare1
   }
   doAreaCombatHealth(cid, FIREDAMAGE, getThingPosWithDebug(cid), area1[turn], -min, -max, 483)
   -- doAreaCombatHealth(cid, STATUS_BURN10, myPos, area1[turn], -min, -max, 1392)
   if turn == 24 or isSleeping(cid) then
      stopEvent(event)
   end
end
doSendMove(cid)

elseif spell == "Leaf Tornado" then
local function doSendMove(cid, turn)
   if not isCreature(cid) then
      return true
   end
   local turn = turn or 1
   local event = addEvent(doSendMove, 150, cid, turn + 1)
   local area1 = {
      flare1,
      flare2,
      flare3,
      flare4,
      flare5,
      flare6,
      flare1,
      flare2,
      flare3,
      flare4,
      flare5,
      flare6,
      flare1,
      flare2,
      flare3,
      flare4,
      flare5,
      flare6,
      flare1,
      flare2,
      flare3,
      flare4,
      flare5,
      flare6,
      flare1
   }
   -- local frompos = getThingPosWithDebug(cid)
   -- doSendDistanceShoot(frompos, getPosfromArea(cid, headSmash), 14)
   doAreaCombatHealth(cid, GRASSDAMAGE, getThingPosWithDebug(cid), area1[turn], -min, -max, 253)
   if turn == 24 or isSleeping(cid) then
      stopEvent(event)
   end
end
doSendMove(cid)

elseif spell == "Seed Bomb" then --alterado v1.6
local master = isSummon(cid) and getCreatureMaster(cid) or cid

local function doFall(cid)
   for rocks = 1, 42 do --62
      addEvent(fall, rocks * 35, cid, master, GRASSDAMAGE, 1, 405)
   end
end

for up = 1, 10 do
   addEvent(upEffect, up * 75, cid, 1)
end
addEvent(doFall, 450, cid)

addEvent(doMoveAreaWithSteal, 1400, cid, pullArea, GRASSDAMAGE, spell, min, max, -1)
elseif spell == "Normal Passive" then
	doAreaCombatHealth(cid, NORMALDAMAGE, getThingPosWithDebug(cid), circle3x3, -min, -max, 3)
elseif spell == "Fire Passive" then
	if isInArray({"Shiny Magmortar", "Shiny Ninetales"}, doCorrectString(getCreatureName(cid))) then
		doAreaCombatHealth(cid, FIREDAMAGE, getThingPosWithDebug(cid), circle3x3, -min, -max, 584)
	else
		doAreaCombatHealth(cid, FIREDAMAGE, getThingPosWithDebug(cid), circle3x3, -min, -max, 15)
	end
elseif spell == "Fighting Passive" then
	doAreaCombatHealth(cid, FIGHTINGDAMAGE, getThingPosWithDebug(cid), circle3x3, -min, -max, 112)
elseif spell == "Water Passive" then
	doAreaCombatHealth(cid, WATERDAMAGE, getThingPosWithDebug(cid), circle3x3, -min, -max, 290)
elseif spell == "Flying Passive" then
	doAreaCombatHealth(cid, FLYINGDAMAGE, getThingPosWithDebug(cid), circle3x3, -min, -max, 42)
elseif spell == "Grass Passive" then
	doAreaCombatHealth(cid, GRASSDAMAGE, getThingPosWithDebug(cid), circle3x3, -min, -max, 46)
elseif spell == "Poison Passive" then
	doAreaCombatHealth(cid, POISONDAMAGE, getThingPosWithDebug(cid), circle3x3, -min, -max, 6)
elseif spell == "Electric Passive" then
	doAreaCombatHealth(cid, ELECTRICDAMAGE, getThingPosWithDebug(cid), circle3x3, -min, -max, 554)
elseif spell == "Ground Passive" then
	doAreaCombatHealth(cid, GROUNDDAMAGE, getThingPosWithDebug(cid), circle3x3, -min, -max, 118)
elseif spell == "Psychic Passive" then
	doAreaCombatHealth(cid, PSYCHICDAMAGE, getThingPosWithDebug(cid), circle3x3, -min, -max, 6)
elseif spell == "Rock Passive" then
	doAreaCombatHealth(cid, ROCKDAMAGE, getThingPosWithDebug(cid), circle3x3, -min, -max, 6)
elseif spell == "Ice Passive" then
	doAreaCombatHealth(cid, ICEDAMAGE, getThingPosWithDebug(cid), circle3x3, -min, -max, 43)
elseif spell == "Bug Passive" then
	doAreaCombatHealth(cid, BUGDAMAGE, getThingPosWithDebug(cid), circle3x3, -min, -max, 487)
elseif spell == "Dragon Passive" then
	doAreaCombatHealth(cid, DRAGONDAMAGE, getThingPosWithDebug(cid), circle3x3, -min, -max, 6)
elseif spell == "Ghost Passive" then
	doAreaCombatHealth(cid, GHOSTDAMAGE, getThingPosWithDebug(cid), circle3x3, -min, -max, 1097)
elseif spell == "Dark Passive" then
	doAreaCombatHealth(cid, DARKDAMAGE, getThingPosWithDebug(cid), circle3x3, -min, -max, 552)
elseif spell == "Steel Passive" then
	doAreaCombatHealth(cid, STEELDAMAGE, getThingPosWithDebug(cid), circle3x3, -min, -max, 258)
elseif spell == "Fairy Passive" then
	doAreaCombatHealth(cid, FAIRYDAMAGE, getThingPosWithDebug(cid), circle3x3, -min, -max, 428)
elseif spell == "Crystal Passive" then
	doAreaCombatHealth(cid, CRYSTALDAMAGE, getThingPosWithDebug(cid), circle3x3, -min, -max, 6)

	elseif spell == "Burn Up" then
		local pos = getThingPosWithDebug(cid)
		pos.x = pos.x + 3
		pos.y = pos.y + 3
		doSendMagicEffect(pos, 1401)
		local ret = {}
		ret.id = 0
		ret.attacker = cid
		ret.cd = 6
		ret.check = 0
		ret.eff = 438
		ret.spell = spell
		ret.cond = "Stun"

        doMoveInArea2(cid, 1392, burnUp, FIREDAMAGE, -min, -max, spell, ret)
	elseif spell == "Burning Jealousy" then
		local pos = getThingPosWithDebug(cid)
		pos.x = pos.x + 3
		pos.y = pos.y + 3
		doSendMagicEffect(pos, 1400)
		local ret = {}
		ret.id = 0
		ret.attacker = cid
		ret.cd = 6
		ret.check = 0
		ret.eff = 438
		ret.spell = spell
		ret.cond = "Stun"

        doMoveInArea2(cid, 1392, burnUp, FIREDAMAGE, -min, -max, spell, ret)
		
	elseif spell == "Hellfire Storm" then
		local master = isSummon(cid) and getCreatureMaster(cid) or cid
		local function doFall(cid)
		for rocks = 0, 60 do --62
			addEvent(fall, rocks * 35, cid, master, FIREDAMAGE, 3, 15)
		end
		end
		doFall(cid)
		local function doSendMove(cid, turn)
			if not isCreature(cid) then
				return true
			end
		local turn = turn or 1
		local event = addEvent(doSendMove, 350, cid, turn + 1)
		-- local eff = {278, 53, 68, 290, 278}
		doAreaCombatHealth(cid, FIREDAMAGE, getThingPosWithDebug(cid), BigArea2New, -min, -max, 1392)
		if turn == 3 then
			stopEvent(event)
		end
		end
		doSendMove(cid)
		-- doAreaCombatHealth(cid, FIREDAMAGE, getThingPosWithDebug(cid), BigArea2New, -min, -max, -1)
	

elseif spell == "Reverse Earthshock" then

local p = getThingPosWithDebug(cid)
p.x = p.x+1
p.y = p.y+1

sendEffWithProtect(cid, p, 151)   --send eff

local function doDano(cid)
   local pos = getThingPosWithDebug(cid)

   local function doSendBubble(cid, pos)
      if not isCreature(cid) then return true end
      doSendDistanceShoot(getThingPosWithDebug(cid), pos, 39)
      doSendMagicEffect(pos, 239)
   end
   --alterado!!
   for a = 1, 20 do
      local r1 = math.random(-4, 4)
      local r2 = r1 == 0 and choose(-3, -2, -1, 2, 3) or math.random(-3, 3)
      --
      local lugar = {x = pos.x + r1, y = pos.y + r2, z = pos.z}
      addEvent(doSendBubble, a * 25, cid, lugar)
   end

   addEvent(doDanoWithProtect, 150, cid, GROUNDDAMAGE, pos, waterarea, -min, -max, 0)
end

addEvent(doDano, 1250, cid)


    elseif spell == "Fury Swipes" then
        doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 23)
        doDanoInTargetWithDelay(cid, target, NORMALDAMAGE, min, max, 268)
	elseif spell == "Poison Jab" then
		doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 15)
		doDanoInTargetWithDelay(cid, target, POISONDAMAGE, min, max, 275)
    elseif spell == "Cross Poison" then
        local ret = {}
        ret.cd = 10
        ret.eff = 8
        ret.damage = pbdmg
        ret.cond = "Poison"

        doMoveInArea2(cid, 275, crossPoison, POISONDAMAGE, -min, -max, spell, ret)


elseif spell == "Hydro Dance" then
local function doSendMove(cid, turn)
   if not isCreature(cid) then
      return true
   end
   local turn = turn or 1
   local event = addEvent(doSendMove, 400, cid, turn + 1)
   local area1 = {waterSpout1, waterSpout2, waterSpout3, waterSpout4, waterSpout5}
   local eff = {278, 53, 68, 290, 278}
   doAreaCombatHealth(cid, WATERDAMAGE, getThingPosWithDebug(cid), area1[turn], -min, -max, eff[turn])
   if turn == 5 then
      stopEvent(event)
   end
end
doSendMove(cid)

local mpos = getThingPosWithDebug(cid)
mpos.x = mpos.x + 1
mpos.y = mpos.y + 1
doSendMagicEffect(mpos, 683)

elseif spell == "Counter Spin" then

local function doSendMove(cid, turn)
	if not isCreature(cid) then
		return true
	end
	local turn = turn or 1
	local event = addEvent(doSendMove, 400, cid, turn + 1)
	-- doAreaCombatHealth(cid, FIGHTINGDAMAGE, getThingPosWithDebug(cid), square1x1, -min, -max, 1392)
      doAreaCombatHealth(cid, FIGHTINGDAMAGE, getThingPosWithDebug(cid), square1x1, -min, -max, 1392) --alterado v1.6.1
      doAreaCombatHealth(cid, nil, getThingPosWithDebug(cid), scythe1, 0, 0, 259) --cima
      doAreaCombatHealth(cid, nil, getThingPosWithDebug(cid), scythe2, 0, 0, 260) --baixo
      doAreaCombatHealth(cid, nil, getThingPosWithDebug(cid), scythe3, 0, 0, 261) --direita
      doAreaCombatHealth(cid, nil, getThingPosWithDebug(cid), scythe4, 0, 0, 262)  --esquerda
	doSetCreatureOutfit(cid, {lookType = 1156}, -1)
	if turn == 10 or isSleeping(cid) then
		doRemoveCondition(cid, CONDITION_OUTFIT)
		stopEvent(event)
	end
end
doSendMove(cid)


elseif spell == "Stick Throw" then

local area = {Throw01, Throw02, Throw03, Throw04, Throw03, Throw02, Throw01}

local ret = {}
ret.id = 0
ret.attacker = cid
ret.cd = 9
ret.check = 0
ret.eff = 0
ret.spell = spell
ret.cond = "Stun"

stopNow(cid, 2000)
doMoveInArea2(cid, 212, reto5, FLYINGDAMAGE, min, max, spell, ret)

elseif spell == "Skull Bash" then
doMoveInArea2(cid, -1, triplo6, NORMALDAMAGE, min, max, spell, ret)
local ret = {}
ret.id = 0
ret.attacker = cid
ret.cd = 5
ret.check = 0
ret.eff = 439 
ret.spell = spell
ret.cond = "Stun" 

stopNow(cid, 500)
doMoveInArea2(cid, 439, reto5, NORMALDAMAGE , 0, 0, spell, ret)

   elseif spell == "Gyro Ball" then

      local p = getThingPosWithDebug(cid)
      local d = isCreature(target) and getCreatureDirectionToTarget(cid, target) or getCreatureLookDir(cid)

      function sendAtk(cid, area, eff)
         if isCreature(cid) then
            if not isSightClear(p, area, false) then return true end
            doAreaCombatHealth(cid, STEELDAMAGE, area, 0, 0, 0, eff)
            doAreaCombatHealth(cid, STEELDAMAGE, area, whirl3, -min, -max, 258)
         end
      end

      for a = 0, 4 do

         local t = {                                     --alterado v1.4
            [0] = {538, {x=p.x, y=p.y-(a+1), z=p.z}},
            [1] = {538, {x=p.x+(a+1), y=p.y, z=p.z}},
            [2] = {538, {x=p.x, y=p.y+(a+1), z=p.z}},
            [3] = {538, {x=p.x-(a+1), y=p.y, z=p.z}}
         }
         addEvent(sendAtk, 300*a, cid, t[d][2], t[d][1])
      end

elseif spell == "Rock Tomb" then

local ret = {}
ret.id = target
ret.attacker = cid
ret.cd = 9
ret.eff = 0
ret.check = getPlayerStorageValue(target, conds["Slow"])
ret.first = true
ret.cond = "Slow"

local function doRockFall(cid, frompos, target)
   if not isCreature(target) or not isCreature(cid) then return true end
   local pos = getThingPosWithDebug(target)
   local ry = math.abs(frompos.y - pos.y)
   doSendDistanceShoot(frompos, pos, 39)
   addEvent(doMoveDano2, ry * 11, cid, target, ROCKDAMAGE, min, max, ret, spell)
   addEvent(sendEffWithProtect, ry*11, cid, pos, 157)
end

local function doRockUp(cid, target)
   if not isCreature(target) or not isCreature(cid) then return true end
   local pos = getThingPosWithDebug(target)
   local mps = getThingPosWithDebug(cid)
   local xrg = math.floor((pos.x - mps.x) / 2)
   local topos = mps
   topos.x = topos.x + xrg
   local rd =  7
   topos.y = topos.y - rd
   doSendDistanceShoot(getThingPosWithDebug(cid), topos, 39)
   addEvent(doRockFall, rd * 49, cid, topos, target)
end
addEvent(doRockUp, 155, cid, target)

	elseif spell == "Sand Tomb" then
	  	local myPos = getThingPosWithDebug(cid)
		doFrontalCombatHealth(cid, myPos, GROUNDDAMAGE, min, max, 341, 22)
		doFrontalCombatHealth(cid, myPos, STATUS_BLIND, 34, 34, -1, -1)

	elseif spell == "Magnet Bomb" then
	  	local myPos = getThingPosWithDebug(cid)
		doFrontalCombatHealth(cid, myPos, ELECTRICDAMAGE, min, max, 48, 41)
		doFrontalCombatHealth(cid, myPos, STATUS_STUN7, 48, 48, -1, -1)

elseif spell == "Rain Dance" or spell == "Hail" then
   if not isCreature(cid) then
      return true
   end
local master = isSummon(cid) and getCreatureMaster(cid) or cid
------------
local ret = {}
ret.id = 0
ret.attacker = cid
ret.cd = 9
ret.check = 0
ret.eff = 1
ret.cond = "Silence"
---
local function doFall(cid)
	if not isCreature(cid) then
		return true
	end
   for rocks = 1, 42 do --62
      addEvent(fall, rocks*35, cid, master, WATERDAMAGE, spell == "Hail" and 28 or 52, 1)
   end
end
---
local function doRain(cid)
	if not isCreature(cid) then
		return true
	end
   if isSummon(cid) then
      doClearBallStatus(getPlayerSlotItem(getCreatureMaster(cid), 8).uid)
   end                                                      --cura status
   doClearPokemonStatus(cid)
   ---
   setPlayerStorageValue(cid, 253, 1)  --focus
   sendOpcodeStatusInfo(cid)
   doSendMagicEffect(getThingPosWithDebug(cid), 132)
   if isInArray(specialabilities["swift swim"], getCreatureName(cid)) then
      doRaiseStatus(cid, 0,0,200,10)
   end
   ---
   doMoveInArea2(cid, 1392, confusion, WATERDAMAGE, 0, 0, spell, ret)
end
---
doCastform(cid, spell)
addEvent(doFall, 200, cid)
addEvent(doRain, 1000, cid)


elseif spell == "Night Slash" then
local function doSendMove(cid)
   if not isCreature(cid) then
      return true
   end
   -- if getPokemonStatus(cid, "sleep") then return true end
   local info = {
      [1] = {259, {x = myPos.x + 1, y = myPos.y - 1, z = myPos.z}},
      [2] = {261, {x = myPos.x + 2, y = myPos.y + 1, z = myPos.z}},
      [3] = {260, {x = myPos.x + 1, y = myPos.y + 2, z = myPos.z}},
      [4] = {262, {x = myPos.x - 1, y = myPos.y + 1, z = myPos.z}}
   }
   for i = 1, 4 do
      doSendMagicEffect(info[i][2], info[i][1])
   end
   doAreaCombatHealth(cid, DARKDAMAGE, myPos, square1x1, -min, -max, 226)
end
for i = 0, 1 do
   addEvent(doSendMove, i * 400, cid)
end

elseif spell == "Heavy Slam" then

local p = getThingPosWithDebug(cid)

local t = {
   {251, {x = p.x+1, y = p.y-1, z = p.z}},
   {253, {x = p.x+2, y = p.y+1, z = p.z}},
   {252, {x = p.x+1, y = p.y+2, z = p.z}},
   {254, {x = p.x-1, y = p.y+1, z = p.z}},
}

doAreaCombatHealth(cid, STEELDAMAGE, p, confusion, -min, -max, 77)
for a = 0, 1 do
   for i = 1, 4 do
      addEvent(doSendMagicEffect, a*400, t[i][2], t[i][1])          --alterado v1.8
   end
end
addEvent(doAreaCombatHealth, 400, cid, STEELDAMAGE, p, confusion, -min, -max, 165)

elseif spell == "Misty Terrain" then
local arrs = {rock4, rock3, rock2, rock1}
local ret = {}
ret.id = 0
ret.attacker = cid
ret.cd = 3
ret.eff = 22
ret.check = 0
ret.spell = spell
ret.cond = "Silence"

if isSummon(cid) then
   doClearBallStatus(getPlayerSlotItem(getCreatureMaster(cid), 8).uid)
end
doClearPokemonStatus(cid)
setPlayerStorageValue(cid, 234247, 1)
addEvent(setPlayerStorageValue, 6400, cid, 234247, -1)

local function doPulse(cid)
   if not isCreature(cid) then
      return true
   end
   for x = 0, 3 do
      addEvent(doMoveInArea2, x * 400, cid, 19, arrs[x + 1], FAIRYDAMAGE, min, max, spell, ret)
   end
end

for x = 0, 4 do
   addEvent(doPulse, x * 1600, cid)
end

elseif spell == "Metal Sound" then

local eff = spell == "Metal Sound" and 537 or 419
local arrs = {rock1, rock2, rock3, rock4, rock5}
local ret = {}
ret.id = 0
ret.attacker = cid
ret.cd = 3
ret.eff = eff
ret.check = 0
ret.spell = spell
ret.cond = "Stun"

local function doPulse(cid)
   if not isCreature(cid) then return true end
   for x=0,4 do
      addEvent(doMoveInArea2,x*400,cid, eff, arrs[x+1], STEELDAMAGE, min, max, spell, ret)
   end
end

for x = 0,6 do
   addEvent(doPulse,x*2000,cid)
   --addEvent(doMoveInArea2, x*interval, cid, eff, arrs[nowarr], spell == "Metal Sound" and STEELDAMAGE or FAIRYDAMAGE, min, max, spell, ret)
end

elseif spell == "Mamaragan" then

local eff = 801
local arrs = {rock1, rock2, rock3, rock4, rock5}
local ret = {}
ret.id = 0
ret.attacker = cid
ret.cd = 3
ret.eff = eff
ret.check = 0
ret.spell = spell
ret.cond = "Stun"

local function doPulse(cid)
   if not isCreature(cid) then return true end
   for x=0,4 do
      addEvent(doMoveInArea2,x*400,cid, eff, arrs[x+1], ELECTRICDAMAGE, min, max, spell, ret)
   end
end

for x = 0,6 do
   addEvent(doPulse,x*1000,cid)
   --addEvent(doMoveInArea2, x*interval, cid, eff, arrs[nowarr], spell == "Metal Sound" and STEELDAMAGE or FAIRYDAMAGE, min, max, spell, ret)
end

elseif spell == "Magnitude" then

local outs = {
   ["Swampert"] = {2176,2426},
   ["Shiny Ursaring"] = {1933,1987},
}

local function retOut(cid, out)
   if not isCreature(cid) then return true end
   doRemoveCondition(cid, CONDITION_OUTFIT)
   doSetCreatureOutfit(cid, {lookType = outs[getCreatureName(cid)][1]}, -1)
   setPlayerStorageValue(cid, 237273, -1)
end

local arrs = {rock1, rock2, rock3, rock4, rock5}
setPlayerStorageValue(cid, 237273, 1)

local ret = {}
ret.id = 0
ret.attacker = cid
ret.cd = 2
ret.eff = 1392
ret.check = 0
ret.spell = spell
ret.cond = "Slow"

local interval = 400
local rounds = 30

if outs[getCreatureName(cid)] then
   doSetCreatureOutfit(cid, {lookType = outs[getCreatureName(cid)][2]}, -1)
   addEvent(retOut, (rounds-1) * interval, cid)
end
stopNow(cid, (rounds-1) * interval)

for x = 0,rounds-1 do
   local nowarr = x + 1 - (math.floor(x/5)*5)
   addEvent(doMoveInArea2, x*interval, cid, getCreatureName(cid) == "Shiny Ursaring" and 270 or 355, arrs[nowarr], getCreatureName(cid) == "Shiny Ursaring" and DARKDAMAGE or GROUNDDAMAGE, min, max, spell, ret)
end

elseif spell == "Wild Charge" or spell == "Last Resort" then

if spell == "Wild Charge" then
   local ret = {}
   ret.id = 0
   ret.attacker = cid
   ret.cd = 9
   ret.eff = 48
   ret.check = 0
   ret.spell = spell
   ret.cond = "Stun"
end

local eff = spell == "Wild Charge" and 48 or 3
local dmgt = spell == "Wild Charge" and ELECTRICDAMAGE or NORMALDAMAGE

local pos = getThingPosWithDebug(cid)
local areas = {rock5, rock4, rock3, rock2, rock1, rock5, rock4, rock3, rock2, rock1, rock5, rock4, rock3, rock2, rock1}

for i = 0, 14 do
   addEvent(doMoveInArea2, i*400, cid, eff, areas[i+1], dmgt, min, max, spell, ret)
   -- addEvent(doMoveInArea2, i*400, cid, 1392, areas[i+1], dmgt, 0, 0, spell)
end

elseif spell == "DynamicPunch" then

local ret = {}
ret.id = 0
ret.attacker = cid
ret.cd = 9
ret.eff = 136
ret.check = 0
ret.spell = spell
ret.cond = "Confusion"

local pos = getThingPosWithDebug(cid)
-- local areas = {rock5, rock4, rock3, rock2, rock1, rock5, rock4, rock3, rock2, rock1, rock5, rock4, rock3, rock2, rock1}
local areas = {rock1, rock2, rock3, rock4, rock5}

for i = 0, 4 do
   addEvent(doMoveInArea2, i*320, cid, 112, areas[i+1], FIGHTINGDAMAGE, min, max, spell, ret)
   -- addEvent(doMoveInArea2, i*330, cid, 112, areas[i+1], FIGHTINGDAMAGE, 0, 0, spell)
end

	elseif spell == "Jump Kick" then
	        local function doSendMove(cid, turn)
            if not isCreature(cid) then
                return true
            end
            local turn = turn or 1
            local event = addEvent(doSendMove, 50, cid, turn + 1)
            local area1 = {square1x1, jumpKick2}
            local eff = {903, 113}
            doAreaCombatHealth(cid, FIGHTINGDAMAGE, getThingPosWithDebug(cid), area1[turn], -min, -max, eff[turn])
            if turn == 2 or isSleeping(cid) then
                stopEvent(event)
            end
        end
		-- doSendCreatureJump(cid)
        addEvent(doSendMove, 500, cid)
	
elseif spell == "Astonish" then
	if doCorrectString(getCreatureName(cid)) == "Shiny Gengar" then
		doAreaCombatHealth(cid, GHOSTDAMAGE, getThingPosWithDebug(cid), astonish, -min, -max, 1399)
	else
		doAreaCombatHealth(cid, GHOSTDAMAGE, getThingPosWithDebug(cid), astonish, -min, -max, 688)
	end
		

elseif spell == "Lava Plume" then                               --alterado v1.8 \/\/\/

doMoveInArea2(cid, 5, plume, FIREDAMAGE, -min, -max, spell)
--doMoveInArea2(cid, 87, plume, FIREDAMAGE, 0, 0, spell)

elseif spell == "Silver Wind" then
doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 39)
doDanoWithProtectWithDelay(cid, target, BUGDAMAGE, min, max, 266, SilverWing)

elseif spell == "Whirlpool" then
local function setSto(cid)
   if isCreature(cid) then
      setPlayerStorageValue(cid, 3644587, -1)
   end
end

local function doDano(cid)
   if isSleeping(cid) then
      return true
   end
   doDanoWithProtect(cid, WATERDAMAGE, getThingPosWithDebug(cid), splash, min, max, 309)
end

setPlayerStorageValue(cid, 3644587, 1)
for r = 0, 10 do
   addEvent(doDano, 600 * r, cid)
end
addEvent(setSto, 600 * 10, cid)


elseif spell == "Venoshock" then

        local master = isSummon(cid) and getCreatureMaster(cid) or cid
        local ret = {}
        ret.id = 0
        ret.attacker = cid
        ret.cd = 6
        ret.eff = 34
        ret.check = 0
        ret.first = true
        ret.cond = "Miss"

        local function doFall(cid)
            for rocks = 1, 42 do
                addEvent(fall, rocks * 35, cid, master, POISONDAMAGE, 6, 116)
            end
        end

        for up = 1, 10 do
            addEvent(upEffect, up * 75, cid, 6)
        end --alterado v1.4
        addEvent(doFall, 450, cid)
        addEvent(doMoveInArea2, 1400, cid, -1, BigArea2, POISONDAMAGE, min, max, spell, ret)

elseif spell == "Groundshock" then

local typedmg = GROUNDDAMAGE
local eff = 151
local effpos = getThingPosWithDebug(cid)
effpos.x = effpos.x+1
effpos.y = effpos.y+1
doSendMagicEffect(effpos, eff)
doMoveInArea2(cid, 2, check, typedmg, min, max, spell, ret)

elseif spell == "Raigoh" then

doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 90)
doDanoInTargetWithDelay(cid, target, ELECTRICDAMAGE, -min, -max, 380)

elseif spell == "Iron Head" then
doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 39)
doDanoInTargetWithDelay(cid, target, STEELDAMAGE, -min, -max, 258)

elseif spell == "Volt Kitten" then

local ret = {}
ret.id = 0
ret.attacker = cid
ret.cd = 6
ret.eff = 48
ret.check = 0
ret.first = true
ret.cond = "Stun"

local a = isCreature(target) and getCreatureDirectionToTarget(cid, target) or getCreatureLookDir(cid)
local p = getThingPosWithDebug(cid)
local t = {
   [0] = {527, {x=p.x+1, y=p.y-1, z=p.z}},
   [1] = {528, {x=p.x+2, y=p.y+1, z=p.z}},
   [2] = {530, {x=p.x+1, y=p.y+2, z=p.z}},
   [3] = {529, {x=p.x-1, y=p.y+1, z=p.z}},
}

doMoveInArea2(cid, 0, BrickBeak, ELECTRICDAMAGE, min, max, spell, ret)
doSendMagicEffect(t[a][2], t[a][1])

elseif spell == "Zen Headbutt" then
local ret = {}
ret.id = 0
ret.attacker = cid
ret.cd = 5
ret.eff = 88
ret.check = 0
ret.first = true
ret.cond = "Sleep"

local a = isCreature(target) and getCreatureDirectionToTarget(cid, target) or getCreatureLookDir(cid)
local p = getThingPosWithDebug(cid)
local t = {
   [0] = {527, {x = p.x + 1, y = p.y - 1, z = p.z}},
   [1] = {528, {x = p.x + 2, y = p.y + 1, z = p.z}},
   [2] = {530, {x = p.x + 1, y = p.y + 2, z = p.z}},
   [3] = {529, {x = p.x - 1, y = p.y + 1, z = p.z}}
}

doMoveInArea2(cid, 0, BrickBeak, PSYCHICDAMAGE, min, max, spell, ret)
doSendMagicEffect(t[a][2], t[a][1])


elseif spell == "Brick Break" then

local ret = {}
ret.id = 0
ret.attacker = cid
ret.cd = 9
ret.eff = 88
ret.check = 0
ret.first = true
ret.cond = "Paralyze"

local a = isCreature(target) and getCreatureDirectionToTarget(cid, target) or getCreatureLookDir(cid)
local p = getThingPosWithDebug(cid)
local t = {
   [0] = {90, {x=p.x+1, y=p.y-1, z=p.z}},
   [1] = {90, {x=p.x+2, y=p.y+1, z=p.z}},
   [2] = {90, {x=p.x+1, y=p.y+2, z=p.z}},
   [3] = {90, {x=p.x-1, y=p.y+1, z=p.z}},
}

doMoveInArea2(cid, 0, BrickBeak, FIGHTINGDAMAGE, min, max, spell, ret)
doSendMagicEffect(t[a][2], t[a][1])


elseif spell == "Blast Burn" then
local pos = getThingPosWithDebug(cid)

doAreaCombatHealth(cid, FIREDAMAGE, getThingPosWithDebug(cid), blastBurn, -min, -max, 362)
addEvent(doDanoWithProtect, math.random(100, 400), cid, FIREDAMAGE, pos, inferno2, -min, -max, 1392)

elseif spell == "Bone Rush" then
        local function doSendMove(cid, turn)
            if not isCreature(cid) then
                return true
            end
            local turn = turn or 1
            local event = addEvent(doSendMove, 400, cid, turn + 1)
            local area1 = {bone1, bone2, bone3, bone4, bone3, bone2, bone1}
            doAreaCombatHealth(cid, ROCKDAMAGE, getThingPosWithDebug(cid), area1[turn], -min, -max, 117)
            if turn == 7 then
                stopEvent(event)
            end
        end
        doSendMove(cid)

elseif spell == "Hammer Arm" then
--///////////////////////   PASSIVAS /////////////////////////--
local ret = {}
ret.id = 0
ret.attacker = cid
ret.cd = 5
ret.eff = 111
ret.check = 0
ret.first = true
ret.cond = "Sleep"

local a = isCreature(target) and getCreatureDirectionToTarget(cid, target) or getCreatureLookDir(cid)
local p = getThingPosWithDebug(cid)
local t = {
   [0] = {293, {x = p.x, y = p.y - 1, z = p.z}},
   [1] = {296, {x = p.x + 3, y = p.y + 1, z = p.z}},
   [2] = {306, {x = p.x + 1, y = p.y + 2, z = p.z}},
   [3] = {292, {x = p.x - 1, y = p.y, z = p.z}}
}

doMoveInArea2(cid, 1392, BrickBeak, FIGHTINGDAMAGE, min, max, spell, ret)
doSendMagicEffect(t[a][2], t[a][1])


--///////////////////////   PASSIVAS /////////////////////////--

elseif spell == "Counter Helix" then
local OutFit = {
   ["Scyther"] = {out = 145, cima = 128, direita = 129, esquerda = 130, baixo = 131},  --scyther
   ["Scizor"] = {out = 376, cima = 128, direita = 129, esquerda = 130, baixo = 131},  --Scizor
   ["Shiny Scyther"] = {out = 498, cima = 128, direita = 129, esquerda = 130, baixo = 131}, --Shiny Scyther
   ["Hitmontop"] = {out = 464, cima = 128, direita = 129, esquerda = 130, baixo = 131}, --Hitmontop
   ["Shiny Hitmontop"] = {out = 1156, cima = 128, direita = 129, esquerda = 130, baixo = 131}, --Shiny Hitmontop
   ["Pineco"] = {out = 1194, cima = 128, direita = 129, esquerda = 130, baixo = 131}, --pineco
   ["Forretress"] = {out = 1192, cima = 128, direita = 129, esquerda = 130, baixo = 131}, --Forretress
   ["Wobbuffet"] = {out = 924, cima = 128, direita = 129, esquerda = 130, baixo = 131},  --wobb
   ["Alakazam"] = {out = 569, cima = 128, direita = 129, esquerda = 130, baixo = 131},  --alaka
   ["Kadabra"] = {out = 570, cima = 128, direita = 129, esquerda = 130, baixo = 131},  --kadabra
   ["Shiny Abra"] = {out = 1257, cima = 128, direita = 129, esquerda = 130, baixo = 131},  --s abra
   ["Kangaskhan"] = {out = 549, cima = 251, direita = 253, esquerda = 254, baixo = 252},  --test
}

-- if isMega(cid) then return true end

if getPlayerStorageValue(cid, 32623) == 1 then  --proteçao pra n usar a passiva 2x seguidas...
   setPlayerStorageValue(cid, 32623, 0)
   return true
end


local nome1 = doCorrectString(getCreatureName(cid))   --alterado v1.6.1
local outfitt = OutFit[nome1]   --alterado v1.6.1
if not outfitt then outfitt = {out = getCreatureOutfit(cid).lookType, cima = 128, direita = 129, esquerda = 130, baixo = 131} end
--print("No outfitt for ".. nome1 .." on 'Counter Helix'. [pokemon moves.lua]")

local function doDamage(cid, min, max)
   if isCreature(cid) then
      if isInArray({"Scyther", "Shiny Scyther", "Pineco"}, nome1) then   --alterado v1.6
         damage = BUGDAMAGE
      elseif isInArray({"Hitmontop", "Shiny Hitmontop", "Kangaskhan"}, nome1) then
         damage = FIGHTINGDAMAGE                --alterado v1.6.1
      else
         damage = STEELDAMAGE
      end
      doAreaCombatHealth(cid, damage, getThingPosWithDebug(cid), scyther5, -min, -max, CONST_ME_NONE) --alterado v1.6.1
      ---
      doAreaCombatHealth(cid, null, getThingPosWithDebug(cid), scythe1, 0, 0, outfitt.cima) --cima
      doAreaCombatHealth(cid, null, getThingPosWithDebug(cid), scythe2, 0, 0, outfitt.baixo) --baixo
      doAreaCombatHealth(cid, null, getThingPosWithDebug(cid), scythe3, 0, 0, outfitt.direita) --direita
      doAreaCombatHealth(cid, null, getThingPosWithDebug(cid), scythe4, 0, 0, outfitt.esquerda)  --esquerda
   end
end

local function sendEff(cid)
   if isCreature(cid) then
      doAreaCombatHealth(cid, null, getThingPosWithDebug(cid), scythe1, 0, 0, outfitt.cima) --cima
      doAreaCombatHealth(cid, null, getThingPosWithDebug(cid), scythe2, 0, 0, outfitt.baixo) --baixo
      doAreaCombatHealth(cid, null, getThingPosWithDebug(cid), scythe3, 0, 0, outfitt.direita) --direita       --alterado v1.6
      doAreaCombatHealth(cid, null, getThingPosWithDebug(cid), scythe4, 0, 0, outfitt.esquerda)  --esquerda
   end
end

local function doChangeO(cid)
   if not isCreature(cid) then return true end
   setPlayerStorageValue(cid, 32623, 0)
   if isSleeping(cid) and getMonsterInfo(getCreatureName(cid)).lookCorpse ~= 0 then
      doSetCreatureOutfit(cid, {lookType = 0, lookTypeEx = getMonsterInfo(getCreatureName(cid)).lookCorpse}, -1)
   else
      doRemoveCondition(cid, CONDITION_OUTFIT)
   end
end

local delay = 200
local master = isSummon(cid) and getCreatureMaster(cid) or cid
local summons = getCreatureSummons(master)

if (isPlayer(master) and #summons >= 2) or (ehMonstro(master) and #summons >= 1) then
   for j = 1, #summons do
      setPlayerStorageValue(summons[j], 32623, 1)
      doSetCreatureOutfit(summons[j], {lookType = outfitt.out}, -1)

      for i = 1, 2 do
         addEvent(sendEff, delay*i, summons[j])
      end
      addEvent(doChangeO, 2 * 300 + 10, summons[j])
      for i = 1, 2 do
         addEvent(doDamage, delay*i,  summons[j], min, max)
      end
   end
else
   setPlayerStorageValue(cid, 32623, 1)
   setPlayerStorageValue(cid, 98654, 1)
   doSetCreatureOutfit(cid, {lookType = outfitt.out}, -1)

   for i = 1, 2 do                                                                 --alterado v1.6
      addEvent(doDamage, delay*i, cid, min, max)
   end
   addEvent(doChangeO, 2 * 300 + 10, cid)
end

elseif spell == "Lava-Counter" then

local outfit = getSubName(cid, target) == "Shiny Magmar" and 1780 or getSubName(cid, target) == "Magmar" and 679 or 0
if outfit ~= 0 then
   doSetCreatureOutfit(cid, {lookType = outfit}, -1)
   addEvent(doRemoveConditionSecurity,500,cid,CONDITION_OUTFIT)
end

local ret = {}
ret.id = 0
ret.im = 0
ret.attacker = cid
ret.cd = 3
ret.eff = 355
ret.check = 0
ret.spell = spell
ret.cond = "Burn"
ret.damage = pbdmg
ret.tickt = 750


local function dmg(cid)
   if not isCreature(cid) then return true end
   doMoveInArea2(cid, 5, rock2, FIREDAMAGE, min, max, spell, ret)
end

local effpos = getThingPosWithDebug(cid)
doSendMagicEffect(effpos, 6)
doMoveInArea2(cid, 5, check, FIREDAMAGE, min, max, spell, ret)
addEvent(dmg,450,cid)

elseif spell == "Mega Drain" then

if getPlayerStorageValue(cid, 757575) > os.time() then return true end
setPlayerStorageValue(cid, 757575, os.time() + 1)

local function getCreatureHealthSecurity(cid)
   if not isCreature(cid) then return 0 end
   return getCreatureHealth(cid) or 0
end

local uid = checkAreaUid(getThingPosWithDebug(cid), check, 1, 1)
for _,pid in pairs(uid) do
   if isCreature(cid) and isCreature(pid) and pid ~= cid then
      if isPlayer(pid) and #getCreatureSummons(pid) >= 1 then return false end

      local life = getCreatureHealthSecurity(pid)

      doAreaCombatHealth(cid, GRASSDAMAGE, getThingPos(pid), 0, -min, -max, 14)

      local newlife = (life - getCreatureHealthSecurity(pid))

      if isWild(pid) then newlife = newlife / 4 end

      doSendMagicEffect(getThingPosWithDebug(cid), 14)
      setPlayerStorageValue(cid, 98654, 1)

      if newlife >= 1 then
         doCreatureAddHealth(cid, newlife)
         doSendAnimatedText(getThingPosWithDebug(cid), "+"..math.floor(newlife).."", 32)
      end

   end
end

elseif spell == "Spores Reaction" then

local random = math.random(1, 3)

if random == 1 then
   local ret = {}
   ret.id = 0
   ret.attacker = cid
   ret.cd = math.random(2, 3)
   ret.check = 0                   --alterado v1.6
   ret.first = true
   ret.cond = "Sleep"

   doMoveInArea2(cid, 27, confusion, GRASSDAMAGE, 0, 0, "Spores Reaction", ret)
   setPlayerStorageValue(cid, 98654, 1)
elseif random == 2 then
   local ret = {}
   ret.id = 0
   ret.attacker = cid
   ret.cd = 6
   ret.eff = 0
   ret.check = 0
   ret.spell = spell
   ret.cond = "Stun"

   doMoveInArea2(cid, 85, confusion, GRASSDAMAGE, 0, 0, "Spores Reaction", ret)
   setPlayerStorageValue(cid, 98654, 1)
else
   local ret = {}
   ret.id = 0
   ret.attacker = cid
   ret.cd = math.random(6, 10)
   ret.check = 0
   local lvl = isSummon(cid) and getMasterLevel(cid) or getPokemonLevel(cid)     --alterado v1.6
   ret.damage = pbdmg
   ret.cond = "Poison"

   doMoveInArea2(cid, 84, confusion, POISONDAMAGE, 0, 0, "Spores Reaction", ret)
   setPlayerStorageValue(cid, 98654, 1)
end

elseif spell == "Stunning Confusion" then

if getPlayerStorageValue(cid, 32623) == 1 then  --proteçao pra n usar a spell 2x seguidas...
   return true
end

local function damage(cid)
   if isCreature(cid) then
      doMoveInArea2(cid, 133, selfArea1, psyDmg, min, max, spell, ret)
   end
end

setPlayerStorageValue(cid, 32623, 1)        --proteçao
for i = 1, 7 do
   addEvent(damage, i*500, cid)
end
addEvent(setPlayerStorageValue, 3500, cid, 32623, 0)        --proteçao
setPlayerStorageValue(cid, 98654, 1)

elseif spell == "Bone-Spin" or spell == "Stick-Spin" then

local dmg = spell == "Bone-Spin" and GROUNDDAMAGE or FLYINGDAMAGE
local eff = spell == "Bone-Spin" and 117 or 212
local function sendStickEff(cid, dir)
   if not isCreature(cid) then return true end
   doAreaCombatHealth(cid, dmg, getPosByDir(getThingPosWithDebug(cid), dir), 0, -min, -max, eff)
end

local function doStick(cid)
   if not isCreature(cid) then return true end
   local t = {
      [1] = SOUTHWEST,
      [2] = SOUTH,
      [3] = SOUTHEAST,
      [4] = EAST,
      [5] = NORTHEAST,
      [6] = NORTH,
      [7] = NORTHWEST,
      [8] = WEST,
      [9] = SOUTHWEST,
   }
   for a = 1, 9 do
      addEvent(sendStickEff, a * 140, cid, t[a])
   end
end

doStick(cid, false, cid)
setPlayerStorageValue(cid, 98654, 1)
--alterado v1.4
elseif spell == "Amnesia" then

if getPlayerStorageValue(cid, 253) >= 1 then return true end

doCreatureSay(cid, "????", 20)
doSendMagicEffect(getThingPosWithDebug(cid), 445)
setPlayerStorageValue(cid, 253, 1)
sendOpcodeStatusInfo(cid)
setPlayerStorageValue(cid, 98654, 1)

elseif spell == "Dragon Fury" then

if getPlayerStorageValue(cid, 32623) == 1 then
   return true
end

setPlayerStorageValue(cid, 32623, 1)
setPlayerStorageValue(cid, 98654, 1)

if isInArray({"Persian", "Raticate", "Shiny Raticate"}, getSubName(cid, target)) then  --alterado v1.6.1
   doRaiseStatus(cid, 1.5, 0, 0, 10)
else                                               --alterado v1.5
   doRaiseStatus(cid, 1.5, 1.5, 0, 10)     --ver isso
end

for t = 1, 7 do                  --alterado v1.5
   addEvent(sendMoveEffect, t*1500, cid, 12)
end
addEvent(setPlayerStorageValue, 10500, cid, 32623, 0) --alterado v1.8

elseif spell == "Electric Charge" then

if getPlayerStorageValue(cid, 253) >= 1 then
   return true
end

setPlayerStorageValue(cid, 253, 1)
sendOpcodeStatusInfo(cid)
setPlayerStorageValue(cid, 98654, 1)
doSendMagicEffect(getThingPosWithDebug(cid), 207)
doSendAnimatedText(getThingPosWithDebug(cid), "FOCUS", 144)

elseif spell == "Punishment" then

doSetCreatureOutfit(cid, {lookType = 1987}, -1)
addEvent(doRemoveConditionSecurity,3000,cid,CONDITION_OUTFIT)

local function doDano(cid)
   local function doDano2(cid, arr)
      if not isCreature(cid) then return true end
      if isSleeping(cid) then return true end
      local ret = {}
      ret.id = 0
      ret.attacker = cid
      ret.cd = math.random(5,10)
      ret.eff = 34
      ret.check = 0
      ret.spell = spell
      ret.cond = "Slow"

      doMoveInArea2(cid, 270, arr, DARKDAMAGE, min, max, spell, ret)
   end

   if not isCreature(cid) then return true end

   doDano2(cid,rock1)
   addEvent(doDano2,330,cid,rock2)
   doSendMagicEffect(getThingPosWithDebug(cid), 182)
end

if getPlayerStorageValue(cid, 237132) ~= 1 then
   setPlayerStorageValue(cid, 237132, 1)
   for r = 0, 3 do
      addEvent(doDano, 750 * r, cid)
   end
   addEvent(setPlayerStorageValue,3000,cid,237132,-1)
end

elseif spell == "Shock-Counter" then
	local eff = getSubName(cid, target) == "Shiny Electabuzz" and 799 or 798
	local effpos = getThingPosWithDebug(cid)
	effpos.x = effpos.x+2
	effpos.y = effpos.y+1
	doSendMagicEffect(effpos, eff)
	doAreaCombatHealth(cid, ELECTRICDAMAGE, getThingPosWithDebug(cid), splash, -min, -max, 1392)

elseif spell == "Mirror Coat" then

if spell == "Magic Coat" then
   eff = 11
else
   eff = 135
end

doSendMagicEffect(getThingPosWithDebug(cid), eff)
setPlayerStorageValue(cid, storages.reflect, 5)
setPlayerStorageValue(cid, 98654, 1)
sendOpcodeStatusInfo(cid)

elseif spell == "Zen Mind" then

function doCure(cid)
   if not isCreature(cid) then return true end
   if isSummon(cid) then
      doClearBallStatus(getPlayerSlotItem(getCreatureMaster(cid), 8).uid)
   end
   doClearPokemonStatus(cid)
end

addEvent(doCure, 1000, cid)
doSetCreatureOutfit(cid, {lookType = 1001}, 2000)
setPlayerStorageValue(cid, 98654, 1)

elseif spell == "Protect" then
-- local function eff(cid)
   -- if not isCreature(cid) then
      -- return true
   -- end
   -- doSendMagicEffect({x = getThingPosWithDebug(cid).x + 1, y = getThingPosWithDebug(cid).y + 1, z = getThingPosWithDebug(cid).z}, 621)
-- end

-- local function retireStatus(cid)
   -- if not isCreature(cid) then
      -- return true
   -- end
   -- setPlayerStorageValue(cid, 9658783, -1)
-- end

-- for x = 0, 11 do
   -- addEvent(eff, x * 500, cid)
-- end
-- addEvent(retireStatus, 6000, cid)
-- setPlayerStorageValue(cid, 9658783, 1)
local function doSendMove(cid, turn)
   if not isCreature(cid) then
      return true
   end
   local turn = turn or 1
   local event = addEvent(doSendMove, 500, cid, turn + 1)
   setPlayerStorageValue(cid, 9658783, 1)
   local pos = getThingPosWithDebug(cid)
   pos.x = pos.x + 1
   pos.y = pos.y + 1
   doSendMagicEffect(pos, 621)
   if turn == 12 or isSleeping(cid) then
      stopEvent(event)
      setPlayerStorageValue(cid, 9658783, -1)
   end
end
doSendMove(cid)


elseif spell == "Detect" then
local function doSendMove(cid, turn)
   if not isCreature(cid) then
      return true
   end
   local turn = turn or 1
   local event = addEvent(doSendMove, 1000, cid, turn + 1)
   setPlayerStorageValue(cid, 9658783, 1)
   local eff = {875, 876, 877, 878, 879}
   local pos = getThingPosWithDebug(cid)
   pos.x = pos.x + 1
   pos.y = pos.y + 2
   doSendMagicEffect(pos, eff[turn])
   if turn == 5 or isSleeping(cid) then
      stopEvent(event)
      setPlayerStorageValue(cid, 9658783, -1)
   end
end
doSendMove(cid)

elseif spell == "Sturdy" then

local function doKillWildPokeWhiteSecuirty(cid)
   if not isCreature(cid) then return true end
   --if isSummon(cid) then
   --  if isInDuel(getCreatureMaster(cid)) then
   --	   doRemoveCountPokemon(getCreatureMaster(cid))
   --  end
   --end
   doKillWildPoke(cid, cid)
end

local outfit = 1865
if isMega(cid) then
   outfit = 2088
elseif getCreatureName(cid) == "Shiny Sudowoodo" then
   outfit = 2253
elseif getCreatureName(cid) == "Sudowoodo" then
   outfit = 2122
elseif getCreatureName(cid) == "Carracosta" then
	outfit = 4447
end

doSetCreatureOutfit(cid, {lookType = outfit}, -1)
setPlayerStorageValue(cid, 9658783, 1)  -- nao velar dano
addEvent(doKillWildPokeWhiteSecuirty, 6000, cid)

elseif spell == "Demon Kicker" then

--[outfit] = outfit chutando,
local hitmonlees = {
   ["Hitmonlee"] =  301,      --hitmonlee
   ["Shiny Hitmonlee"] = 527,  --shiny hitmonlee
}

local nome = getCreatureName(cid)
--alterado v1.6                                        --alterado v1.7
if (not hitmonlees[nome] and isCreature(target)) or (isCreature(target) and math.random(1, 100) <= passivesChances["Demon Kicker"][nome]) then

   if getDistanceBetween(getThingPosWithDebug(cid), getThingPos(target)) > 1 then
      return true
   end
   if getPlayerStorageValue(cid, 32623) == 1 then  --proteçao pra n usar a passiva 2x seguidas...
      return true
   end

   if not isSummon(cid) then       --alterado v1.7
      doCreatureSay(cid, string.upper(spell).."!", TALKTYPE_MONSTER)
   end

   local function doChangeHitmon(cid)
      if not isCreature(cid) then return true end
      setPlayerStorageValue(cid, 32623, 0)         --proteçao
      if isSleeping(cid) and getMonsterInfo(getCreatureName(cid)).lookCorpse ~= 0 then
         doSetCreatureOutfit(cid, {lookType = 0, lookTypeEx = getMonsterInfo(getCreatureName(cid)).lookCorpse}, -1)
      else
         doRemoveCondition(cid, CONDITION_OUTFIT)
      end
   end

   setPlayerStorageValue(cid, 32623, 1)       --proteçao
   setPlayerStorageValue(cid, 98654, 1)

   local look = hitmonlees[nome] or getPlayerStorageValue(cid, 21104)  --alterado v1.6

   doCreatureSetLookDir(cid, getCreatureDirectionToTarget(cid, target))
   doSetCreatureOutfit(cid, {lookType = look}, -1)   --alterado v1.6
   doTargetCombatHealth(cid, target, FIGHTINGDAMAGE, -min, -max, 255)

   addEvent(doChangeHitmon, 700, cid)
end

elseif spell == "Illusion" then

local team = {
   ["Misdreavus"] = "MisdreavusTeam",
   ["Shiny Stantler"] = "Shiny StantlerTeam",
   ["Stantler"] = "StantlerTeam",
}

local function RemoveTeam(cid)
   if isCreature(cid) then
      doSendMagicEffect(getThingPosWithDebug(cid), 211)
      doRemoveCreature(cid)
   end
end

local function sendEff(cid, master, t)
   if isCreature(cid) and isCreature(master) and t > 0 and #getCreatureSummons(master) >= 2 then
      doSendMagicEffect(getThingPosWithDebug(cid), 86, master)
      addEvent(sendEff, 1000, cid, master, t-1)                        --alterado v1.9
   end
end

if getPlayerStorageValue(cid, 637500) >= 1 then
   return true
end

local master = getCreatureMaster(cid)
local item = getPlayerSlotItem(master, 8)
local life, maxLife = getCreatureHealth(cid), getCreatureMaxHealth(cid)
local name = getItemAttribute(item.uid, "poke")
local pos = getThingPosWithDebug(cid)
local time = 5

doItemSetAttribute(item.uid, "hp", (life/maxLife))

local num = getSubName(cid, target) == "Misdreavus" and 3 or 2
local pk = {}

doTeleportThing(cid, {x=4, y=3, z=10}, true)

if team[name] then
   pk[1] = cid
   for b = 2, num do
      pk[b] = doSummonCreature(team[name], pos)
      doConvinceCreature(master, pk[b])
   end

   for a = 1, num do
      addEvent(doTeleportThing, math.random(0, 5), pk[a], getClosestFreeTile(pk[a], pos), true)
      addEvent(doAdjustWithDelay, 5, master, pk[a], true, true, true)
      doSendMagicEffect(getThingPosWithDebug(pk[a]), 211)
   end
   sendEff(cid, master, time)     --alterado v1.9
   setPlayerStorageValue(master, 637501, 1)
   addEvent(setPlayerStorageValue, time * 1000, master, 637501, -2)
   -----
   setPlayerStorageValue(pk[2], 637500, 1)
   addEvent(RemoveTeam, time * 1000, pk[2])
   -----
   setPlayerStorageValue(pk[3], 637500, 1)
   addEvent(RemoveTeam, time * 1000, pk[3])
   ----
   if getSubName(cid, target) == "Scizor" then
      setPlayerStorageValue(pk[4], 637500, 1)
      addEvent(RemoveTeam, time * 1000, pk[4])
   end
end


elseif spell == "Demon Puncher" then

local name = getCreatureName(cid)
--alterado v1.7
if (not hitmonchans[name] and isCreature(target)) or (isCreature(target) and math.random(1, 100) <= passivesChances["Demon Puncher"][name]) then

   if getDistanceBetween(getThingPosWithDebug(cid), getThingPosWithDebug(target)) > 1 then
      return true
   end

   if not isSummon(cid) then       --alterado v1.7
      doCreatureSay(cid, string.upper(spell).."!", TALKTYPE_MONSTER)
   end

   if ehMonstro(cid) or not hitmonchans[name] then
      hands = getPlayerStorageValue(cid, 823413) or getPlayerStorageValue(target, 823413) or 0
   else
      hands = getItemAttribute(getPlayerSlotItem(getCreatureMaster(cid), 8).uid, "hands")
   end

   if not hitmonchans[name] then
      tabela = hitmonchans[getCreatureName(target)][hands]
   else
      tabela = hitmonchans[name][hands]
   end

   doSendDistanceShoot(getThingPosWithDebug(cid), getThingPosWithDebug(target), 39)
   doTargetCombatHealth(cid, target, tabela.type, -min, -max, 255)

   local alvo = getThingPosWithDebug(target)
   alvo.x = alvo.x + 1                           ---alterado v1.7

   if hands == 4 then
      doSendMagicEffect(alvo, tabela.eff)
   else
      doSendMagicEffect(getThingPosWithDebug(target), tabela.eff)
   end

   if hands == 3 then
      local ret = {}
      ret.id = target
      ret.attacker = cid
      ret.cd = 9                     --alterado v1.6
      ret.eff = 43
      ret.check = getPlayerStorageValue(target, conds["Slow"])
      ret.first = true
      ret.cond = "Slow"

      doMoveDano2(cid, target, FIGHTINGDAMAGE, 0, 0, ret, spell)
      setPlayerStorageValue(cid, 98654, 1)
   end
end

elseif string.find(spell:lower(), "mega -") then
return doTransformMega(cid)
end
return true
end

function isMega(cid)
if getPlayerStorageValue(cid, storages.isMega) ~= -1 then
return true
end
return false
end

function doTransformMega(cid)
local rateBuff = 1.40 -- 25%
local rateWild = 5
local name = doCorrectString(getCreatureName(cid))
local wildMult = 1.5
local megaID = ""
if isSummon(cid) then
local master = getCreatureMaster(cid)
if getItemAttribute(getPlayerSlotItem(master, 8).uid, "megaID") and getItemAttribute(getPlayerSlotItem(master, 8).uid, "megaID") ~= "" then
   megaID = getItemAttribute(getPlayerSlotItem(master, 8).uid, "megaID")
end
else
megaID = getPlayerStorageValue(cid, storages.isMegaID)
end
local megaName = "Mega " .. name .. (megaID ~= "" and " " .. megaID or "")
if megasConf[megaName] then

if isSummon(cid) then
   local master = getCreatureMaster(cid)
   -- local clan = getPlayerClan(master):lower()
   -- local type1,type2 = megasConf[megaName].type, megasConf[megaName].type2
   -- if not (isInArray(clanTypes[clan], type1) or isInArray(clanTypes[clan], type2)) then
   -- doPlayerSendCancel(master, "You can't control this mega evolution as ".. clan ..".")
   -- return false
   -- end
   doCreatureSay(master, ""..getPokeName(cid)..", mega evolve!", TALKTYPE_ORANGE_1)
end


setPlayerStorageValue(cid, storages.isMega, megaName)


doRegainSpeed(cid)	     --alterado!
local pos = getThingPosWithDebug(cid)
pos.x = pos.x + 1
pos.y = pos.y +1
doSendMagicEffect(pos, 574)

local heldBonusAttack = 1
local heldBonusDefense = 1

if isSummon(cid) then
   local master = getCreatureMaster(cid)
   doUpdateMoves(master)
   wildMult = 1
   -- adjusting life:
   local ball = getPlayerSlotItem(master, 8)
   local pokeLifeMax = megasConf[megaName].life
   local heldBonusBoost = 0
   local heldBonusVitality = 0
   local boost = getItemAttribute(ball.uid, "boost") or 0 -- ajeitar o boost!
   local masterLevel = getPlayerLevel(master)

   if getItemAttribute(ball.uid, "xHeldItem") then
      local heldName = string.explode(getItemAttribute(ball.uid, "xHeldItem"), "|")[1]
      local heldTier = string.explode(getItemAttribute(ball.uid, "xHeldItem"), "|")[2]
      if heldName == "X-Vitality" then
         --print(getCreatureName(cid).." has a X-Vitality T-".. heldTier, "Life before: "..lifeM)
         heldBonusVitality = heldVitality[tonumber(heldTier)]/100
         --lifeM = lifeM + lifeM * heldVitality[tonumber(heldTier)]/100
         --print("Life after: ".. lifeM)
      end
      if heldName == "X-Boost" then
         heldBonusBoost = heldBoost[tonumber(heldTier)]
      end
      if heldName == "X-Attack" then
         heldBonusAttack = heldAttack[tonumber(heldTier)]
      end
      if heldName == "X-Defense" then
         heldBonusDefense = heldDefense[tonumber(heldTier)]
      end
   end

   local lifeM = (pokeLifeMax + (megasConf[megaName].vitality * (masterLevel + boost + heldBonusBoost)) * 12.2 * rateBuff)
   lifeM = lifeM + (lifeM * heldBonusVitality)

   local lnow = getCreatureHealth(cid)
   --print(getCreatureName(master).." lnow: "..lnow)
   local lifePercent = lnow/getCreatureMaxHealth(cid)
   --print(getCreatureName(master).." lifePercent: "..lifePercent)
   local newLifePercent = lifeM * lifePercent
   --print(getCreatureName(master).." newLifePercent: "..newLifePercent)
   setCreatureMaxHealth(cid, lifeM)
   doCreatureAddHealth(cid, -lnow+1)
   doCreatureAddHealth(cid, newLifePercent)
   --print(getCreatureName(master).." ".. megaName .." new HP: ".. lifeM)
   doSendPlayerExtendedOpcode(master, opcodes.OPCODE_POKEMON_HEALTH, math.ceil(newLifePercent).."|"..math.ceil(lifeM))
   --
   setPlayerStorageValue(cid, storages.isMegaID, megaID)
end


	if isSummon(cid) then
		setPlayerStorageValue(cid, 1001, megasConf[megaName].attack * wildMult * rateBuff * heldBonusAttack)
		setPlayerStorageValue(cid, 1002, megasConf[megaName].defense * (wildMult + rateBuff) * heldBonusDefense)
		setPlayerStorageValue(cid, 1003, megasConf[megaName].agility)
		setPlayerStorageValue(cid, 1005, megasConf[megaName].specialattack * wildMult * rateBuff * heldBonusAttack)
		doRegainSpeed(cid)
	else
		setPlayerStorageValue(cid, 1001, megasConf[megaName].attack * heldBonusAttack)
		setPlayerStorageValue(cid, 1002, megasConf[megaName].defense * heldBonusDefense)
		setPlayerStorageValue(cid, 1003, megasConf[megaName].agility)
		setPlayerStorageValue(cid, 1005, megasConf[megaName].specialattack * wildMult * heldBonusAttack)
		doRegainSpeed(cid)
	end

if wildMult == 1.5 then
   local life = megasConf[megaName].wildVity * math.random(10000, 13500)
   local lifeNow = getCreatureMaxHealth(cid) - getCreatureHealth(cid)
   setCreatureMaxHealth(cid, life) -- perfeita formula, os pokemons "ruins" só precisam de ajustes no pokemonStatus, tabela vitality.
   doCreatureAddHealth(cid, getCreatureMaxHealth(cid))
   doCreatureAddHealth(cid, -lifeNow)

end
if isInArray({"Charizard", "Blaziken", "Ampharos"}, name) then
   doPantinOutfit(cid, 0, megaName)
else
   doSetCreatureOutfit(cid, {lookType = megasConf[megaName].out}, -1)
   checkOutfitMega(cid, megaName)
end
end
end

function checkChenceToMega(cid, god)
local name, chance = doCorrectString(getCreatureName(cid)), math.random(0.1, 100.9)
local megaID = ""
if name == "Charizard" then
megaID = math.random(1, 100) < 51 and "Y" or "X"
end
if name == "Gengar" then
megaID = math.random(1, 100) < 51 and "" or "X"
end
local megaName = "Mega " .. name .. (megaID ~= "" and " " .. megaID or "")
if megasConf[megaName] and not isMega(cid) then
if getPlayerStorageValue(cid, 23134) < 0 then
   setPlayerStorageValue(cid, 23134, 0)
end
if getPlayerStorageValue(cid, 23134) ~= 1 or god then -- apenas o primeiro hit pode transformá-lo em mega
   if (megasConf[megaName].wildChance >= chance) or god then
      setPlayerStorageValue(cid, storages.isMegaID, megaID)
      doTransformMega(cid)
   end
   setPlayerStorageValue(cid, 23134, 1)
end
end
end

function getMegaID(cid)
return getPlayerStorageValue(cid, storages.isMegaID) ~= -1 and getPlayerStorageValue(cid, storages.isMegaID) or ""
end

function checkOutfitMega(cid, megaName)
if not isCreature(cid) or not isMega(cid) then return true end
local name = doCorrectString(getCreatureName(cid))
if not megasConf[megaName] then return true end
if getCreatureOutfit(cid).lookType ~= megasConf[megaName].out then
doSetCreatureOutfit(cid, {lookType = megasConf[megaName].out}, -1)
end
addEvent(checkOutfitMega, 50, cid)
end

function doPantinOutfit(cid, times, megaName)
if not isCreature(cid) or not isMega(cid) then return true end
if getPlayerStorageValue(cid, 213712) == 1 then return true end
if getCreatureOutfit(cid).lookType == 1875 or getCreatureOutfit(cid).lookType == 2 then return true end
local name = doCorrectString(getCreatureName(cid))
if not megasConf[megaName] then return true end
local outfitIndex = 1
if times <= 500 then
outfitIndex = 1
elseif times > 500 and times <= 1000 then
outfitIndex = 2
elseif times > 1000 and times <= 1500 then
outfitIndex = 3
end
doSetCreatureOutfit(cid, {lookType = megasConf[megaName].out[outfitIndex]}, -1)
times = times + 50
if times > 1500 then
times = 0
end
addEvent(doPantinOutfit, 50, cid, times, megaName)
end

function doRolloutReflected(cid, name)
local RollOuts = {
["Voltorb"] = {lookType = 287},
["Electrode"] = {lookType = 286},
["Sandshrew"] = {lookType = 284},
["Sandslash"] = {lookType = 285},
["Phanpy"] = {lookType = 480},
["Donphan"] = {lookType = 482},
["Miltank"] = {lookType = 481},
["Golem"] = {lookType = 288},
["Omastar"] = {lookType = 1245},
["Shiny Electrode"] = {lookType = 513},
["Shiny Golem"] = {lookType = 648},
["Shiny Voltorb"] = {lookType = 514},
["Shiny Sandslash"] = {lookType = 1506}
}
local function setOutfit(cid, outfit)
if isCreature(cid) and getCreatureCondition(cid, CONDITION_OUTFIT) == true then
   if getCreatureOutfit(cid).lookType == outfit then
      doRemoveCondition(cid, CONDITION_OUTFIT)
      if getCreatureName(cid) == "Ditto" and pokes[getPlayerStorageValue(cid, 1010)] and getPlayerStorageValue(cid, 1010) ~= "Ditto" then
         if isSummon(cid) then
            local item = getPlayerSlotItem(getCreatureMaster(cid), 8)
            doSetCreatureOutfit(cid, {lookType = getItemAttribute(item.uid, "transOutfit")}, -1)   --alterado v1.8
         end
      end
   end
end
end


if RollOuts[name] then
doSetCreatureOutfit(cid, RollOuts[name], -1)   --alterado v1.6.1
end

local outfit = getCreatureOutfit(cid).lookType

local function roll(cid, outfit)
if not isCreature(cid) then return true end
if isSleeping(cid) then return true end
if RollOuts[name] then
   doSetCreatureOutfit(cid, RollOuts[name], -1)
end
end

setPlayerStorageValue(cid, 3644587, 1)
addEvent(setPlayerStorageValue, 9000, cid, 3644587, -1)
for r = 1, 11 do  --8
addEvent(roll, 750 * r, cid, outfit)
end
addEvent(setOutfit, 9050, cid, outfit)
end