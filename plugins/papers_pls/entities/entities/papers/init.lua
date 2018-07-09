AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include('shared.lua')

function ENT:Initialize()
  self:SetModel("models/props_lab/clipboard.mdl")
  self:PhysicsInit(SOLID_VPHYSICS)
  self:SetMoveType(MOVETYPE_VPHYSICS)
  self:SetSolid(SOLID_VPHYSICS)
  self:SetUseType(SIMPLE_USE)

  local phys = self:GetPhysicsObject()
  if (phys:IsValid()) then
    phys:Wake()
  end
end

ENT.fromplayer = nil
ENT.inuse = false
function ENT:SetPlayerInfo(ply)
  self.fromplayer = ply
end

function ENT:Use( activator, caller )
  local inv_items = {}
  local items = nut.item.list
  local inv = self.fromplayer:getChar():getInv()
  for k,v in pairs(items) do
    if string.Explode("_",v.uniqueID)[1] == "permit" then
      if inv:hasItem(v.uniqueID) then
        inv_items[#inv_items+1] = v.name
      end
    end
  end

  netstream.Start(activator, "openpapers", {
    target = self.fromplayer,
    time = time,
    ent = self,
    items = inv_items
  })
  self:Remove()
  -- nut.db.query("SELECT _playTime FROM nut_players WHERE _steamID='" .. self.fromplayer:SteamID64() .. "';", function(data)
  --   -- local time = {
  --   --   mins = math.Round(data[1]._playTime/60),
  --   --   hrs = math.Round(data[1]._playTime/3600),
  --   --   days = math.Round(data[1]._playTime/86400)
  --   -- }
  --
  --
  -- end)
end
