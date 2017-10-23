
ITEM.Name 			= "Crystal Axe"
ITEM.Class 			= "weapon"
ITEM.Desc 			= "A more advanced axe made from crystals."
ITEM.Model 			= "models/props_debris/wood_board02a.mdl"
ITEM.Icon 			= Material("wintersurvival2/hud/ws1_icons/icon_axe")

ITEM.Structure = {
	{
		Bone = "ValveBiped.Bip01_R_Hand",
		Model = "models/props_combine/breenlight.mdl",
		Size = Vector(0.1,0.5,1),
		Pos = Vector(3,-4,-27),
		Ang = Angle(0,0,0),
	},
	{
		Bone = "ValveBiped.Bip01_R_Hand",
		Model = "models/props_debris/wood_board02a.mdl",
		Size = Vector(0.5,0.5,0.5),
		Pos = Vector(3,-1.5,-12),
		Ang = Angle(0,0,0),
	},
}

ITEM.Recipe		= {
	Resources = {
		["Log"] = 1,
		["Crystal"] = 1,
		["Rope"] = 1,
		["Vine"] = 1,
	},
	Tools = {
		["Crystal Hammer"] = 1,
	},
}



ITEM.Damage 	= 30
ITEM.Range 		= 64
ITEM.CD 		= 0.4

function ITEM:OnPrimary(pl,tr)
	if (CLIENT) then return end
	
	if (tr.Hit) then
		if (IsValid(tr.Entity)) then
			local ent = tr.Entity
			local class = ent:GetClass()
			
			if (class == "player" or class:find("npc_") or class == "ws_pigeon" or class == "ws_prop") then
				ent:TakeDamage(self.Damage,pl)
				
				if (class == "ws_prop") then pl:EmitSound(Sound("physics/wood/wood_plank_impact_hard"..math.random(1,3)..".wav"),100,math.random(90,110))
				else pl:EmitSound(Sound("physics/flesh/flesh_impact_hard"..math.random(1,6)..".wav"),100,math.random(90,110)) end
			elseif (ent:IsTree()) then
				if (math.random(1,35)/10 < 2) then pl:AddItem("Wood",1) end
				if (math.random(1,90)/10 < 1) then pl:AddItem("Ancient Wood",1) end
				
				pl:EmitSound(Sound("physics/concrete/rock_impact_hard"..math.random(1,6)..".wav"),100,math.random(90,110))
			else
				pl:EmitSound(Sound("physics/surfaces/sand_impact_bullet"..math.random(1,4)..".wav"),100,math.random(90,110))
			end
		else
			pl:EmitSound(Sound("physics/surfaces/sand_impact_bullet"..math.random(1,4)..".wav"),100,math.random(90,110))
		end
	else
		pl:EmitSound(Sound("weapons/iceaxe/iceaxe_swing1.wav"),100,math.random(90,110))
	end
end
