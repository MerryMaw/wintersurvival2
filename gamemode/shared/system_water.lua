
local meta = FindMetaTable("Player")

if (SERVER) then
	util.AddNetworkString("SetWater")
	
	local Tick = CurTime()
	
	function meta:SetWater(s)
		if (s > 100) then self:TakeDamage(s-100) s = 100 end
		s = math.Clamp(s,0,100)
		
		self.Water = s
		
		net.Start("SetWater") 
			net.WriteUInt(s,8)
		net.Send(self)
	end
	
	function meta:AddWater(s)
		self:SetWater(self:GetWater()+s)
	end
	
	hook.Add("Tick","Water",function()
		if (Tick < CurTime()) then
			for k,v in pairs(player.GetAllHumans()) do
				v:AddWater(1)
			end
			
			Tick = CurTime()+3.5
		end
	end)
	
	hook.Add("KeyPress","FindWater",function(pl,key)
		if (key == IN_USE) then
			local tr = util.TraceLine({start=pl:GetShootPos(),endpos=pl:GetShootPos()+pl:GetAimVector()*200,filter=pl})
			local A  = util.PointContents( tr.HitPos )
			
			if (A == CONTENTS_WATER or A == CONTENTS_WATER+CONTENTS_TRANSLUCENT ) then
				pl:AddWater(-20)
			end
		end
	end)
else
	net.Receive("SetWater",function()
		LocalPlayer().Water = net.ReadUInt(8)
	end)
end
	
function meta:GetWater()
	return self.Water or 0
end
	