
--An antlion NPC using the power of nextbot!
--By The Maw
--This script was primarily for AwesomeX so he can edit the shit out of it!

AddCSLuaFile()

ENT.Base 			= "ws_npc_base"

function ENT:PreInitialize()
	self:SetupNextbot({
		runspeed 	= 300,
		walkspeed 	= 80,
		searchrange = 1000,
		looserange 	= 5000,
		jumpheight	= 200,
		health		= 30,
		model		= "models/antlion.mdl",
	})
end

function ENT:OnChase()
	if (self:EnemyRange() < 100 and self:CanSeeEnemy()) then
		local A = self:GetEnemy()
		A:TakeDamage(10,self)
		A:SetVelocity((A:GetShootPos()-self:GetPos()):GetNormal()*100)
		
		if (A:Health() <= 0) then self:SetEnemy(nil) end
		
		self:StartActivity(ACT_MELEE_ATTACK1)
		coroutine.wait(1)
		self:StartActivity( ACT_RUN )
	end
	
end

function ENT:OnMovePos()
	self:ScanEnemy()
	return self:HaveEnemy()
end

function ENT:OnKilled( dmginfo )
	hook.Call( "OnNPCKilled", GAMEMODE, self, dmginfo:GetAttacker(), dmginfo:GetInflictor() )
	self:BecomeRagdoll( dmginfo )
	SpawnWSItem("Meat",self:GetPos())
end