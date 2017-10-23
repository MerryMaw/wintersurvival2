
local MCO = Color(0,0,0,150)

MAIN_HELP = false
MAIN_HELP_PAGES = 5

hook.Add("Tick","Help",function()
	if (input.KeyPress(KEY_F1)) then 
		if (MAIN_HELP and MAIN_HELP < MAIN_HELP_PAGES) then
			MAIN_HELP = MAIN_HELP + 1
		elseif (MAIN_HELP) then MAIN_HELP = false
		else MAIN_HELP = 1 end
	end
end)

local function WrapString(str,width)
	local dp = string.Explode(" ",str)
	local dout = dp[1]
	local curline = dout
	
	for k,v in pairs(dp) do
		if k ~= 1 then
			local sz = surface.GetTextSize(curline)
			local sza = surface.GetTextSize(" "..v)
			if sz+sza < width then
				dout = dout .. " " .. v
				curline = curline .. " " .. v
			else
				dout = dout .. "\n" .. v
				curline = v
			end
		end
	end
	
	return dout
end

function DrawHelp()
	local gx,gy = 5,30
	
	if (!MAIN_HELP) then 
		DrawRect(gx,gy,140,20,MCO)
		DrawText("F1 - Help/Next Page","Trebuchet18",gx+4,gy,MAIN_TEXTCOLOR)
		return 
	end
	
	DrawRect(gx,gy,256,392,MCO)
	
	gx = gx + 4
	gy = gy + 4
	
	if (MAIN_HELP == 1) then
		draw.DrawText("Bird","Trebuchet24",gx+4,gy,MAIN_TEXTCOLOR,0)
		gy = gy + 24
		
		draw.DrawText("Controls:\n\t[W] Fly/Move forward\n\t[Mouse] Steer the bird\n\t[Left Mouse] Taunt\n","Trebuchet18",gx+4,gy,MAIN_TEXTCOLOR,0)
		gy = gy + 72
		
		draw.DrawText("Purpose:"..WrapString("\n         You are a spectator. When you first join, you are assigned as a bird. To become a human you must wait until the round is over, which means you will have to wait til everyones dead.\n\nIn addition to this, the gamemode needs atleast 2 people in the server before the round can actually begin, invite a friend over!\n\nAlternativly, players can perform ritual resurrections to bring a player back to life.",240),"Trebuchet18",gx+4,gy,MAIN_TEXTCOLOR,0)
	elseif (MAIN_HELP == 2) then
		draw.DrawText("Survivor","Trebuchet24",gx+4,gy,MAIN_TEXTCOLOR,0)
		gy = gy + 24
		
		draw.DrawText("Controls:\n\t[WASD] Move around\n\t[Mouse] Aim\n\t[Left Mouse] Attack\n\t[Scroll] Select equipment\n","Trebuchet18",gx+4,gy,MAIN_TEXTCOLOR,0)
		gy = gy + 90
		
		draw.DrawText("Halo:\n","Trebuchet18",gx+4,gy,MAIN_TEXTCOLOR,0)
		gy = gy + 18
		
		draw.DrawText("\t[GREEN] \t- Hunger","Trebuchet18",gx+4,gy,MAIN_GREENCOLOR,0)
		gy = gy + 18
		
		draw.DrawText("\t[BLUE]     \t- Thirst","Trebuchet18",gx+4,gy,MAIN_BLUECOLOR,0)
		gy = gy + 18
		
		draw.DrawText("\t[YELLOW] \t- Fatigue","Trebuchet18",gx+4,gy,MAIN_YELLOWCOLOR,0)
		gy = gy + 18
		
		draw.DrawText("\t[RED]     \t- Heat","Trebuchet18",gx+4,gy,MAIN_REDCOLOR,0)
		gy = gy + 18
		
		draw.DrawText("\t[WHITE]   \t- Health","Trebuchet18",gx+4,gy,MAIN_WHITECOLOR,0)
	elseif (MAIN_HELP == 3) then
		draw.DrawText("Inventory","Trebuchet24",gx+4,gy,MAIN_TEXTCOLOR,0)
		gy = gy + 24
		
		draw.DrawText("While hovering:\n\t[Right Click] Open drop-down menu\n\t[Left Click] Start dragging item\n\t[Hover] Item info\n","Trebuchet18",gx+4,gy,MAIN_TEXTCOLOR,0)
		gy = gy + 72
		
		draw.DrawText("While dragging:\n\tDrop in a slot to equip\n\tDrop outside inventory to drop it\n","Trebuchet18",gx+4,gy,MAIN_TEXTCOLOR,0)
		gy = gy + 54
		
		draw.DrawText("Drop-down menu:\n\t[Drop] Drops the item\n\t[Use] Use/Eat the item\n","Trebuchet18",gx+4,gy,MAIN_TEXTCOLOR,0)
	elseif (MAIN_HELP == 4) then
		draw.DrawText("Recipes:","Trebuchet24",gx+4,gy,MAIN_TEXTCOLOR,0)
		gy = gy + 24
		
		surface.SetFont("Trebuchet18")
		draw.DrawText(WrapString("Combining:\n         To create an item, you drag and drop an item into the bottom of your recipes menu and then press combine. If there is a recipe corresponding to the items you placed, then a recipe will be discovered and you can select it from your recipes list to create the item.",240),"Trebuchet18",gx+4,gy,MAIN_TEXTCOLOR,0)
	elseif (MAIN_HELP == 5) then
		draw.DrawText("Credits:","Trebuchet24",gx+4,gy,MAIN_TEXTCOLOR,0)
		gy = gy + 24
		
		draw.DrawText("The Maw\nThirteen (Notes textures)","Trebuchet18",gx+4,gy,MAIN_TEXTCOLOR,0)
	end
end
