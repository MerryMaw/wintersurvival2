local rad = math.rad
local cos = math.cos
local sin = math.sin
local abs = math.abs

function DrawOutlinedCircle(x,y,r,s,ang,dang,iter,color)
	ang 	= rad(ang)
	dang 	= rad(dang)
	iter 	= iter or 8
	
	local step = abs(dang)/iter
	
	surface.SetDrawColor(color.r,color.g,color.b,color.a)
	
	for i = 0, iter-1 do
		local r2 = r + s
		local Time1 = step*i+ang
		local Time2 = Time1+step
		local dat 	= {
			{
				x=cos(Time2)*r+x,
				y=-sin(Time2)*r+y,
				u=0,
				v=0,
			},
			{
				x=cos(Time2)*r2+x,
				y=-sin(Time2)*r2+y,
				u=1,
				v=0,
			},
			{
				x=cos(Time1)*r2+x,
				y=-sin(Time1)*r2+y,
				u=1,
				v=1,
			},
			{
				x=cos(Time1)*r+x,
				y=-sin(Time1)*r+y,
				u=0,
				v=1,
			},
		}
		
		surface.DrawPoly(dat)
	end
end