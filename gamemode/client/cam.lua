local Off = Vector(0,0,10)

OverrideDefaultGFCamera(function(ply, origin, angles, fov)
	local Bg = ply:GetRagdollEntity()
		
	if (IsValid(Bg)) then
		local view = {
			origin = Bg:GetPos()-angles:Forward()*80+Off,
			angles = angles,
		}
		
		return view
	else
		local Pig = ply:GetPigeon()
		
		if (IsValid(Pig)) then
			local view = {
				origin = Pig:GetPos()-angles:Forward()*80+Off,
				angles = angles,
			}
			
			return view
		elseif (!ply:Alive() and ply.DeathPos) then
			local view = {
				origin = ply.DeathPos-angles:Forward()*80+Off,
				angles = angles,
			}
			
			return view
		end
	end 
end)