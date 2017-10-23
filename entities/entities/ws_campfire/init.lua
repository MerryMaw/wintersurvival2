AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize()
	self:SetModel("models/props_junk/Rock001a.mdl")
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetCollisionGroup( COLLISION_GROUP_INTERACTIVE )
	self:SetUseType(SIMPLE_USE)
	
	local phys = self:GetPhysicsObject()
	
	phys:EnableMotion(false)
	phys:Sleep()
	
	self.StoredItems = {}
end

function ENT:BeginCooking(item)
end

function ENT:Think()
	for k,v in pairs(player.GetAllHumans()) do
		if (v:GetPos():Distance(self:GetPos()) < 500) then
			v:AddHeat(-5)
		end
	end
	
	for k,v in pairs(self.StoredItems) do
		if (v.Timer < CurTime()-13) then
			if (GetItemByName(v.Name).OnCooked) then
				GetItemByName(v.Name):OnCooked(self)
			end
			
			if (v.Quantity > 1) then
				v.Quantity = v.Quantity - 1
			else
				table.remove(self.StoredItems,k)
			end
			
			self:EmitSound("ambient/fire/mtov_flame2.wav",100,math.random(80,100))
			
			v.Timer = CurTime()+13
		end
	end
	
	self:NextThink(CurTime()+1)
	return true
end

function ENT:AddItem(item,quantity)
	for k,v in pairs(self.StoredItems) do
		if (v.Name == item) then
			v.Quantity = v.Quantity + quantity
			return
		end
	end
	
	table.insert(self.StoredItems,{Name = item, Quantity = quantity, Timer = CurTime(),})
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

function ENT:PhysicsCollide( data, physobj )
	
end 
