
ITEM.Name 			= "Juice"
ITEM.Class 			= "food"
ITEM.Desc 			= "Restores some thirst."
ITEM.Model 			= "models/props_junk/Rock001a.mdl"
ITEM.Icon			= Material("wintersurvival2/hud/ws1_icons/icon_beer")

ITEM.Recipe		= {
	Resources = {
		["Berry"] = 3,
		["Log"] = 1,
	},
	Tools = {},
}

function ITEM:OnUse(user)
	if (CLIENT) then return end
	
	user:SetWater(0)
	user:RemoveItem(self.Name,1)
end
