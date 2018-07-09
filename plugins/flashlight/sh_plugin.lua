PLUGIN.name = "Flashlight"
PLUGIN.author = "Chessnut"
PLUGIN.desc = "Provides a flashlight item to regular flashlight usage."

function PLUGIN:PlayerSwitchFlashlight(client, state)
	local char = client:getChar()
	if char == nil then return end
	if (char:getInv():hasItem("flashlight")) then
		return true
	else
		return false
	end
end
