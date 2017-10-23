local Ventory = nil
local MCO = Color(0,0,0,150)

function ReloadLootventory()
	if (!IsValid(Ventory)) then return end
	
	Ventory.List:Clear()
	
	for k,v in pairs(Ventory.DATA) do
		local a = Ventory.List:Add("DPanel")
		a:SetSize(64,64)
		a.Item = GetItemByName(v.Name)
		a.Par = Ventory
		a.Quantity = v.Quantity
		a:Droppable("LOOTVENTORY")
		a.Paint = function(s,w,h)
			DrawRect(0,0,w,h,MCO)
			if (s.Item) then DrawMaterialRect(0,0,w,h,MAIN_WHITECOLOR,s.Item.Icon) end
			
			DrawText("x"..v.Quantity,"ChatFont",1,h-18,MAIN_TEXTCOLOR)
		end
	end
end

function IsLootventoryOpen()
	return (Ventory and Ventory:IsVisible())
end

function CloseLootventory()
	if (!IsLootventoryOpen()) then return end
	
	Ventory:SetVisible(false)
end

function MakeLootventory(dat,ent)
	if (!dat) then return end
	
	if (!Ventory) then
		Ventory = vgui.Create("MBFrame")
		Ventory:SetPos(690,ScrH()-480)
		Ventory:SetSize(200,200)
		Ventory:SetTitle("Lootventory")
		Ventory:SetDeleteOnClose(false)
		Ventory:MakePopup()
		Ventory.Paint = function(s,w,h) DrawRect(0,0,w,h,MCO) end
		Ventory.OnClose = function(s) surface.PlaySound("wintersurvival2/hud/itemequip.wav") end
		
		local Pane = vgui.Create( "DScrollPanel", Ventory )
		Pane:SetPos(5,25)
		Pane:SetSize(Ventory:GetWide()-10,Ventory:GetTall()-30)
		Pane.Paint = function(s,w,h) DrawRect(0,0,w,h,MCO) end
		Pane:Receiver("INVENTORY", function(s,a,b,c) 
			local p = a[1] 
			
			if (p.Item and IsValid(Ventory.Entity) and b) then
				TransferItems(p.Item.Name,p.Quantity,Ventory.Entity)
				DemandLootventoryUpdate(Ventory.Entity)
			end
		end)
		
		local l = vgui.Create("DIconLayout",Pane)
		l:SetSize(Pane:GetWide()-10,Pane:GetTall()-10)
		l:SetPos(5,5)
		l:SetSpaceY(5)
		l:SetSpaceX(5)

		Ventory.List = l
	end
	
	Ventory.Entity = ent
	Ventory.DATA = dat
	
	ReloadLootventory()
	
	Ventory:SetVisible(true)
end