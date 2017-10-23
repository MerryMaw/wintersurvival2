
local random = math.random
local traceline = util.TraceLine
local contents  = util.PointContents
local Up 		= Vector(0,0,1)

function GM:GeneratePropRain()
	local Items = {
		GetItemByName("Wood"),
		GetItemByName("Rock"),
		GetItemByName("Crystal"),
	}
	
	--NEW VERSION WS MAPS
	for k,v in pairs(ents.FindByClass("ws_spawnarea")) do
		v:GenerateRain()
	end
	
	--THIS PIECE OF CODE IS FOR OLDER VERSIONS OF WS MAPS! ITS CRAP BUT WE HAVE TO... For WS players!
	local areas = {}
	
	for i,area in pairs(ents.FindByClass("info_target")) do
		if (area:GetName() == "survival_spawn") then
			local parent = area:GetParent()
			if (IsValid(parent)) then
				areas[area] = parent
			end
		end
	end
	
	for pAe,pBe in pairs(areas) do
		local pA,pB = pAe:GetPos(),pBe:GetPos()
		local Dis = pA:Distance(pB)
		
		for i = 1,40+math.ceil(Dis/70) do
			local V = Vector(random(pB.x,pA.x),random(pB.y,pA.y),random(pB.z,pA.z))
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
		
		--Shop spawn
		local V = Vector(random(pB.x,pA.x),random(pB.y,pA.y),random(pB.z,pA.z))
		local Tr = traceline({start=V,endpos=V-Up*40000})
		local Pos = Tr.HitPos+Up*20
		local C  = contents(Pos)
		
		if (C != CONTENTS_WATER and C != CONTENTS_WATER+CONTENTS_TRANSLUCENT) then 
			local drop = ents.Create("ws_shop")
			drop:SetPos(Pos)
			drop:Spawn()
			drop:Activate()
		end
	end
	--END... Newer versions of maps should use a brush entity instead.
end