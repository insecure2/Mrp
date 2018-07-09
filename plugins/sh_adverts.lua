PLUGIN.name = "Advertising"
PLUGIN.author = "AngryBaldMan"
PLUGIN.desc = "Adds an advert command."


nut.chat.register("advert", {
	onCanSay =  function(speaker, text)	
		if speaker:getChar():hasMoney(100) then
				speaker:getChar():takeMoney(100)
				speaker:notify("$100 has been deducted from your account for advertising.")
			return true
		else 
			speaker:notify("You lack sufficient funds to advertise.")
			return false 
		end
		end,
	onChatAdd = function(speaker, text)
		chat.AddText( Color(255, 238, 0), " [Advertisement] ", color_white, text)
	end,
	prefix = {"/advertisement"},
	noSpaceAfter = true,
	filter = "advertisements"
})
