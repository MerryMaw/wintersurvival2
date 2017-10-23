
local meta = FindMetaTable("Player")

if (SERVER) then
	util.AddNetworkString("SetHunger")
	
	local Tick = CurTime()
	
	function meta:SetHunger(s)
		if (s > 100) then self:TakeDamage(s-100) s = 100 end
		s = math.Clamp(s,0,100)
		
		self.Hunger = s
		
		net.Start("SetHunger") 
			net.WriteUInt(s,8)
		net.Send(self)
	end
	
	function meta:AddHunger(s)
		self:SetHunger(self:GetHunger()+s)
	end
	
	hook.Add("Tick","Hunger",function()
		if (Tick < CurTime()) then
			for k,v in pairs(player.GetAllHumans()) do
				v:AddHunger(1)
			end
			
			Tick = CurTime()+10
		end
	end)
else
	net.Receive("SetHunger",function()
		LocalPlayer().Hunger = net.ReadUInt(8)
	end)
end
	
function meta:GetHunger()
	return self.Hunger or 0
end
	