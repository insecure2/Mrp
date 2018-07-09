PLUGIN.name = "Mail System"
PLUGIN.desc = "Let players write their own letters and put them to people's doorstep. \nCareful though, other people can pick it up for them."

--Includes
nut.util.include("cl_open_mail.lua", "client")

if SERVER then
  netstream.Hook("write_mail", function(ply, data)
    local ent = ents.Create("sh_mail")
    local pos = ply:getItemDropPos()
    ent:Spawn()
    ent:SetPos(pos)
    ent:SetNWString("from", ply:Nick())
    ent:SetNWString("to", data.to)
    ent:SetNWString("msg", data.msg)
  end)

  netstream.Hook("remove_mail", function(ply, data)
    data.entity:Remove()
  end)
end
