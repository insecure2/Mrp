mid = {}
surface.CreateFont("BigText", {
  font = "Arial",
  size = 18,
  weight = 800
})
net.Receive("middlemsg", function()
  if mid.frame and IsValid(mid.frame) then
    mid.frame:Close()
    timer.Remove("status_close")
  end
  local msg = net.ReadString()
  local col = net.ReadTable()

  mid.frame = vgui.Create("DFrame")
  mid.frame:SetSize(ScrW(),45)
  mid.frame:Center()
  mid.frame:SetTitle("")
  mid.frame:ShowCloseButton(false)
  function mid.frame:Paint(w,h)
    draw.RoundedBox(0,0,0,w,h,Color(0,0,0,0))
  end

  mid.txt = vgui.Create("DLabel", mid.frame)
  mid.txt:SetText(msg)
  mid.txt:SetFont("BigText")
  mid.txt:SetColor(Color(col[1], col[2], col[3]))
  mid.txt:SizeToContents()
  mid.txt:Center()

  timer.Create("status_close", 5, 1, function()
    mid.frame:Close()
  end)
end)
