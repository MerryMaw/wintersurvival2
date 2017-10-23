
local SCO = Color(0,0,0,250)
local MCO = Color(0,0,0,150)
local x,y = ScrW()-200,30

local AccountMenu = nil
local Info = nil

hook.Add("Tick","AccountInventory",function()
	if (input.KeyPress(KEY_F2)) then 
		OpenAccountMenu()
	end
end)


function ReloadAccountMenu()
	if (!IsAccountMenuOpen()) then return end
	AccountMenu.List:Clear()
	
	for k,v in pairs(LocalPlayer():GetAccountInventory()) do
		local a = AccountMenu.List:Add("DPanel")
		a:SetSize(64,64)
		a.Item = GetItemByName(v.Name)
		a.Quantity = v.Quantity
		a:Droppable("ACCOUNT")
		a.Paint = function(s,w,h)
			DrawRect(0,0,w,h,MCO)
			DrawMaterialRect(0,0,w,h,MAIN_WHITECOLOR,s.Item.Icon)
			
			DrawText("x"..v.Quantity,"ChatFont",1,h-18,MAIN_TEXTCOLOR)
		end
		
		a.OnCursorEntered = function(s)
			if (!Info) then
				Info = vgui.Create("DPanel")
				Info:SetPos(x-410,60)
				Info:SetSize(195,100)
				Info.Paint = function(s,w,h) DrawRect(0,0,w,h,SCO) end
				
				Info.Label = vgui.Create("DLabel",Info)
				Info.Label:SetPos(5,5)
				Info.Label:SetSize(185,20)
				
				Info.LabelDesc = vgui.Create("DLabel",Info)
				Info.LabelDesc:SetPos(5,30)
				Info.LabelDesc:SetSize(185,65)
				Info.LabelDesc:SetWrap(true)
				Info.LabelDesc:SetAutoStretchVertical(true)
			end
			
			Info.Label:SetText(v.Name)
			Info.LabelDesc:SetText(s.Item.Desc)
			
			Info:SetVisible(true)
		end
		
		a.OnCursorExited = function(s)
			Info:SetVisible(false)
		end
		
		a.OnStopDragging = function(s,a,b,c)
		end
		
		
		local Ab = a.OnMousePressed
		a.OnMousePressed = function(s,m)
			if (m == MOUSE_RIGHT) then
				local X,Y = gui.MousePos()
				
				local menu = DermaMenu() 
				menu.Paint = function(s,w,h) DrawRect(0,0,w,h,MCO) end
				menu:AddOption( "Use", function() if (s.Item) then RequestUseItem(s.Item.Name,true) end end ):SetColor(MAIN_TEXTCOLOR)
				menu:AddOption( "Destroy", function() if (s.Item) then RequestDropItem(s.Item.Name,true) end end ):SetColor(MAIN_TEXTCOLOR)
					
				menu:Open()
				menu:SetPos(X,Y)
			end
			
			Ab(s,m)
		end
	end
end

function OpenAccountMenu()
	if (IsAccountMenuOpen()) then return end
	
	surface.PlaySound("wintersurvival2/hud/itemopen.wav")
	
	if (!AccountMenu) then
		--Inventory
		AccountMenu = vgui.Create("MBFrame")
		AccountMenu:SetPos(x-205,y+25)
		AccountMenu:SetSize(400,400)
		AccountMenu:SetTitle("Account")
		AccountMenu:SetDeleteOnClose(false)
		AccountMenu:MakePopup()
		AccountMenu.Paint = function(s,w,h)
			DrawRect(0,0,w,h,MCO)
			DrawRect(5,20,w-10,20,MCO)
			
			DrawText("Time spent: "..math.SecondsToTime(LocalPlayer():GetTimeSpent()),"Trebuchet18",8,21,MAIN_WHITECOLOR)
		end
		AccountMenu.OnClose = function(s) surface.PlaySound("wintersurvival2/hud/itemequip.wav") end
		
		local Pane = vgui.Create( "DScrollPanel", AccountMenu )
		Pane:SetPos(5,45)
		Pane:SetSize(AccountMenu:GetWide()-10,AccountMenu:GetTall()-50)
		Pane.Paint = function(s,w,h) DrawRect(0,0,w,h,MCO) end
		
		local l = vgui.Create("DIconLayout",Pane)
		l:SetSize(Pane:GetWide()-10,Pane:GetTall()-10)
		l:SetPos(5,5)
		l:SetSpaceY(5)
		l:SetSpaceX(5)

		AccountMenu.List = l
	end
	
	AccountMenu:SetVisible(true)
	
	ReloadAccountMenu()
end

function IsAccountMenuOpen()
	return (IsValid(AccountMenu) and AccountMenu:IsVisible())
end

function DrawAccountInventory()
	DrawRect(x,y,200,20,MCO)
	DrawText("F2 - Account","Trebuchet18",x+4,y+2,MAIN_TEXTCOLOR)
end
