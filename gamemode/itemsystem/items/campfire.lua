
ITEM.Name 		= "Campfire"
ITEM.Class 		= "structure"
ITEM.Desc 		= "Ready to be lit. Some assembly required."
ITEM.Model 		= "models/props_debris/wood_board07a.mdl"
ITEM.Icon 		=  Material("wintersurvival2/hud/ws1_icons/icon_campfire")
ITEM.Recipe		= {
	Resources = {
		["Wood"] = 4,
		["Rock"] = 1,
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
		Model = "models/props_junk/Rock001a.mdl",
		Size = Vector(1,1,1),
		Pos = Vector(0,0,0),
		Ang = Angle(0,0,0),
	},
	{
		Model = "models/props_debris/wood_board02a.mdl",
		Size = Vector(1,1,1),
		Pos = Vector(0,10,0),
		Ang = Angle(-45,90,0),
	},
	{
		Model = "models/props_debris/wood_board02a.mdl",
		Size = Vector(1,1,1),
		Pos = Vector(-10,0,0),
		Ang = Angle(-45,180,0),
	},
	{
		Model = "models/props_debris/wood_board02a.mdl",
		Size = Vector(1,1,1),
		Pos = Vector(0,-10,0),
		Ang = Angle(-45,-90,0),
	},
	{
		Model = "models/props_debris/wood_board02a.mdl",
		Size = Vector(1,1,1),
		Pos = Vector(10,0,0),
		Ang = Angle(-45,0,0),
	},
}

ITEM.Range 		= 200
ITEM.CD 		= 0.5

function ITEM:OnPrimary(pl,tr)
	if (CLIENT) then return end
	
	if (!pl:CanPlaceStructure(tr)) then pl:GhostStructure(self.Name) return end
	
	if (tr.Hit and tr.HitWorld) then
		local drop = ents.Create("ws_campfire")
		drop:SetAngles(Angle(0,pl:GetAimVector():Angle().y+90,0))
		drop:SetPos(tr.HitPos)
		drop:Spawn()
		drop:Activate()
		
		if (pl:HasItem(self.Name)) then pl:RemoveItem(self.Name,1)
		else pl:UnEquipWeaponSlot(pl.Select,true) end
		
		pl:GhostRemove()
	else
		pl:EmitSound(Sound("weapons/iceaxe/iceaxe_swing1.wav"),100,math.random(90,110))
	end
end