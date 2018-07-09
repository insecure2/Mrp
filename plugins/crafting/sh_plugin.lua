PLUGIN.name = "Crafting System"
PLUGIN.desc = "Let superadmins create recipes and players craft them"

--Includes
nut.util.include("sh_recipe_manager.lua", "shared")
nut.util.include("cl_status.lua", "client")

if SERVER then
  util.AddNetworkString("dyn_crafting_open")
  util.AddNetworkString("getrecipes")
  util.AddNetworkString("return_recipies")
  util.AddNetworkString("addrecipe")
  util.AddNetworkString("editrecipe")
  util.AddNetworkString("middlemsg")
  util.AddNetworkString("delrecipe")
end
