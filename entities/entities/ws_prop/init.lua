AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:Initialize()
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	self:DrawShadow(false)
	
	local phys = self:GetPhysicsObject()
	phys:EnableMotion(false)
	phys:Sleep()
	
	self:SetHealth(30)
	
	self.HP = 500
end

function ENT:OnTakeDamage(dmginfo)
	self.HP = self.HP-dmginfo:GetDamage()
	
	if (self.HP <= 0) then 
		self:EmitSound(Sound("physics/wood/wood_plank_break"..math.random(1,4)..".wav"))
		self:Remove() 
	end
end
