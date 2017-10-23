
ITEM.Name 		= "Alter"
ITEM.Class 		= "structure"
ITEM.Desc 		= "This allows you to sacrifice your soul for a player."
ITEM.Model 		= "models/props_c17/gravestone003a.mdl"
ITEM.Icon 		=  Material("wintersurvival2/hud/ws2_icons/icon_crow.png")
ITEM.Recipe		= {
	Resources = {
		["Ancient Log"] = 20,
		["Plank"] = 16,
		["Rope"] = 16,
		["Sap"] = 30,
	},
	Tools = {
		["Diamond Hammer"] = 1,
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
		Model = "models/props_c17/gravestone003a.mdl",
		Size = Vector(8,1,1),
		Pos = Vector(22,0,0),
		Ang = Angle(90,0,0),
	},
	{
		Model = "models/props_c17/gravestone003a.mdl",
		Size = Vector(8,1,1),
		Pos = Vector(-22,0,0),
		Ang = Angle(-90,0,0),
	},
}

ITEM.Range 		= 200
ITEM.CD 		= 0.5

function ITEM:OnPrimary(pl,tr)
	if (CLIENT) then return end
	
	if (!pl:CanPlaceStructure(tr)) then pl:GhostStructure(self.Name) return end
	
	if (tr.Hit and tr.HitWorld) then
		local drop = ents.Create("ws_alter")
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