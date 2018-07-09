PLUGIN.name = "Drop Weapon Plugin"
PLUGIN.author = "Dirk Dimmadome"
PLUGIN.desc = "Get pranked epic style it drops your weapon"

function PLUGIN:PlayerDeath( client )
    local items = client:getChar():getInv():getItems()
    for k, item in pairs( items ) do
        if item.isWeapon then
            if item:getData( "equip" ) then
                nut.item.spawn( item.uniqueID, client:GetShootPos(), function()
                    item:remove()
                end, Angle(), item.data )
            end
        end
    end
end