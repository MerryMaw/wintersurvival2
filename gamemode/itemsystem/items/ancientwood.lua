
ITEM.Name 			= "Ancient Wood"
ITEM.Class 			= "weapon"
ITEM.Desc 			= "A stronger type of wood.\nUsed for advanced equipment."
ITEM.Model 			= "models/gibs/furniture_gibs/furniturewooddrawer003a_chunk04.mdl"
ITEM.Icon 			= Material("wintersurvival2/hud/ws2_icons/icon_ancientwood.png")

ITEM.Structure = {
	{
		Bone = "ValveBiped.Bip01_R_Hand",
		Model = "models/gibs/furniture_gibs/furniturewooddrawer003a_chunk04.mdl",
		Size = Vector(.5,.5,.5),
		Pos = Vector(3,-1.5,-12),
		Ang = Angle(0,0,0),
	},
}

ITEM.Damage = 5
ITEM.Range = 60
ITEM.CD = 0.6

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
			elseif (ent:GetModel():find("tree")) then
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

function ITEM:OnSecondary(pl,tr)
	if (CLIENT) then return end
	if (!pl:HasItem(self.Name)) then return end
	
	local drop = SpawnWSItem(self.Name,pl:GetShootPos()+pl:GetAimVector()*20)
	drop:GetPhysicsObject():ApplyForceCenter(pl:GetAimVector() * 200)
		
	pl:RemoveItem(self.Name,1)
		
	pl:EmitSound(Sound("weapons/iceaxe/iceaxe_swing1.wav"),100,math.random(40,60))
end


