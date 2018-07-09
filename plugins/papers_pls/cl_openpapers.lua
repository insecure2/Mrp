surface.CreateFont("Verdana",{
  font = "Verdana",
  size = 13,
  weight = 800,
  antialias = true
})

surface.CreateFont("bold", {
  font = "Verdana",
  size = "13",
  weight = 1200,
  antialias = true
})

netstream.Hook("openpapers", function(data)
  local char = data.target:getChar()

  --Frame
  local frame = vgui.Create("DFrame")
  frame:SetTitle("")
  frame:SetSize(400, 200)
  frame:Center()
  frame:MakePopup()
  function frame:Paint(w,h)
    draw.RoundedBox(0,0,0,w,h,Color(35,35,35))
  end

  --Done
  local done = vgui.Create("DButton", frame)
  done:SetText("Done")
  done:SetPos(frame:GetWide()-done:GetWide(), 0)
  done:SetColor(color_white)
  function done:DoClick()
    frame:Close()
  end
  function done:Paint(w,h)
    draw.RoundedBox(0,0,0,w,h,Color(20,20,20))
    if self:IsHovered() then
      draw.RoundedBox(0,0,0,w,h,Color(20,20,20))
    end
  end

  --info
  local name = vgui.Create("RichText", frame)
  name:InsertColorChange(255,255,255,255)
  name:AppendText("Name: " .. char:getName() .. "\n")
  name:AppendText("Description: " .. char:getDesc() .. "\n")
  -- name:AppendText("Time Spent In The City: " .. data.time.days .. " day(s) " .. data.time.hrs .. " hr(s)\n")
  name:SetSize(frame:GetWide(), 100)
  name:SetPos(0, frame:GetTall() - name:GetTall())
  name:SetVerticalScrollbarEnabled(true)
  function name:PerformLayout()
    self:SetFontInternal("Verdana")
  end

  --Model Preview
  local icon = vgui.Create( "DModelPanel", frame )
  icon:SetSize(frame:GetTall()-name:GetTall(), frame:GetTall()-name:GetTall())
  icon:SetModel(data.target:GetModel())
  icon:SetAmbientLight(color_white)
  icon:SetAnimated(false)
  icon:SetLookAt(Vector(-15,0,65))
  icon:SetCamPos(Vector(20,-3,65))
  function icon:LayoutEntity( Entity ) return end
  function icon.Entity:GetPlayerColor() return Vector ( 1, 0, 0 ) end

  if #data.items >= 1 then
    --Permit Title
    local pt = vgui.Create("DLabel", frame)
    pt:SetText("Permits: ")
    pt:SetPos(icon:GetWide()+10, 0)
    pt:SetFont("bold")

    --Permits
    local p = vgui.Create("RichText", frame)
    p:InsertColorChange(255,255,255,255)
    for i=1,#data.items do
      p:AppendText(data.items[i] .. "\n")
    end
    p:SetPos(icon:GetWide()+5, pt:GetTall()+2)
    p:SetSize(frame:GetWide()-icon:GetWide()-done:GetWide(),icon:GetTall())
    p:SetVerticalScrollbarEnabled(false)
    function p:PerformLayout()
      self:SetFontInternal("Verdana")
    end
  end
end)
