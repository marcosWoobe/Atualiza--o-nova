local shinysName = {
"Magikarp", "Voltorb", "Rattata", "Krabby", "Paras", "Horsea",

"Growlithe", "Grimer", "Larvitar", "Dratini", "Tentacool", "Zubat", "Cubone", "Venonat",

"Golbat", "Parasect", "Butterfree", "Beedrill", "Seadra", "Kingler", "Raticate",

"Magcargo", "Crobat", "Electrode", "Venomoth",

"Feraligatr", "Lanturn", "Blastoise", "Pidgeot", "Arcanine", "Charizard", "Mr. Mime", "Tangela", "Machamp", "Weezing", "Alakazam", "Dragonair",
"Venusaur", "Tauros", "Tentacruel", "Jynx", "Pupitar", "Ampharos", "Muk", "Typhlosion", "Marowak", "Xatu", "Raichu", "Pinsir", "Gengar", "Meganium",

"Gyarados", "Magmar", "Electabuzz", "Scyther", "Giant Magikarp", "Farfetch'd"
-- "Gyarados", "Magmar", "Electabuzz", "Scyther", "Giant Magikarp", "Farfetch'd", "Gardevoir", "Sceptile", "Swampert"
}

-- local shinysCyber = {
-- "Onix", "Umbreon", "Espeon", "Stantler", "Magneton", "Rhydon", "Ariados", "Dodrio", "Ninetales", "Politoed",,
-- }

local phBoss = {'Rhyperior','Magmortar','Electivire','Dusknoir','Milotic','Metagross','Tangrowth','Slaking','Salamence'}

-- local phenacPokes = {'Zoroark', 'Shiny Gardevoir', 'Shiny Heatmor'}
local phenacPokes = {'Zoroark', 'Pangoro', 'Archeops', 'Carracosta', 'Shiny Rampardos', "Shiny Heatmor"}

function onSpawn(cid)
	if getCreatureName(cid) == "" or getCreatureName(cid) == nil then
	   setPlayerStorageValue(cid, 510, getCreatureNick(cid))
	end
	
	
	--if isTwoGerenetion(doCorrectString(getCreatureName(cid))) then doRemoveCreature(cid) return false end
	registerCreatureEvent(cid, "GeneralConfiguration")
	registerCreatureEvent(cid, "WildAttack")
	registerCreatureEvent(cid, "Experience")
	registerCreatureEvent(cid, "Matou")
	registerCreatureEvent(cid, "PokeWalk")
	registerCreatureEvent(cid, "StatsChange")
	
	if not ehMonstro(cid) then
		registerCreatureEvent(cid, "Target")
		registerCreatureEvent(cid, "Matou")
		registerCreatureEvent(cid, "SummonDeath")
		getPokeDistanceToTeleport(cid)
		setPokemonGhost(cid)
		if getCreatureName(cid):find("Shiny ") then
		   setPlayerStorageValue(cid, storages.EhShiny, 1)
		end
	return true
	end
	
	addEvent(doShiny, 1, cid)
	addEvent(spawnMega, 1, cid)
	addEvent(spawnBoss, 1, cid)
	addEvent(isPhenacShiny, 1, cid)
	adjustWildPoke(cid, rate)
	setPokemonGhost(cid)
	doMarkedPos(cid, getThingPos(cid))
	
	   if isPokePassive(cid) then
	      setPokemonPassive(cid, true)
	   end

return true
end

function isPhenacShiny(cid)
	if isSummon(cid) then return true end
	if isCreature(cid) then
		if isWild(cid) and isPhenac(doCorrectString(getCreatureName(cid))) then
			local chance = 40
			if math.random(1, 10000) <= chance then
				local phenacMob = doSummonCreature(phenacPokes[math.random(1, #phenacPokes)], getThingPos(cid))
				adjustWildPoke(phenacMob, 4)
				return true
			end
			return true
		end
		return true
	end
end


function spawnBoss(cid)
	if isSummon(cid) then return true end
	if isCreature(cid) then
		if isWild(cid) and isPhenac(doCorrectString(getCreatureName(cid))) then
			local chance = 40
			if math.random(1, 10000) <= chance then
				local boss = doSummonCreature(phBoss[math.random(1, #phBoss)], getThingPos(cid))
				adjustWildPoke(boss, 7)
				return true
			end
			return true
		end
		return true
	end
end

function spawnMega(cid)
	if isSummon(cid) then return true end
	if isCreature(cid) then
		if isWild(cid) and not isMega(cid) then
			local chance = 50
			if math.random(1, 10000) <= chance then 
				checkChenceToMega(cid, true)
				return true
			end
		return true
		end
		return true
	end
return true
end

local chShinyOut = 200 -- 4%
		
function doShiny(cid)
	-- if isInArea(getThingPos(cid), towerTopCorner, towerBottomCorner) then return false end
	if isCreature(cid) then
		if isSummon(cid) then return true end
		if isNPCSummon(cid) then return true end
		if isOutlandPoke(getCreatureName(cid)) then
			-- local rand = math.random(1,100) <= 75 and 
			local namee = "Shiny ".. shinysName[math.random(21, #shinysName)]
			local side, pose = cid, getThingPos(cid)
			if pokes[namee] then
				if math.random(1,10000) <= chShinyOut then
					doCreateMonsterNick(side, namee, retireShinyName(namee), pose, false)
				end
			else
				print("Shiny ".. namee .." doesn't exists!")
			end
		end
		local chance = 0
		if isInArray(shinysName, doCorrectString(getCreatureName(cid))) then  --alterado v1.9 \/
		   chance = 400    --2.5% chance  
		end    
		local sid = cid
		if math.random(1, 10000) <= chance then  
		  doSendMagicEffect(getThingPos(cid), 18)               
		  local name, pos = "Shiny ".. getCreatureName(cid), getThingPos(cid)
		  if not pokes[name] then return true end
		  doRemoveCreature(cid)
		  --print(name .. ", " .. retireShinyName(name))
		  local shi = doCreateMonsterNick(sid, name, retireShinyName(name), pos, false)		  
		end 
		return true
	end
	return false
end