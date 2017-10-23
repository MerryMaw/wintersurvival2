AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include('shared.lua')

local ResurrectionTable = {
	["Meat"] = 25,
	["Berry"] = 30,
	["Feather"] = 10,
}

function ENT:Initialize()
	self:SetModel("models/props_junk/wood_crate001a.mdl")
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

function ENT:Think()
	local HasItems = {}
	
	for k,v in pairs(self.StoredItems) do
		if (ResurrectionTable[v.Name] and v.Quantity >= ResurrectionTable[v.Name]) then
			HasItems[v.Name] = {k,ResurrectionTable[v.Name]}
		end
	end
	
	if (table.Count(HasItems) >= table.Count(ResurrectionTable)) then
		for k,v in pairs(player.GetAll()) do
			if (v:IsPigeon() and v:Alive() and v:GetPos():Distance(self:GetPos()) < 200) then
				v:SetHuman(true)
				v:KillSilent()
				v:ChatPrint("You have been resurrected from the dead!")
				self:EmitSound("wintersurvival2/ritual/wololo.mp3")
				
				for a,b in pairs(HasItems) do
					if (self.StoredItems[b[1]].Quantity == b[2]) then table.remove(self.StoredItems,b[1])
					else self.StoredItems[b[1]].Quantity = self.StoredItems[b[1]].Quantity-b[2] end
				end
				
				v:Spawn()
				
				break
			end
		end
	end
	
	self:NextThink(CurTime()+10)
	return true
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