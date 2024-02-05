////////////////////////////////////////////////////////////////////////
// OpenTibia - an opensource roleplaying game
////////////////////////////////////////////////////////////////////////
// This code did is maded by Tony Araújo (OrochiElf)
////////////////////////////////////////////////////////////////////////

#include "otpch.h"
#include "const.h"

#include "area.h"
#include "tools.h"

#include "game.h"
#include "configmanager.h"

#include "creature.h"
#include "player.h"

extern Game g_game;
extern ConfigManager g_config;

std::list<Tile*> Area::getList(const Position& pos)
{
	Tile* tile = NULL;
	std::list<Tile*> tileList;
	uint16_t offsetX = pos.x, offsetY = pos.y;

	offsetX -= getCenterX();
	offsetY -= getCenterY();
	for(size_t y = 0; y < getRows(); ++y)
	{
		for(size_t x = 0; x < getCols(); ++x)
		{
			if(getValue(y, x))
			{
				if(pos.z < MAP_MAX_LAYERS && g_game.isSightClear(pos, Position(offsetX, offsetY, pos.z), true))
				{
					if(tile = g_game.getTile(offsetX, offsetY, pos.z))
						tileList.push_back(tile);
				}
			}
			offsetX++;
		}
		offsetX -= cols;
		offsetY++;
	}
	return tileList;
}
