function onUse(cid, item) 
		if not isInChannelsArray(cid) then
			doOpenChannelTVs(cid)
		else
			doPlayerPopupFYI(cid, "Voc� n�o pode assistir enquanto filma.") 
			return true 
		end
		if isRiderOrFlyOrSurf(cid) then 
		   doPlayerPopupFYI(cid, "Desmonte seu pokemon primeiro para assistir.")
		   return true 
		end
		if #getCreatureSummons(cid) > 0 then
		   doPlayerPopupFYI(cid, "Get your pok�mon back before watching TV.")
		   return true 
		end
		
return true
end