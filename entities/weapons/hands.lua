AddCSLuaFile("hands.lua")

SWEP.ViewModel				= "models/error.mdl"
SWEP.WorldModel				= "models/error.mdl"

SWEP.HoldType 				= "normal"

SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = true
SWEP.Primary.Ammo           = "none"

SWEP.Secondary.Clipsize    	= -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic   	= false
SWEP.Secondary.Ammo         = "none"

SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= false

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
	self:DrawShadow(false)
	
	if (CLIENT) then 
		self.MOB = ClientsideModel("error.mdl")
		self.MOB:SetNoDraw(true)
		self.MOB:DrawShadow(false)
	end
end

function SWEP:ShouldDropOnDie()
	return false
end

function SWEP:Think()
end

function SWEP:Reload()
end

local Box = Vector(8,8,8)

function SWEP:PrimaryAttack()
	if (CLIENT and !IsFirstTimePredicted()) then return end
	if (!self.Owner.Weapons or !self.Owner.Weapons[self.Owner.Select]) then return end
	if (self.Owner.CD and self.Owner.CD > CurTime()) then return end
	
	local item = self.Owner.Weapons[self.Owner.Select].Item
	
	if (!item or !item.OnPrimary) then return end
	
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	
	local Trace = {
		start 	= self.Owner:GetShootPos(),
		endpos 	= self.Owner:GetShootPos()+self.Owner:GetAimVector()*item.Range,
		filter 	= self.Owner,
		mins 	= Box*-1,
		maxs	= Box,
	}
		
	local Tr = util.TraceHull(Trace)
		
	item:OnPrimary(self.Owner,Tr)
	
	self.Owner.CD = CurTime()+item.CD
end

function SWEP:SecondaryAttack()
	if (CLIENT and !IsFirstTimePredicted()) then return end
	if (!self.Owner.Weapons or !self.Owner.Weapons[self.Owner.Select]) then return end
	if (self.Owner.CD and self.Owner.CD > CurTime()) then return end
	
	local item = self.Owner.Weapons[self.Owner.Select].Item
	
	if (!item or !item.OnSecondary) then return end
	
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	
	local Trace = {
		start 	= self.Owner:GetShootPos(),
		endpos 	= self.Owner:GetShootPos()+self.Owner:GetAimVector()*item.Range,
		filter 	= self.Owner,
		mins 	= Box*-1,
		maxs	= Box,
	}
		
	local Tr = util.TraceHull(Trace)
		
	item:OnSecondary(self.Owner,Tr) 
	
	self.Owner.CD = CurTime()+item.CD
end

if (CLIENT) then
	local Zero = Vector(1,1,1)
	
	function SWEP:DrawWorldModel()
		if (!self.Owner.Weapons or !self.Owner.Weapons[self.Owner.Select]) then return end
		
		local item = self.Owner.Weapons[self.Owner.Select].Item
		
		for k,v in pairs(item.Structure) do
			local ID 		= self.Owner:LookupBone(v.Bone)
			local Pos,Ang 	= self.Owner:GetBonePosition(ID)
			
			local Offset = v.Pos*1
			Offset:Rotate(Ang)
			Pos = Pos + Offset
			
			local Dang 	 = Ang*1
			
			Ang:RotateAroundAxis(Dang:Right(),v.Ang.p)
			Ang:RotateAroundAxis(Dang:Up(),v.Ang.y)
			Ang:RotateAroundAxis(Dang:Forward(),v.Ang.r)
			
			self.MOB:SetModel(v.Model)
			self.MOB:SetRenderOrigin(Pos)
			self.MOB:SetRenderAngles(Ang)
				
			local mat 	= Matrix()
			mat:Scale( v.Size or Zero )
			
			self.MOB:EnableMatrix( "RenderMultiply", mat )
			self.MOB:SetupBones()
			self.MOB:DrawModel() 
		end
	end
end
