-- local coins = {
-- [12416] = {to = 2148},
-- [2148] = {to = 2152, from = 12416}, 
-- [2152] = {to = 2160, from = 2148}, 
-- [2160] = {to = 2161, from = 2152},
-- [2161] = {from = 2160},
-- }

local coins = {
[2148] = {to = 2152},
[2152] = {to = 2160, from = 2148}, 
[2160] = {to = 2161, from = 2152}, 
[2161] = {from = 2160},
}

function onUse(cid, item, fromPosition, itemEx, toPosition)

	if(getPlayerFlagValue(cid, PLAYERFLAG_CANNOTPICKUPITEM)) then
		return false
	end

	local coin = coins[item.itemid]
	if(not coin) then
		return false
	end

	if(coin.to ~= nil and item.type == 100) then
		doChangeTypeItem(item.uid, item.type - item.type)
		doPlayerAddItem(cid, coin.to, 1)
	elseif(coin.from ~= nil) then
		doChangeTypeItem(item.uid, item.type - 1)
		doPlayerAddItem(cid, coin.from, 100)
	end
	
	return true
end

-- local coins = {
	-- [ITEM_GOLD_COIN] = {
		-- to = ITEM_HUNDRED_THOUSAND, 
		-- effect = TEXTCOLOR_YELLOW
	-- },
	-- [ITEM_HUNDRED_THOUSAND] = {
		-- to = ITEM_TEN_THOUSAND, 
		-- effect = TEXTCOLOR_YELLOW
	-- },
	-- [ITEM_TEN_THOUSAND] = {
		-- to = ITEM_MILLION_NOTE, 
		-- effect = TEXTCOLOR_BLUE
	-- },
-- }

-- function onUse(cid, item, fromPosition, itemEx, toPosition)
	-- if(getPlayerFlagValue(cid, PLAYERFLAG_CANNOTPICKUPITEM)) then
		-- return false
	-- end

	-- local coin = coins[item.itemid]
	-- if(not coin) then
		-- return false
	-- end

	-- if(coin.to ~= nil and item.type == 100) then
		-- doChangeTypeItem(item.uid, item.type - item.type)
		-- doPlayerAddItem(cid, coin.to, 1)
		-- doSendAnimatedText(fromPosition, "$$$", coins[coin.to].effect)
	-- elseif(coin.from ~= nil) then
		-- doChangeTypeItem(item.uid, item.type - 1)
		-- doPlayerAddItem(cid, coin.from, 100)
		-- doSendAnimatedText(fromPosition, "$$$", coins[coin.from].effect)
	-- end
	-- return true
-- end
