hook.Add("CreateMenuButtons", "nutHelpMenu", function(tabs)
  tabs[BGROUP_SHOP.tab_name] = function(panel)
    --Some vars
    local ply = LocalPlayer()
    local ch = ply:getChar()
    local groups = LocalPlayer():getChar():getData("groups", {})

    --[[Other Functions]]--
    local function getBodygroupsById(id, gbl)
      for i=1, #gbl do
        if gbl[i].id == id then
          return gbl[i]
        end
      end
    end

    --[[Font(s)]]--
    surface.CreateFont("price_number", {
      font = "Arial",
      size = 20,
      weight = 800,
      antialias = true
    })

    --[[Derma/Real-Time Refreshing Functions]]--
    --Displaying player's model
    appliedBGs = {} --Cache
    local function drawPreview(bg)
      if prev then
        prev:Remove()
      end

      prev = vgui.Create("DModelPanel", panel)
      prev:SetSize(panel:GetWide()-330, panel:GetTall()-60)
      prev:SetPos(0,0)
      prev:SetModel(ply:GetModel())
      local eyepos = prev.Entity:GetBonePosition(prev.Entity:LookupBone("ValveBiped.Bip01_Head1"))
  		eyepos:Add(Vector(10, 0, -30))
  		prev:SetLookAt(eyepos)
  		prev:SetCamPos(eyepos-Vector(-60, 0, 0))
  		prev.Entity:SetEyeTarget(eyepos-Vector(-100, 0, 0))

      --Checking idle sequence
      local sqcs = prev:GetEntity():GetSequenceList()
      local gotSequence = false
      for k,v in pairs(sqcs) do
        if v == "idle_angry" then
          gotSequence = true
          prev:SetAnimSpeed(1)
          prev:GetEntity():SetSequence(prev:GetEntity():LookupSequence("idle_angry"))
          prev:RunAnimation()
        end
      end

      function prev:LayoutEntity( ent )
        if gotSequence then
          ent:SetPlaybackRate(self:GetAnimSpeed())
          ent:FrameAdvance()
        end
      end

      --Applying already bought bodygroups
      if #groups >= 1 then
        for k,v in pairs(groups) do
          prev:GetEntity():SetBodygroup(k,v)
        end
      end

      --Applying/Overwriting choosen bodygroups
      if bg then
        appliedBGs[bg[1]] = bg[2] --Adding to cache
        for k,v in pairs(appliedBGs) do --Applying Bodygroups from Cache
          prev:GetEntity():SetBodygroup(k, v)
        end
      end
    end
    drawPreview()

    --Bodygroup list
    local function createBL()
      local bl = vgui.Create("DPanel", panel)
      bl:SetSize(250, panel:GetTall()-60)
      bl:SetPos(panel:GetWide()-bl:GetWide())
      function bl:Paint(w,h)
        draw.RoundedBox(0,0,0,w,h,Color(40,40,40))
      end

      return bl
    end

    --Price Panel
    local function drawPrice()
      if price then
        price.panel:Remove()
      end

      price = {}
      price.panel = vgui.Create("DPanel", panel)
      price.panel:SetSize(panel:GetWide(), 60)
      price.panel:SetPos(0, panel:GetTall() - price.panel:GetTall())
      function price.panel:Paint(w,h)
        draw.RoundedBox(0,0,0,w,h,Color(40,40,40))
      end

      --Checking if there is price exceptions in the settings
      local pricetag = 0
      local gbl = prev:GetEntity():GetBodyGroups()
      for k, v in pairs(appliedBGs) do
        if #BGROUP_SHOP.custom_prices >= 1 then
          local g = getBodygroupsById(k, gbl)
          for j, c in pairs(BGROUP_SHOP.custom_prices) do
           if j == g.name then --If there's an exception
             if c.all then --If it applies to all the bodygroups in this category
               pricetag = pricetag + c.all
             else
               if c[v] then --If there's an exception for this particular bodygroup
                 pricetag = pricetag + c[v]
               else
                 pricetag = pricetag + BGROUP_SHOP.static_price --Apply the set static price
               end
             end
           end
          end
        else
          pricetag = pricetag + BGROUP_SHOP.static_price --Apply the set static price
        end
      end

      --Printing the price
      price.num = vgui.Create("DLabel", price.panel)
      price.num:SetText(BGROUP_SHOP.currency_symbol .. " " .. pricetag)
      price.num:SetFont("price_number")
      price.num:SizeToContents()
      price.num:Center()

      --Buy button
      price.buy = vgui.Create("DButton", price.panel)
      price.buy:SetText("Save & Buy")
      price.buy:SetSize(250, price.panel:GetTall())
      price.buy:SetPos(price.panel:GetWide()-price.buy:GetWide(), 0)
      function price.buy:Paint(w,h)
        draw.RoundedBox(0,0,0,w,h,Color(35,35,35))
        if self:IsHovered() then
          draw.RoundedBox(0,0,0,w,h,Color(45,45,45))
        end
      end
      function price.buy:DoClick()
        netstream.Start("saveBoughtBodygroups", {
          price = pricetag,
          bodygroups = appliedBGs
        })
        nut.gui.menu:Remove()
      end
    end
    drawPrice()

    local bgl = prev:GetEntity():GetBodyGroups()
    function setSectionTitle(txt, bl, backbutton, backFnc)
      --Categories
      local secPanel = vgui.Create("DPanel", bl)
      secPanel:SetSize(bl:GetWide(), 30)
      function secPanel:Paint(w,h)
        draw.RoundedBox(0,0,0,w,h,Color(35,35,35))
      end

      secLabel = vgui.Create("DLabel", secPanel)
      secLabel:SetText(txt)
      secLabel:SizeToContents()
      secLabel:Center()

      --Back
      if backbutton then
        local back = vgui.Create("DButton", panel)
        back:SetText("Back")
        back:SetSize(80, 30)
        back:SetPos(panel:GetWide()-bl:GetWide()-back:GetWide(), 0)
        function back:Paint(w,h)
          draw.RoundedBox(0,0,0,w,h,Color(30,30,30))
          if self:IsHovered() then
            draw.RoundedBox(0,0,0,w,h,Color(35,35,35))
          end
        end

        function back:DoClick()
          self:Remove()
          remove:Remove()
          bl:Remove()
          drawCategories()
        end
      end
    end

    function drawCategories()
      local bl = createBL()

      setSectionTitle("Categories", bl, false)

      --List
      local scroll = vgui.Create("DScrollPanel", bl)
      scroll:SetSize(bl:GetWide(), bl:GetTall())

      local list = vgui.Create("DIconLayout", scroll)
      list:SetSize(scroll:GetWide(),scroll:GetTall()-25)
      list:SetPos(0,35)
      list:SetSpaceY(1)

      --Categories
      for i=2, #bgl do
        local section = list:Add("DButton")
        section:SetSize(list:GetWide(), 40)
        section:SetText(bgl[i].name)
        section:SetColor(color_white)
        function section:Paint(w,h)
          draw.RoundedBox(0,0,0,w,h,Color(30,30,30))
          if self:IsHovered() then
            draw.RoundedBox(0,0,0,w,h,Color(35,35,35))
          end
        end
        function section:DoClick()
          bl:Remove()
          drawSection(bgl[i].id)
        end
      end
    end
    drawCategories()

    function drawSection(gid)
      local sel = nil
      local b = prev:GetEntity():GetBodyGroups()
      local bl = createBL()
      setSectionTitle("Bodygroups", bl, true)

      -- List
      local scroll = vgui.Create("DScrollPanel", bl)
      scroll:SetSize(bl:GetWide(), bl:GetTall())

      local list = vgui.Create("DIconLayout", scroll)
      list:SetSize(scroll:GetWide(),scroll:GetTall()-25)
      list:SetPos(0,35)
      list:SetSpaceY(1)

      -- Adding items to the list
      local g = getBodygroupsById(gid, b)
      for i=0, #g.submodels do
        local item = list:Add("DButton")
        item:SetSize(bl:GetWide(), 30)
        item:SetText(g.submodels[i])
        function item:Paint(w,h)
          draw.RoundedBox(0,0,0,w,h,Color(30,30,30))
          if self:IsHovered() or sel == self then
            draw.RoundedBox(0,0,0,w,h,Color(35,35,35))
          end
        end
        function item:DoClick()
          sel = self
          drawPreview({g.id, i})
          drawPrice() --Updates the price
        end
      end

      --Remove Button
      remove = vgui.Create("DButton", panel)
      remove:SetSize(80,30)
      remove:SetPos(panel:GetWide() - bl:GetWide() - remove:GetWide(), 30)
      remove:SetText("Remove")
      function remove:DoClick()
        appliedBGs[g.id] = nil
        drawPreview()

        --Remove Selected Button
        sel = nil

        --Refreshing model
        for k,v in pairs(appliedBGs) do --Applying Bodygroups from Cache
          prev:GetEntity():SetBodygroup(k, v)
        end
      end
      function remove:Paint(w,h)
        draw.RoundedBox(0,0,0,w,h,Color(30,30,30))
        if self:IsHovered() then
          draw.RoundedBox(0,0,0,w,h,Color(35,35,35))
        end
      end
    end
  end
end)
