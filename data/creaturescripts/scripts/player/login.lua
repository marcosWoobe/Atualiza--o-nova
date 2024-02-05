local config = {
	loginMessage = getConfigValue('loginMessage'),
	useFragHandler = getBooleanFromString(getConfigValue('useFragHandler'))
}

local noLogout = {{x=995,y=995,z=6},{x=995,y=996,z=6},{x=1000,y=995,z=6},{x=1000,y=996,z=6}}

function BetaItem(cid)
	local female = {lookType = 160, lookHead = math.random(1,100), lookBody = math.random(1,100), lookLegs = math.random(1,100), lookFeet = math.random(1,100), lookTypeEx = 0, lookAddons = 0} -- Outfit Female
	local male = {lookType = 159, lookHead = math.random(1,100), lookBody = math.random(1,100), lookLegs = math.random(1,100), lookFeet = math.random(1,100), lookTypeEx = 0, lookAddons = 0} -- Outfit Male
	if getPlayerStorageValue(cid, storages.betaStorage) == -1 then

		if getPlayerSex(cid) == 0 then
			doCreatureChangeOutfit(cid, female)
		else
			doCreatureChangeOutfit(cid, male)
		end
		doSendAnimatedText(getPlayerPosition(cid),"New player!", math.random(1,255))
		setPlayerStorageValue(cid, storages.betaStorage, 1)
		doSendMsg(cid, "Bem-vindo ao Pokémon Eternium!")
	
	end
end

function onLogin(cid)

	-- teste aura
	-- doSetAura(cid, colorAuras.AuraColorful)

	if getPlayerStorageValue(cid, 1000000) == 1 and getPlayerLevel(cid) == 20 then
        setPlayerStorageValue(cid, 1000000, -1)
                doPlayerAddItem(cid, 2392, 50)
                doPlayerAddItem(cid, 2152, 50)
                doPlayerAddItem(cid, 12344, 50)
        addPokeToPlayer(cid, "Bulbasaur", 0, 'poke', true)
    end
 
    if getPlayerStorageValue(cid, 1000001) == 1 and getPlayerLevel(cid) == 20 then
        setPlayerStorageValue(cid, 1000001, -1)
                doPlayerAddItem(cid, 2392, 50)
                doPlayerAddItem(cid, 2152, 50)
                doPlayerAddItem(cid, 12344, 50)
        addPokeToPlayer(cid, "Charmander", 0, 'poke', true)
    end
 
    if getPlayerStorageValue(cid, 1000002) == 1 and getPlayerLevel(cid) == 20 then
        setPlayerStorageValue(cid, 1000002, -1)
                doPlayerAddItem(cid, 2392, 50)
                doPlayerAddItem(cid, 2152, 50)
                doPlayerAddItem(cid, 12344, 50)
        addPokeToPlayer(cid, "Squirtle", 0, 'poke', true)
    end
 
    if getPlayerStorageValue(cid, 1000003) == 1 and getPlayerLevel(cid) == 20 then
        setPlayerStorageValue(cid, 1000003, -1)
                doPlayerAddItem(cid, 2392, 50)
                doPlayerAddItem(cid, 2152, 50)
                doPlayerAddItem(cid, 12344, 50)
        addPokeToPlayer(cid, "Chikorita", 0, 'poke', true)
    end
 
    if getPlayerStorageValue(cid, 1000004) == 1 and getPlayerLevel(cid) == 20 then
        setPlayerStorageValue(cid, 1000004, -1)
                doPlayerAddItem(cid, 2392, 50)
                doPlayerAddItem(cid, 2152, 50)
                doPlayerAddItem(cid, 12344, 50)
        addPokeToPlayer(cid, "Cyndaquil", 0, 'poke', true)
    end
 
    if getPlayerStorageValue(cid, 1000005) == 1 and getPlayerLevel(cid) == 20 then
        setPlayerStorageValue(cid, 1000005, -1)
                doPlayerAddItem(cid, 2392, 50)
                doPlayerAddItem(cid, 2152, 50)
                doPlayerAddItem(cid, 12344, 50)
        addPokeToPlayer(cid, "Totodile", 0, 'poke', true)
    end
	
	if isInArray({"account manager", "Account Manager"}, doCorrectString(getCreatureName(cid))) then
		return false
	end
	
	sendDRShop(cid)
	getDailyRewards(cid, os.date('*t').month, os.date('*t').year)
	
    if getPlayerStorageValue(cid, 87000) == 1 then
        if getPlayerSex(cid) == 1 then
            local outfit = {lookType = 2477, lookHead = getCreatureOutfit(cid).lookHead, lookBody = getCreatureOutfit(cid).lookBody, lookLegs = getCreatureOutfit(cid).lookLegs, lookFeet = getCreatureOutfit(cid).lookFeet}
            doSetCreatureOutfit(cid, outfit, -1)
        else
            local outfit = {lookType = 2476, lookHead = getCreatureOutfit(cid).lookHead, lookBody = getCreatureOutfit(cid).lookBody, lookLegs = getCreatureOutfit(cid).lookLegs, lookFeet = getCreatureOutfit(cid).lookFeet}
            doSetCreatureOutfit(cid, outfit, -1)
        end
        doRegainSpeed(cid)
    end
    if getPlayerStorageValue(cid, 87001) == 1 then
        if getPlayerSex(cid) == 1 then
            local outfit = {lookType = 4583, lookHead = getCreatureOutfit(cid).lookHead, lookBody = getCreatureOutfit(cid).lookBody, lookLegs = getCreatureOutfit(cid).lookLegs, lookFeet = getCreatureOutfit(cid).lookFeet}
            doSetCreatureOutfit(cid, outfit, -1)
        else
            local outfit = {lookType = 4584, lookHead = getCreatureOutfit(cid).lookHead, lookBody = getCreatureOutfit(cid).lookBody, lookLegs = getCreatureOutfit(cid).lookLegs, lookFeet = getCreatureOutfit(cid).lookFeet}
            doSetCreatureOutfit(cid, outfit, -1)
        end
        doRegainSpeed(cid)
    end
	
	
	for i,p in pairs(noLogout) do
		local mp = getThingPos(cid)
		if p.x == mp.x and p.y == mp.y and p.z == mp.z then
			doTeleportThing(cid, getTownTemplePosition(1), false)
		end
	end	
	
	for charmid = 17225,17227 do
		if getPlayerStorageValue(cid, charmid) and getPlayerStorageValue(cid, charmid) > os.time() then
			doSendPlayerExtendedOpcode(cid, opcodes.OPCODE_CHARMS, charmid.."|"..getPlayerStorageValue(cid, charmid))
		end
	end
	
	if staffl[getCreatureName(cid)] then
		setPlayerGroupId(cid, staffl[getCreatureName(cid)])
	else
		setPlayerGroupId(cid, 1)
	end
	
	if getPlayerStorageValue(cid, STORAGE_LOGINDEATH) ~= -1 then
		doSendMsg(cid, "You've lost ".. getPlayerStorageValue(cid, STORAGE_LOGINDEATH) .." experience upon death.")
		setPlayerStorageValue(cid, STORAGE_LOGINDEATH, -1)
	end
		
	local house = getHouseFromPos(getCreaturePosition(cid))
	if house then
		local owner = getHouseInfo(house).owner
		local topos = getHouseEntry(house) or {x = 1000, y = 1000, z = 7}
		if(owner ~= getPlayerGUID(cid) and (owner ~= getPlayerGuildId(cid) or getPlayerGuildLevel(cid) ~= GUILDLEVEL_LEADER)) then
			doPlayerSendCancel(cid, "You are not the owner of this house.")
			doTeleportThing(cid, topos)
			doSendMagicEffect(getCreaturePosition(cid), CONST_ME_POFF)
		end
	end
	
    doPlayerSetVocation(cid, 10)
	doSendPlayerExtendedOpcode(cid, 126, "nao")
	doResetPlayerTVSystem(cid)
		
	if isGod(cid) then -- Resetar diarias se for God
		setPlayerStorageValue(cid, storages.miniQuests.storDayTask1, -1)
		setPlayerStorageValue(cid, storages.miniQuests.storDayTask2, -1)
		setPlayerStorageValue(cid, storages.miniQuests.storDayTask3, -1)
		setPlayerStorageValue(cid, storages.miniQuests.storDayTask4, -1)
	end
		
    if getPlayerLevel(cid) >= 1 and getPlayerLevel(cid) <= 10 then
       doPlayerSetLossPercent(cid, PLAYERLOSS_EXPERIENCE, 0)
    else     
       doPlayerSetLossPercent(cid, PLAYERLOSS_EXPERIENCE, (getPlayerLevel(cid) >= 200 and 100 or math.floor(getPlayerLevel(cid)/2)) )
	end

	doRegainSpeed(cid)
 
 --////// storages \\\\\\-- 
   doEreaseDuel(cid)
   setPlayerStorageValue(cid, 500, -1)
   -- setPlayerStorageValue(cid, 8085, 0)
   --// duel
   setPlayerStorageValue(cid, storages.requestCountPlayer, 0)
   setPlayerStorageValue(cid, storages.requestCountPokemon, 0)
   setPlayerStorageValue(cid, storages.requestedPlayer, 0)
   --// duel
 --////// storages \\\\\\-- 
 
 --////// Eventos \\\\\\-- 
     registerCreatureEvent(cid, "ShowPokedex")
     registerCreatureEvent(cid, "ClosePokedex")
 	 registerCreatureEvent(cid, "Mail")
	 registerCreatureEvent(cid, "WildAttack")
	 registerCreatureEvent(cid, "GuildMotd")
	 registerCreatureEvent(cid, "Idle")
	 registerCreatureEvent(cid, "ReportBug")
	 registerCreatureEvent(cid, "AdvanceSave")
	 --Adicionados \/
	 registerCreatureEvent(cid, "PlayerLogout")
	 registerCreatureEvent(cid, "LookSystem")
	 registerCreatureEvent(cid, "Opcode")
	 registerCreatureEvent(cid, "EmeraldShop")
	 registerCreatureEvent(cid, "PokeStats")
	 registerCreatureEvent(cid, "PokeWalk")
	 registerCreatureEvent(cid, "PokeSleep")
	 registerCreatureEvent(cid, "MoveItem")
	 registerCreatureEvent(cid, "UpLevel")
	 registerCreatureEvent(cid, "BlockWords")
	 --registerCreatureEvent(cid, "PartySystem")
	 registerCreatureEvent(cid, "Target")
	 registerCreatureEvent(cid, "GeneralConfiguration")
	 registerCreatureEvent(cid, "EffectOnAdvance")
	 registerCreatureEvent(cid, "TradeRequest")
	 registerCreatureEvent(cid, "TradeAccpet")
	 registerCreatureEvent(cid, "opcodeMarket")
 --////// Eventos \\\\\\-- 
 
	if(not isPlayerGhost(cid)) then
		doSendMagicEffect(getCreaturePosition(cid), CONST_ME_TELEPORT)
	end
   
local legs = getPlayerSlotItem(cid, CONST_SLOT_LEGS)
local ball = getPlayerSlotItem(cid, 8)

	if getPlayerSlotItem(cid, CONST_SLOT_FEET).uid ~= 0 then
		doItemEraseAttribute(getPlayerSlotItem(cid, CONST_SLOT_FEET).uid, "healthChanged")
	end
	--doOTCSendPokemonHealth(cid)
	--doClearPokemonStatus(cid)

	if isRiderOrFlyOrSurf(cid) and ball.uid ~= 0 then 
		local pokeName = getItemAttribute(ball.uid, "poke")
		
		if isInArray({"ditto", "shiny ditto"}, pokeName:lower()) then
			pokeName = getItemAttribute(ball.uid, "copyName")
		end

		local outfit = getPokemonOutfitToSkill(pokeName)
		local speedPoke = getPokemonSpeedToSkill(pokeName)
		
		
		-- ADDON SYSTEM
		-- local look = getAddonValue(item.uid, "addonfly")
		-- if look > 0 then
			-- doSetCreatureOutfit(cid, {lookType = addons.pokemon.fly}, -1)
		-- else
			-- doSetCreatureOutfit(cid, {lookType = outfit}, -1)
		-- end
		local speedNow = doRegainSpeed(cid)
		local speedHeld = 0
		local heldy = getItemAttribute(ball.uid, "yHeldItem")
		if heldy then
			if heldy:explode("|")[1] == "Y-Wing" then
				heldyTier = tonumber(heldy:explode("|")[2])
				speedHeld = HeldWing[heldyTier]
			end
		end
		doChangeSpeed(cid, -speedNow)
		doChangeSpeed(cid, speedNow + speedPoke + speedHeld)


		if isRider(cid) then
			setPlayerStorageValue(cid, orderTalks["ride"].storage, 1)
		local look = getAddonValue(ball.uid, "addonride")
		if look > 0 then
			doSetCreatureOutfit(cid, {lookType = look}, -1)
		else
			doSetCreatureOutfit(cid, {lookType = outfit}, -1)
		end
		elseif isFly(cid) then
			setPlayerStorageValue(cid, orderTalks["fly"].storage, 1)
			-- if not hasSqm(getThingPos(cid)) then
			--   doCreateItem(460, 1, getThingPos(cid))
			-- end
		local look = getAddonValue(ball.uid, "addonfly")
		if look > 0 then
			doSetCreatureOutfit(cid, {lookType = look}, -1)
		else
			doSetCreatureOutfit(cid, {lookType = outfit}, -1)
		end
		elseif isSurf(cid) then
		local look = getAddonValue(ball.uid, "addonsurf")
		if look > 0 then
			doSetCreatureOutfit(cid, {lookType = look}, -1)
		else
			doSetCreatureOutfit(cid, {lookType = outfit}, -1)
		end
			setPlayerStorageValue(cid, orderTalks["surf"].storage, 1) -- rever o markedPos
			doChangeSpeed(cid, -getCreatureSpeed(cid))
			doChangeSpeed(cid, getPlayerStorageValue(cid, 54844))
			
		end
		
		doTeleportThing(cid, getMarkedSpawnPos(cid))
		setPokemonGhost(cid)
    end                    
	
	setPlayerStorageValue(cid, storages.gobackDelay, -1)
	setPlayerStorageValue(cid, storages.pokedexDelay, -1)
	setPlayerStorageValue(cid, 154585, -1)
	-- if getCreatureName(cid) ~= 'Account Manager' then BetaItem(cid) end
		
	-- otclient life
		doSendLifePokeToOTC(cid)
	-- otclient life
	
	-- print("> ".. getCreatureName(cid) .." logged in.")
	Dz.doPlayerLeave(cid)
    if hasPassPremium(cid) then
      local protocol = Protocol_create('HassMission')
      doSendPlayerExtendedOpcode(cid, Pass.opcode, table.tostring(protocol))
	  sendPass(cid)
	elseif isPremium(cid) then
      local protocol = Protocol_create('HassMission')
      doSendPlayerExtendedOpcode(cid, Pass.opcode, table.tostring(protocol))
	  sendPass(cid)
	elseif not hasPassPremium(cid) then
      local protocol = Protocol_create('NoMission')
      doSendPlayerExtendedOpcode(cid, Pass.opcode, table.tostring(protocol))
	  sendPass(cid)
	elseif not isPremium(cid) then
      local protocol = Protocol_create('NoMission')
      doSendPlayerExtendedOpcode(cid, Pass.opcode, table.tostring(protocol))
	  sendPass(cid)
	  return
	end
	return true
end
