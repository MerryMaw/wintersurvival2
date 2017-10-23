local VoiceEna 	= true
local VOCOL	 	= table.Copy(MAIN_COLOR)
local x,y 		= ScrW(),ScrH()

function GM:PlayerStartVoice( ply )
	ply.Talking = true
end

function GM:PlayerEndVoice( ply )
	ply.Talking = nil
end

hook.Add("HUDPaint","_VoiceChatDraw",function()
	local D = 0

	for k,v in pairs( player.GetAll() ) do
		if (v.Talking) then
			local H = 45*D
			D = D+1
			
			local V = v:VoiceVolume()
			local D = MAIN_COLOR
			
			VOCOL.r = math.Clamp(D.r-100*V,0,255)
			VOCOL.g = math.Clamp(D.g+200*V,0,255)
			VOCOL.b = math.Clamp(D.b-100*V,0,255)
			
			DrawRect( x-250, y-170-H, 200, 40, VOCOL )
			DrawRect( x-246, y-166-H, 32, 32, MAIN_WHITECOLOR )
			DrawText( v:Nick(), "Trebuchet18", x-206, y-159-H, MAIN_TEXTCOLOR )
		end
	end
end)