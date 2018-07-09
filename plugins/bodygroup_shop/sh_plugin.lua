PLUGIN.name = "Bodygroup-Shop"
PLUGIN.author = "RobertLP"
PLUGIN.desc = "Let's players buy some shits (bodygroups from the F1 tabs) bla bla bla"

--Includings
nut.util.include("cl_bgshop.lua", "client")

--Settings
BGROUP_SHOP = {}

BGROUP_SHOP.tab_name = "Clothing"
BGROUP_SHOP.currency_symbol = "$"
BGROUP_SHOP.not_enough_funds = "You do not have enough money to buy that."
BGROUP_SHOP.successful_sell = "You successfuly bought the skin(s) (?m)" --'?m' will display the money
BGROUP_SHOP.static_price = 50 --Static price, if the price isn't specified in the BGROUP_SHOP.custom_prices table it will be set to this.
BGROUP_SHOP.custom_prices = {
  ties = { --Name of the bodygroup
  [1] = 10,  --[number of the bodygroup] = price
  [2] = 10,
  [3] = 10,
  [4] = 10,
  [5] = 10,
  [6] = 10,
  [7] = 10,
  [8] = 10,
  [9] = 10,
  [10] = 10,
  [11] = 10,
  [12] = 10,
  [13] = 10,
  [14] = 10,
  [15] = 10,
  [16] = 10,
  [17] = 10,
  [18] = 10,
  [19] = 10,
  [20] = 10,
  [21] = 10
  }
}

--Netstream Hook(s)
netstream.Hook("saveBoughtBodygroups", function(ply, data)
  --Setting money
  local wallet = ply:getChar():getMoney()
  local msg = string.gsub(BGROUP_SHOP.successful_sell, '?m', BGROUP_SHOP.currency_symbol .. " " ..tostring(data.price))
  if wallet - data.price < 0 then
    ply:notify(BGROUP_SHOP.not_enough_funds)
  else
    ply:getChar():setMoney(wallet - data.price)
    ply:notify(msg)
  end

  ply:getChar():setData("groups", data.bodygroups) --Saving bodygroups
  for k,v in pairs(data.bodygroups) do
		ply:SetBodygroup(k, v or 0) --Applying them on the character/player
  end
end)
