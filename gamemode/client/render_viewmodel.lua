
local Zero = Vector(1,1,1)

function GM:PreDrawViewModel()
	local pl 	= LocalPlayer()
	local Wep 	= pl:GetActiveWeapon()
	
	if (!pl:IsPigeon() and IsValid(Wep)) then return true end
	return false
end

function GM:PostDrawOpaqueRenderables()
	local pl  	= LocalPlayer()
	local Wep 	= pl:GetActiveWeapon()
	
	if (pl:IsPigeon() or !IsValid(Wep)) then return end
	if (!pl.Weapons or !pl.Weapons[pl.Select]) then return end
	
	local Ent 	= Wep.MOB
	local item 	= pl.Weapons[pl.Select].Item

	for k,v in pairs(item.Structure) do
		local ID 		= pl:LookupBone(v.Bone)
		local Pos,Ang 	= pl:GetBonePosition(ID)
		
		local Rop = v.Pos*1
		local Roa = Ang*1
		
		Roa:RotateAroundAxis(Ang:Right(),v.Ang.p)
		Roa:RotateAroundAxis(Ang:Forward(),v.Ang.r)
		Roa:RotateAroundAxis(Ang:Up(),v.Ang.y)
		
		Rop:Rotate(Ang)
		
		Ent:SetModel(v.Model)
		Ent:SetRenderOrigin(Pos+Rop)
		Ent:SetRenderAngles(Roa)
		
		local mat 	= Matrix()
		mat:Scale( v.Size or Zero )
		
		Ent:EnableMatrix( "RenderMultiply", mat )
		Ent:SetupBones()
		
		Ent:DrawModel()
	end
end


