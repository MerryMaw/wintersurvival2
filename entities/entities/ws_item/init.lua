AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:Initialize()
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self:PhysWake()
	self:SetUseType(SIMPLE_USE)
	
	if (!self.Item) then self:Remove() end
end

function ENT:Use(pl)
	if (pl:IsPigeon()) then return end
	pl:AddItem(self.Item.Name,1)
	
	self:Remove()
end
