local function editor()
  local frame = vgui.Create("DFrame")
  frame:SetSize(600,350)
  frame:Center()
  frame:SetTitle("")
  frame:MakePopup()
  frame:ShowCloseButton(false)
  function frame:Paint(w,h)
    draw.RoundedBox(0,0,0,w,h,Color(250,250,250))
  end

  local c = vgui.Create("DButton", frame)
  c:SetSize(25,25)
  c:SetPos(frame:GetWide()-25, 0)
  c:SetText("X")
  c:SetColor(Color(0,0,0))
  function c:DoClick()
    frame:Close()
  end
  function c:Paint(w,h)
    draw.RoundedBox(0,0,0,w,h,Color(240,240,240))
    if self:IsHovered() then
      draw.RoundedBox(0,0,0,w,h,Color(230,230,230))
    end
  end

  local tot = vgui.Create("DTextEntry", frame)
  tot:SetSize(180, 25)
  tot:SetPos(80, 45-tot:GetTall())

  local tol = vgui.Create("DLabel", frame)
  tol:SetText("To: ")
  tol:SizeToContents()
  tol:SetColor(Color(0,0,0))
  tol:SetPos(20, 50-tot:GetTall())

  local t = vgui.Create("DTextEntry", frame)
  t:SetPos(0,70)
  t:SetSize(frame:GetWide(), frame:GetTall()-80*2)
  t:SetMultiline(true)

  local b = vgui.Create("DButton", frame)
  b:SetSize(180,25)
  b:SetText("Write")
  b:CenterHorizontal()
  local x,y = b:GetPos()
  b:SetPos(x, frame:GetTall()-b:GetTall()-10)
  function b:DoClick()
    --Checking
    if not t:GetValue() or not tot:GetValue() then return end

    frame:Close()
    nut.gui.menu:Remove()

    netstream.Start("write_mail", {
      entity = ent,
      to = tot:GetValue(),
      msg = t:GetValue()
    })
  end
end

local function open(ent)
  local frame = vgui.Create("DFrame")
  frame:SetSize(600,200)
  frame:Center()
  frame:SetTitle("")
  frame:MakePopup()
  frame:ShowCloseButton(false)
  function frame:Paint(w,h)
    draw.RoundedBox(0,0,0,w,h,Color(250,250,250))
  end

  local c = vgui.Create("DButton", frame)
  c:SetSize(25,25)
  c:SetPos(frame:GetWide()-25, 0)
  c:SetText("X")
  c:SetColor(Color(0,0,0))
  function c:DoClick()
    frame:Close()
  end
  function c:Paint(w,h)
    draw.RoundedBox(0,0,0,w,h,Color(240,240,240))
    if self:IsHovered() then
      draw.RoundedBox(0,0,0,w,h,Color(230,230,230))
    end
  end

  local del = vgui.Create("DButton", frame)
  del:SetText("Delete")
  del:SetSize(120,25)
  local x,y = c:GetPos()
  del:SetPos(x-del:GetWide(),0)
  function del:Paint(w,h)
    draw.RoundedBox(0,0,0,w,h,Color(240,240,240))
    if self:IsHovered() then
      draw.RoundedBox(0,0,0,w,h,Color(230,230,230))
    end
  end
  function del:DoClick()
    frame:Close()
    netstream.Start("remove_mail", {
      entity = ent
    })
  end

  local from = vgui.Create("DLabel", frame)
  from:SetText("Mail from: " .. ent:GetNWString("from", nil))
  from:SizeToContents()
  from:SetColor(Color(0,0,0))
  from:SetPos(20, 20)

  local to = vgui.Create("DLabel", frame)
  to:SetText("Mail to: " .. ent:GetNWString("to", nil))
  to:SetColor(Color(0,0,0))
  to:SizeToContents()
  to:SetPos(20, 40)

  local msg = vgui.Create("Richtext", frame)
  msg:SetSize(frame:GetWide(),frame:GetTall()/2)
  msg:SetPos(0, frame:GetTall()-msg:GetTall())
  msg:InsertColorChange(0,0,0,255)
  msg:AppendText(ent:GetNWString("msg", nil))
end

netstream.Hook("edit_mail", function(data)
  editor()
end)

netstream.Hook("open_mail", function(data)
  open(data.ent)
end)
