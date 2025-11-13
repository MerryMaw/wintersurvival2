
include( "shared.lua" )

function GM:Initialize()
	self.KnownRecipes = {
		GetItemByName("Axe"),
		GetItemByName("Campfire"),
		GetItemByName("Pickaxe"),
	}

    self:AddBlockCHud("CHudHealth");
    self:AddBlockCHud("CHudBattery");
end

function GM:Think()
end