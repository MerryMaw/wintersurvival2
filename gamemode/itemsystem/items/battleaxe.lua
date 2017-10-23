ITEM.Name = [[Battle Axe]]
ITEM.Desc = [[The vikings once used these]]
ITEM.Model = [[models/props_junk/Rock001a.mdl]]
ITEM.Icon = Material([[wintersurvival2/hud/ws1_icons/icon_axe]])
ITEM.Structure = {
	{
		Bone="ValveBiped.Bip01_R_Hand",
		Model="models/props_debris/wood_board02a.mdl",
		Size=Vector(0.5,0.5,0.5),
		Pos=Vector(3.182,-1.76,-11.64),
		Ang=Angle(0,86.83,0),
	},
	{
		Bone="ValveBiped.Bip01_R_Hand",
		Model="models/props_junk/Rock001a.mdl",
		Size=Vector(1.18,0.06,1),
		Pos=Vector(6,-1.76,-22.94),
		Ang=Angle(0,0,0),
	},
	{
		Bone="ValveBiped.Bip01_R_Hand",
		Model="models/props_junk/Rock001a.mdl",
		Size=Vector(0.74,0.06,0.62),
		Pos=Vector(4.24,-1.75,-14.82),
		Ang=Angle(0,0,-180),
	},
}

ITEM.Recipe		= {
	Resources = {
		["Plank"] = 2,
		["Flint"] = 1,
		["Sap"] = 1,
	},
	Tools = {},
}

ITEM.HoldType	= "melee2"
ITEM.Damage 	= 70
ITEM.Range 		= 80
ITEM.CD 		= 0.9

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
		pl:EmitSound(Sound("weapons/iceaxe/iceaxe_swing1.wav"),100,math.random(60,80))
	end
end