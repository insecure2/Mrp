ITEM.name = "Mail Template"
ITEM.desc = "Mail template to let you write to your beloved ones."
ITEM.class = "sh_mail"
ITEM.model = "models/props_lab/clipboard.mdl"
ITEM.uniqueID = "mail"
ITEM.price = 15
ITEM.width = 2
ITEM.height = 2
ITEM.flag = "y"

ITEM.functions.write = {
  name = "Write",
  icon = "icon16/application_edit.png",
  onRun = function(item)
    local pos = item.player:getItemDropPos()

    netstream.Start(item.player, "edit_mail", {
      ent = entity
    })
  end
}
