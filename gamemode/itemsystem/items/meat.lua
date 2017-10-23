
ITEM.Name 			= "Meat"
ITEM.Class 			= "food"
ITEM.Desc 			= "Delicious..."
ITEM.Model 			= "models/Weapons/w_bugbait.mdl"
ITEM.Icon			= Material("wintersurvival2/hud/ws1_icons/icon_bugbait")

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
	
	user:SetHealth(math.min(100,user:Health()+10))
	user:AddHunger(-30)
	user:RemoveItem(self.Name,1)
end

function ITEM:OnCooked(campfire)
	campfire:AddItem("Cooked Meat",1)
end