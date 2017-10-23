include('shared.lua')

local Col = Color(0,0,0,150)

function ENT:Draw()
	self:DrawModel()
	
	cam.Start3D2D(self:GetPos()+self:GetUp()*50,Angle(0,CurTime()*40,90),0.3)
		DrawRect(-100,0,200,20,Col)
		DrawText("Shop (To be announced!)","Trebuchet18",0,10,MAIN_TEXTCOLOR,1)
	cam.End3D2D()
end
