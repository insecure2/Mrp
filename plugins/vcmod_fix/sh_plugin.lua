PLUGIN.name = "VCMod Economy Compatibility"
PLUGIN.author = "AngryBaldMan"
PLUGIN.desc = "Allows all VCMod economic functions to work."

hook.Add("VC_canAfford", "NS_Fix_Has", function(ply, amount)

if ply:getChar():hasMoney(amount) then
return true else
return false
end

end)

hook.Add("VC_canAddMoney", "NS_Fix_Give", function(ply, amount)

ply:getChar():giveMoney(amount)

	local can = false
	return can 
end)

hook.Add("VC_canRemoveMoney", "NS_Fix_Take", function(ply, amount)

ply:getChar():takeMoney(amount)

	local can = false
	return can 
end)
