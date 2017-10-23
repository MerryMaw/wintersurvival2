
include( "shared.lua" )

function GM:Initialize()
	self:SetEnableMawCircle(false)
	self:EnableMOTD(false)
	self:SetEnableMawNameTag(false)
	self:SetEnableMawChat(false)
	self:SetEnableThirdPerson(false)
	
	self.KnownRecipes = {
		GetItemByName("Axe"),
		GetItemByName("Campfire"),
		GetItemByName("Pickaxe"),
	}
end

function GM:Think()
end