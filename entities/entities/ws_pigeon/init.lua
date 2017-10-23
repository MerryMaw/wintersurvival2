AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include('shared.lua')

local bo,ao = Vector(-3,-3,-1),Vector(3,3,3)
local up	= Vector(0,0,1)
local zero  = Vector(0,0,0)

function ENT:OnRemove()
end

function ENT:KeyValue(key,value)
end

function ENT:Initialize()
	self:SetModel("models/crow.mdl")
	self:PhysicsInitBox(bo,ao)
	self:SetMoveCollide(MOVECOLLIDE_FLY_SLIDE)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	
	self.ShadowParams = {}
	self.ShadowParams.secondstoarrive 	= 0.1
	self.ShadowParams.angle				= Angle(0,0,0)
	self.ShadowParams.maxangular 		= 5000
	self.ShadowParams.maxangulardamp 	= 10000 
	self.ShadowParams.maxspeed 			= 1000000
	self.ShadowParams.maxspeeddamp 		= 10000
	self.ShadowParams.dampfactor 		= 0.8
	self.ShadowParams.teleportdistance 	= 0
	
	self.IsMoving = false
	self.Dir 	  = Vector(1,0,0)
	self.Phys	  = self:GetPhysicsObject()
	self.Speed	  = 0
	self.Up		  = zero
	self.Caw	  = CurTime()
	self.Yaw 	  = 0
	
	self.Phys:EnableMotion(false)
	self.Phys:Sleep()
end

function ENT:SetPlayer(pl)
	self.Player = pl
end

function ENT:OnRemove()
	if (IsValid(self.Player)) then
		self.Player:KillSilent()
		self:EmitSound("npc/crow/die"..math.random(1,2)..".wav")
		
		if (math.random(1,2) == 1) then SpawnWSItem("Meat",self:GetPos())
		else SpawnWSItem("Feather",self:GetPos()) end
	end
end

function ENT:OnTakeDamage(dmg)
	if (IsValid(self.Player)) then
		self.Player:KillSilent()
		self:Remove()
	end
end

function ENT:OnTheGround()
	local Pos 	= self:GetPos()
	local tr 	= util.TraceLine({
		start 	= Pos,
		endpos 	= Pos - Vector(0,0,5),
		filter 	= self,
	})
	
	return tr.Hit,tr.HitNormal
end

function ENT:Think()
	if (IsValid(self.Player) and self.Player:Alive() and self.Player:IsPigeon()) then
		local pl 	= self.Player
		local For 	= self:GetForward()
		local Jump  = pl:KeyDown(IN_JUMP)
		
		if (pl:KeyDown(IN_FORWARD) or Jump) then
			if (!self.IsMoving) then 
				self.IsMoving = true 
				self.Phys:EnableMotion(true)
				self.Phys:Wake() 
				self:StartMotionController() 
			end
		
			self.Speed = self.Speed+(300-self.Speed)/16
			
			if (Jump) then self.Up = up end
		elseif (self.Speed < 0.01 and self.Dir:DotProduct(For) > 0.9) then
			if (self.IsMoving) then 
				self.IsMoving = false 
				self.Phys:EnableMotion(false)
				self.Phys:Sleep() 
				self:StopMotionController() 
			end
		else
			self.Speed = self.Speed-self.Speed/4
		end
		
		if (!Jump and self.Up) then self.Up = zero end
		
		if (self.Speed > 1) then 
			self.Dir = pl:GetAimVector()
			self.Yaw = self.Dir:Angle().y
			
			if (!self.IsMoving and self.Dir:DotProduct(For) < 0.9) then
				self.IsMoving = true 
				self.Phys:EnableMotion(true)
				self.Phys:Wake() 
				self:StartMotionController() 
			end
		end
		
		if (pl:KeyDown(IN_ATTACK) and self.Caw < CurTime()) then
			self:EmitSound("npc/crow/idle"..math.random(1,3)..".wav")
			self.Caw = CurTime()+1.5
		end
		
		if (self.Speed > 0.01) then 
			if (!self.PLTimer or self.PLTimer < CurTime()) then pl:SetPos(self:GetPos()) self.PLTimer = CurTime()+1 end
			
			local Hit,Norm = self:OnTheGround()
			
			if (Hit) then 
				self.Speed = math.min(5,self.Speed) 
				
				if (pl:KeyDown(IN_SPEED)) then self.Speed = self.Speed*5 end
				
				local ang 	= self.Dir:Angle()
				local an2 	= Norm:Angle()
				local avel 	= an2:Right():Angle()
				local rot 	= self.Yaw-avel.y
				
				avel:RotateAroundAxis(an2:Forward(),rot)
				vel = avel:Forward()
				
				self.Dir = vel
			end
		end
	else
		self:Remove()
	end
	
	self.Entity:NextThink(CurTime()+0.01)
	return true
end

function ENT:PhysicsSimulate( phys, deltatime )
 
	phys:Wake()
	
	self.ShadowParams.angle = self.Dir:Angle()
	self.ShadowParams.pos = self:GetPos() + (self.Dir+self.Up)*self.Speed/8
	
	phys:ComputeShadowControl(self.ShadowParams)
 
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end
