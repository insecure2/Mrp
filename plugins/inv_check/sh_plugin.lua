PLUGIN.name = "Tying"
PLUGIN.author = "Chessnut"
PLUGIN.desc = "Adds the ability to tie players."

nut.util.include("sh_charsearch.lua")
inv_search = {}

TARGET_TO_ADMIN = 0
ADMIN_TO_TARGET = 1

function inv_search:Log(way, target, admin, item)
  local Timestamp = os.time()
  local t = os.date("*t", Timestamp)

  --Creating dir
  file.CreateDir("inventory_checker")
  file.CreateDir("inventory_checker/target_to_admin")
  file.CreateDir("inventory_checker/admin_to_target")

  file_name = nil
  if way == TARGET_TO_ADMIN then
    file_name = "inventory_checker/target_to_admin/" .. t.year .. "-" .. t.month .. "-" .. t.day .. ".txt"
  else
    file_name = "inventory_checker/admin_to_target/" .. t.year .. "-" .. t.month .. "-" .. t.day .. ".txt"
  end

  --Getting/Creating file
  local f = file.Read(file_name, "DATA") or ""
  if not f then
    f = ""
  end
  if way == TARGET_TO_ADMIN then
    file.Append(file_name, "\nADMIN: " .. admin:Name() .. "/" .. admin:SteamID() .. " TOOK: " .. item.name ..
    " FROM: " .. target:GetName() .. "/" .. target:SteamID())
  else
    file.Append(file_name, "\nADMIN: " .. admin:Name() .. "/" .. admin:SteamID() .. " GAVE: " .. item.name ..
    " TO: " .. target:GetName() .. "/" .. target:SteamID())
  end
end
