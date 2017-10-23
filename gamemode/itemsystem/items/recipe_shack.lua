
ITEM.Name 			= "Recipe: Shack"
ITEM.Class 			= "account"
ITEM.Desc 			= "A recipe for the shack. Use it to print it on chat!"
ITEM.Model 			= "models/Weapons/w_bugbait.mdl"
ITEM.Icon			= Material("wintersurvival2/hud/ws2_icons/icon_recipe.png")

function ITEM:OnUse(user)
	if (CLIENT) then return end
	
	local rec,item = GetRecipeForItem("Shack")
	local txt = "Recipe: "
	
	txt = txt.." RESOURCES("
	for a,b in pairs(rec.Resources) do
		txt=txt..b.." x "..a..", "
	end
	txt = txt..")"
	
	txt = txt.." TOOLS("
	for a,b in pairs(rec.Tools) do
		txt=txt..b.." x "..a..", "
	end
	txt = txt..")"
			
	user:ChatPrint(txt)
end