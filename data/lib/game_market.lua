json = require('data/lib/json')

local market_items = {}
local OFFERUNDERCONSTRUCTION = 0
local OFFERPOSTED = 1
local OFFERDECLINED = 2
local OFFERACCEPTED = 3

local pokeballs = {12921, 12922, 12923}
local stones_items = {11441, 11442}
local pokebolas_items = {2391, 2392, 2393, 2394}
local diamond_items = {2145}
local addon_items = {}
local outfit_items = {}
local held_items = {}
local furniture_items = {}
local berry_items = {}
local plate_items = {}
local doll_items = {}
local food_items = {}
local utilities_items = {}
local suplies_items = {}

local block_items = {}

function isBlockItem(itemId) return isInArray(block_items, itemId) end
function isPokeball(itemId) return isInArray(pokeballs, itemId) end
function isStones(itemId) return isInArray(stones_items, itemId) end
function isPokebolas(itemId) return isInArray(pokebolas_items, itemId) end
function isDiamonds(itemId) return isInArray(diamond_items, itemId) end
function isAddons(itemId) return isInArray(addon_items, itemId) end
function isOutfits(itemId) return isInArray(outfit_items, itemId) end
function isHelds(itemId) return isInArray(held_items, itemId) end
function isFurnitures(itemId) return isInArray(furniture_items, itemId) end
function isBerrys(itemId) return isInArray(berry_items, itemId) end
function isPlates(itemId) return isInArray(plate_items, itemId) end
function isDolls(itemId) return isInArray(doll_items, itemId) end
function isFoods(itemId) return isInArray(food_items, itemId) end
function isUtilities(itemId) return isInArray(utilities_items, itemId) end
function isSuplies(itemId) return isInArray(suplies_items, itemId) end

function getMarketItemName(itemId, uid)
  if isPokeball(itemId) and getItemAttribute(uid, "poke") then
    return getItemAttribute(uid, "poke")
  end
  return getItemInfo(itemId).name
end

function getMarketPokeInfo(itemId, uid)
  local info = {name = getItemInfo(itemId).name}
  if isPokeball(itemId) and getItemAttribute(uid, "poke") then
    info.name = getItemAttribute(uid, "poke")
    -- info.sex = getItemAttribute(uid, ballsAttributes.sex)
    -- info.level = getItemAttribute(uid, ballsAttributes.pokemonLevel)
  end
  return info
end

function getPokeMarketDescription(itemId, uid, pokemonName, pokemonNickname)
  local description = ""
  if isPokeball(itemId) and getItemAttribute(uid, "poke") then
  
    description = description..getItemAttribute(uid, "poke")
	if getItemAttribute(uid, "xHeldItem") then
		description = description.."\n holding: "..getItemAttribute(uid, "xHeldItem")
	else
		description = description.."\n holding X: nothing."
	end
	if getItemAttribute(uid, "yHeldItem") then
		description = description.."\n holding: "..getItemAttribute(uid, "yHeldItem")
	else
		description = description.."\n holding Y: nothing."
	end

  else
    description = getItemInfo(itemId).description
  end
    return description
  end

function nearOnMarket(cid)
  local lastMarketPosition = getPlayerStorageValue(cid, storages.marketPos)
  local pos = {x = 0,y = 0,z = 0,stackpos = 0}
  local explode = string.explode(lastMarketPosition, ',')
  for s=1, #explode do
    if string.find(explode[s], 'X:') then
	  pos.x = tonumber(string.explode(explode[s], 'X:')[1])
	end
    if string.find(explode[s], 'Y:') then
	  pos.y = tonumber(string.explode(explode[s], 'Y:')[1])
	end
    if string.find(explode[s], 'Z:') then
	  pos.z = tonumber(string.explode(explode[s], 'Z:')[1])
	end
    if string.find(explode[s], 'S:') then
	  pos.stackpos = tonumber(string.explode(explode[s], 'S:')[1])
	end
  end
  -- print("getDistanceBetween: "..getDistanceBetween(getCreaturePosition(cid), pos))
  if getDistanceBetween(getCreaturePosition(cid), pos) > 5 then return false end
  return true
end

function sendMarketClose(cid)
  doSendPlayerExtendedOpcode(cid, GameServerOpcodes.Market, table.tostring(Protocol_create('close')))
end

function refreshMarketOnClient(cid)
  doRefreshMarketItems()
  sendMarketBuyItems(cid, "Todos", 1, 0)
  sendMarketSellItems(cid)
  sendMarketOffers(cid)
  sendMarketHistoric(cid)
end

function doRefreshMarketItems()
  local refresh = false
  for item_code, market_item in pairs(market_items) do
    if market_item.time-os.time() < 0 then
      for playeroffer_id, offers in pairs(market_item.offers) do
	    local checkHistoric = false
        for num, offer_item in ipairs(offers) do
		  if offer_item.state == OFFERUNDERCONSTRUCTION or offer_item.state == OFFERPOSTED then
            local query = ("SELECT `attributes` FROM `market_offers` WHERE `item_code` = '"..item_code.."' AND `playeroffer_id`  = "..offer_item.playeroffer_id.." AND `item_index` = "..offer_item.item_index)
            local mysql = db.getResult(query)
            if mysql:getID() == -1 then
              doPlayerPopupFYI(cid, "Item de mercado inválido")
              return false
            end
            local offerItem = doCreateItemEx(offer_item.itemid, offer_item.count)
            doItemLoadAttributes(offerItem, 'attributes', mysql:getID())
            doItemSetCount(offerItem, offer_item.count)
            if addItem(getPlayerNameByGUID(offer_item.playeroffer_id), offer_item.itemid, offerItem) then
              db.executeQuery("DELETE FROM `market_offers` WHERE `item_code` = '"..item_code.."' AND `item_index` = "..offer_item.item_index.." AND `playeroffer_id` = "..offer_item.playeroffer_id)
            end
            if not checkHistoric and offer_item.state == OFFERPOSTED then 
			  setMarketHistoric(offer_item.playeroffer_id, "Sua oferta foi recusada para o "..market_item.item_name..".")
			  checkHistoric = true
			end
		  end
	  	  refresh = true
        end
      end
	end
  end
  if refresh then getMarketItems() end
end

function setMarketHistoric(guid, negotiation, cid)
  negotiation = os.date('*t').day.."/"..os.date('*t').month.."/"..os.date('*t').year.." - "..negotiation
  local historic = getMarketHistoric(guid)
  historic[#historic+1] = {time = os.time(), negotiation = negotiation}
  if #historic >= 2 then table.sort(historic, function(a,b) return a.time > b.time end) end
  if historic[31] then historic[31] = nil end
  db.executeQuery("UPDATE `market_historic` set `historic` = '"..json.encode(historic).."' WHERE `player_id` = "..guid)
  if cid then sendMarketHistoric(cid) end
end

function getMarketHistoric(guid)
  local historic = {}
  local query = ("SELECT `historic` FROM `market_historic` WHERE `player_id` = "..guid)
  local mysql = db.getResult(query)
  if mysql:getID() ~= -1 then
    historic = json.decode(mysql:getDataString('historic'))
  else
    db.executeQuery("INSERT INTO `market_historic` (`player_id`, `historic`) VALUES ("..guid..", '"..json.encode(historic).."')")
  end
  if #historic >= 2 then table.sort(historic, function(a,b) return a.time < b.time end) end
  return historic
end

function sendMarketHistoric(cid)
  local protocol = Protocol_create('market_historic')
  Protocol_add(protocol, getMarketHistoric(getPlayerGUID(cid)))
  doSendPlayerExtendedOpcode(cid, GameServerOpcodes.Market, table.tostring(protocol))
end

function sendMarketOffers(cid)
  local myitems_withoffers, myOffers = {}, {}
  for item_code, market_item in pairs(market_items) do
    if market_item.playerseller_id == getPlayerGUID(cid) then
	  for playeroffer_id, offers in pairs(market_item.offers) do
	    if offers[1].state == OFFERPOSTED then
		  if not myitems_withoffers[item_code] then
            myitems_withoffers[item_code] = {
		      spriteId          = market_item.spriteId,
		      count             = market_item.count,
		      item_name         = market_item.item_name,
			  poke_info         = market_item.poke_info,
		      time              = market_item.time,
			  description       = market_item.description,
		      offers = {[1] = offers}
		    }
		  else
		    myitems_withoffers[item_code].offers[#myitems_withoffers[item_code].offers+1] = offers
		  end
		end
	  end
	end
	if market_item.offers[getPlayerGUID(cid)] then
	  for num, offer_item in ipairs(market_item.offers[getPlayerGUID(cid)]) do
        if offer_item.state == OFFERPOSTED and offer_item.state <= OFFERACCEPTED then
		  if not myOffers[item_code] then
            myOffers[item_code] = {
		      spriteId          = market_item.spriteId,
			  count             = market_item.count,
		      item_name         = market_item.item_name,
		      poke_info         = market_item.poke_info,
		      playerseller_name = market_item.playerseller_name,
			  description       = market_item.description,
		      offers            = market_item.offers[getPlayerGUID(cid)]
		    }
		  else
		    myOffers[item_code].offers = market_item.offers[getPlayerGUID(cid)]
		  end
        end
	  end
	end
  end
  local count = 1
  local first = true
  local new_myitems_withoffers, new_myOffers = {}, {}
  for item_code, market_item in pairs(myitems_withoffers) do
    new_myitems_withoffers[item_code] = market_item
    if count == 5 then
      local protocol = Protocol_create("market_myitems_withoffers")
      Protocol_add(protocol, first)
      Protocol_add(protocol, new_myitems_withoffers)
      doSendPlayerExtendedOpcode(cid, GameServerOpcodes.Market, table.tostring(protocol))
	  first = false
	  count = 1
	  new_myitems_withoffers = {}
	end
	count = count+1
  end
  local protocol = Protocol_create("market_myitems_withoffers")
  Protocol_add(protocol, first)
  Protocol_add(protocol, new_myitems_withoffers)
  doSendPlayerExtendedOpcode(cid, GameServerOpcodes.Market, table.tostring(protocol))
  count = 1
  first = true
  for item_code, market_item in pairs(myOffers) do
    new_myOffers[item_code] = market_item
    if count == 5 then
      local protocol = Protocol_create("market_myOffers")
      Protocol_add(protocol, first)
      Protocol_add(protocol, new_myOffers)
      doSendPlayerExtendedOpcode(cid, GameServerOpcodes.Market, table.tostring(protocol))
	  first = false
	  count = 1
	  new_myOffers = {}
	end
	count = count+1
  end
  local protocol = Protocol_create("market_myOffers")
  Protocol_add(protocol, first)
  Protocol_add(protocol, new_myOffers)
  doSendPlayerExtendedOpcode(cid, GameServerOpcodes.Market, table.tostring(protocol))
end

function sendMarketSellItems(cid)
  local send_market_items = {}
  for item_code, market_item in pairs(market_items) do
    if getPlayerGUID(cid) == market_item.playerseller_id then
	  send_market_items[#send_market_items+1] = market_item
	end
  end
  if #send_market_items == 0 then
	local protocol = Protocol_create("marketsellitems")
	Protocol_add(protocol, true)
	Protocol_add(protocol, {})
	doSendPlayerExtendedOpcode(cid, GameServerOpcodes.Market, table.tostring(protocol))
	return true
  end 
  local count = 1
  local first = true
  local new_send_market_items = {}
  for i=1, #send_market_items, 1 do
    new_send_market_items[i] = send_market_items[i]
    if count == 5 or i == #send_market_items then
      local protocol = Protocol_create("marketsellitems")
      Protocol_add(protocol, first)
      Protocol_add(protocol, new_send_market_items)
      doSendPlayerExtendedOpcode(cid, GameServerOpcodes.Market, table.tostring(protocol))
	  first = false
	  count = 1
	  new_send_market_items = {}
	end
	count = count+1
  end
end

function sendMarketOffersByItemCode(cid, code)
  local send_offers = {}
  if market_items[code] then
    for playeroffer_id, offers in pairs(market_items[code].offers) do
      for num, offer_item in ipairs(offers) do
        if offer_item.state == OFFERPOSTED then
          send_offers[#send_offers+1] = offer_item
        end
      end
    end
  end
  local protocol = Protocol_create("marketbuyitemsoffers")
  Protocol_add(protocol, send_offers)
  doSendPlayerExtendedOpcode(cid, GameServerOpcodes.Market, table.tostring(protocol))
end

function sendMarketBuyItems(cid, category, page, focus, order, searchstring)
  -- if not nearOnMarket(cid) then return sendMarketClose(cid) end
  if not order then order = "timeasc" end
  local send_market_items = {}
  local qnt_per_page = 15
  for item_code, itemInfo in pairs(market_items) do
    if itemInfo.time - os.time() > 0 then
      if (category == "Todos" or getItemCategory(itemInfo.itemid) == category) then
        if not searchstring or (string.find(string.lower(itemInfo.item_name), string.lower(searchstring)) or string.find(string.lower(itemInfo.playerseller_name), string.lower(searchstring))) then
          local market_item = {
            item_code         = itemInfo.item_code,
            playerseller_name = itemInfo.playerseller_name,
            onlyoffer         = itemInfo.onlyoffer,
            itemid            = itemInfo.itemid,
            spriteId          = itemInfo.spriteId,
            count             = itemInfo.count,
            price             = itemInfo.price,
            time              = itemInfo.time,
      	    item_name         = itemInfo.item_name,
      	    poke_info         = itemInfo.poke_info,
			description       = itemInfo.description,
          }
      	  send_market_items[#send_market_items+1] = market_item
        end
      end
	end
  end
  local maxPage = math.ceil(#send_market_items / qnt_per_page)
  if string.find(order, 'itemdesc') then 
    table.sort(send_market_items, function(a,b) return a.item_name < b.item_name end)
  elseif string.find(order, 'itemasc') then
    table.sort(send_market_items, function(a,b) return a.item_name > b.item_name end)
  elseif string.find(order, 'sellerdesc') then
    table.sort(send_market_items, function(a,b) return a.playerseller_name < b.playerseller_name end)
  elseif string.find(order, 'sellerasc') then
    table.sort(send_market_items, function(a,b) return a.playerseller_name > b.playerseller_name end)
  elseif string.find(order, 'amountdesc') then
    table.sort(send_market_items, function(a,b) return a.count < b.count end)
  elseif string.find(order, 'amountasc') then
    table.sort(send_market_items, function(a,b) return a.count > b.count end)
  elseif string.find(order, 'pricedesc') then
    table.sort(send_market_items, function(a,b) return a.price < b.price end)
  elseif string.find(order, 'priceasc') then
    table.sort(send_market_items, function(a,b) return a.price > b.price end)
  end
  local max_send = 0
  local resend_page = page
  if page > 1 then
    if #send_market_items < page*qnt_per_page then
	  max_send = page*qnt_per_page - (page*qnt_per_page - #send_market_items)
	else
	  max_send = page*qnt_per_page
	end
	page = (page-1)*qnt_per_page+1
  else
    if #send_market_items < qnt_per_page then
      max_send = #send_market_items
    else
	  max_send = qnt_per_page
    end	
  end
  local new_send_market_items = {}
  for _=page, max_send, 1 do
    new_send_market_items[#new_send_market_items+1] = send_market_items[_]
  end
  local protocol = Protocol_create("marketbuyitems")
  Protocol_add(protocol, category)
  Protocol_add(protocol, resend_page)
  Protocol_add(protocol, maxPage)
  Protocol_add(protocol, focus)
  Protocol_add(protocol, searchstring or '')
  Protocol_add(protocol, new_send_market_items)
  doSendPlayerExtendedOpcode(cid, GameServerOpcodes.Market, table.tostring(protocol))
end

function checkMarketCanSellItem(cid, container_index, slot_index)
  -- if not nearOnMarket(cid) then return sendMarketClose(cid) end
  local item = {itemid = 0}
  if container_index >= CONST_SLOT_FIRST and container_index <= CONST_SLOT_LAST then
    item = getPlayerSlotItem(cid, container_index) or item
  elseif container_index >= 64 and container_index <= 80 then
    item = getContainerItemByIndex(cid, container_index - 64, slot_index) or item
  end
  if item.itemid == 0 then
    return doPlayerPopupFYI(cid, "Item não encontrado")
  elseif isBlockItem(item.itemid) then -- block item
    return doPlayerPopupFYI(cid, "Você não pode vender este item")
  elseif isContainer(item.uid) and getContainerSize(item.uid) > 0 then
    return doPlayerPopupFYI(cid, "Você não pode vender este item")
  elseif getItemInfo(item.itemid).worth > 0 then
    return doPlayerPopupFYI(cid, "Você não pode vender este item.")
  elseif not getItemInfo(item.itemid).movable then
    return doPlayerPopupFYI(cid, "Você não pode vender este item.")
  end
  local itemInfo = {item_code = "", itemid = item.itemid, count = item.type, spriteId = getItemInfo(item.itemid).clientId}
  if not isItemStackable(item.itemid) then
    itemInfo.item_code = generateCode()
    doItemSetAttribute(item.uid, storages.marketBase, itemInfo.item_code)
  end
  itemInfo.description = getPokeMarketDescription(item.itemid, item.uid)
  itemInfo.poke_info = getMarketPokeInfo(item.itemid, item.uid)
  local protocol = Protocol_create("marketsellitemschecked")
  Protocol_add(protocol, itemInfo)
  doSendPlayerExtendedOpcode(cid, GameServerOpcodes.Market, table.tostring(protocol))
end

function getMarketItems()
  market_items = {}
  local query = "SELECT `market_items`.*, `players`.`name` FROM `market_items` INNER JOIN `players` ON `market_items`.`playerseller_id` = `players`.`id`"
  local mysql = db.getResult(query)
  if mysql:getID() ~= -1 then
    while(true) do
	  local market_item = {
        item_code         = mysql:getDataString('item_code'),
        playerseller_id   = mysql:getDataInt('playerseller_id'),
        playerseller_name = mysql:getDataString('name'),
        onlyoffer         = mysql:getDataInt('onlyoffer'),
        itemid            = mysql:getDataInt('itemid'),
        count             = mysql:getDataInt('count'),
        price             = mysql:getDataInt('price'),
        time              = mysql:getDataInt('time'),
      }
      local item = doCreateItemEx(market_item.itemid, market_item.count)
      doItemLoadAttributes(item, 'attributes', mysql:getID())
      doItemSetCount(item, market_item.count)
	  market_item.item_name = getMarketItemName(market_item.itemid, item)
	  market_item.poke_info = getMarketPokeInfo(market_item.itemid, item)
	  market_item.spriteId = getItemInfo(market_item.itemid).clientId
	  market_item.offers = getMarketItemOffers(market_item.item_code)
	  market_item.description = getPokeMarketDescription(market_item.itemid, item)
	  market_items[market_item.item_code] = market_item
      if not(mysql:next())then
        break
      end
    end
    mysql:free()
  end
end

function getMarketItemOffers(item_code)
  local offers = {}
  local mysql = db.getResult("SELECT * FROM `market_offers` WHERE `item_code` = '"..item_code.."'")
  if mysql:getID() ~= -1 then
    while(true) do
	  local offer_item = {
	    item_code         = mysql:getDataString('item_code'),
        itemid            = mysql:getDataInt('itemid'),
        count             = mysql:getDataInt('count'),
        item_index        = mysql:getDataInt('item_index'),
        playeroffer_id    = mysql:getDataInt('playeroffer_id'),
        playeroffer_name  = mysql:getDataString('playeroffer_name'),
        state  = mysql:getDataInt('state'),
	  }
      local item = doCreateItemEx(offer_item.itemid, offer_item.count)
      doItemLoadAttributes(item, 'attributes', mysql:getID())
      doItemSetCount(item, offer_item.count)
	  offer_item.item_name = getMarketItemName(offer_item.itemid, item)
	  offer_item.poke_info = getMarketPokeInfo(offer_item.itemid, item)
	  offer_item.spriteId = getItemInfo(offer_item.itemid).clientId
	  offer_item.description = getPokeMarketDescription(offer_item.itemid, item)
	  if not offers[offer_item.playeroffer_id] then offers[offer_item.playeroffer_id] = {} end
	  offers[offer_item.playeroffer_id][#offers[offer_item.playeroffer_id]+1] = offer_item
      if not(mysql:next())then
        break
      end
	end
	mysql:free()
  end
  return offers
end

function doMarketAcceptOffer(cid, code, playeroffer_id)
  -- if not nearOnMarket(cid) then return sendMarketClose(cid) end
  if isCreature(cid) then doPlayerPopupFYI(cid, "Offer desativado") return  end
  local market_item = market_items[code]
  if not market_item then return end
  local offers = market_item.offers[playeroffer_id]
  if not offers then
    return doPlayerPopupFYI(cid, "Esta oferta não existe")
  end
  local playeroffer_name
  for num, offer_item in ipairs(offers) do
    if offer_item.state == OFFERPOSTED then
      local query = ("SELECT `attributes` FROM `market_offers` WHERE `item_code` = '"..code.."' AND `playeroffer_id`  = "..offer_item.playeroffer_id.." AND `item_index` = "..offer_item.item_index)
      local mysql = db.getResult(query)
      if mysql:getID() == -1 then
        doPlayerPopupFYI(cid, "Item de mercado inválido")
        return false
      end
      local offerItem = doCreateItemEx(offer_item.itemid, offer_item.count)
      doItemLoadAttributes(offerItem, 'attributes', mysql:getID())
	  doItemSetCount(offerItem, offer_item.count)
      if addItem(getCreatureName(cid), offer_item.itemid, offerItem) then
		playeroffer_name = getPlayerNameByGUID(offer_item.playeroffer_id)
		offer_item.state = OFFERACCEPTED
      end
    end
  end
  if not playeroffer_name then return end
  local query = ("SELECT `attributes` FROM `market_items` WHERE `item_code` = '"..code.."' AND `playerseller_id`  = "..market_item.playerseller_id)
  local mysql = db.getResult(query)
  if mysql:getID() == -1 then
    doPlayerPopupFYI(cid, "Item de mercado inválido")
    return false
  end
  local item = doCreateItemEx(market_item.itemid, market_item.count)
  doItemLoadAttributes(item, 'attributes', mysql:getID())
  doItemSetCount(item, market_item.count)
  if addItem(playeroffer_name, market_item.itemid, item) then
	db.executeQuery("DELETE FROM `market_items` WHERE `item_code` = '"..code.."'")
  end
  setMarketHistoric(getPlayerGUID(cid), "Você aceitou uma oferta para "..market_item.item_name..".", cid)
  setMarketHistoric(playeroffer_id, "Sua oferta foi aceita para o "..market_item.item_name..".")
  for _playeroffer_id, _offers in pairs(market_item.offers) do
    local checkHistoric = false
    for num, offer_item in ipairs(_offers) do
      if offer_item.state == OFFERPOSTED or offer_item == OFFERUNDERCONSTRUCTION then
        local query = ("SELECT `attributes` FROM `market_offers` WHERE `item_code` = '"..code.."' AND `playeroffer_id`  = "..offer_item.playeroffer_id.." AND `item_index` = "..offer_item.item_index)
        local mysql = db.getResult(query)
        if mysql:getID() == -1 then
          doPlayerPopupFYI(cid, "Item de mercado inválido")
          return false
        end
        local offerItem = doCreateItemEx(offer_item.itemid, offer_item.count)
        doItemLoadAttributes(offerItem, 'attributes', mysql:getID())
        doItemSetCount(offerItem, offer_item.count)
		if addItem(getPlayerNameByGUID(offer_item.playeroffer_id), offer_item.itemid, offerItem) then
		  db.executeQuery("DELETE FROM `market_offers` WHERE `item_code` = '"..offer_item.item_code.."' AND `item_index` = "..offer_item.item_index..offer_item.item_index.." AND `playeroffer_id` = "..offer_item.playeroffer_id)
          if not checkHistoric and offer_item.state == OFFERPOSTED then 
			setMarketHistoric(_playeroffer_id, "Sua oferta foi recusada para o "..market_item.item_name..".")
		  end
		  checkHistoric = true
		end
      else
	    db.executeQuery("DELETE FROM `market_offers` WHERE `item_code` = '"..offer_item.item_code.."' AND `item_index` = "..offer_item.item_index..offer_item.item_index.." AND `playeroffer_id` = "..offer_item.playeroffer_id)
      end
	end
  end
  getMarketItems()
  refreshMarketOnClient(cid)
end

function doMarketRefuseOffer(cid, code, playeroffer_id)
  -- if not nearOnMarket(cid) then return sendMarketClose(cid) end
  if isCreature(cid) then doPlayerPopupFYI(cid, "Offer desativado") return  end
  local market_item = market_items[code]
  if not market_item then return end
  local offers = market_item.offers[playeroffer_id]
  if not offers then
    return doPlayerPopupFYI(cid, "Esta oferta não existe")
  end
  local checkHistoric = false
  for num, offer_item in ipairs(offers) do
    if offer_item.state == OFFERPOSTED then
      local query = ("SELECT `attributes` FROM `market_offers` WHERE `item_code` = '"..code.."' AND `playeroffer_id`  = "..offer_item.playeroffer_id.." AND `item_index` = "..offer_item.item_index)
      local mysql = db.getResult(query)
      if mysql:getID() == -1 then
        doPlayerPopupFYI(cid, "Item de mercado inválido")
        return false
      end
      local offerItem = doCreateItemEx(offer_item.itemid, offer_item.count)
      doItemLoadAttributes(offerItem, 'attributes', mysql:getID())
	  doItemSetCount(offerItem, offer_item.count)
      if addItem(getPlayerNameByGUID(playeroffer_id), offer_item.itemid, offerItem) then
        db.executeQuery("DELETE FROM `market_offers` WHERE `item_code` = '"..offer_item.item_code.."' AND `item_index` = "..offer_item.item_index.." AND  `playeroffer_id` = "..offer_item.playeroffer_id)
        if not checkHistoric then 
          setMarketHistoric(playeroffer_id, "Sua oferta foi recusada para o "..market_item.item_name..".")
          checkHistoric = true
	    end
	  end
    end
  end
  market_item.offers = getMarketItemOffers(market_item.item_code)
  sendMarketOffers(cid)
  doPlayerSave(cid)
end

function doMarketRemoveOffer(cid, code)
  -- if not nearOnMarket(cid) then return sendMarketClose(cid) end
  if isCreature(cid) then doPlayerPopupFYI(cid, "Offer desativado") return  end
  local market_item = market_items[code]
  if not market_item then return end
  local offers = market_item.offers[getPlayerGUID(cid)]
  if not offers then
    return doPlayerPopupFYI(cid, "Esta oferta não existe")
  end
  for num, offer_item in ipairs(offers) do
    if offer_item.state == OFFERPOSTED then
      local query = ("SELECT `attributes` FROM `market_offers` WHERE `item_code` = '"..code.."' AND `playeroffer_id`  = "..offer_item.playeroffer_id.." AND `item_index` = "..offer_item.item_index)
      local mysql = db.getResult(query)
      if mysql:getID() == -1 then
        doPlayerPopupFYI(cid, "Item de mercado inválido")
        return false
      end
      local offerItem = doCreateItemEx(offer_item.itemid, offer_item.count)
      doItemLoadAttributes(offerItem, 'attributes', mysql:getID())
      doItemSetCount(offerItem, offer_item.count)
      if addItem(getCreatureName(cid), offer_item.itemid, offerItem) then
        db.executeQuery("DELETE FROM `market_offers` WHERE `item_code` = '"..offer_item.item_code.."' AND `item_index` = "..offer_item.item_index.." AND  `playeroffer_id` = "..offer_item.playeroffer_id)
      end
    end
  end
  market_item.offers = getMarketItemOffers(market_item.item_code)
  sendMarketOffers(cid)
  doPlayerSave(cid)
end

function getMarketFee(price)
  return math.max(1, price / 1000)
end

function doMarketSellItem(cid, code, itemId, count, onlyoffer, price)
  -- if not nearOnMarket(cid) then return sendMarketClose(cid) end
  if not code or code == "" or code == 'nil' or code == nil then code = generateCode() end
  if itemId == 0 then return doPlayerPopupFYI(cid, "Item não encontrado") end
  if price < 0 or price > 1000000001 then return doPlayerPopupFYI(cid, "Preço inválido") end
  if onlyoffer < 0 or onlyoffer > 1 then onlyoffer = 0 end
  local item = isItemStackable(itemId) and getPlayerItemByIdInMarket(cid, itemId) or getPlayerItemByCode(cid, code)
  if not item then return doPlayerPopupFYI(cid, "Item não encontrado") end
  if isItemUnique(item.uid) then return doPlayerPopupFYI(cid, "Você não pode vender este item unico") end
  if isContainer(item.uid) and getContainerSize(item.uid) > 0 then
    return doPlayerPopupFYI(cid, "Você não pode vender este item")
  elseif getItemInfo(item.itemid).worth > 0 then
    return doPlayerPopupFYI(cid, "Você não pode vender este item")
  elseif not getItemInfo(item.itemid).movable then
    return doPlayerPopupFYI(cid, "Você não pode vender este item")
  end
  if onlyoffer == 0 and price == 0 then
    return doPlayerPopupFYI(cid, "Defina um valor maior que zero")
  end
  price = onlyoffer == 1 and 0 or price
  if getPlayerItemCount(cid, item.itemid) < count then
    return doPlayerPopupFYI(cid, "Você não tem tantos itens")
  end
  if getPlayerMoney(cid) < getMarketFee(price * count) then
    return doPlayerPopupFYI(cid, "Você não possui o dinheiro da taxa")
  end
  doPlayerRemoveMoney(cid, getMarketFee(price * count))
  local market_item = {
    item_code = code, playerseller_id = getPlayerGUID(cid), playerseller_name = getCreatureName(cid), 
    onlyoffer = onlyoffer, spriteId = getItemInfo(item.itemid).clientId, itemid = item.itemid, count = count, price = price,
    time = (os.time() + (60 * 60 * 60)), attributes = getItemAttributesBlob(item.uid), offers = {}
  }
  
  market_item.description = getPokeMarketDescription(market_item.itemid, item.uid)
  market_item.item_name = getMarketItemName(market_item.itemid, item.uid)
  market_item.poke_info = getMarketPokeInfo(market_item.itemid, item.uid)
  -- local values = "'"..code.."', "..market_item.playerseller_id..", '"..market_item.playerseller_name.."', "..onlyoffer..", "..item.itemid..", "..count..", "..price..", '"..json.encode(market_item.attributes).."', "..market_item.time..")"
  local values = "'"..code.."', "..market_item.playerseller_id..", '"..market_item.playerseller_name.."', "..onlyoffer..", "..item.itemid..", "..count..", "..price..", "..market_item.attributes..", "..market_item.time..")"
  if db.executeQuery("INSERT INTO `market_items` (`item_code`, `playerseller_id`, `playerseller_name`, `onlyoffer`, `itemid`, `count`, `price`, `attributes`, `time`) VALUES ( "..values) then
    if isItemStackable(itemId) then doPlayerRemoveItem(cid, item.itemid, count) else doRemoveItem(cid, item.uid, count) end
	market_items[code] = market_item
  end
  sendMarketBuyItems(cid, "Todos", 1, 0)
  sendMarketSellItems(cid)
  doPlayerSave(cid)
end

function doMarketBuyItem(cid, code, buy_count)
  -- if not nearOnMarket(cid) then return sendMarketClose(cid) end
  if not buy_count or buy_count < 1 then buy_count = 1 end		
  if getPlayerFreeSlots(cid) < 0 then
    doPlayerSendCancel(cid, "Sua mochila está cheia")
    return false
  end
  local market_item = market_items[code]
  if not market_item then
    doPlayerPopupFYI(cid, "Item de mercado inválido")
    return false
  end
  if market_item.onlyoffer == 1 then
    doPlayerPopupFYI(cid, "Este item só aceita ofertas")
	return false
  end
  if getPlayerFreeCap(cid) < getItemInfo(market_item.itemid).weight then
    doPlayerPopupFYI(cid, "Sua mochila está com capacidade máxima")
    return false
  elseif market_item.playerseller_id == getPlayerGUID(cid) then
    doPlayerPopupFYI(cid, "Você não pode comprar seu próprio item")
    return false
  elseif buy_count > market_item.count then
    doPlayerPopupFYI(cid, "Item de mercado inválido")
    return false
  elseif market_item.time - os.time() < 1 then
    doPlayerPopupFYI(cid, "O tempo expirou")
    return false
  elseif market_item.count < 1 then
    doPlayerPopupFYI(cid, "Item de mercado inválido")
    return false
  elseif getPlayerMoney(cid) < (market_item.price * buy_count) then
    doPlayerPopupFYI(cid, "Você não tem dinheiro suficiente")
    return false
  end
  local query = ("SELECT `attributes` FROM `market_items` WHERE `item_code` = '"..code.."' AND `playerseller_id`  = "..market_item.playerseller_id)
  local mysql = db.getResult(query)
  if mysql:getID() == -1 then
    doPlayerPopupFYI(cid, "Item de mercado inválido")
    return false
  end
  local item = doCreateItemEx(market_item.itemid, market_item.count)
  doItemLoadAttributes(item, 'attributes', mysql:getID())
  doItemSetCount(item, buy_count)
  if addItem(getCreatureName(cid), market_item.itemid, item) then
	local sellerItem = market_item.playerseller_name
	local CountPriceValue = market_item.price * buy_count
	addMoney(sellerItem, market_item.price * buy_count)
	doPlayerRemoveMoney(cid, market_item.price * buy_count)
	if buy_count == market_item.count then
	  db.executeQuery("DELETE FROM `market_items` WHERE `item_code` = '"..code.."'")
      for playeroffer_id, offers in pairs(market_item.offers) do
        local checkHistoric = false
        for num, offer_item in ipairs(offers) do
          local query = ("SELECT `attributes` FROM `market_offers` WHERE `item_code` = '"..code.."' AND `playeroffer_id`  = "..offer_item.playeroffer_id.." AND `item_index` = "..offer_item.item_index)
          local mysql = db.getResult(query)
          if mysql:getID() == -1 then
            doPlayerPopupFYI(cid, "Item de mercado inválido")
            return false
          end
		  local offerItem = doCreateItemEx(offer_item.itemid, offer_item.count)
          doItemLoadAttributes(offerItem, 'attributes', mysql:getID())
          doItemSetCount(offerItem, offer_item.count)
          if offer_item.state == OFFERPOSTED then
            if addItem(getPlayerNameByGUID(offer_item.playeroffer_id), offer_item.itemid, offerItem) then
              -- db.executeQuery("UPDATE `market_offers` set `state` = "..OFFERDECLINED.." WHERE `item_code` = '"..offer_item.item_code.."' AND `item_index` = "..offer_item.item_index)
              if not checkHistoric then 
      	        setMarketHistoric(playeroffer_id, "Sua oferta foi recusada para o "..market_item.item_name..".")
      	      end
      	      checkHistoric = true
      	    end
          elseif offer_item.state == OFFERUNDERCONSTRUCTION then
            if addItem(getPlayerNameByGUID(offer_item.playeroffer_id), offer_item.itemid, offerItem) then
              db.executeQuery("DELETE FROM `market_offers` WHERE `item_code` = '"..offer_item.item_code.."' AND `item_index` = "..offer_item.item_index..offer_item.item_index.." AND `playeroffer_id` = "..offer_item.playeroffer_id)
            end
          end
        end
      end
	  getMarketItems()
	else
	  db.executeQuery("UPDATE `market_items` SET `count` = `count` - ".. buy_count .." WHERE `item_code` = '"..code.."'")
	  market_item.count = market_item.count - buy_count
	end
	setMarketHistoric(getPlayerGUID(cid), "Você comprou "..buy_count.." "..market_item.item_name..".", cid)
	setMarketHistoric(market_item.playerseller_id, "Você vendeu "..buy_count.." "..market_item.item_name..".")
	sendMarketBuyItems(cid, "Todos", 1, 0)
  end
  return true
end

function doMarketRemoveItem(cid, code)
  -- if not nearOnMarket(cid) then return sendMarketClose(cid) end
  if getPlayerFreeSlots(cid) < 0 then
    doPlayerSendCancel(cid, "Sua mochila está cheia")
    return false
  end
  local market_item = market_items[code]
  if not market_item then
    doPlayerPopupFYI(cid, "Item de mercado inválido")
    return false
  end
  if market_item.playerseller_id ~= getPlayerGUID(cid) then
    doPlayerPopupFYI(cid, "Isso não pertence a você")
    return false
  elseif getPlayerFreeCap(cid) < getItemInfo(market_item.itemid).weight then
    doPlayerSendCancel(cid, "Sua mochila está com capacidade máxima")
    return false
  end
  local query = ("SELECT `attributes` FROM `market_items` WHERE `item_code` = '"..code.."' AND `playerseller_id`  = "..market_item.playerseller_id)
  local mysql = db.getResult(query)
  if mysql:getID() == -1 then
    doPlayerPopupFYI(cid, "Item de mercado inválido")
    return false
  end
  local item = doCreateItemEx(market_item.itemid, market_item.count)
  doItemLoadAttributes(item, 'attributes', mysql:getID())
  doItemSetCount(item, market_item.count)
  if addItem(getCreatureName(cid), market_item.itemid, item) then
	db.executeQuery("DELETE FROM `market_items` WHERE `item_code` = '"..code.."'")
	for playeroffer_id, offers in pairs(market_item.offers) do
	  local checkHistoric = false
	  for num, offer_item in ipairs(offers) do
        local query = ("SELECT `attributes` FROM `market_offers` WHERE `item_code` = '"..code.."' AND `playeroffer_id`  = "..offer_item.playeroffer_id.." AND `item_index` = "..offer_item.item_index)
        local mysql = db.getResult(query)
        if mysql:getID() == -1 then
          doPlayerPopupFYI(cid, "Item de mercado inválido")
          return false
        end
        local offerItem = doCreateItemEx(offer_item.itemid, offer_item.count)
        doItemLoadAttributes(offerItem, 'attributes', mysql:getID())
        doItemSetCount(offerItem, offer_item.count)
		if offer_item.state == OFFERUNDERCONSTRUCTION then
          if addItem(getPlayerNameByGUID(offer_item.playeroffer_id), offer_item.itemid, offerItem) then
            db.executeQuery("DELETE FROM `market_offers` WHERE `item_code` = '"..code.."' AND `item_index` = "..offer_item.item_index..offer_item.item_index.." AND `playeroffer_id` = "..offer_item.playeroffer_id)
          end
		elseif offer_item.state == OFFERPOSTED then
          if addItem(getPlayerNameByGUID(offer_item.playeroffer_id), offer_item.itemid, offerItem) then
            -- db.executeQuery("UPDATE `market_offers` set `state` = "..OFFERDECLINED.." WHERE `item_code` = '"..code.."' AND `item_index` = "..offer_item.item_index)
            if not checkHistoric then 
      	      setMarketHistoric(playeroffer_id, "Sua oferta foi recusada para o "..market_item.item_name..".")
      	    end
      	    checkHistoric = true
		  end
		end
	  end
	end
	getMarketItems()
	sendMarketBuyItems(cid, "Todos", 1, 0)
	sendMarketSellItems(cid)
  end
  return true
end

function doMarketPostOffer(cid, code)
  -- if not nearOnMarket(cid) then return sendMarketClose(cid) end
  if isCreature(cid) then doPlayerPopupFYI(cid, "Offer desativado") return  end
  local market_item, playeroffer_id = market_items[code], getPlayerGUID(cid)
  if not market_item or not market_item.offers[playeroffer_id] then return end
  for num, offer_item in pairs(market_item.offers[playeroffer_id]) do
    if offer_item.state ~= OFFERUNDERCONSTRUCTION then return end
    offer_item.state = OFFERPOSTED
	db.executeQuery("UPDATE `market_offers` set `state` = "..OFFERPOSTED.." WHERE `item_code` = '"..code.."' AND `item_index` = "..offer_item.item_index)
  end
  doPlayerPopupFYI(cid, 'Sua oferta foi feita, espere até que o vendedor avalie')
  sendMarketBuyItems(cid, "Todos", 1, 0)
  sendMarketOffers(cid)
end

function doMarketCancelMakeOffer(cid, code)
if isCreature(cid) then doPlayerPopupFYI(cid, "Offer desativado") return  end
  local market_item, playeroffer_id = market_items[code], getPlayerGUID(cid)
  if not market_item then return end
  local offers = market_item.offers[playeroffer_id]
  if not offers then return end
  for num, offer_item in pairs(offers) do
    if offer_item.item_code == code and offer_item.state == OFFERUNDERCONSTRUCTION then
      local query = ("SELECT `attributes` FROM `market_offers` WHERE `item_code` = '"..code.."' AND `playeroffer_id`  = "..offer_item.playeroffer_id.." AND `item_index` = "..offer_item.item_index)
      local mysql = db.getResult(query)
      if mysql:getID() == -1 then
        doPlayerPopupFYI(cid, "Item de mercado inválido")
        return false
      end
      local offerItem = doCreateItemEx(offer_item.itemid, offer_item.count)
      doItemLoadAttributes(offerItem, 'attributes', mysql:getID())
      doItemSetCount(offerItem, offer_item.count)
	  if addItem(getCreatureName(cid), offer_item.itemid, offerItem) then
		db.executeQuery("DELETE FROM `market_offers` WHERE `item_code` = '"..code.."' AND `item_index` = "..offer_item.item_index..offer_item.item_index.." AND `playeroffer_id` = "..offer_item.playeroffer_id)
	  end
    end
  end
  market_item.offers = getMarketItemOffers(market_item.item_code)
  sendMarketBuyItems(cid, "Todos", 1, 0)
end

function doMarketMakeOffer(cid, code, container_index, slot_index, count)
  -- if not nearOnMarket(cid) then return doMarketCancelMakeOffer(cid, code) end
  if isCreature(cid) then doPlayerPopupFYI(cid, "Offer desativado") return  end
  local item = {itemid = 0}
  if container_index >= 64 and container_index <= 80 then
    item = getContainerItemByIndex(cid, container_index - 64, slot_index) or item
  else
    return doPlayerPopupFYI(cid, "Apenas itens dentro da sua mochila")
  end
  if item.itemid == 0 then
    return doPlayerPopupFYI(cid, "Item não encontrado")
  elseif isContainer(item.uid) and getContainerSize(item.uid) > 0 then
    return doPlayerPopupFYI(cid, "Você não pode vender este item")
  elseif not getItemInfo(item.itemid).movable then
    return doPlayerPopupFYI(cid, "Você não pode vender este item")
  end
  if isItemUnique(item.uid) then return doPlayerPopupFYI(cid, "Você não pode oferecer este item unico") end
  if getPlayerItemCount(cid, item.itemid) < count then
    return doPlayerPopupFYI(cid, "Você não possui a quantidade de itens selecionada")
  end
  local current_market_item = market_items[code]
  if not current_market_item then 
    return doPlayerPopupFYI(cid, "Item não encontrado")
  end
  if current_market_item.playerseller_id == getPlayerGUID(cid) then
    return doPlayerPopupFYI(cid, "Você não pode dar uma oferta em seu próprio item")
  end
  local current_offers = current_market_item.offers[getPlayerGUID(cid)]
  if current_offers and current_offers[1].state ~= OFFERUNDERCONSTRUCTION then
    return doPlayerPopupFYI(cid, "Você já fez uma oferta para este item")
  end
  if current_offers and #current_offers >= 8 then
    return doPlayerPopupFYI(cid, "Você atingiu o limite máximo de itens a oferecer")
  end
  local offer_item = {
    item_code         = code,
    itemid            = item.itemid,
	spriteId          = getItemInfo(item.itemid).clientId,
    count             = count,
    item_index        = current_offers and #current_offers+1 or 1,
    attributes        = getItemAttributesBlob(item.uid),
    playeroffer_id    = getPlayerGUID(cid),
    playeroffer_name  = getCreatureName(cid),
    state             = OFFERUNDERCONSTRUCTION,
  }
  offer_item.description = getPokeMarketDescription(offer_item.itemid, item.uid)
  offer_item.poke_info = getMarketPokeInfo(item.itemid, item.uid)
  local values = "'"..offer_item.item_code.."', "..offer_item.itemid..", "..offer_item.count..", "..offer_item.item_index..", "..offer_item.playeroffer_id..", '"..offer_item.playeroffer_name.."', "..offer_item.attributes..")"
  if db.executeQuery("INSERT INTO `market_offers` (`item_code`, `itemid`, `count`, `item_index`, `playeroffer_id`, `playeroffer_name`, `attributes`) VALUES ( "..values) then
    doRemoveItem(cid, item.uid, count)
	if not current_market_item.offers[offer_item.playeroffer_id] then current_market_item.offers[offer_item.playeroffer_id] = {} end
	current_market_item.offers[offer_item.playeroffer_id][#current_market_item.offers[offer_item.playeroffer_id]+1] = offer_item
  end
  local protocol = Protocol_create("marketbuymakeoffer")
  Protocol_add(protocol, {count = count, spriteId = offer_item.spriteId, description = offer_item.description, poke_info = offer_item.poke_info})
  doSendPlayerExtendedOpcode(cid, GameServerOpcodes.Market, table.tostring(protocol))
  doPlayerSave(cid)
end

function cancelMakeOfferOnLogout(cid)
  local code = nil
  local mysql = db.getResult("SELECT * FROM `market_offers` WHERE `playeroffer_id` = "..getPlayerGUID(cid).." AND `state` = "..OFFERUNDERCONSTRUCTION)
  if mysql:getID() ~= -1 then
    while(true) do
	  local offer_item = {
	    item_code         = mysql:getDataString('item_code'),
        itemid            = mysql:getDataInt('itemid'),
        count             = mysql:getDataInt('count'),
	  }
      local offerItem = doCreateItemEx(offer_item.itemid, offer_item.count)
      doItemLoadAttributes(offerItem, 'attributes', mysql:getID())
      doItemSetCount(offerItem, offer_item.count)
	  code = offer_item.item_code
      if not(mysql:next())then
        break
      end
	end
	mysql:free()
  end
  if code then
    local market_item, playeroffer_id = market_items[code], getPlayerGUID(cid)
    if not market_item then return end
    local offers = market_item.offers[playeroffer_id]
    if not offers then return end
    for num, offer_item in pairs(offers) do
      if offer_item.item_code == code and offer_item.state == OFFERUNDERCONSTRUCTION then
        local query = ("SELECT `attributes` FROM `market_offers` WHERE `item_code` = '"..code.."' AND `playeroffer_id`  = "..offer_item.playeroffer_id.." AND `item_index` = "..offer_item.item_index)
        local mysql = db.getResult(query)
        if mysql:getID() == -1 then
          doPlayerPopupFYI(cid, "Market item invalid.")
          return false
        end
        local offerItem = doCreateItemEx(offer_item.itemid, offer_item.count)
        doItemLoadAttributes(offerItem, 'attributes', mysql:getID())
        doItemSetCount(offerItem, offer_item.count)
	    if addItem(getCreatureName(cid), offer_item.itemid, offerItem) then
          -- print("doMarketCancelMakeOffer: delete")
	  	db.executeQuery("DELETE FROM `market_offers` WHERE `item_code` = '"..code.."' AND `item_index` = "..offer_item.item_index.." AND `playeroffer_id` = "..offer_item.playeroffer_id)
	    end
      end
    end
    -- print("doMarketCancelMakeOffer: refresh")
    market_item.offers = getMarketItemOffers(market_item.item_code)
  end
end

getMarketItems()

------------------------- SUPPORT FUNCTIONS ----------------------------------------

function addMoney(name, money)
  local money_table = {
     [1] = {first = 1000000, second = 2161},
     [2] = {first = 10000, second = 2160},
	 [3] = {first = 1, second = 2152},
  }
  local tmp = 0
  for a, b in pairs(money_table) do
    tmp = money / b.first
    if math.floor(tmp) > 0 then
      local _tmp = tmp
      if math.floor(math.floor(tmp) / 1000000) > 0 then 
        for _y = 1, math.floor(math.floor(tmp) / 1000000) do
          local item = doCreateItemEx(b.second, 1000000)
          doPlayerSendMailByName(name, item, 13)
          _tmp = math.floor(_tmp) - 1000000
        end
      end
      if _tmp > 0 and _tmp < 1000000 then
        local item = doCreateItemEx(b.second, math.floor(_tmp))
        doPlayerSendMailByName(name, item, 13)
      end
      money = money - (b.first * math.floor(tmp))
    end
  end
end

function addItem(name, itemId, item)
  doPlayerSendMarketMailByName(name, item, 13)
  return true
end

function getItemCategory(itemid)
  local item = getItemInfo(itemid)
  if isStones(itemid) then
	return "Stones"
  elseif isPokebolas(itemid) then
	return "Poke Balls"
  elseif isDiamonds(itemid) then
	return "Diamonds"
  elseif isAddons(itemid) then
	return "Addons"
  elseif isOutfits(itemid) then
	return "Outfits"
  elseif isPokeball(itemid) then
	return "Pokemon"
  elseif isHelds(itemid) then
	return "Held Item"
  elseif isFurnitures(itemid) then
	return "Furnitures"
  elseif isBerrys(itemid) then
	return "Berries"
  elseif isPlates(itemid) then
	return "Plates"
  elseif isDolls(itemid) then
	return "Dolls"
  elseif isFoods(itemid) then
	return "Foods"
  elseif isUtilities(itemid) then
	return "Utilities"
  elseif isSuplies(itemid) then
	return "Supplies"
  else
	return "Items"
  end
end

function generateCode()
  local code = "Mkt"
  for num=1, 20 do
    code = code..math.random(0,9)
  end
  return code
end

function freeSlotsdeepSearch(_item)
  local freeSlot = 0
  for slot = 1, getContainerCap(_item) do
    local item = getContainerItem(_item, slot)
    if item.uid == 0 then
      freeSlot = freeSlot + 1
    elseif item.uid ~= 0 then
      if isContainer(item.uid) then
        freeSlot = freeSlot + freeSlotsdeepSearch(item.uid)
      end
    end
  end
  return freeSlot
end

function getPlayerFreeSlots(cid)
  local freeSlot = 0
  local item = getPlayerSlotItem(cid, CONST_SLOT_BACKPACK)
  if item.uid ~= 0 then
    if isContainer(item.uid) then
      freeSlot = freeSlot + freeSlotsdeepSearch(item.uid)
    end
  end
  return math.max(0, (freeSlot - 1))
end

function getPlayerItemByCode(cid, item_code)
  local function getItemInContainerByCode(container, item_code)
    if isContainer(container) and getContainerSize(container) > 0 then
	  for slot = 0, (getContainerSize(container)-1) do
	    local item = getContainerItem(container, slot)
	    if isContainer(item.uid) and getContainerItem(item.uid, 0).uid ~= 0 then
		  local item = getItemInContainerByCode(item.uid, item_code)
		  if item then return item end
		else
		  if getItemAttribute(item.uid, storages.marketBase) and getItemAttribute(item.uid, storages.marketBase) == item_code then
		    return item
		  end
		end
	  end
	end
	return false
  end
  return getItemInContainerByCode(getPlayerSlotItem(cid, CONST_SLOT_BACKPACK).uid, item_code) 
end

function isItemUnique(uid)
  if getItemAttribute(uid, "unique") then return true end 
  return false
end

function getPlayerItemByIdInMarket(cid, itemId)
  local function getItemInContainerById(container, itemId)
    if isContainer(container) and getContainerSize(container) > 0 then
	  for slot = 0, (getContainerSize(container)-1) do
	    local item = getContainerItem(container, slot)
	    if isContainer(item.uid) and getContainerItem(item.uid, 0).uid ~= 0 then
		  local item = getItemInContainerById(item.uid, itemId)
		  if item then return item end
		else
		  if item.itemid == itemId then
		    return item
		  end
		end
	  end
	end
	return false
  end
  return getItemInContainerById(getPlayerSlotItem(cid, CONST_SLOT_BACKPACK).uid, itemId) 
end