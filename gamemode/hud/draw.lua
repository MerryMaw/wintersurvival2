
local MCO = Color(0,0,0,150)

local DrawText = draw.DrawText

function GM:HUDPaint()
	local CountDown = self.CountDown
	
	if (#player.GetAll() < 2) then
		draw.DrawText("You need at least 2 people to play this gamemode!", "Trebuchet18", ScrW()/2, 10, MAIN_WHITECOLOR,1)
	end
	
	if (CountDown and CountDown > CurTime()) then
        surface.SetDrawColor(MCO.r,MCO.g,MCO.b,MCO.a);
        surface.DrawRect(5,5,100,20);
        draw.DrawText("Preround: "..math.ceil(CountDown-CurTime()), "Trebuchet18", 10, 6, MAIN_WHITECOLOR)
	end
	
	if (CountDown and CountDown < CurTime() and CountDown > CurTime()-MAIN_PVPTIMER) then
        surface.SetDrawColor(MCO.r,MCO.g,MCO.b,MCO.a);
        surface.DrawRect(5,5,130,20);
		draw.DrawText("Anti PVP timer: "..math.ceil(CountDown-(CurTime()-MAIN_PVPTIMER)), "Trebuchet18", 10, 6, MAIN_WHITECOLOR)
	end
		
	DrawAccountInventory()
	DrawHelp()
	DrawIndicators()
	DrawWepSwap()
	DrawTargets()
end