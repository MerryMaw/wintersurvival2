
ITEM.Name 		= "Plank"
ITEM.Class 		= "resource"
ITEM.Desc 		= "Advanced wood material."
ITEM.Model 		= "models/props_debris/wood_board06a.mdl"
ITEM.Icon 		=  Material("wintersurvival2/hud/ws1_icons/icon_plank")
ITEM.Recipe		= {
	Resources = {
		["Wood"] = 2,
		["Sap"] = 1,
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