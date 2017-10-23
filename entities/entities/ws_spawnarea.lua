
ENT.Type 			= "brush"
ENT.Base 			= "base_brush"
ENT.PrintName		= ""
ENT.Author			= "Maw"
ENT.Purpose			= "Stuff"

local random = math.random
local traceline = util.TraceLine
local contents  = util.PointContents
local Up 		= Vector(0,0,1)

function ENT:Initialize()
	
end

function ENT:GenerateRain()
	local Mins,Maxs = self:OBBMins(),self:OBBMaxs()
	
	local Dis = Mins:Distance(Maxs)
		
	for i = 1,40+math.ceil(Dis/70) do
		local V = Vector(random(Mins.x,Maxs.x),random(Mins.y,Maxs.y),random(Mins.z,Maxs.z))
		local Tr = traceline({start=V,endpos=V-Up*40000})
		local Pos = Tr.HitPos+Up*20
		local C  = contents(Pos)
		
		if (C != CONTENTS_WATER and C != CONTENTS_WATER+CONTENTS_TRANSLUCENT) then 
			local drop = ents.Create("ws_item")
			drop.Item = Items[random(1,3)]
			drop:SetModel(drop.Item.Model)
			drop:SetPos(Pos)
			drop:Spawn()
			drop:GetPhysicsObject():Sleep()
		end
	end
end

function ENT:StartTouch( Ent )
end

function ENT:EndTouch( Ent )
end

function ENT:Think()
end


