ENT.Type = "anim"
ENT.PrintName = "Mail Letter"
ENT.Category = "NutScript"
ENT.Spawnable = true
ENT.AdminOnly = true

if SERVER then
  function ENT:Initialize()
    self:SetModel("models/props_lab/clipboard.mdl")
    self:SetUseType(SIMPLE_USE)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
  end

  function ENT:Use(client)
    netstream.Start(client, "open_mail", {
      to = self:GetNWString("to", nil),
      from = self:GetNWString("from", nil),
      msg = self:GetNWString("msg", nil),
      ent = self
    })
  end
end
