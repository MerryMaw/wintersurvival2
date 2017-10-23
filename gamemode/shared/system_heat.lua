
local meta = FindMetaTable("Player")

if (SERVER) then
	util.AddNetworkString("SetHeat")
	
	local Tick = CurTime()
	
	function meta:SetHeat(s)
		if (s > 100) then self:TakeDamage(s-100) s = 100 end
		s = math.Clamp(s,0,100)
		
		self.Heat = s
		
		net.Start("SetHeat") 
			net.WriteUInt(s,8)
		net.Send(self)
	end
	
	function meta:AddHeat(s)
		self:SetHeat(self:GetHeat()+s)
	end
	
	hook.Add("Tick","Heat",function()
		if (Tick < CurTime()) then
			for k,v in pairs(player.GetAllHumans()) do
				v:AddHeat(1+v:WaterLevel())
			end
			
			Tick = CurTime()+1.5
		end
	end)
else
	net.Receive("SetHeat",function()
		LocalPlayer().Heat = net.ReadUInt(8)
	end)
end
	
function meta:GetHeat()
	return self.Heat or 0
end
	