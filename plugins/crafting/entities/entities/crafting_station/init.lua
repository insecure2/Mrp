AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
  self:SetModel("models/props_wasteland/kitchen_counter001c.mdl")
  self:PhysicsInit(SOLID_VPHYSICS)
  self:SetMoveType(MOVETYPE_VPHYSICS)
  self:SetSolid(SOLID_VPHYSICS)
  self:SetUseType(SIMPLE_USE)

  local phys = self:GetPhysicsObject()
  if (phys:IsValid()) then
  	phys:Wake()
  end
  self.crafting = false
end

function ENT:Craft(ply)
  if self.crafting then
    net.Start("middlemsg")
      net.WriteString("Crafting... (" .. math.Round(timer.TimeLeft("craft_delay")) .. " seconds left)")
      net.WriteTable({255,0,0})
    net.Send(ply)
    return
  end
  self.items = {}
  --Getting items
  local items = ents.FindInBox(self:GetPos() + self:OBBMaxs() + Vector(0,0,0,20), self:GetPos() + self:OBBMins())
  for i=1, #items do
    if items[i] ~= self and not items[i]:IsPlayer() and items[i]:GetClass() ~= "physgun_beam" then
      self.items[#self.items+1] = items[i]
    end
  end

  if #self.items == 1 then
    return
  end

  --Checking for the right recipe
  local crafts = util.JSONToTable(file.Read("recipes.dat", "DATA") or "{}") or {}
  if #crafts == 0 then return end

  local matched = 0
  local recipe = nil
  for i=1, #crafts do
    for x=1, #crafts[i].items do
      for y=1, #self.items do
        if string.lower(crafts[i].items[x]) == string.lower(self.items[y]:GetModel() or "") or string.lower(crafts[i].items[x]) == string.lower(self.items[y]:GetClass()) then
          matched = matched + 1
        end

        if matched == #crafts[i].items then
          self.crafting = true
          timer.Create("craft_delay", crafts[i].time, 1, function() --Craft delay
            self.crafting = false
            local previtemcount = {}
            local items = ents.FindInBox(self:GetPos() + self:OBBMaxs() + Vector(0,0,0,20), self:GetPos() + self:OBBMins())
            for i=1, #items do
              if items[i] ~= self and not items[i]:IsPlayer() and items[i]:GetClass() ~= "physgun_beam" then
                previtemcount[#previtemcount+1] = items[i]
              end
            end

            if #previtemcount == #self.items then --Checking if player removed a prop
              for z=1, #self.items do --Fetching through all the props (on the table)
                if z == #self.items then
                  if crafts[i].result_class and crafts[i].result_class ~= "" then
                    local ent = ents.Create(crafts[i].result_class)
                    ent:Spawn()
                    ent:Activate()
                    -- ent:GetPhysicsObject():EnableMotion(false)
                    ent:SetPos(self:GetPos() + Vector(0,0,80))
                    ent:CPPISetOwner(ply)
                  else
                    local ent = ents.Create("prop_physics")
                    ent:SetModel(crafts[i].result_model)
                    ent:Spawn()
                    ent:Activate()
                    -- ent:GetPhysicsObject():EnableMotion(false)
                    ent:SetPos(self:GetPos() + Vector(0,0,80))
                    ent:CPPISetOwner(ply)
                  end
                end
                if self.items[z]:GetClass() ~= "physgun_beam" and self.items[z]:GetClass() ~= "predicted_viewmodel" then
                  self.items[z]:Remove()
                end
              end
            else
              net.Start("middlemsg")
                net.WriteString("You removed an item before the crafting could be finished, crafting canceled.")
                net.WriteTable({255,0,0})
              net.Send(ply)
            end
          end)
          return
        end
      end
    end
  end
  net.Start("middlemsg")
    net.WriteString("No recipe found with the items placed on the table.")
    net.WriteTable({255,0,0})
  net.Send(ply)
  ply:EmitSound("physics/wood/wood_crate_break1.wav", 50)
  for i=1, #self.items do
    if self.items[i]:GetClass() ~= "physgun_beam" and self.items[i]:GetClass() ~= "predicted_viewmodel" then
      self.items[i]:Remove()
    end
  end
end

function ENT:Use(ply)
  self:Craft(ply)
end
