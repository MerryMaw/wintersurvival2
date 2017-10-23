
ITEM.Name 			= "Bow"
ITEM.Class 			= "weapon"
ITEM.Desc 			= "A primitive bow made from vine, sap, and wood."
ITEM.Model 			= "models/props_debris/wood_board02a.mdl"
ITEM.Icon 			= Material("wintersurvival2/hud/ws1_icons/icon_bow")
ITEM.HoldType		= "smg"

ITEM.Structure = {
	{
		Bone = "ValveBiped.Bip01_L_Hand",
		Model = "models/props_debris/wood_board02a.mdl",
		Size = Vector(.5,.5,.35),
		Pos = Vector(-1,-6,9),
		Ang = Angle(-30,-65,180),
	},
	{
		Bone = "ValveBiped.Bip01_L_Hand",
		Model = "models/props_debris/wood_board02a.mdl",
		Size = Vector(.5,.5,.35),
		Pos = Vector(-1,-6,-9),
		Ang = Angle(30,-65,180),
	},
	{
		Bone = "ValveBiped.Bip01_L_Hand",
		Model = "models/props_debris/wood_board02a.mdl",
		Size = Vector(.05,.05,.51),
		Pos = Vector(-3.3,-9.5,0),
		Ang = Angle(0,-65,180),
	},
}

ITEM.Recipe		= {
	Resources = {
		["Plank"] = 2,
		["Rope"] = 1,
		["Sap"] = 1,
	},
	Tools = {},
}

ITEM.CD = 1

function ITEM:OnPrimary(pl,tr)
	if (CLIENT) then return end
	if (!pl:HasItem("Arrow",1)) then return end
	
	local aim = pl:GetAimVector()
	
	local D = ents.Create("ws_arrow")
	D:SetPos(pl:GetShootPos()+aim*20)
	D:SetOwner(pl)
	D:SetAngles(aim:Angle())
	D:Spawn()
	D:GetPhysicsObject():ApplyForceCenter(aim * 10000)
	
	pl:RemoveItem("Arrow",1)
end
