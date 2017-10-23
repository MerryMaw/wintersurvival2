
ITEM.Name 			= "Sword"
ITEM.Class 			= "weapon"
ITEM.Desc 			= "A sword for combat."
ITEM.Model 			= "models/weapons/w_archersword/w_archersword.mdl"
ITEM.Icon 			= Material("wintersurvival2/hud/ws2_icons/icon_sword.png")

ITEM.Structure = {
	{
		Bone = "ValveBiped.Bip01_R_Hand",
		Model = "models/weapons/w_archersword/w_archersword.mdl",
		Size = Vector(1,1,1),
		Pos = Vector(3,-1,0),
		Ang = Angle(0,0,-90),
	},
}

ITEM.Recipe		= {
	Resources = {
		["Wood"] = 1,
		["Crystal"] = 1,
		["Sap"] = 1,
	},
	Tools = {},
}



ITEM.Damage 	= 60
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
