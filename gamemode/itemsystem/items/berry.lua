
ITEM.Name 			= "Berry"
ITEM.Class 			= "food"
ITEM.Desc 			= "Berries..."
ITEM.Model 			= "models/Weapons/w_bugbait.mdl"
ITEM.Icon			= Material("settlement/icon_berries")

ITEM.Structure = {
	{
		Bone = "ValveBiped.Bip01_R_Hand",
		Model = "models/Weapons/w_bugbait.mdl",
		Size = Vector(0.5,0.5,0.5),
		Pos = Vector(4,-3,-1),
		Ang = Angle(0,0,0),
	},
}

function ITEM:OnUse(user)
	if (CLIENT) then return end
	
	user:SetHealth(math.min(100,user:Health()+5))
	user:AddHunger(-25)
	user:RemoveItem(self.Name,1)
end