
ITEM.Name 			= "Arrow"
ITEM.Class 			= "ammo"
ITEM.Desc 			= "An arrow, used for bows."
ITEM.Model 			= "models/mixerman3d/other/arrow.mdl"
ITEM.Icon			= Material("wintersurvival2/hud/ws1_icons/icon_arrow")

ITEM.Structure = {
	{
		Bone = "ValveBiped.Bip01_R_Hand",
		Model = "models/mixerman3d/other/arrow.mdl",
		Pos = Vector(1,-1,-2.5),
		Ang = Angle(0,90,180),
	},
}

ITEM.Recipe		= {
	Resources = {
		["Rock"] = 1,
		["Feather"] = 1,
		["Sap"] = 1,
		["Wood"] = 1,
	},
	Tools = {},
}

