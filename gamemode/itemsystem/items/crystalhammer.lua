
ITEM.Name 			= "Crystal Hammer"
ITEM.Class 			= "resource"
ITEM.Desc 			= "A tool used for crystal equipment"
ITEM.Model 			= "models/props_combine/breenlight.mdl"
ITEM.Icon			= Material("wintersurvival2/hud/ws1_icons/icon_crystal")

ITEM.Structure = {
	{
		Bone = "ValveBiped.Bip01_R_Hand",
		Model = "models/props_combine/breenlight.mdl",
		Size = Vector(0.5,0.5,0.5),
		Pos = Vector(4,-3,-1),
		Ang = Angle(0,0,0),
	},
}

ITEM.Recipe		= {
	Resources = {
		["Crystal"] = 8,
		["Sap"] = 4,
	},
	Tools = {},
}
