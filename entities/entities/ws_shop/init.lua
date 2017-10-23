AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:Initialize()
	self:SetModel("models/props_junk/wood_crate001a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	
	local phys = self:GetPhysicsObject()
	phys:EnableMotion(false)
	phys:Sleep()
end

