local SCOREBOARD_FADE 	= Color(20,20,20,70)

local SCOREBOARD_OFF	= 101
local SCOREBOARD_WIDTH 	= 700
local SCOREBOARD_X 		= ScrW() / 2 - SCOREBOARD_WIDTH / 2

local DrawText = draw.DrawText

function GM:ScoreboardShow()
	self.ShowSB = true
end

function GM:ScoreboardHide()
	self.ShowSB = false
end

function GM:HUDDrawScoreBoard()
	if (!self.ShowSB) then return end
	
	local NPly 		= #player.GetAll()
	local Tall 		= SCOREBOARD_OFF + 20 * NPly
	local y 		= ScrH() / 2 - Tall / 2
	local by 		= y + SCOREBOARD_OFF

    surface.SetDrawColor(MAIN_COLOR.r,MAIN_COLOR.g,MAIN_COLOR.b,MAIN_COLOR.a);
    surface.DrawRect(SCOREBOARD_X, y, SCOREBOARD_WIDTH, Tall, MAIN_COLOR)

    surface.SetDrawColor(MAIN_COLORD.r,MAIN_COLORD.g,MAIN_COLORD.b,MAIN_COLORD.a);
    surface.DrawRect(SCOREBOARD_X, by, SCOREBOARD_WIDTH, NPly*20)
	
	DrawText(self.Name, "ScoreboardFont", ScrW()/2, y + 50, MAIN_TEXTCOLOR,1)
	DrawText("By The Maw", "Trebuchet18", ScrW()/2-150, y + 80, MAIN_TEXTCOLOR,1)
	
	for k,v in pairs( player.GetAll() ) do
		local Y = by + 20 * (k-1)
		
		if (v:IsPigeon()) then
			DrawText(v:Nick(), "Trebuchet18", SCOREBOARD_X + 2, Y, MAIN_GREYCOLOR)
			DrawText(v:Ping(), "Trebuchet18", SCOREBOARD_X + SCOREBOARD_WIDTH - 30, Y, MAIN_GREYCOLOR)
		else
			DrawText(v:Nick(), "Trebuchet18", SCOREBOARD_X + 2, Y, MAIN_TEXTCOLOR)
			DrawText(v:Ping(), "Trebuchet18", SCOREBOARD_X + SCOREBOARD_WIDTH - 30, Y, MAIN_TEXTCOLOR)
		end
	end
end

