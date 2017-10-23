
ITEM.Name 		= "Tent"
ITEM.Class 		= "structure"
ITEM.Desc 		= "Something to duck under."
ITEM.Model 		= "models/props_debris/wood_board07a.mdl"
ITEM.Icon 		=  Material("settlement/icon_tent")
ITEM.Recipe		= {
	Resources = {
		["Fence"] = 4,
		["Rope"] = 2,
	},
	Tools = {
		["Crystal"] = 1,
	},
}

ITEM.Structure = {
	{
		Bone = "ValveBiped.Bip01_R_Hand",
		Model = "models/props_junk/Rock001a.mdl",
		Size = Vector(0.5,0.5,0.5),
		Pos = Vector(4,-3,-1),
		Ang = Angle(0,0,0),
	},
}

ITEM.Ghost = {
	{
		Model = "models/props_wasteland/wood_fence01a.mdl",
		Size = Vector(1,1,1),
		Pos = Vector(30,0,40),
		Ang = Angle(0,-90,45),
	},
	{
		Model = "models/props_wasteland/wood_fence01a.mdl",
		Size = Vector(1,1,1),
		Pos = Vector(-30,0,40),
		Ang = Angle(0,90,45),
	},
}

ITEM.Range 		= 300
ITEM.CD 		= 0.5

function ITEM:OnPrimary(pl,tr)
	if (CLIENT) then return end
	
	if (!pl:CanPlaceStructure(tr)) then pl:GhostStructure(self.Name) return end
	
	if (tr.Hit and tr.HitWorld) then
		local Ang = Angle(0,pl:GetAimVector():Angle().y+90,0)
		local Pos = tr.HitPos
		
		for k,v in pairs(self.Ghost) do
			local Off = v.Pos*1
			Off:Rotate(Ang)
			
			local Roa = Ang*1
								
			Roa:RotateAroundAxis(Ang:Right(),v.Ang.p)
			Roa:RotateAroundAxis(Ang:Forward(),v.Ang.r)
			Roa:RotateAroundAxis(Ang:Up(),v.Ang.y)
			
			local drop = ents.Create("ws_prop")
			drop:SetModel(v.Model)
			drop:SetAngles(Roa)
			drop:SetPos(Pos+Off)
			drop:Spawn()
			drop:Activate()
		end
		
		if (pl:HasItem(self.Name)) then pl:RemoveItem(self.Name,1)
		else pl:UnEquipWeaponSlot(pl.Select,true) end
		
		pl:GhostRemove()
	else
		pl:EmitSound(Sound("weapons/iceaxe/iceaxe_swing1.wav"),100,math.random(90,110))
	end
end