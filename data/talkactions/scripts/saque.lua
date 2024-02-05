local function getCount(msg)
    local ret = -1
    local b, e = string.find(msg, "%d+")
    if b ~= nil and e ~= nil then
       ret = tonumber(string.sub(msg, b, e))
    end
 
    return ret
end

function onSay(cid, words, param)
	local playerGold = getPlayerBalance(cid)
	if param == '' then
		doPlayerSendTextMessage(cid, 27, "Você precisa digitar algum número.")
	else
	
		doPlayerSetBalance(cid, playerGold - param)
		doPlayerAddMoney(cid, param)
		doPlayerSendTextMessage(cid, 27, "Você sacou ".. param .. " e agora seu saldo é de: " .. playerGold - param..".")
	end
return true
end