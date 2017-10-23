include('shared.lua')
ENT.RenderGroup = RENDERGROUP_BOTH

local ZeroA = Angle(0,0,0)
local Flame = Material("particles/fire1")

local Up 	= Vector(0,0,120)
local UP 	= Vector(0,0,32)

function ENT:Initialize()
	self.FrameA = 0
	self.LastDrawn = UnPredictedCurTime()
	
	self.Dibs = ClientsideModel("models/props_debris/wood_board02a.mdl")
	self.Dibs:SetNoDraw(true)
	self.Dibs:DrawShadow(false)
	
	timer.Simple(0.1,function() self.Pos = self:GetPos() self.Ang = self:GetAngles() end)
end

function ENT:OnRemove()
end

function ENT:Think()
	if (!self.Pos) then return end
/*
	local light = DynamicLight(self:EntIndex())
	
	if (light) then
		light.Pos = self.Pos + UP
		
		light.r = 255
		light.g = 140
		light.b = 0
		
		light.Brightness 		= 1
		light.Size 				= 400
		light.Decay 			= 700
		light.DieTime 			= CurTime()+1
		light.Style 			= 0
	end*/
end

function ENT:Draw()
	if (!self.Pos) then return end
	
	local Vec = Vector(10,0,0)
	Vec:Rotate(self.Ang)
	
	for i = 1,4 do
		Vec:Rotate(Angle(0,90,0))
		
		local AB = self.Pos+Vec
		
		self.Dibs:SetRenderOrigin(AB)
		self.Dibs:SetRenderAngles(Angle(-45,90*i,0)+self.Ang)
		self.Dibs:SetupBones()
		self.Dibs:DrawModel()
	end
	
	self:DrawModel()
end


function ENT:DrawTranslucent()
	if (!self.Pos) then return end
	
	local FlameStart = self.Pos
	local FlameEnd   = self.Pos + Up
	
	self.FrameA = self.FrameA+(UnPredictedCurTime()-self.LastDrawn)*20
	if (self.FrameA > 52) then self.FrameA = 0 end
	
	Flame:SetFloat("$frame", self.FrameA)
	render.SetMaterial(Flame)
	render.DrawBeam(FlameStart,FlameEnd,48,0.99,0,MAIN_WHITECOLOR)
	
	self.LastDrawn = UnPredictedCurTime()
end
