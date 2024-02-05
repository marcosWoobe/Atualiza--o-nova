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
		doPlayerSendTextMessage(cid, 27, "Voc� precisa digitar algum n�mero.")
	else
	
		doPlayerSetBalance(cid, playerGold - param)
		doPlayerAddMoney(cid, param)
		doPlayerSendTextMessage(cid, 27, "Voc� sacou ".. param .. " e agora seu saldo � de: " .. playerGold - param..".")
	end
return true
end