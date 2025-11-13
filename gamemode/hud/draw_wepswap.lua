local Num = 0
local MCO = Color(0,0,0,150)

local max = math.max
local min = math.min
local cos = math.cos
local sin = math.sin
local rad = math.rad

local h = ScrH()
local s = 65
local B = s+5

function DrawWepSwap()
	local pl = LocalPlayer()
	if (pl:IsPigeon()) then return end
	if (GetRecentSwapTime() < CurTime()-3 and !IsInventoryOpen()) then return end
	
	local Slot = GetWeaponSlot()
	
	Num = Num+math.Clamp((Slot-Num)/6,-1,1)
	
	if (!IsInventoryOpen()) then MCO.a = 150*min(1,GetRecentSwapTime()-(CurTime()-3))
	else MCO.a = 150 end
	
	local Ib = input.MousePress(MOUSE_LEFT,"Unequip")
	
	for i = 0,9 do
		local r = Num-i
		local x = max(0,B*r)
		local y = max(0,B*-r)
		
		if (Slot == i) then MCO.b = 150
		else MCO.b = 0 end

        surface.SetDrawColor(MCO.r,MCO.g,MCO.b,MCO.a);
        surface.DrawRect(x+10,h-s-y-10,s,s);
		
		if (pl.Weapons and pl.Weapons[i]) then
			if (pl.Weapons[i].Item.Icon) then
                surface.SetDrawColor(MAIN_WHITECOLOR.r,MAIN_WHITECOLOR.g,MAIN_WHITECOLOR.b,MAIN_WHITECOLOR.a);
                surface.SetMaterial(pl.Weapons[i].Item.Icon);
                surface.DrawTexturedRect(x+10,h-s-y-10,s,s);
            end
			
			if (input.IsMouseInBox(x+10,h-s-y-10,s,s) and Ib) then
				RequestUnEquip(i)
				timer.Simple(0.05,function() ReloadInventory() end)
			end
		end
	end
end

function IsMouseInSlot()
	local mx,my = gui.MousePos()
	
	for i = 0,9 do
		local r = Num-i
		local x = max(0,B*r)
		local y = max(0,B*-r)
		
		if (input.IsMouseInBox(x+10,h-s-y-10,s,s)) then
			return i
		end
	end
	
	return false
end
	