local Inventory 	= nil
local RecipeMenu	= nil
local MCO = Color(0,0,0,150)
local BCO = Color(0,50,100,150)
local GCO = Color(0,100,0,150)
local HCO = Color(30,30,30,150)

--Garry... for the love of god, this fucking function is spamming the console with debug information. 
--I decided to override it so it shuts up!
dragndrop.HandleDroppedInGame = function() end

function ReloadInventory()
	if (!IsInventoryOpen()) then return end
	Inventory.List:Clear()
	
	ReloadRecipes()
	
	for k,v in pairs(LocalPlayer():GetInventory()) do
		local a = Inventory.List:Add("DPanel")
		a:SetSize(64,64)
		a.Item = GetItemByName(v.Name)
		a.Quantity = v.Quantity
		a:Droppable("INVENTORY")
		a.Paint = function(s,w,h)
			DrawRect(0,0,w,h,MCO)
			DrawMaterialRect(0,0,w,h,MAIN_WHITECOLOR,s.Item.Icon)
			
			DrawText("x"..v.Quantity,"ChatFont",1,h-18,MAIN_TEXTCOLOR)
		end
		
		a.OnStopDragging = function(s,a,b,c)
			local ID = IsMouseInSlot()
			
			if (!ID) then return end
			
			RequestEquip(ID,s.Item.Name)
		end
		
		local Ab = a.OnMousePressed
		a.OnMousePressed = function(s,m)
			if (m == MOUSE_RIGHT) then
				local X,Y = gui.MousePos()
				
				local menu = DermaMenu() 
				menu.Paint = function(s,w,h) DrawRect(0,0,w,h,MCO) end
				menu:AddOption( "Use", function() if (s.Item) then RequestUseItem(s.Item.Name) end end ):SetColor(MAIN_TEXTCOLOR)
				menu:AddOption( "Drop", function() if (s.Item) then RequestDropItem(s.Item.Name) end end ):SetColor(MAIN_TEXTCOLOR)
					
				menu:Open()
				menu:SetPos(X,Y)
			end
			
			Ab(s,m)
		end
		
		a.OnCursorEntered = function(s)
			Inventory.Desc:SetVisible(true)
			Inventory.Desc:SetText(s.Item.Name.."\n\n"..s.Item.Desc)
			Inventory.CraftingButton:SetVisible(false)
			
			s.Hover = true 
		end
		
		a.OnCursorExited = function(s)
			Inventory.Desc:SetVisible(false)
			
			if (RecipeMenu.SelectedRecipe) then
				Inventory.CraftingButton:SetVisible(true)
			end
			
			s.Hover = false 
		end
	end
end

function ReloadRecipes()
	if (!IsInventoryOpen()) then return end
	RecipeMenu.List:Clear()
	RecipeMenu.Combine.Items = {}
	
	for k,v in pairs(GAMEMODE.KnownRecipes) do
		local a = RecipeMenu.List:Add("MBButton")
		a:SetText(v.Name)
		a:SetSize(RecipeMenu.List:GetWide()-5,23)
		a.Item = v
		a.Paint = function(s,w,h)
			if (s.Pressed) then DrawRect(0,0,w,h-3,BCO)
			elseif (s.Hover) then DrawRect(0,0,w,h-3,HCO)
			else DrawRect(0,0,w,h-3,MCO) end
			
			DrawText(s.Item.Name,"Trebuchet18",4,0,MAIN_TEXTCOLOR)
		end
		a.DoClick = function(s)
			if (RecipeMenu.SelectedRecipe == a.Item) then RecipeMenu.SelectedRecipe = nil Inventory.CraftingButton:SetVisible(false)
			else RecipeMenu.SelectedRecipe = a.Item Inventory.CraftingButton:SetVisible(true) end
		end
	end
end
	

function GM:OnSpawnMenuOpen()
	if (LocalPlayer():IsPigeon()) then return end
	if (IsInventoryOpen()) then return end
	
	surface.PlaySound("wintersurvival2/hud/itemopen.wav")
	
	if (!Inventory) then 
		--Recipes
		RecipeMenu = vgui.Create("MBFrame")
		RecipeMenu:SetPos(485,ScrH()-480)
		RecipeMenu:SetSize(200,400)
		RecipeMenu:SetTitle("Recipes")
		RecipeMenu:ShowCloseButton(false)
		RecipeMenu.Paint = function(s,w,h) DrawRect(0,0,w,h,MCO) end
		RecipeMenu.SelectedRecipe = nil
		
		local Pane = vgui.Create( "DScrollPanel", RecipeMenu )
		Pane:SetPos(5,25)
		Pane:SetSize(RecipeMenu:GetWide()-10,RecipeMenu:GetTall()-150)
		Pane.Paint = function(s,w,h) DrawRect(0,0,w,h,MCO) end
		
		local l = vgui.Create("DListLayout",Pane)
		l:SetSize(Pane:GetWide()-10,Pane:GetTall()-10)
		l:SetPos(5,5)
	
		RecipeMenu.List = l
		
		local c = vgui.Create( "MBFrame", RecipeMenu )
		c:SetPos(5,RecipeMenu:GetTall()-120)
		c:SetSize(RecipeMenu:GetWide()-10,115)
		c:SetTitle("")
		c:ShowCloseButton(false)
		c.Items = {}
		c.Paint = function(s,w,h) 
			DrawRect(0,0,w,h,MCO) 
			
			local Press = input.MousePress(MOUSE_LEFT,"MenuPress")
			
			if (table.Count(s.Items) < 1) then
				DrawText("Draw items here!","Trebuchet24",w/2,h/2-3,MAIN_WHITECOLOR,1)
			else
				for i = 1,4 do
					local v = s.Items[i]
					
					if (v and v.Name) then
						local Item = GetItemByName(v.Name)
						local y    = -15+20*i
						local x    = 5
						
						local X,Y  	= s:GetParent():GetPos()
						local SX,SY = s:GetPos()
						X = X+SX
						Y = Y+SY
						
						if (!input.IsMouseInBox(X+x,Y+y,w-10,18)) then DrawRect(x,y,w-10,18,MCO) 
						else 
							DrawRect(x,y,w-10,18,GCO) 
							
							if (Press) then
								s.Items[i] = nil
								break
							end
						end
						
						if (Item.Icon) then
							DrawMaterialRect(x+1,y+1,16,16,MAIN_WHITECOLOR,Item.Icon) 
						end
						
						DrawText("x "..v.Quantity.." "..v.Name,"Trebuchet18",23,y,MAIN_WHITECOLOR)
					end
				end
			end
		end
		c:Receiver("INVENTORY", function(s,a,b,c) 
			local p = a[1] 
			
			if (p.Item and b) then
				local Find = false
				
				for i = 1,4 do
					if (s.Items[i] and s.Items[i].Name == p.Item.Name) then
						if (LocalPlayer():HasItem(s.Items[i].Name,s.Items[i].Quantity+1)) then
							s.Items[i].Quantity = s.Items[i].Quantity + 1
						end
						
						Find = true
						break
					end
				end
				
				if (!Find) then
					for i = 1,4 do
						if (!s.Items[i]) then
							s.Items[i] = {Name = p.Item.Name,Quantity = 1}
							break
						end
					end
				end
			end
		end)
		
		local B = vgui.Create("MBButton",c)
		B:SetPos(5,c:GetTall()-25)
		B:SetSize(c:GetWide()-10,20)
		B:SetVisible(true)
		B.DoClick = function(s)
			local Items = RecipeMenu.Combine.Items
			
			if (Items and table.Count(Items) > 0) then
				DiscoverItems(Items)
			end
		end
		B.Paint = function(s,w,h)
			if (s.Pressed) then DrawRect(0,0,w,h-3,BCO)
			elseif (s.Hover) then DrawRect(0,0,w,h-3,HCO)
			else DrawRect(0,0,w,h-3,MCO) end
			
			DrawText("Combine","Trebuchet18",w/2,h/2,MAIN_TEXTCOLOR,1)
		end
		
		RecipeMenu.Combine = c
		
		--Inventory
		Inventory = vgui.Create("MBFrame")
		Inventory:SetPos(80,ScrH()-480)
		Inventory:SetSize(400,400)
		Inventory:SetTitle("Inventory")
		Inventory:SetDeleteOnClose(false)
		Inventory:MakePopup()
		Inventory.Paint = function(s,w,h)
			DrawRect(0,0,w,h,MCO)
			
			local X,Y,W,H = 5,h-120,w-10,115
			DrawRect(X,Y,W,H,MCO)
			
			local Rec = RecipeMenu.SelectedRecipe
			
			if (Rec and Inventory.CraftingButton:IsVisible()) then
				local Recipe 	= Rec.Recipe
				local pl 		= LocalPlayer()
				local C 		= 0
				local Step		= W/3
				
				DrawText("Products:","Trebuchet18",X+5,Y,MAIN_TEXTCOLOR)
				DrawText("Reagents:","Trebuchet18",X+Step+5,Y,MAIN_TEXTCOLOR)
				DrawText("Tools:","Trebuchet18",X+Step*2+5,Y,MAIN_TEXTCOLOR)
				
				for k,v in pairs(Recipe.Resources) do
					C = C+1
					if (pl:HasItem(k,v)) then DrawText(v.." x "..k,"Trebuchet18",X+Step+5,Y+16*C,MAIN_GREENCOLOR)
					else DrawText(v.." x "..k,"Trebuchet18",X+Step+5,Y+16*C,MAIN_REDCOLOR) end
				end
				
				C = 0
				
				for k,v in pairs(Recipe.Tools) do
					C = C+1
					if (pl:HasItem(k,v)) then DrawText(v.."x "..k,"Trebuchet18",X+5+Step*2,Y+16*C,MAIN_GREENCOLOR) 
					else DrawText(v.."x "..k,"Trebuchet18",X+5+Step*2,Y+16*C,MAIN_REDCOLOR) end
				end
				
				DrawText("1 x "..Rec.Name,"Trebuchet18",X+5,Y+16,MAIN_GREENCOLOR)
			end
		end
		Inventory.OnClose = function(s) CloseLootventory() RecipeMenu:SetVisible(false) surface.PlaySound("wintersurvival2/hud/itemequip.wav") end
		
		local Pane = vgui.Create( "DScrollPanel", Inventory )
		Pane:SetPos(5,25)
		Pane:SetSize(Inventory:GetWide()-10,Inventory:GetTall()-150)
		Pane.Paint = function(s,w,h) DrawRect(0,0,w,h,MCO) end
		Pane:Receiver("LOOTVENTORY", function(s,a,b,c) 
			local p = a[1] 
			
			if (p.Item and IsValid(p.Par.Entity) and b) then
				DemandItems(p.Item.Name,p.Quantity,p.Par.Entity)
				DemandLootventoryUpdate(p.Par.Entity)
			end
		end)
		
		local l = vgui.Create("DIconLayout",Pane)
		l:SetSize(Pane:GetWide()-10,Pane:GetTall()-10)
		l:SetPos(5,5)
		l:SetSpaceY(5)
		l:SetSpaceX(5)

		Inventory.List = l
		
		local B = vgui.Create("MBButton",Inventory)
		B:SetPos(Inventory:GetWide()-110,Inventory:GetTall()-25)
		B:SetSize(100,20)
		B:SetVisible(false)
		B.DoClick = function(s)
			if (RecipeMenu.SelectedRecipe) then RequestCreateRecipe(RecipeMenu.SelectedRecipe.Name) end
		end
		B.Paint = function(s,w,h)
			if (s.Pressed) then DrawRect(0,0,w,h-3,BCO)
			elseif (s.Hover) then DrawRect(0,0,w,h-3,HCO)
			else DrawRect(0,0,w,h-3,MCO) end
			
			DrawText("Craft!","Trebuchet18",w/2,h/2,MAIN_TEXTCOLOR,1)
		end
		
		Inventory.CraftingButton = B
		
		local a = vgui.Create("DLabel",Inventory)
		a:SetPos(10,Inventory:GetTall()-120)
		a:SetSize(Inventory:GetWide()-2,1)
		a:SetText("")
		a:SetWrap(true)
		a:SetVisible(false)
		a:SetTextColor(MAIN_TEXTCOLOR)
		a:SetFont("Trebuchet18")
		a:SetAutoStretchVertical(true)
		
		Inventory.Desc = a
	end
	
	RecipeMenu:SetVisible(true)
	Inventory:SetVisible(true)
	
	ReloadInventory()
end

function IsInventoryOpen()
	return (Inventory and Inventory:IsVisible())
end

