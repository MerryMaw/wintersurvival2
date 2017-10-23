include('shared.lua')

local Up = Vector(0,0,20)
local Sc = Vector(8,1,1)

function ENT:Initialize()
	timer.Simple(0.1,function() self.Pos = self:GetPos() self.Ang = self:GetAngles() end)
	
	self.Dibs = ClientsideModel("models/props_c17/gravestone003a.mdl")
	self.Dibs:SetNoDraw(true)
end

function ENT:Think()
	if (!self.Pos) then return end

	local light = DynamicLight(self:EntIndex())
	
	if (light) then
		light.Pos = self.Pos + Up
		
		light.r = 255
		light.g = 10
		light.b = 0
		
		light.Brightness 		= 4
		light.Size 				= 400
		light.Decay 			= 700
		light.DieTime 			= CurTime()+1
		light.Style 			= 0
	end
end


local a = Angle(0,180,0)
local A = Angle(90,0,0)

function ENT:Draw()
	if (!self.Pos) then return end
	
	local mat = Matrix()
	mat:Scale(Sc)
	
	local vec = Vector(22,0,0)
	vec:Rotate(self.Ang)
	
	for i = 0,1 do
		local ab = a*i
		
		vec:Rotate(ab)
		
		self.Dibs:EnableMatrix( "RenderMultiply", mat )
		self.Dibs:SetRenderOrigin(self.Pos+vec)
		self.Dibs:SetRenderAngles(self.Ang+ab+A)
		self.Dibs:SetupBones()
		self.Dibs:DrawModel()
	end
end
