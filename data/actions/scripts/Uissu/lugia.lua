local posf = {{x=2010,y=2023,z=7},{x=2012,y=2023,z=7},{x=2010,y=2025,z=7},{x=2012,y=2025,z=7},}
local toposi = {{x=1922,y=2055,z=7},{x=1923,y=2055,z=7},{x=1922,y=2054,z=7},{x=1923,y=2054,z=7},}

local postop = {x=1899,y=1932,z=4}
local posbot = {x=2043,y=2067,z=7}

local posbosstop = {x=1979,y=1934,z=4}
local posbossbot = {x=2020,y=1970,z=4}

local effect = {27, 28, 79, 84, 85}

local bosspos = {x=1996,y=1950,z=4}

local posf2 = {{x=1917,y=1942,z=4},{x=1934,y=1959,z=4}}

local function outPosLugia()
return {x=math.random(2015,2016),y=math.random(2023,2024),z=7}
end

local sto = 42414
local stoT = 42415

local prize = 12227
local rwdexp = 1000000
local cd = 60 * 60 -- 1 hora
local cdWin = 60 * 60 * 24 -- 24 horas
local minPlayers = 4
function doTeleportThingWithPk(cid, topos)
	if not isCreature(cid) then return false end
	if #getCreatureSummons(cid) > 0 then
		doTeleportThing(getCreatureSummons(cid)[1], topos)
	end
	return doTeleportThing(cid, topos)
end

local players = {}
-- uid, frompos, name

function lugiaClean(dead)
	local namedead = ''
	namedead = dead
	for x=postop.x,posbot.x do
		for y=postop.y,posbot.y do
			for z=postop.z,posbot.z do
				for stack=250,255 do
					local checkpos = {x=x,y=y,z=z,stackpos=stack}
					local c = getThingFromPos(checkpos).uid
					if isCreature(c) and not isSummon(c) and not isPlayer(c) and (getCreatureName(c) == "Lugia" or getCreatureName(c) == "Weakened Lugia" or getCreatureName(c) == "Crystal" or getCreatureName(c) == "Teste") then
						doRemoveCreature(c)
					end
					if isPlayer(c) then
						local byepos = outPosLugia()
						--local namsg = namedead ~= '' and namedead or "Someone"
						--doPlayerSendTextMessage(c, MESSAGE_STATUS_CONSOLE_RED, namsg .." died, your team failed the tomb.")
						doTeleportThingWithPk(c, byepos)
					end
				end
			end
		end
	end
	for k,v in pairs(players) do players[k]=nil end
end

local poscrystals = {{x=2011,y=1960,z=4},{x=2009,y=1939,z=4},{x=1983,y=1939,z=4},{x=1982,y=1959,z=4},}

function lugiaCheckPlayers()
	local nameDead = ""
	for i,v in ipairs(players) do
		if not isPlayer(v.uid) or not isInArea(getThingPos(v.uid), postop, posbot) then
			nameDead = v.name
			break
		end
	end
	if nameDead ~= "" then
		doBroadcastMessage(nameDead .." died and his team failed the Lugia Mountain.")
		for i,v in ipairs(players) do
			doSendMsg(v.uid, "Lugia: !!!")
			doSendMsg(v.uid, nameDead .." has frozen solid.")
		end
		lugiaClean(nameDead)
		return true
	end
	return addEvent(lugiaCheckPlayers, 100)
end

function lugiaCheckStage()
	if isCreature(lugiatab.boss) then
		return addEvent(lugiaCheckStage, 5000)
	end
	
	for i,v in pairs(players) do
		if isPlayer(v.uid) then
			doSendMsg(v.uid, "Lugia: KIIIIEEEEAAAAaaAa!")
			if getPlayerStorageValue(v.uid, sto) ~= 1 then
				setPlayerStorageValue(v.uid, sto, 1)
				local bag = doCreateItemEx(12684)
				addItemInFreeBag(bag, 17245, 1) -- stamina 3h
				addItemInFreeBag(bag, 17205, 1) -- tm box a
				addItemInFreeBag(bag, 6569, 36) -- rare candy
				addItemInFreeBag(bag, 15644, 40) -- mighty token
				addItemInFreeBag(bag, 15646, 10) -- honored token
				doPlayerAddItemEx(v.uid, bag)
				setPlayerStorageValue(v.uid, 100132, 1)
				addEvent(doSendMsg, 5000, v.uid, "You've received a reward.")
				addEvent(addExpByStages, 5000, v.uid, rwdexp * 4, true)
			end
			doPlayerAddItem(v.uid, 17206, 1) -- tm box d
			doPlayerAddItem(v.uid, 6569, 50) -- Rare candy 
			doPlayerAddItem(v.uid, 18418, 1) -- Reroll IV Ticket
			setPlayerStorageValue(v.uid, stoT, os.time() + cdWin)
			addEvent(addExpByStages, 5000, v.uid, rwdexp, true)
			local byepos = outPosLugia()
			addEvent(doTeleportThingWithPk, 5000, v.uid, byepos)
			addEvent(doSendMagicEffect, 5000, byepos, effect[math.random(1,#effect)])
		end
	end
	for x=posbosstop.x,posbossbot.x do
		for y=posbosstop.y,posbossbot.y do
			local effpos = {x=x,y=y,z=posbosstop.z}
			if math.random(1,5) == 1 then
				addEvent(doSendMagicEffect, math.random(0,4000), effpos, effect[math.random(1,#effect)])
			end
		end
	end
	addEvent(lugiaClean, 5001)
end

god = getPlayerByName("[*] Uissu")

function getPlayerFromPos2(pos)
	for i,p in pairs(getPlayersOnline()) do
		local ppos = getThingPos(p)
		if ppos.x == pos.x and ppos.y == pos.y and ppos.z == pos.z then
			return p
		end
	end
	return 0
end

function lugiaValidate(cid)
	players = nil
	players = {}
	local tmpP = {}
	local tmpC = {}
	for i=1,#posf do
			local cpos = posf[i]
			cpos.z = 7 -- AMÉM
			local pid = getPlayerFromPos2(cpos)
			if isPlayer(pid) and getPlayerGroupId(pid) < 5 then
				if isGod(cid) then doSendMsg(cid, i .. ": ".. getCreatureName(pid)) end
				local uid, frompos, name = pid, cpos, getCreatureName(pid)
				if getPlayerStorageValue(pid, stoT) > os.time() then doSendMsg(cid, name.." is on cooldown. Wait ".. math.ceil((getPlayerStorageValue(pid, stoT) - os.time())/60) .." minutes to go again!") return false end
				if getPlayerLevel(pid) < 300 then doSendMsg(cid, name.."'s level is not high enough.") return false end
				table.insert(tmpP, {uid=uid,frompos=frompos,name=name})
			end
	end
	if #tmpP < minPlayers then
		doSendMsg(cid, "You need at least ".. minPlayers .." players. (".. #tmpP .."/".. minPlayers ..")")
		return false
	else
		for i,v in pairs(tmpP) do
			players[i] = v
		end
		doBroadcastMessage(getCreatureName(cid).."'s team is going to challenge the Legendary Lugia!")
		lugiaStart()
	end
	return true
end

function lugiaStart()
	lugiatab = {
	boss = 0,
	crystals = {},
	}
	setGlobalStorageValue(sto, os.time() + cd)
	for i,v in pairs(players) do
		doTeleportThingWithPk(v.uid, toposi[i])
		doSendMsg(v.uid, "Lugia: ?!")
	end
	lugiatab.boss = doSummonCreature("Lugia", bosspos)
	return lugiaCheckPlayers()
end

function lugiaAlternateCrystals()
	local noCrystals = true
	local id = 0
	for i,v in pairs(lugiatab.crystals) do
		if isCreature(v) then
			doSendMagicEffect(getThingPos(v), 43)
			setPlayerStorageValue(v, stoT, 0)
			noCrystals = false
		end
	end
	local id = math.random(1,4)
	if noCrystals == true then
		for i,v in pairs(players) do
			if isPlayer(v.uid) then
				doSendMsg(v.uid, "All crystals are broken, Lugia is now vulnerable!")
			end
		end
		return true
	elseif not isCreature(lugiatab.crystals[id]) and id ~= 0 then
		return addEvent(lugiaAlternateCrystals,100)
	else
		for i,v in pairs(players) do
			if isPlayer(v.uid) then
				doSendMsg(v.uid, "A new crystal is vulnerable, destroy it!")
			end
		end
	end
	setPlayerStorageValue(lugiatab.crystals[id], stoT, 1)
	doSendMagicEffect(getThingPos(lugiatab.crystals[id]), 412)
	return addEvent(lugiaAlternateCrystals,16000)
end

local disttoboss = 72

function onUse(cid, item, frompos, item2, topos)
	
	if item.actionid == 42414 then
		if isGod(cid) then
			if getGlobalStorageValue(sto) > 0 then
				lugiaClean()
				doSendMsg(cid, sto.." reset.")
				setGlobalStorageValue(sto, 0)
				return true
			end
			minPlayers = 1
		end
		if getGlobalStorageValue(sto) > os.time() then
			doSendMsg(cid, "Wait ".. math.ceil((getGlobalStorageValue(item.actionid)-os.time())/60) .." minutes.")
			return true
		end
		lugiaValidate(cid)
	elseif item.actionid == 42415 then
		local teleme = {}
		for i,v in pairs(players) do
			local chid = v.uid
			if not isInArea(getThingPos(chid), posf2[1], posf2[2]) then
				doSendMsg(cid, "You can't go alone. Wait for your friends!")
				return true
			end
			table.insert(teleme, chid)
		end
		for vi,vuid in pairs(teleme) do
			local fpost = getThingPos(vuid)
			doTeleportThingWithPk(vuid, {x=fpost.x+disttoboss,y=fpost.y,z=fpost.z})
		end
		for ci,cp in pairs(poscrystals) do
			lugiatab.crystals[ci] = doSummonCreature("Crystal", cp)
		end
		lugiaAlternateCrystals()
		lugiaCheckStage()
	end
return true
end