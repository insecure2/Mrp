RM = {}
if SERVER then
  net.Receive("getrecipes", function(lenght, ply)
    local f = util.JSONToTable(file.Read("recipes.dat", "DATA") or "{}") or {}
    net.Start("return_recipies")
      net.WriteTable(f)
    net.Send(ply)
  end)

  net.Receive("addrecipe", function()
    local i = net.ReadTable()
    local f = util.JSONToTable(file.Read("recipes.dat", "DATA") or "{}") or {}
    f[#f+1] = i

    file.Write("recipes.dat", util.TableToJSON(f, true))
  end)

  net.Receive("editrecipe", function()
    local index = tonumber(net.ReadString())
    local i = net.ReadTable()
    local f = util.JSONToTable(file.Read("recipes.dat", "DATA") or "{}") or {}
    f[index] = i

    file.Write("recipes.dat", util.TableToJSON(f, true))
  end)

  net.Receive("delrecipe", function()
    local index = tonumber(net.ReadString())
    local f = util.JSONToTable(file.Read("recipes.dat", "DATA") or "{}") or {}
    table.remove(f, index)
    file.Write("recipes.dat", util.TableToJSON(f, true))
  end)
end

if CLIENT then
  surface.CreateFont("ArialBig", {
    font = "Arial",
    size = 18,
    weight = 250
  })

  function RM:Editor(item, new, index)
    if RM.frame and IsValid(RM.frame) then
      RM.frame:Close()
    end
    if not LocalPlayer():IsSuperAdmin() then return end
    if not new then new = false end
    if new then
      item = {
        name = "",
        items = {
          "models/props_junk/PopCan01a.mdl"
        },
        result_class = "",
        result_model = "models/props_junk/cardboard_box004a_gib01.mdl",
        time = 10,
        hasclasses = false
      }
    end

    RM.frame = vgui.Create("DFrame")
    RM.frame:SetSize(ScrW()-250, ScrH() - 250)
    RM.frame:Center()
    RM.frame:MakePopup()
    RM.frame:SetTitle("")
    RM.frame:SetDraggable(false)
    function RM.frame:Paint(w,h)
      draw.RoundedBox(0,0,0,w,h,Color(25,25,25))
    end

    local name = vgui.Create("DLabel", RM.frame)
    name:SetText("Name of the recipe: ")
    name:SizeToContents()
    name:CenterHorizontal()
    local x,y = name:GetPos()
    name:SetPos(x-95,10)

    local name_entry = vgui.Create("DTextEntry", RM.frame)
    name_entry:SetText(item.name)
    name_entry:SetSize(180,20)
    name_entry:SetPos(x+95,5)

    local time = vgui.Create("DLabel", RM.frame)
    time:SetText("Time needed: ")
    time:SizeToContents()
    time:CenterHorizontal()
    local x,y = time:GetPos()
    time:SetPos(x-95,35)

    local time_entry = vgui.Create("DTextEntry", RM.frame)
    time_entry:SetText(item.time)
    time_entry:SetSize(180,20)
    time_entry:SetPos(x+93,30)

    local scroll = vgui.Create("DScrollPanel", RM.frame)
    scroll:SetSize(RM.frame:GetWide(), RM.frame:GetTall()-25)
    scroll:SetPos(0,35)

    --Items needed
    local in_title = vgui.Create("DLabel", scroll)
    in_title:SetText("Objects needed")
    in_title:SetFont("ArialBig")
    in_title:SetPos(5,5)
    in_title:SetColor(color_white)
    in_title:SizeToContents()

    local items_needed = vgui.Create("DPanel", scroll)
    items_needed:SetSize(scroll:GetWide()-4, 174)
    items_needed:SetPos(2, 30)
    function items_needed:Paint(w,h)
      draw.RoundedBox(0,0,0,w,h,color_white)
      draw.RoundedBoxEx(0,1,1,w-2,h-2,Color(25,25,25))
    end

    function draw_item_needed()
      if in_list and IsValid(in_list) then
        in_list:Remove()
      end

      local nt = item.items or {}

      in_list = vgui.Create("DIconLayout", items_needed)
      in_list:SetSize(items_needed:GetWide()-4,items_needed:GetTall()-4)
      in_list:SetPos(items_needed:GetWide()/2 - in_list:GetWide()/2+2, 2)
      in_list:SetSpaceX(2)
      in_list:SetSpaceY(2)

      for i=1, #item.items do
        local ri = in_list:Add("DPanel")
        ri:SetSize(170,170)
        function ri:Paint(w,h)
          draw.RoundedBox(0,0,0,w,h,Color(35,35,35))
        end

        --Model Prev
        local in_prev = vgui.Create("SpawnIcon", ri)
        in_prev:SetSize(ri:GetWide(), ri:GetTall())
        in_prev:SetPos(0,0)
        in_prev:SetModel(item.items[i])
        function in_prev:LayoutEntity(ent) return end

        --Remove button
        local rb = vgui.Create("DButton", ri)
        rb:SetText("Remove Object")
        rb:SetSize(150,25)
        rb:CenterHorizontal()
        local x,y = rb:GetPos()
        rb:SetPos(x, ri:GetTall()-rb:GetTall()-5)
        function rb:Paint(w,h)
          self:SetColor(color_white)
          draw.RoundedBox(0,0,0,w,h,Color(30,30,30))
          if self:IsHovered() then
            self:SetColor(Color(69, 195, 237))
            draw.RoundedBox(0,0,0,w,h,Color(33,33,33))
          end
        end
        function rb:DoClick()
          local changed = false
          table.remove(item.items, i)
          draw_item_needed()
        end

        --Model entry
        local mdl_changer = vgui.Create("DTextEntry", ri)
        mdl_changer:SetSize(ri:GetWide()-10, 20)
        mdl_changer:SetPos(5, 2)
        mdl_changer:SetValue(nt[i])
        function mdl_changer:OnEnter()
          if not string.find(self:GetValue(), "models") then
            nt[i] = self:GetValue()

            --Checking for clases
            for x=1, #nt do
              if not string.find(nt[x], "models") then
                item.hasclasses = true
              end
            end
            return
          end
          nt[i] = self:GetValue()
          in_prev:SetModel(self:GetValue())
        end
      end
    end
    draw_item_needed()

    local controls_plus = vgui.Create("DButton", RM.frame)
    controls_plus:SetText("Add Object")
    controls_plus:SetFont("ArialBig")
    controls_plus:SizeToContents()
    controls_plus:SetSize(controls_plus:GetWide()+20,controls_plus:GetTall()+10)
    controls_plus:SetPos(RM.frame:GetWide()-controls_plus:GetWide()-5, 30)
    function controls_plus:Paint(w,h)
      self:SetColor(color_white)
      draw.RoundedBox(0,0,0,w,h,Color(30,30,30))
      if self:IsHovered() then
        self:SetColor(Color(69, 195, 237))
        draw.RoundedBox(0,0,0,w,h,Color(33,33,33))
      end
    end
    function controls_plus:DoClick()
      table.insert(item.items, #item.items+1, "models/props_junk/cardboard_box004a_gib01.mdl")
      draw_item_needed()
    end

    local result = vgui.Create("DPanel", scroll)
    result:SetSize(174,174)
    result:SetPos(scroll:GetWide()/2-result:GetWide()/2 - 150, 100 + in_list:GetTall())
    function result:Paint(w,h)
      draw.RoundedBox(0,0,0,w,h,color_white)
      draw.RoundedBoxEx(0,1,1,w-2,h-2,Color(25,25,25))
    end

    --Result
    local re_title = vgui.Create("DLabel", scroll)
    re_title:SetText("Result:")
    local x,y = result:GetPos()
    re_title:SetPos(scroll:GetWide()/2-result:GetWide()/2 - 250, y + result:GetTall()/2-re_title:GetTall()/2)
    re_title:SetFont("ArialBig")
    re_title:SetColor(color_white)
    re_title:SizeToContents()

    local ri = vgui.Create("DPanel", result)
    ri:SetSize(172,172)
    ri:Center()
    function ri:Paint(w,h)
      draw.RoundedBox(0,0,0,w,h,Color(35,35,35))
    end

    local x,y = result:GetPos()

    --Model Prev
    local re_prev = vgui.Create("SpawnIcon", ri)
    re_prev:SetSize(ri:GetWide(), ri:GetTall())
    re_prev:SetPos(0,0)
    re_prev:SetModel("models/props_junk/cardboard_box004a_gib01.mdl")
    if not IsValid(item.result) then
      re_prev:SetModel(item.result_model or "models/props_junk/cardboard_box004a_gib01.mdl")
    else
      re_prev:SetModel("models/props_junk/cardboard_box004a_gib01.mdl")
    end

    local re_mdl_title = vgui.Create("DLabel", scroll)
    re_mdl_title:SetText("Model of the entity: ")
    re_mdl_title:SizeToContents()
    re_mdl_title:SetPos(x + result:GetWide() + 5, y + result:GetTall()/2 - 70)

    --Model entry
    local re_mdl_changer = vgui.Create("DTextEntry", scroll)
    re_mdl_changer:SetSize(250, 25)
    local x,y = result:GetPos()
    re_mdl_changer:SetPos(x + result:GetWide() + 5, y + result:GetTall()/2 - 50)
    re_mdl_changer:SetValue(item.result_model or "models/props_junk/cardboard_box004a_gib01.mdl")
    function re_mdl_changer:OnEnter()
      re_prev:SetModel(self:GetValue())
      item.result_model = self:GetValue()
    end

    local re_class_title = vgui.Create("DLabel", scroll)
    re_class_title:SetText("Entity class (Leave empty for simple prop): ")
    re_class_title:SizeToContents()
    re_class_title:SetPos(x + result:GetWide() + 5, y + result:GetTall()/2 + 30)

    local re_class_changer = vgui.Create("DTextEntry", scroll)
    re_class_changer:SetSize(250, 25)
    re_class_changer:SetPos(x + result:GetWide() + 5, y + result:GetTall()/2 + 50)
    if item.result_class then
      re_class_changer:SetValue(item.result_class)
    end
    function re_class_changer:OnEnter()
      item.result_class = self:GetValue()
    end

    local function drawErr(msg)
      if err_panel and IsValid(err_panel) then
        err_panel:Remove()
        timer.Remove("err_panel_timer")
      end

      err_panel = vgui.Create("DPanel", RM.frame)
      err_panel:SetSize(RM.frame:GetWide(), 28)
      err_panel:SetPos(0, RM.frame:GetTall()-err_panel:GetTall())
      function err_panel:Paint(w,h)
        draw.RoundedBox(0,0,0,w,h,Color(148,16,16))
      end

      local err = vgui.Create("DLabel", err_panel)
      err:SetText(msg)
      err:SizeToContents()
      err:Center()

      timer.Create("err_panel_timer", 5, 1, function()
        err_panel:Remove()
      end)
    end

    --Save
    local save = vgui.Create("DButton", RM.frame)
    save:SetText("Save")
    save:SetSize(180,30)
    save:CenterHorizontal()
    local x,y = save:GetPos()
    save:SetPos(x, RM.frame:GetTall()-save:GetTall()-30)
    function save:Paint(w,h)
      self:SetColor(color_white)
      draw.RoundedBox(0,0,0,w,h,Color(30,30,30))
      if self:IsHovered() then
        self:SetColor(Color(69, 195, 237))
        draw.RoundedBox(0,0,0,w,h,Color(33,33,33))
      end
    end
    function save:DoClick()
      --Checking
      if #item.items <= 0 then
        drawErr("You need at least 1 object.")
        return
      end

      if (re_class_changer:GetValue() == "" or not re_class_changer:GetValue()) and (re_mdl_changer:GetValue() == "" or not re_mdl_changer:GetValue()) then
        drawErr("You need to specify an object for the result.")
        return
      end

      -- if (re_class_changer:GetValue() ~= "" or re_class_changer:GetValue()) and (re_mdl_changer:GetValue() == "" or not re_mdl_changer:GetValue()) then
      --   drawErr("Vous avez seulement spécifié la classe du résultat, spécifiez le model aussi.")
      --   return
      -- end

      if not name_entry:GetValue() or name_entry:GetValue() == "" then
        drawErr("You need to specify a name for your recipe")
        return
      end

      if not time_entry:GetValue() or time_entry:GetValue() == "" then
        drawErr("You need to specify the time needed to complete the recipe.")
        return
      end

      --Adding not-added items/text
      item.result_class = re_class_changer:GetValue()
      item.result_model = re_mdl_changer:GetValue()
      item.name = name_entry:GetValue()
      item.time = time_entry:GetValue()

      --Saving
      if new then
        net.Start("addrecipe")
        net.WriteTable(item)
        net.SendToServer()
      else
        net.Start("editrecipe")
        net.WriteString(index)
        net.WriteTable(item)
        net.SendToServer()
      end
      if RM.frame and IsValid(RM.frame) then
        RM.frame:Close()
      end
      LocalPlayer():ConCommand("rm")
    end
  end

  function RM:Display()
    if not LocalPlayer():IsSuperAdmin() then return end
    if RM.frame and IsValid(RM.frame) then
      return
    end
    RM.frame = vgui.Create("DFrame")
    RM.frame:SetSize(ScrW()-250, ScrH() - 250)
    RM.frame:Center()
    RM.frame:MakePopup()
    RM.frame:SetTitle("")
    RM.frame:SetDraggable(false)
    function RM.frame:Paint(w,h)
      draw.RoundedBox(0,0,0,w,h,Color(25,25,25))
    end

    --Premade panels
    local function recipe_browser(parent, x, y, w, h, enablecheckboxes, stylepanel, oncheckchange)
      if pp and IsValid(pp) then
        pp:Remove()
      end
      --Parent panel
      pp = vgui.Create("DPanel", parent)
      local px,py = parent:GetPos()
      pp:SetPos(x or px, y or py)
      pp:SetSize(w or parent:GetWide(), h or parent:GetTall())
      if stylepanel then
        function pp:Paint(w,h)
          draw.RoundedBox(0,0,0,w,h,Color(30,30,30))
        end
      end

      --List elements
      local scroll = vgui.Create("DScrollPanel", pp)
      scroll:SetSize(pp:GetWide(), pp:GetTall())

      local list = vgui.Create("DIconLayout", scroll)
      list:SetSize(scroll:GetWide()-4, scroll:GetTall()-4)
      list:SetPos(2, 2)
      list:SetSpaceY(1)

      net.Start("getrecipes") --Getting recipies
      net.SendToServer()
      net.Receive("return_recipies", function()
        local t = net.ReadTable()
        local checks = {}
        for i=1, #t do --Displaying them
          local item = list:Add("DPanel")
          item:SetSize(list:GetWide(), 30)
          function item:Paint(w,h)
            local _,f = math.modf(i/2)
            if f <= 0 then
              draw.RoundedBox(0,0,0,w,h,Color(35,35,35))
            else
              draw.RoundedBox(0,0,0,w,h,Color(33,33,33))
            end
          end

          if enablecheckboxes then
            local check = vgui.Create("DCheckBox", item)
            check:CenterVertical()
            check:CenterHorizontal(0.02)

            --Logging
            checks[#checks+1] = check

            function check:OnChange(val)
              oncheckchange(t, i)
              --Disabling all the other checkboxes
              for x=1, #checks do
                if checks[x] ~= self and checks[x]:GetChecked() then
                  checks[x]:SetChecked(false)
                end
              end
            end
          end

          local name = vgui.Create("DLabel", item)
          name:SetText(t[i].name)
          name:SizeToContents()
          name:CenterVertical()
          if enablecheckboxes then
            name:CenterHorizontal(0.08)
          else
            name:CenterHorizontal(0.05)
          end

          local items_needed = vgui.Create("DLabel", item)
          items_needed:SetText(#t[i].items .. " object(s) needed to complete recipe")
          items_needed:SizeToContents()
          items_needed:Center()
        end
      end)
    end

    local function MakeSub()
      local sf = vgui.Create("DPanel", RM.frame)
      sf:SetSize(RM.frame:GetWide(), RM.frame:GetTall()-RM.scroll:GetTall()-30)
      sf:SetPos(0, RM.scroll:GetTall()+30)
      function sf:Paint(w,h)
        draw.RoundedBox(0,0,0,w,h,Color(35,35,35))
      end
      return sf
    end

    --Tabs
    RM.tabs = {
      [1] = {
        name = "Recettes",
        action = function()
          --Display recipies
        end
      },
      [2] = {
        name = "Gestion",
        action = function()
          --Create, Remove, Edit recipies
          local sf = MakeSub()


        end
      }
    }

    local function applyStyle(btn)
      function btn:Paint(w,h)
        self:SetColor(color_white)
         draw.RoundedBox(0,0,0,w,h,Color(33,33,33))
         if self:IsHovered() or sel == self then
           self:SetColor(Color(69, 195, 237))
           draw.RoundedBox(0,0,0,w,h,Color(25,25,25))
         end
      end
    end

    --Controls
    local create = vgui.Create("DButton", RM.frame)
    create:SetText("Create Recipe")
    create:SetSize(150,30)
    create:SetPos(0,2)
    applyStyle(create)
    function create:DoClick()
      RM:Editor({}, true)
    end

    local edit = vgui.Create("DButton", RM.frame)
    edit:SetText("Edit Recipe")
    edit:SetSize(150, 30)
    edit:SetPos(150,2)
    applyStyle(edit)

    local delete = vgui.Create("DButton", RM.frame)
    delete:SetText("Delete Recipe")
    delete:SetSize(150, 30)
    delete:SetPos(300,2)
    applyStyle(delete)

    --Drawing browser
    local function draw_rb()
      recipe_browser(RM.frame, 0, 34, RM.frame:GetWide(), RM.frame:GetTall()-32, true, true, function(list, index)
        function edit:DoClick()
          if RM.frame and IsValid(RM.frame) then
            RM.frame:Close()
          end
          RM:Editor(list[index], false, index)
        end

        function delete:DoClick()
          net.Start("delrecipe")
          net.WriteString(index)
          net.SendToServer()
          draw_rb()
        end
      end)
    end

    draw_rb()
  end

  --Hook
  net.Receive("open_recipe_manager", function()
    RM:Display()
  end)

  concommand.Add("rm", function()
    RM:Display()
  end)
end
