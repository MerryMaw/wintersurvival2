function DrawTargets()
	local pl = LocalPlayer()
	
	if (pl:IsPigeon()) then return end
	
	local tr = pl:GetEyeTrace()
	
	if (IsValid(tr.Entity) and tr.Entity:IsPlayer()) then
		DrawText(tr.Entity:Nick(),"ChatFont",ScrW()/2,ScrH()/2,MAIN_YELLOWCOLOR,1)
	end
end