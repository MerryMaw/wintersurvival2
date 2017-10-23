include('shared.lua')

//Some of this code originated from Termy and Night Eagle. Might aswell reuse some of it and fix the best of it.

function ENT:Initialize()
	self.Cycle 		= 0
	self.lastdraw 	= UnPredictedCurTime()
	self.Player 	= NULL
	self.Seq 		= -1
	self.Rate		= 1
	
	self.AutomaticFrameAdvance = true 
	
	timer.Simple(0.5,function() if (IsValid(self)) then self:InitializeOwner() end end)
end

function ENT:InitializeOwner()
	for k,v in pairs(player.GetAll()) do
		if (IsValid(v.Pigeon) and v.Pigeon == self) then self.Player = v v.DeathPos = nil return end
	end
	
	timer.Simple(0.5,function() if (IsValid(self)) then self:InitializeOwner() end end)
end

function ENT:OnRemove()
	if (IsValid(self.Player)) then
		self.Player.DeathPos = self:GetPos() 
		local Rag = self:BecomeRagdollOnClient( )
		local Phy = Rag:GetPhysicsObject()
		Phy:ApplyForceCenter(self:GetVelocity()*Phy:GetMass()*12)
		timer.Simple(3,function() if (IsValid(Rag)) then Rag:Remove() end end)
	end
end

function ENT:Think()
	local Pos 	= self:GetPos()
	local vel 	= self:GetVelocity()
	local velL 	= vel:Length()
	
	local tr = util.TraceLine({
		start = Pos,
		endpos = Pos - Vector(0,0,12),
		filter = self,
	})
	
	local ground 	= tr.Hit
	
	if (velL < 16 and !ground) then
		self.Seq = 0
		self.Rate = 0.7
		
	elseif (ground) then
		if (velL > 30) then
			self.Rate = 2
			self.Seq = 3
		elseif (velL > 7) then
			self.Rate = 1
			self.Seq = 2
		else
			self.Seq = 1
			self.Rate = .1
		end
	elseif (vel.z > 2) then
		self.Seq = 0
	elseif (velL < 16 and ground) then
	else
		self.Seq = 7
	end
	
	if (self:GetSequence() != self.Seq) then self:SetSequence(self.Seq) end 
	
	local delta = UnPredictedCurTime()-self.lastdraw
	self.lastdraw = UnPredictedCurTime()
	
	self.Cycle = self.Cycle + delta*self.Rate
	if (self.Cycle > 1) then self.Cycle = 0 end
	
	self:SetCycle(self.Cycle)
end

function ENT:Draw()
	if (!IsValid(self.Player)) then return end
	
	self:DrawModel()
end