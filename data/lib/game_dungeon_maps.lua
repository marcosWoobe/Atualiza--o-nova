Dz.PrizeRooms = {
  [1] = {
    teleportPos =  {x = 37, y = 53, z = 6},
    inUse = false,
    corpse = {
      [1] = {x = 36, y = 23, z = 6},
      [2] = {x = 25, y = 33, z = 6},
      [3] = {x = 46, y = 33, z = 6},
    },
    chest = {
      [1] = {x = 32, y = 11, z = 6},
      [2] = {x = 36, y = 10, z = 6},
      [3] = {x = 40, y = 11, z = 6},
    },
  },
  [2] = {
    teleportPos =  {x = 37, y = 53, z = 6},
    inUse = false,
    corpse = {
      [1] = {x = 36, y = 23, z = 6},
      [2] = {x = 25, y = 33, z = 6},
      [3] = {x = 46, y = 33, z = 6},
    },
    chest = {
      [1] = {x = 32, y = 11, z = 6},
      [2] = {x = 36, y = 10, z = 6},
      [3] = {x = 40, y = 11, z = 6},
    },
  },
}

----------------------------------------------------------------------------------------------------
---------------------------------------------BEGINNER-----------------------------------------------
----------------------------------------------------------------------------------------------------

Dz.Diff[DzBeginner].Level = {min=200, max=400}
Dz.Diff[DzBeginner].Maps = {}
Dz.Diff[DzBeginner].Maps[1] = {name = "Lugia Quest", rarity = DzBronze, maxPlayers = 1, image = "catinhorattata", active = true}
Dz.Diff[DzBeginner].Maps[1].experience = 30000000
Dz.Diff[DzBeginner].Maps[1].time = 60000 * 60
Dz.Diff[DzBeginner].Maps[1].potions = 20
Dz.Diff[DzBeginner].Maps[1].revives = 12
Dz.Diff[DzBeginner].Maps[1].corpses = {[1] = {"Glalie","Walrein", "Altaria", "Froslass"}, [2] = {"Raticate","Rattata","Raticate","Rattata"}}
Dz.Diff[DzBeginner].Maps[1].reward = {}
Dz.Diff[DzBeginner].Maps[1].rooms = {}
Dz.Diff[DzBeginner].Maps[1].rooms[1] = {
  pos = {player = {x = 1922, y = 2056, z = 7}, from = {x = 1987, y = 1930, z = 4}, to = {x = 1951, y = 2066, z = 7}},
  inUse = false,
  variable = {pokemonCount = 0, time = nil, members = {}, pokemons = {}},
  pokemons = {
    {name = "Glalie", pos = {x = 1914, y = 2029, z = 6}},
	
    {name = "Altaria", pos = {x = 1914, y = 1997, z = 5}},
	
    {name = "Walrein", pos = {x = 1936, y = 2006, z = 6}},
	
    {name = "Froslass", pos = {x = 1927, y = 1987, z = 5}},
	
  },
  boss = {name = "Lugia", pos = {x = 1926, y = 1950, z = 4}}
}


Dz.Diff[DzTalented].Maps = {}

Dz.Diff[DzIntermediary].Maps = {}

Dz.Diff[DzAdvanced].Maps = {}

Dz.Diff[DzExperient].Maps = {}

for diff=DzBeginner, DzExperient do
  for mapId, map in pairs (Dz.Diff[diff].Maps) do
    if map.active then
      for rewardId, reward in pairs(map.reward) do
        reward.name = getItemInfo(reward.id).name
        reward.clientId = getItemInfo(reward.id).clientId
      end
      Dz.SearchingPlayers[diff][mapId] = {}
    end
  end
end