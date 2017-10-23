AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include('shared.lua')

local Ab = Color(255,255,255,100)

function ENT:Initialize()
	self:SetModel("models/mixerman3d/other/arrow.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE)
	self:PhysWake()
	self:SetUseType(SIMPLE_USE)
	
	util.SpriteTrail( self, 0, Ab, true, 1, 0, 1, 1, "sprites/smoke_trail.vmt" )
	
	self:NextThink(CurTime()+10)
end

function ENT:Think()
	self:Remove()
	return true
end


