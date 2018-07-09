PLUGIN.name = "Papers, Please"
PLUGIN.author = "RobertLP"
PLUGIN.desc = "Let's players give their papers"

--Includes
nut.util.include("cl_openpapers.lua", "client")

if (SERVER) then
  hook.Add("PlayerSpawn", "papers_init_spawn", function(ply)
    local item = nut.item.list["papers"]
    local inv = ply:getChar():getInv()

    if not inv:hasItem(item.uniqueID, item:getData()) then
      local x,y = inv:findEmptySlot(item.width, item.height, true)
      inv:add(item.uniqueID, 1, item:getData(), x, y)
    end
  end)
end
