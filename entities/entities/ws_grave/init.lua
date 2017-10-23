AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:Initialize()
	self:SetModel("models/props_c17/gravestone002a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	
	local phys = self:GetPhysicsObject()
	phys:EnableMotion(false)
	phys:Sleep()
	
	self:SetHealth(30)
	
	self.StoredItems = {}
end

function ENT:AddItem(item,quantity)
	for k,v in pairs(self.StoredItems) do
		if (v.Name == item) then
			v.Quantity = v.Quantity + quantity
			return
		end
	end
	
	table.insert(self.StoredItems,{Name = item, Quantity = quantity})
end

function ENT:TakeItem(pl,item,quantity)
	for k,v in pairs(self.StoredItems) do
		if (v.Name == item) then
			quantity = math.min(quantity,v.Quantity)
			v.Quantity = v.Quantity - quantity
			
			pl:AddItem(item,quantity)
			
			if (v.Quantity <= 0) then table.remove(self.StoredItems,k) end
			break
		end
	end
end

function ENT:GetItems()
	return self.StoredItems
end

function ENT:Use(pl)
	if (pl:IsPigeon()) then return end
	OpenLootventory(pl,self.StoredItems,self)
end

function ENT:OnTakeDamage(dmg)
	self:SetHealth(self:Health()-dmg)
	
	if (self:Health() <= 0) then self:Remove() end
end
