ITEM.name = "Papers"
ITEM.price = 0
ITEM.desc = "Civilian Documents"
ITEM.model = "models/props_lab/clipboard.mdl"
ITEM.flag = "y"
ITEM.uniqueID = "papers"
ITEM.class = "physics_prop"
ITEM.cangive = true
ITEM.functions = {}
ITEM.functions.give = {
  name = "Give Papers",
  icon = "icon16/arrow_down.png",
  onRun = function(item)
    if item.cangive then
      local pos = item.player:getItemDropPos()
      local ent = ents.Create("papers")
      ent:SetPos(pos)
      ent:SetPlayerInfo(item.player)
      ent:Spawn()
    end

    --Cooldown
    item.cangive = false
    timer.Simple(30, function()
      item.cangive = true
    end)
    return false
  end
}
