local a = {
[11638] = {
pokemons = {"Slowpoke", "Magnemite", "Doduo", "Seel", "Grimer", "Gastly", "Drowzee", "Voltorb",
        "Cubone", "Koffing", "Cyndaquil", "Pidgeotto", "Weepinbell", "Wooper", "Dratini", "Dunsparce", "Pichu", "Slugma", "Remoraid", "Ledyba", 
        "Goldeen", "Vulpix", "Tentacool", "Bulbasaur", "Charmander", "Squirtle", "Metapod", "Kakuna",
        "Teddiursa", "Chikorita", "Chinchou", "Cleffa", "Marill", "Natu", "Smoochum", "Phanpy", "Slugma",
        "Ekans", "Abra", "Mankey", "Psyduck", "Sandshrew", "Kabuto", "Beedrill", "Omanyte", "Butterfree", "Snubbul", "Togepi",
        "Zubat", "Diglett", "Venonat", "Shuckle", "Mareep",
        "Meowth", "Poliwag", "Growlithe", "Machop", "Ponyta", "Geodude", "Hoothoot", "Pineco", "Sentret",
        "Swinub", "Totodile"}},
[11639] = {pokemons = {"Skiploom", "Raticate", "Ariados", "Flaffy", "Delibird", "Fearow", "Clefairy", "Arbok",
        "Nidorino", "Nidorina", "Elekid", "Magby", "Ledian",
        "Dodrio", "Golbat", "Gloom", "Parasect", "Venomoth", "Dugtrio", "Persian",
        "Poliwhirl", "Machoke", "Quilava", "Yanma",
        "Graveler", "Slowbro", "Magneton", "Farfetch'd", "Haunter", "Kingler", "Electrode",
        "Weezing", "Seadra", "Bayleef", "Croconaw", "Qwilfish", "Tyrogue",
        "Jigglypuff", "Seaking", "Tauros", "Starmie", "Eevee", "Charmeleon",
        "Wartortle", "Ivysaur", "Pikachu"}},
[11640] = {pokemons = {"Politoed", "Magcargo", "Noctowl", "Poliwrath", "Nidoking", "Pidgeot", "Sandslash", "Ninetales", "Vileplume",
        "Primeape", "Nidoqueen", "Granbull", "Jumpluff", "Golduck", "Kadabra", "Rapidash", "Azumarill", "Murkrow",
        "Clefable", "Wigglytuff", "Dewgong", "Onix", "Cloyster", "Hypno", "Exeggutor", "Marowak",
        "Hitmonchan", "Quagsire", "Stantler", "Xatu", "Hitmonlee", "Bellossom", "Lanturn", "Pupitar", "Smeargle",
        "Lickitung", "Golem", "Chansey", "Tangela", "Mr. Mime", "Pinsir", "Espeon", "Umbreon", "Vaporeon", "Jolteon", 
        "Flareon", "Porygon", "Dragonair", "Hitmontop", "Octillery", "Sneasel"}},
[11641] = {pokemons = {"Dragonite", "Snorlax", "Kabutops", "Omastar", "Kingdra",
        "Ampharos", "Blissey", "Donphan", "Girafarig", "Mantine", "Miltank", "Porygon2", "Skarmory", "Lapras", "Gyarados", "Magmar", "Electabuzz", "Jynx", "Scyther", "Kangaskhan",
        "Venusaur", "Crobat", "Heracross", "Meganium",  "Piloswine", "Scizor",
        "Machamp", "Arcanine", "Charizard", "Blastoise", "Tentacruel",
        "Alakazam", "Feraligatr", "Houndoom",
        "Gengar", "Rhydon", "Misdreavus", "Wobbuffet", "Raichu", "Slowking", "Steelix", "Sudowoodo", "Typhlosion", "Tyranitar", "Ursaring"}},
[12331] = {pokemons = {"Shiny Abra"}},
[12227] = {pokemons = {"Shiny Crobat", "Shiny Giant Magikarp", "Shiny Venusaur", "Shiny Charizard", "Shiny Blastoise", "Shiny Arcanine", "Shiny Alakazam", "Shiny Ninetales",
        "Shiny Gengar", "Shiny Rhydon", "Shiny Umbreon", "Shiny Pidgeot", "Shiny Raichu", "Shiny Tentacruel", "Shiny Ampharos", "Shiny Feraligatr", "Shiny Meganium", 
		"Shiny Tangela", "Shiny Ariados", "Shiny Politoed", "Shiny Typhlosion", "Shiny Tauros", 
        "Shiny Venomoth", "Shiny Espeon", "Shiny Magneton","Shiny Machamp", 
	"Shiny Golbat", "Shiny Dodrio", "Shiny Farfetch'd", "Shiny Zubat", "Shiny Venonat", 
        "Shiny Muk", "Shiny Stantler", "Shiny Marowak"}
},
		
['tier a/s'] = {pokemons = {"Shiny Magmar", "Shiny Scyther", "Shiny Jynx", "Shiny Electabuzz", "Shiny Gyarados", "Crystal Onix", "Shiny Larvitar", "Shiny Pupitar", "Shiny Pinsir", "Shiny Dratini", "Shiny Dragonair", "Shiny Mr. Mime"}},

}     

local c = {
["volcanic"] = "Infernape",
["seavell"] = "Empoleon",
["orebound"] = "Torterra",
["wingeon"] = "Honchkrow",
["malefic"] = "Honchkrow",
["gardestrike"] = "Infernape",
["psycraft"] = "Gallade",
["naturia"] = "Torterra",
["raibolt"] = "Luxray",
["ironhard"] = "Empoleon",
}
         
function onUse(cid, item, frompos, item2, topos)
		if item.actionid == 99 then return true end
		local b = a[item.itemid]                                    
		if not b and item.itemid ~= 17201 then return true end
		local pokemon = false
		if item.itemid ~= 17201 then
			pokemon = b.pokemons[math.random(#b.pokemons)]
		end
		
		local balltype = "poke"
		if item.itemid == 17201 then pokemon = c[getPlayerClan(cid):lower()] balltype = "heavy" end
		if not pokes[pokemon] then return true end  
			   
		if getPlayerFreeCap(cid) > 1 then
			doPlayerSendTextMessage(cid, 27, "You opened a ".. getItemNameById(item.itemid) .."!")
			doPlayerSendTextMessage(cid, 27, "The prize pokemon was a "..pokemon..", congratulations!")
			doSendMagicEffect(getThingPos(cid), 29)
			addPokeToPlayer(cid, pokemon, 0, balltype)                                               
			doRemoveItem(item.uid, 1)
		else
			doSendMsg(cid, "You don't have enough space in your bag")
		end
    
return true
end