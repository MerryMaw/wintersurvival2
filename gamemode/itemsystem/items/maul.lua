ITEM.Name	= [[Maul]]
ITEM.Desc	= [[The ultimate nutcracker!]]
ITEM.Model	= [[models/props_debris/wood_board02a.mdl]]
ITEM.Icon	= Material([[wintersurvival2/hud/ws2_icons/icon_sword.png]])
ITEM.HoldType	= [[melee2]]
ITEM.Structure	= {
	{
		Bone	="ValveBiped.Bip01_R_Hand",
		Model	="models/props_debris/wood_board02a.mdl",
		Size	=Vector(0.5,0.5,0.5),
		Pos	=Vector(3.8900001049042,-2.1099998950958,-11.640000343323),
		Ang	=Angle(0,74.120002746582,0),
	},
	{
		Bone	="ValveBiped.Bip01_R_Hand",
		Model	="models/props_debris/wood_board02a.mdl",
		Size	=Vector(2.2999999523163,1.7999999523163,0.15000000596046),
		Pos	=Vector(3.8900001049042,-2.1099998950958,-22.579999923706),
		Ang	=Angle(0,78.360000610352,91.059997558594),
	},
}

ITEM.Recipe		= {
	Resources = {
		["Plank"] = 4,
		["Log"] = 1,
		["Sap"] = 1,
	},
	Tools = {},
}

ITEM.Damage 	= 70
ITEM.Range 		= 80
ITEM.CD 		= 1

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
		pl:EmitSound(Sound("weapons/iceaxe/iceaxe_swing1.wav"),100,math.random(50,60))
	end
end