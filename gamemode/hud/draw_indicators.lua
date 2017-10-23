
local x,y  = ScrW()/2,ScrH()-140
local cos = math.cos

function DrawIndicators()	
	local pl = LocalPlayer()
	if (pl:IsPigeon()) then return end
	
	local HP 	= pl:Health()
	local HP_c 	= 1-math.max(0,HP/100)
	local A		= MAIN_WHITECOLOR.a*1
	
	--1 == Hunger
	--2 == Thirst
	--3 == Heat
	--4 == Fatigue
	
	local Cur 	= UnPredictedCurTime()*0.1%1*360
	local Time 	= (cos(Cur)+1)/2
	local CUR   = (cos(UnPredictedCurTime())+1)/2
	
	for i = 1,4 do
		local Col = MAIN_GREENCOLOR
		local Siz = 4
		
		if (i == 1) then 		Col = MAIN_GREENCOLOR Siz=Siz+30*math.Clamp(pl:GetHunger()/100,0,1)
		elseif (i == 2) then 	Col = MAIN_BLUECOLOR Siz=Siz+30*math.Clamp(pl:GetWater()/100,0,1)
		elseif (i == 3) then 	Col = MAIN_REDCOLOR Siz=Siz+30*math.Clamp(pl:GetHeat()/100,0,1)
		else 					Col = MAIN_YELLOWCOLOR Siz=Siz+30*math.Clamp(pl:GetFatigue()/100,0,1)
		end
		
		local AB = Col.a*1
		Col.a = 200+50*CUR
		
		DrawOutlinedCircle(x,y,Siz,8,Cur+90*i,90,8,Col)
		
		Col.a = AB
	end
	
	--HP 
	local Time 	= 255-(255*HP_c)*(cos(UnPredictedCurTime()*(1+10*HP_c))+1)/2
	MAIN_WHITECOLOR.r = Time
	MAIN_WHITECOLOR.g = Time
	MAIN_WHITECOLOR.b = Time
	
	DrawOutlinedCircle(x,y,40,8,Cur,360,32,MAIN_WHITECOLOR)
	
	MAIN_WHITECOLOR.r = 255
	MAIN_WHITECOLOR.g = 255
	MAIN_WHITECOLOR.b = 255
	
	local Time2 = (cos(UnPredictedCurTime()*2*(1+3*HP_c))+1)/2
	local Alpha = math.max(0,50-90*Time2)
	
	MAIN_WHITECOLOR.a = Alpha
	
	DrawOutlinedCircle(x,y,40+200*Time2,8,Cur*30,360,32,MAIN_WHITECOLOR)
	
	MAIN_WHITECOLOR.a = 255
end